import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:productive_muslim/features/auth/domain/entities/auth_user.dart';
import 'package:productive_muslim/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:productive_muslim/features/backup/domain/entities/backup_snapshot.dart';
import 'package:productive_muslim/features/backup/presentation/bloc/backup_bloc.dart';
import 'package:productive_muslim/features/backup/presentation/pages/backup_page.dart';

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

BackupMetadata _meta({int index = 0}) => BackupMetadata(
      id: 'backup_$index',
      createdAt: DateTime(2025, 6, index + 1, 10, 30),
      appVersion: '1.0.0',
      habitCount: 3,
      userId: 'user_001',
    );

Widget _buildPage(MockAuthBloc authBloc, MockBackupBloc backupBloc) {
  return MaterialApp(
    home: MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>.value(value: authBloc),
        BlocProvider<BackupBloc>.value(value: backupBloc),
      ],
      child: const BackupPage(),
    ),
  );
}

final _dummySnapshot = BackupSnapshot(
  userId: 'dummy',
  createdAt: DateTime(2025),
  appVersion: '1.0.0',
  userProfile: const {},
  habits: const [],
  streakRecords: const [],
  settings: const {},
);

void main() {
  setUpAll(() {
    // BackupPage calls add() in initState — register fallback values so mocktail
    // can match any BackupEvent without throwing a TypeError.
    registerFallbackValue(const BackupListRequested('dummy'));
    registerFallbackValue(BackupRequested(_dummySnapshot));
    registerFallbackValue(const RestoreRequested('dummy'));
  });

  late MockAuthBloc authBloc;
  late MockBackupBloc backupBloc;

  setUp(() {
    authBloc = MockAuthBloc();
    backupBloc = MockBackupBloc();
    when(() => backupBloc.state).thenReturn(const BackupInitial());
    whenListen(backupBloc, Stream<BackupState>.fromIterable([const BackupInitial()]),
        initialState: const BackupInitial());
  });

  // ── Guest state ──────────────────────────────────────────────────────────────

  group('BackupPage — guest state', () {
    setUp(() {
      when(() => authBloc.state).thenReturn(const AuthInitial());
      whenListen(authBloc, Stream<AuthState>.fromIterable([const AuthInitial()]),
          initialState: const AuthInitial());
    });

    testWidgets('shows "Backup Unavailable" when not authenticated', (tester) async {
      await tester.pumpWidget(_buildPage(authBloc, backupBloc));
      await tester.pump();
      expect(find.text('Backup Unavailable'), findsOneWidget);
    });

    testWidgets('shows sign-in hint text in guest mode', (tester) async {
      await tester.pumpWidget(_buildPage(authBloc, backupBloc));
      await tester.pump();
      expect(find.textContaining('Sign in with Google'), findsOneWidget);
    });

    testWidgets('shows cloud_off icon in guest mode', (tester) async {
      await tester.pumpWidget(_buildPage(authBloc, backupBloc));
      await tester.pump();
      expect(find.byIcon(Icons.cloud_off_outlined), findsOneWidget);
    });

    testWidgets('anonymous user also sees guest message', (tester) async {
      when(() => authBloc.state)
          .thenReturn(const AuthAuthenticated(_guestUser));
      whenListen(authBloc,
          Stream<AuthState>.fromIterable([const AuthAuthenticated(_guestUser)]),
          initialState: const AuthAuthenticated(_guestUser));
      await tester.pumpWidget(_buildPage(authBloc, backupBloc));
      await tester.pump();
      expect(find.text('Backup Unavailable'), findsOneWidget);
    });
  });

  // ── Authenticated + initial state ────────────────────────────────────────────

  group('BackupPage — authenticated, no backups yet', () {
    setUp(() {
      when(() => authBloc.state)
          .thenReturn(const AuthAuthenticated(_googleUser));
      whenListen(authBloc,
          Stream<AuthState>.fromIterable(
              [const AuthAuthenticated(_googleUser)]),
          initialState: const AuthAuthenticated(_googleUser));
    });

    testWidgets('shows "Not backed up yet" status text', (tester) async {
      await tester.pumpWidget(_buildPage(authBloc, backupBloc));
      await tester.pump();
      expect(find.text('Not backed up yet'), findsOneWidget);
    });

    testWidgets('dispatches BackupListRequested in initState', (tester) async {
      await tester.pumpWidget(_buildPage(authBloc, backupBloc));
      await tester.pump();
      verify(() => backupBloc.add(const BackupListRequested('user_001'))).called(1);
    });

    testWidgets('"Back Up Now" button is present', (tester) async {
      await tester.pumpWidget(_buildPage(authBloc, backupBloc));
      await tester.pump();
      expect(find.text('Back Up Now'), findsOneWidget);
    });

    testWidgets('"Back Up Now" tap dispatches BackupRequested', (tester) async {
      await tester.pumpWidget(_buildPage(authBloc, backupBloc));
      await tester.pump();
      await tester.tap(find.text('Back Up Now'));
      final captured = verify(() => backupBloc.add(captureAny())).captured;
      expect(captured.any((e) => e is BackupRequested), isTrue);
    });
  });

  // ── BackupLoaded with backup list ────────────────────────────────────────────

  group('BackupPage — loaded with backups', () {
    final meta1 = _meta(index: 0);
    final meta2 = _meta(index: 1);

    setUp(() {
      when(() => authBloc.state)
          .thenReturn(const AuthAuthenticated(_googleUser));
      whenListen(authBloc,
          Stream<AuthState>.fromIterable(
              [const AuthAuthenticated(_googleUser)]),
          initialState: const AuthAuthenticated(_googleUser));
      final loaded = BackupLoaded(backups: [meta1, meta2]);
      when(() => backupBloc.state).thenReturn(loaded);
      whenListen(backupBloc, Stream<BackupState>.fromIterable([loaded]),
          initialState: loaded);
    });

    testWidgets('shows "RECENT BACKUPS" section label', (tester) async {
      await tester.pumpWidget(_buildPage(authBloc, backupBloc));
      await tester.pump();
      expect(find.text('RECENT BACKUPS'), findsOneWidget);
    });

    testWidgets('shows backup tile for each backup', (tester) async {
      await tester.pumpWidget(_buildPage(authBloc, backupBloc));
      await tester.pump();
      // Habit count and version shown in tile
      expect(find.textContaining('3 habits'), findsWidgets);
    });

    testWidgets('"Restore" button is enabled when backups exist', (tester) async {
      await tester.pumpWidget(_buildPage(authBloc, backupBloc));
      await tester.pump();
      final button = tester.widget<OutlinedButton>(
          find.widgetWithText(OutlinedButton, 'Restore'));
      expect(button.onPressed, isNotNull);
    });
  });

  // ── BackupInProgress ─────────────────────────────────────────────────────────

  group('BackupPage — BackupInProgress', () {
    setUp(() {
      when(() => authBloc.state)
          .thenReturn(const AuthAuthenticated(_googleUser));
      whenListen(authBloc,
          Stream<AuthState>.fromIterable(
              [const AuthAuthenticated(_googleUser)]),
          initialState: const AuthAuthenticated(_googleUser));
      when(() => backupBloc.state).thenReturn(const BackupInProgress());
      whenListen(backupBloc,
          Stream<BackupState>.fromIterable([const BackupInProgress()]),
          initialState: const BackupInProgress());
    });

    testWidgets('shows "Backing up..." text', (tester) async {
      await tester.pumpWidget(_buildPage(authBloc, backupBloc));
      await tester.pump();
      expect(find.text('Backing up...'), findsOneWidget);
    });

    testWidgets('shows CircularProgressIndicator in status card', (tester) async {
      await tester.pumpWidget(_buildPage(authBloc, backupBloc));
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsWidgets);
    });
  });

  // ── RestoreSuccess → snackbar ─────────────────────────────────────────────────

  group('BackupPage — RestoreSuccess snackbar', () {
    setUp(() {
      when(() => authBloc.state)
          .thenReturn(const AuthAuthenticated(_googleUser));
    });

    testWidgets('shows success snackbar on RestoreSuccess', (tester) async {
      final restoreState = RestoreSuccess(BackupSnapshot(
        userId: 'user_001',
        createdAt: DateTime(2025),
        appVersion: '1.0.0',
        userProfile: const {},
        habits: const [],
        streakRecords: const [],
        settings: const {},
      ));
      whenListen(
        authBloc,
        Stream<AuthState>.fromIterable(
            [const AuthAuthenticated(_googleUser)]),
        initialState: const AuthAuthenticated(_googleUser),
      );
      whenListen(
        backupBloc,
        Stream<BackupState>.fromIterable([const BackupInitial(), restoreState]),
        initialState: const BackupInitial(),
      );
      when(() => backupBloc.state).thenReturn(const BackupInitial());
      await tester.pumpWidget(_buildPage(authBloc, backupBloc));
      await tester.pump();
      expect(find.textContaining('restored'), findsOneWidget);
    });
  });

  // ── BackupError → snackbar ─────────────────────────────────────────────────

  group('BackupPage — BackupError snackbar', () {
    testWidgets('shows error snackbar on BackupError', (tester) async {
      when(() => authBloc.state)
          .thenReturn(const AuthAuthenticated(_googleUser));
      whenListen(
        authBloc,
        Stream<AuthState>.fromIterable(
            [const AuthAuthenticated(_googleUser)]),
        initialState: const AuthAuthenticated(_googleUser),
      );
      whenListen(
        backupBloc,
        Stream<BackupState>.fromIterable(
            [const BackupInitial(), const BackupError('Network error')]),
        initialState: const BackupInitial(),
      );
      when(() => backupBloc.state).thenReturn(const BackupInitial());
      await tester.pumpWidget(_buildPage(authBloc, backupBloc));
      await tester.pump();
      expect(find.text('Network error'), findsOneWidget);
    });
  });
}
