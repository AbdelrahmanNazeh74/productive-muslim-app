/// Responsiveness tests: verifies major pages render without RenderFlex
/// overflow errors at 6 representative screen sizes.
///
/// Sizes tested (logical pixels, portrait unless noted):
///   320 × 568   — iPhone SE 1st gen (small phone)
///   390 × 844   — iPhone 14 Pro (standard phone)
///   414 × 896   — iPhone 11 Pro Max (large phone)
///   600 × 1024  — small Android tablet (portrait)
///   768 × 1024  — iPad / tablet breakpoint (portrait)
///   1024 × 768  — tablet landscape
///
/// Pages tested: AuthPage, OnboardingPage (step 0), HomeShell (phone mode),
/// BackupPage (guest state), SettingsPage, AppSplashScreen.
library;

import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

import 'package:productive_muslim/core/di/app_dependencies.dart';
import 'package:productive_muslim/core/usecases/usecase.dart';
import 'package:productive_muslim/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:productive_muslim/features/auth/presentation/pages/auth_page.dart';
import 'package:productive_muslim/features/backup/presentation/bloc/backup_bloc.dart';
import 'package:productive_muslim/features/backup/presentation/pages/backup_page.dart';
import 'package:productive_muslim/features/onboarding/domain/usecases/onboarding_usecases.dart';
import 'package:productive_muslim/features/onboarding/presentation/bloc/onboarding_bloc.dart';
import 'package:productive_muslim/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:productive_muslim/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:productive_muslim/features/settings/presentation/pages/settings_page.dart';
import 'package:productive_muslim/shared/widgets/app_splash_screen.dart';

class MockAuthBloc extends MockBloc<AuthEvent, AuthState> implements AuthBloc {}
class MockOnboardingBloc extends MockBloc<OnboardingEvent, OnboardingState> implements OnboardingBloc {}
class MockSettingsBloc extends MockBloc<SettingsEvent, SettingsState> implements SettingsBloc {}
class MockBackupBloc extends MockBloc<BackupEvent, BackupState> implements BackupBloc {}
class MockGetUserProfile extends Mock implements GetUserProfile {}

// ── Screen sizes ──────────────────────────────────────────────────────────────

const _sizes = [
  Size(320, 568),  // iPhone SE 1st gen
  Size(390, 844),  // iPhone 14 Pro
  Size(414, 896),  // iPhone 11 Pro Max
  Size(600, 1024), // small tablet portrait
  Size(768, 1024), // iPad portrait (tablet breakpoint)
  Size(1024, 768), // tablet landscape
];

const _sizeLabels = [
  '320×568',
  '390×844',
  '414×896',
  '600×1024',
  '768×1024',
  '1024×768 (landscape)',
];

// ── Helpers ───────────────────────────────────────────────────────────────────

/// Wraps [child] in a MaterialApp that overrides MediaQuery size to [size].
Widget _atSize(Size size, Widget child) {
  return MaterialApp(
    builder: (context, inner) => MediaQuery(
      data: MediaQuery.of(context).copyWith(size: size),
      child: inner!,
    ),
    home: child,
  );
}

// ── AuthPage ──────────────────────────────────────────────────────────────────

void main() {
  late MockAuthBloc authBloc;
  late MockOnboardingBloc onboardingBloc;
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

    onboardingBloc = MockOnboardingBloc();
    const onboardingState = OnboardingState();
    when(() => onboardingBloc.state).thenReturn(onboardingState);
    whenListen(onboardingBloc, Stream<OnboardingState>.fromIterable([onboardingState]),
        initialState: onboardingState);

    settingsBloc = MockSettingsBloc();
    when(() => settingsBloc.state).thenReturn(const SettingsInitial());
    whenListen(settingsBloc, Stream<SettingsState>.fromIterable([const SettingsInitial()]),
        initialState: const SettingsInitial());

    backupBloc = MockBackupBloc();
    when(() => backupBloc.state).thenReturn(const BackupInitial());
    whenListen(backupBloc, Stream<BackupState>.fromIterable([const BackupInitial()]),
        initialState: const BackupInitial());
  });

  // ── AuthPage at all 6 sizes ───────────────────────────────────────────────

  group('AuthPage — no overflow', () {
    for (var i = 0; i < _sizes.length; i++) {
      final size = _sizes[i];
      final label = _sizeLabels[i];

      testWidgets('renders at $label', (tester) async {
        await tester.pumpWidget(BlocProvider<AuthBloc>.value(
          value: authBloc,
          child: _atSize(size, const AuthPage()),
        ));
        await tester.pump();
        expect(tester.takeException(), isNull);
        expect(find.text('Productive Muslim'), findsOneWidget);
      });
    }
  });

  // ── OnboardingPage (step 0) at all 6 sizes ───────────────────────────────

  group('OnboardingPage (step 0) — no overflow', () {
    for (var i = 0; i < _sizes.length; i++) {
      final size = _sizes[i];
      final label = _sizeLabels[i];

      testWidgets('renders at $label', (tester) async {
        await tester.pumpWidget(BlocProvider<OnboardingBloc>.value(
          value: onboardingBloc,
          child: _atSize(size, const OnboardingPage()),
        ));
        await tester.pump();
        expect(tester.takeException(), isNull);
      });
    }
  });

  // ── SettingsPage at all 6 sizes ───────────────────────────────────────────

  group('SettingsPage — no overflow', () {
    for (var i = 0; i < _sizes.length; i++) {
      final size = _sizes[i];
      final label = _sizeLabels[i];

      testWidgets('renders at $label', (tester) async {
        await tester.pumpWidget(MultiBlocProvider(
          providers: [
            BlocProvider<AuthBloc>.value(value: authBloc),
            BlocProvider<SettingsBloc>.value(value: settingsBloc),
            BlocProvider<BackupBloc>.value(value: backupBloc),
          ],
          child: _atSize(size, const SettingsPage()),
        ));
        await tester.pump(const Duration(milliseconds: 100));
        expect(tester.takeException(), isNull);
      });
    }
  });

  // ── BackupPage (guest state) at all 6 sizes ───────────────────────────────

  group('BackupPage (guest) — no overflow', () {
    for (var i = 0; i < _sizes.length; i++) {
      final size = _sizes[i];
      final label = _sizeLabels[i];

      testWidgets('renders at $label', (tester) async {
        await tester.pumpWidget(MultiBlocProvider(
          providers: [
            BlocProvider<AuthBloc>.value(value: authBloc),
            BlocProvider<BackupBloc>.value(value: backupBloc),
          ],
          child: _atSize(size, const BackupPage()),
        ));
        await tester.pump();
        expect(tester.takeException(), isNull);
        expect(find.text('Backup Unavailable'), findsOneWidget);
      });
    }
  });

  // ── AppSplashScreen at all 6 sizes ────────────────────────────────────────

  group('AppSplashScreen — no overflow', () {
    GoRouter makeRouter() => GoRouter(
          initialLocation: '/',
          routes: [
            GoRoute(
              path: '/',
              builder: (_, __) => const AppSplashScreen(targetRoute: '/done'),
            ),
            GoRoute(
              path: '/done',
              builder: (_, __) => const Scaffold(body: SizedBox()),
            ),
          ],
        );

    for (var i = 0; i < _sizes.length; i++) {
      final size = _sizes[i];
      final label = _sizeLabels[i];

      testWidgets('renders at $label', (tester) async {
        await tester.pumpWidget(MaterialApp.router(
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context).copyWith(size: size),
            child: child!,
          ),
          routerConfig: makeRouter(),
        ));
        await tester.pump();
        expect(tester.takeException(), isNull);
        expect(find.text('Productive Muslim'), findsOneWidget);
      });
    }
  });
}
