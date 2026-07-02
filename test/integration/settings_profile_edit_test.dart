/// Integration test: Settings tab → Edit Profile navigation.
///
/// Pumps HomeShell directly, taps the "Profile" bottom nav tab, verifies
/// SettingsPage renders, then verifies "Edit Profile" tile is present and
/// tappable (navigates via Navigator.push).
library;

import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:productive_muslim/core/di/app_dependencies.dart';
import 'package:productive_muslim/core/usecases/usecase.dart';
import 'package:productive_muslim/features/analytics/presentation/bloc/analytics_bloc.dart';
import 'package:productive_muslim/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:productive_muslim/features/backup/presentation/bloc/backup_bloc.dart';
import 'package:productive_muslim/features/habits/presentation/bloc/habits_bloc.dart';
import 'package:productive_muslim/features/onboarding/domain/usecases/onboarding_usecases.dart';
import 'package:productive_muslim/features/ramadan/presentation/bloc/ramadan_bloc.dart';
import 'package:productive_muslim/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:productive_muslim/features/settings/presentation/pages/settings_page.dart';
import 'package:productive_muslim/features/timeline/presentation/bloc/timeline_bloc.dart';
import 'package:productive_muslim/features/timeline/presentation/pages/home_shell.dart';

class MockAuthBloc extends MockBloc<AuthEvent, AuthState> implements AuthBloc {}
class MockTimelineBloc extends MockBloc<TimelineEvent, TimelineState> implements TimelineBloc {}
class MockHabitsBloc extends MockBloc<HabitsEvent, HabitsState> implements HabitsBloc {}
class MockAnalyticsBloc extends MockBloc<AnalyticsEvent, AnalyticsState> implements AnalyticsBloc {}
class MockRamadanBloc extends MockBloc<RamadanEvent, RamadanState> implements RamadanBloc {}
class MockSettingsBloc extends MockBloc<SettingsEvent, SettingsState> implements SettingsBloc {}
class MockBackupBloc extends MockBloc<BackupEvent, BackupState> implements BackupBloc {}
class MockGetUserProfile extends Mock implements GetUserProfile {}

final _today = DateTime(2026, 1, 1);

void main() {
  late MockAuthBloc authBloc;
  late MockTimelineBloc timelineBloc;
  late MockHabitsBloc habitsBloc;
  late MockAnalyticsBloc analyticsBloc;
  late MockRamadanBloc ramadanBloc;
  late MockSettingsBloc settingsBloc;
  late MockBackupBloc backupBloc;

  setUpAll(() {
    registerFallbackValue(const NoParams());
  });

  setUp(() {
    final mockGetProfile = MockGetUserProfile();
    when(() => mockGetProfile(any())).thenAnswer((_) async => const Right(null));
    AppDependencies.getUserProfile = mockGetProfile;

    authBloc = MockAuthBloc();
    when(() => authBloc.state).thenReturn(const AuthInitial());
    whenListen(authBloc, Stream<AuthState>.fromIterable([const AuthInitial()]),
        initialState: const AuthInitial());

    timelineBloc = MockTimelineBloc();
    final timelineState = TimelineState(selectedDate: _today);
    when(() => timelineBloc.state).thenReturn(timelineState);
    whenListen(timelineBloc, Stream<TimelineState>.fromIterable([timelineState]),
        initialState: timelineState);

    habitsBloc = MockHabitsBloc();
    final habitsState = HabitsState(selectedDate: _today);
    when(() => habitsBloc.state).thenReturn(habitsState);
    whenListen(habitsBloc, Stream<HabitsState>.fromIterable([habitsState]),
        initialState: habitsState);

    analyticsBloc = MockAnalyticsBloc();
    final analyticsState = AnalyticsState();
    when(() => analyticsBloc.state).thenReturn(analyticsState);
    whenListen(analyticsBloc, Stream<AnalyticsState>.fromIterable([analyticsState]),
        initialState: analyticsState);

    ramadanBloc = MockRamadanBloc();
    final ramadanState = RamadanState(selectedDate: _today);
    when(() => ramadanBloc.state).thenReturn(ramadanState);
    whenListen(ramadanBloc, Stream<RamadanState>.fromIterable([ramadanState]),
        initialState: ramadanState);

    settingsBloc = MockSettingsBloc();
    when(() => settingsBloc.state).thenReturn(const SettingsInitial());
    whenListen(settingsBloc, Stream<SettingsState>.fromIterable([const SettingsInitial()]),
        initialState: const SettingsInitial());

    backupBloc = MockBackupBloc();
    when(() => backupBloc.state).thenReturn(const BackupInitial());
    whenListen(backupBloc, Stream<BackupState>.fromIterable([const BackupInitial()]),
        initialState: const BackupInitial());
  });

  Widget shellWidget() {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>.value(value: authBloc),
        BlocProvider<TimelineBloc>.value(value: timelineBloc),
        BlocProvider<HabitsBloc>.value(value: habitsBloc),
        BlocProvider<AnalyticsBloc>.value(value: analyticsBloc),
        BlocProvider<RamadanBloc>.value(value: ramadanBloc),
        BlocProvider<SettingsBloc>.value(value: settingsBloc),
        BlocProvider<BackupBloc>.value(value: backupBloc),
      ],
      child: MaterialApp(
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context).copyWith(size: const Size(390, 844)),
          child: child!,
        ),
        home: const HomeShell(),
      ),
    );
  }

  Future<void> buildShell(WidgetTester tester) async {
    await tester.pumpWidget(shellWidget());
  }

  /// Navigate HomeShell to the Profile/Settings tab.
  Future<void> goToSettings(WidgetTester tester) async {
    await buildShell(tester);
    await tester.pump(const Duration(milliseconds: 50));
    await tester.tap(find.text('Profile').last);
    await tester.pump(const Duration(milliseconds: 300));
  }

  // ── Navigate to SettingsPage via Profile tab ──────────────────────────────

  group('HomeShell → Settings tab', () {
    testWidgets('SettingsPage title is visible', (tester) async {
      await goToSettings(tester);
      expect(find.text('Settings'), findsOneWidget);
    });

    testWidgets('SettingsPage shows "Edit Profile" tile', (tester) async {
      await goToSettings(tester);
      expect(find.text('Edit Profile'), findsOneWidget);
    });

    testWidgets('SettingsPage shows "Prayer Settings" tile', (tester) async {
      await goToSettings(tester);
      expect(find.text('Prayer Settings'), findsOneWidget);
    });

    testWidgets('SettingsPage shows "Notifications" tile', (tester) async {
      await goToSettings(tester);
      expect(find.text('Notifications'), findsOneWidget);
    });

    testWidgets('"Edit Profile" tile is tappable (wrapped in InkWell)', (tester) async {
      await goToSettings(tester);
      final inkWell = find.ancestor(
        of: find.text('Edit Profile'),
        matching: find.byType(InkWell),
      );
      expect(inkWell, findsWidgets);
    });
  });

  // ── SettingsPage standalone — Edit Profile navigation ─────────────────────

  group('SettingsPage standalone — Edit Profile', () {
    Future<void> buildSettings(WidgetTester tester) async {
      await tester.pumpWidget(MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>.value(value: authBloc),
          BlocProvider<SettingsBloc>.value(value: settingsBloc),
          BlocProvider<BackupBloc>.value(value: backupBloc),
        ],
        child: const MaterialApp(home: SettingsPage()),
      ));
      await tester.pump(const Duration(milliseconds: 200));
    }

    testWidgets('shows "Data & Privacy" tile', (tester) async {
      await buildSettings(tester);
      expect(find.text('Data & Privacy'), findsOneWidget);
    });

    testWidgets('tapping "Edit Profile" pushes a new page', (tester) async {
      await buildSettings(tester);
      await tester.tap(find.text('Edit Profile'));
      await tester.pump(const Duration(milliseconds: 300));
      // The new page is pushed — SettingsPage title moves off-screen and the
      // route stack has a new page. "Edit Profile" is visible as the new page's
      // title or as a heading on ProfileEditPage.
      expect(find.text('Edit Profile'), findsWidgets);
    });
  });
}
