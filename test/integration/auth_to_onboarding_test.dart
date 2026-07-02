/// Integration test: Router navigates to the correct page based on auth state.
///
/// AppRouter.buildRouter(authUser: null)        → targetRoute = /auth
/// AppRouter.buildRouter(authUser: guestUser)   → targetRoute = /onboarding
/// AppRouter.buildRouter(existingProfile: done) → targetRoute = /home
///
/// Each case: splash screen is shown first, then routes away after ~1600ms.
library;

import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:productive_muslim/core/di/app_dependencies.dart';
import 'package:productive_muslim/core/navigation/app_router.dart';
import 'package:productive_muslim/core/usecases/usecase.dart';
import 'package:productive_muslim/features/analytics/presentation/bloc/analytics_bloc.dart';
import 'package:productive_muslim/features/auth/domain/entities/auth_user.dart';
import 'package:productive_muslim/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:productive_muslim/features/backup/presentation/bloc/backup_bloc.dart';
import 'package:productive_muslim/features/habits/presentation/bloc/habits_bloc.dart';
import 'package:productive_muslim/features/onboarding/domain/entities/user_profile.dart';
import 'package:productive_muslim/features/onboarding/domain/usecases/onboarding_usecases.dart';
import 'package:productive_muslim/features/onboarding/presentation/bloc/onboarding_bloc.dart';
import 'package:productive_muslim/features/ramadan/presentation/bloc/ramadan_bloc.dart';
import 'package:productive_muslim/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:productive_muslim/features/timeline/presentation/bloc/timeline_bloc.dart';

class MockAuthBloc extends MockBloc<AuthEvent, AuthState> implements AuthBloc {}
class MockOnboardingBloc extends MockBloc<OnboardingEvent, OnboardingState> implements OnboardingBloc {}
class MockTimelineBloc extends MockBloc<TimelineEvent, TimelineState> implements TimelineBloc {}
class MockHabitsBloc extends MockBloc<HabitsEvent, HabitsState> implements HabitsBloc {}
class MockAnalyticsBloc extends MockBloc<AnalyticsEvent, AnalyticsState> implements AnalyticsBloc {}
class MockRamadanBloc extends MockBloc<RamadanEvent, RamadanState> implements RamadanBloc {}
class MockSettingsBloc extends MockBloc<SettingsEvent, SettingsState> implements SettingsBloc {}
class MockBackupBloc extends MockBloc<BackupEvent, BackupState> implements BackupBloc {}
class MockGetUserProfile extends Mock implements GetUserProfile {}

const _guestUser = AuthUser(
  id: 'guest_001',
  email: '',
  displayName: 'Guest',
  isAnonymous: true,
);

final _today = DateTime(2026, 1, 1);

Widget _buildApp({
  UserProfile? profile,
  AuthUser? authUser,
  required MockAuthBloc authBloc,
  required MockOnboardingBloc onboardingBloc,
  required MockTimelineBloc timelineBloc,
  required MockHabitsBloc habitsBloc,
  required MockAnalyticsBloc analyticsBloc,
  required MockRamadanBloc ramadanBloc,
  required MockSettingsBloc settingsBloc,
  required MockBackupBloc backupBloc,
}) {
  final router = AppRouter.buildRouter(
    existingProfile: profile,
    authUser: authUser,
  );
  return MultiBlocProvider(
    providers: [
      BlocProvider<AuthBloc>.value(value: authBloc),
      BlocProvider<OnboardingBloc>.value(value: onboardingBloc),
      BlocProvider<TimelineBloc>.value(value: timelineBloc),
      BlocProvider<HabitsBloc>.value(value: habitsBloc),
      BlocProvider<AnalyticsBloc>.value(value: analyticsBloc),
      BlocProvider<RamadanBloc>.value(value: ramadanBloc),
      BlocProvider<SettingsBloc>.value(value: settingsBloc),
      BlocProvider<BackupBloc>.value(value: backupBloc),
    ],
    child: MaterialApp.router(routerConfig: router),
  );
}

void main() {
  late MockAuthBloc authBloc;
  late MockOnboardingBloc onboardingBloc;
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
    // Set up the AppDependencies.getUserProfile static late field
    final mockGetProfile = MockGetUserProfile();
    when(() => mockGetProfile(any())).thenAnswer((_) async => const Right(null));
    AppDependencies.getUserProfile = mockGetProfile;

    authBloc = MockAuthBloc();
    when(() => authBloc.state).thenReturn(const AuthInitial());
    whenListen(authBloc, Stream<AuthState>.fromIterable([const AuthInitial()]),
        initialState: const AuthInitial());

    onboardingBloc = MockOnboardingBloc();
    const onboardingState = OnboardingState();
    when(() => onboardingBloc.state).thenReturn(onboardingState);
    whenListen(onboardingBloc, Stream<OnboardingState>.fromIterable([onboardingState]),
        initialState: onboardingState);

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

  Widget buildApp({UserProfile? profile, AuthUser? authUser}) => _buildApp(
        profile: profile,
        authUser: authUser,
        authBloc: authBloc,
        onboardingBloc: onboardingBloc,
        timelineBloc: timelineBloc,
        habitsBloc: habitsBloc,
        analyticsBloc: analyticsBloc,
        ramadanBloc: ramadanBloc,
        settingsBloc: settingsBloc,
        backupBloc: backupBloc,
      );

  // ── No auth → splash → AuthPage ──────────────────────────────────────────

  group('Router: no auth user → AuthPage after splash', () {
    testWidgets('splash screen shown on first pump', (tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pump();
      // Splash renders "Productive Muslim" before routing away
      expect(find.text('Productive Muslim'), findsOneWidget);
    });

    testWidgets('AuthPage appears after splash completes (~2600ms)', (tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pump(const Duration(milliseconds: 2600));
      await tester.pumpAndSettle();
      // AuthPage is now the active route
      expect(find.text('Continue with Google'), findsOneWidget);
    });

    testWidgets('AuthPage shows "Continue as Guest" option', (tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pump(const Duration(milliseconds: 2600));
      await tester.pumpAndSettle();
      expect(find.text('Continue as Guest'), findsOneWidget);
    });
  });

  // ── Auth user (guest) → splash → OnboardingPage ───────────────────────────

  group('Router: guest auth user → OnboardingPage after splash', () {
    testWidgets('OnboardingPage appears after splash completes', (tester) async {
      await tester.pumpWidget(buildApp(authUser: _guestUser));
      await tester.pump(const Duration(milliseconds: 2600));
      await tester.pumpAndSettle();
      // OnboardingPage step 0 is the welcome screen
      expect(find.text('Productive Muslim'), findsNothing); // splash gone
    });
  });
}
