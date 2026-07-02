import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:productive_muslim/core/di/app_dependencies.dart';
import 'package:productive_muslim/core/usecases/usecase.dart';
import 'package:productive_muslim/features/auth/domain/entities/auth_user.dart';
import 'package:productive_muslim/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:productive_muslim/features/backup/presentation/bloc/backup_bloc.dart';
import 'package:productive_muslim/features/onboarding/domain/usecases/onboarding_usecases.dart';
import 'package:productive_muslim/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:productive_muslim/features/settings/presentation/pages/settings_page.dart';

class MockGetUserProfile extends Mock implements GetUserProfile {}
class MockSettingsBloc extends MockBloc<SettingsEvent, SettingsState> implements SettingsBloc {}
class MockAuthBloc extends MockBloc<AuthEvent, AuthState> implements AuthBloc {}
class MockBackupBloc extends MockBloc<BackupEvent, BackupState> implements BackupBloc {}

const _googleUser = AuthUser(
  id: 'user_001',
  email: 'user@test.com',
  displayName: 'Test User',
  isAnonymous: false,
);
const _guestUser = AuthUser(
  id: 'guest_001',
  email: '',
  displayName: 'Guest',
  isAnonymous: true,
);

void main() {
  late MockSettingsBloc settingsBloc;
  late MockAuthBloc authBloc;
  late MockBackupBloc backupBloc;

  setUpAll(() {
    registerFallbackValue(const NoParams());
  });

  setUp(() {
    final mockGetProfile = MockGetUserProfile();
    when(() => mockGetProfile(any()))
        .thenAnswer((_) async => const Right(null));
    AppDependencies.getUserProfile = mockGetProfile;

    settingsBloc = MockSettingsBloc();
    when(() => settingsBloc.state).thenReturn(const SettingsInitial());
    whenListen(settingsBloc,
        Stream<SettingsState>.fromIterable([const SettingsInitial()]),
        initialState: const SettingsInitial());

    authBloc = MockAuthBloc();
    backupBloc = MockBackupBloc();
    when(() => backupBloc.state).thenReturn(const BackupInitial());
    whenListen(backupBloc,
        Stream<BackupState>.fromIterable([const BackupInitial()]),
        initialState: const BackupInitial());
  });

  Widget buildPage() {
    return MaterialApp(
      home: MultiBlocProvider(
        providers: [
          BlocProvider<SettingsBloc>.value(value: settingsBloc),
          BlocProvider<AuthBloc>.value(value: authBloc),
          BlocProvider<BackupBloc>.value(value: backupBloc),
        ],
        child: const SettingsPage(),
      ),
    );
  }

  // ── _SyncChip — guest state ───────────────────────────────────────────────

  group('_SyncChip — unauthenticated (AuthInitial)', () {
    setUp(() {
      when(() => authBloc.state).thenReturn(const AuthInitial());
      whenListen(authBloc,
          Stream<AuthState>.fromIterable([const AuthInitial()]),
          initialState: const AuthInitial());
    });

    testWidgets('shows "Guest mode" chip text', (tester) async {
      await tester.pumpWidget(buildPage());
      await tester.pump();
      expect(find.text('Guest mode'), findsOneWidget);
    });
  });

  group('_SyncChip — anonymous user', () {
    setUp(() {
      when(() => authBloc.state)
          .thenReturn(const AuthAuthenticated(_guestUser));
      whenListen(
          authBloc,
          Stream<AuthState>.fromIterable(
              [const AuthAuthenticated(_guestUser)]),
          initialState: const AuthAuthenticated(_guestUser));
    });

    testWidgets('shows "Guest mode" for anonymous user', (tester) async {
      await tester.pumpWidget(buildPage());
      await tester.pump();
      expect(find.text('Guest mode'), findsOneWidget);
    });
  });

  // ── _SyncChip — authenticated states ─────────────────────────────────────

  group('_SyncChip — authenticated + BackupInProgress', () {
    setUp(() {
      when(() => authBloc.state)
          .thenReturn(const AuthAuthenticated(_googleUser));
      whenListen(
          authBloc,
          Stream<AuthState>.fromIterable(
              [const AuthAuthenticated(_googleUser)]),
          initialState: const AuthAuthenticated(_googleUser));
      when(() => backupBloc.state).thenReturn(const BackupInProgress());
      whenListen(backupBloc,
          Stream<BackupState>.fromIterable([const BackupInProgress()]),
          initialState: const BackupInProgress());
    });

    testWidgets('shows "Backing up…" text', (tester) async {
      await tester.pumpWidget(buildPage());
      await tester.pump();
      expect(find.text('Backing up…'), findsOneWidget);
    });
  });

  group('_SyncChip — authenticated + BackupLoaded with lastBackupAt', () {
    setUp(() {
      when(() => authBloc.state)
          .thenReturn(const AuthAuthenticated(_googleUser));
      whenListen(
          authBloc,
          Stream<AuthState>.fromIterable(
              [const AuthAuthenticated(_googleUser)]),
          initialState: const AuthAuthenticated(_googleUser));
      final loaded = BackupLoaded(
        backups: const [],
        lastBackupAt: DateTime.now().subtract(const Duration(minutes: 5)),
      );
      when(() => backupBloc.state).thenReturn(loaded);
      whenListen(backupBloc, Stream<BackupState>.fromIterable([loaded]),
          initialState: loaded);
    });

    testWidgets('shows "Backed up" text', (tester) async {
      await tester.pumpWidget(buildPage());
      await tester.pump();
      expect(find.textContaining('Backed up'), findsOneWidget);
    });
  });

  group('_SyncChip — authenticated + BackupInitial (never backed up)', () {
    setUp(() {
      when(() => authBloc.state)
          .thenReturn(const AuthAuthenticated(_googleUser));
      whenListen(
          authBloc,
          Stream<AuthState>.fromIterable(
              [const AuthAuthenticated(_googleUser)]),
          initialState: const AuthAuthenticated(_googleUser));
    });

    testWidgets('shows "Not backed up" text', (tester) async {
      await tester.pumpWidget(buildPage());
      await tester.pump();
      expect(find.text('Not backed up'), findsOneWidget);
    });
  });

  // ── SettingsPage — general rendering ─────────────────────────────────────

  group('SettingsPage — tiles present', () {
    setUp(() {
      when(() => authBloc.state).thenReturn(const AuthInitial());
      whenListen(authBloc,
          Stream<AuthState>.fromIterable([const AuthInitial()]),
          initialState: const AuthInitial());
    });

    testWidgets('shows "Settings" title', (tester) async {
      await tester.pumpWidget(buildPage());
      await tester.pump();
      expect(find.text('Settings'), findsOneWidget);
    });

    testWidgets('shows "Edit Profile" tile', (tester) async {
      await tester.pumpWidget(buildPage());
      await tester.pump();
      expect(find.text('Edit Profile'), findsOneWidget);
    });

    testWidgets('shows "Prayer Settings" tile', (tester) async {
      await tester.pumpWidget(buildPage());
      await tester.pump();
      expect(find.text('Prayer Settings'), findsOneWidget);
    });

    testWidgets('shows "Notifications" tile', (tester) async {
      await tester.pumpWidget(buildPage());
      await tester.pump();
      expect(find.text('Notifications'), findsOneWidget);
    });

    testWidgets('shows "Data & Privacy" tile', (tester) async {
      await tester.pumpWidget(buildPage());
      await tester.pump();
      expect(find.text('Data & Privacy'), findsOneWidget);
    });
  });
}
