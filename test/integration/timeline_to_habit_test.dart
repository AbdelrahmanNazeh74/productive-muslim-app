/// Integration test: HomeShell navigation — Timeline tab → Habits tab.
///
/// Pumps HomeShell directly (no router/splash) with all required mock BLoCs.
/// Uses 390×844 phone surface to stay under the 768px tablet breakpoint and
/// keep BottomNavigationBar visible (instead of NavigationRail).
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
const _settle = Duration(milliseconds: 50);

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

  /// Wraps the app in a MediaQuery that fixes the logical width to 390px so
  /// Responsive.isTablet always returns false, regardless of the test surface.
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

  // ── Default tab: bottom nav labels ────────────────────────────────────────

  // NOTE: HomeShell uses an AnimatedOpacity stack — ALL tab pages render at
  // all times (just opacity-0 when inactive). Page headings can duplicate nav
  // label text, so we use findsAtLeastNWidgets(1) for any label that a page
  // heading also uses (Habits, Analytics, Timeline). "Profile" is unique.
  group('HomeShell — bottom nav labels present', () {
    testWidgets('renders "Timeline" nav label', (tester) async {
      await buildShell(tester);
      await tester.pump(_settle);
      expect(find.text('Timeline'), findsAtLeastNWidgets(1));
    });

    testWidgets('renders "Habits" nav label', (tester) async {
      await buildShell(tester);
      await tester.pump(_settle);
      expect(find.text('Habits'), findsAtLeastNWidgets(1));
    });

    testWidgets('renders "Profile" nav label', (tester) async {
      await buildShell(tester);
      await tester.pump(_settle);
      // "Profile" only appears in the nav bar (SettingsPage shows "Settings")
      expect(find.text('Profile'), findsOneWidget);
    });

    testWidgets('renders "Analytics" nav label', (tester) async {
      await buildShell(tester);
      await tester.pump(_settle);
      expect(find.text('Analytics'), findsAtLeastNWidgets(1));
    });
  });

  // Nav text labels render AFTER body in the widget tree (Scaffold.body before
  // Scaffold.bottomNavigationBar), so .last always targets the nav bar label
  // when the same text also appears in a page heading.

  // ── Tap Habits tab ────────────────────────────────────────────────────────

  group('HomeShell — tap Habits tab', () {
    testWidgets('tapping "Habits" shows filled fire icon (selected)', (tester) async {
      await buildShell(tester);
      await tester.pump(_settle);
      await tester.tap(find.text('Habits').last);
      await tester.pump(_settle);
      expect(find.byIcon(Icons.local_fire_department), findsOneWidget);
    });

    testWidgets('tapping back to Timeline shows filled view_day icon', (tester) async {
      await buildShell(tester);
      await tester.pump(_settle);
      await tester.tap(find.text('Habits').last);
      await tester.pump(_settle);
      await tester.tap(find.text('Timeline').last);
      await tester.pump(_settle);
      expect(find.byIcon(Icons.view_day), findsOneWidget);
    });
  });

  // ── Tap Analytics tab ─────────────────────────────────────────────────────

  group('HomeShell — tap Analytics tab', () {
    testWidgets('tapping Analytics nav item shows filled bar_chart icon', (tester) async {
      await buildShell(tester);
      await tester.pump(_settle);
      await tester.tap(find.text('Analytics').last);
      await tester.pump(_settle);
      expect(find.byIcon(Icons.bar_chart), findsOneWidget);
    });
  });

  // ── Tap Profile tab ───────────────────────────────────────────────────────

  group('HomeShell — tap Profile tab', () {
    testWidgets('tapping "Profile" shows filled person icon (selected)', (tester) async {
      await buildShell(tester);
      await tester.pump(_settle);
      await tester.tap(find.text('Profile').last);
      await tester.pump(_settle);
      expect(find.byIcon(Icons.person), findsOneWidget);
    });

    testWidgets('tapping "Profile" makes SettingsPage visible', (tester) async {
      await buildShell(tester);
      await tester.pump(_settle);
      await tester.tap(find.text('Profile').last);
      // Allow SettingsPage async _loadProfile() to complete
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.text('Settings'), findsOneWidget);
    });
  });
}
