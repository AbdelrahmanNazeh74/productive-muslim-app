/// Integration test: BackupPage full state-machine flow.
///
/// Tests that BackupPage responds correctly to the full state sequence:
/// BackupInitial → BackupInProgress → BackupLoaded (success)
/// and BackupInitial → BackupError (failure)
library;

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

BackupMetadata _meta(int index) => BackupMetadata(
      id: 'bk_$index',
      createdAt: DateTime(2025, 6, index + 1, 10, 0),
      appVersion: '1.0.0',
      habitCount: 5,
      userId: 'user_001',
    );

void main() {
  late MockAuthBloc authBloc;
  late MockBackupBloc backupBloc;

  setUpAll(() {
    registerFallbackValue(const BackupListRequested('dummy'));
    registerFallbackValue(BackupRequested(BackupSnapshot(
      userId: 'dummy',
      createdAt: DateTime(2025),
      appVersion: '1.0.0',
      userProfile: const {},
      habits: const [],
      streakRecords: const [],
      settings: const {},
    )));
    registerFallbackValue(const RestoreRequested('dummy'));
  });

  setUp(() {
    authBloc = MockAuthBloc();
    backupBloc = MockBackupBloc();
  });

  Widget buildPage() => MaterialApp(
        home: MultiBlocProvider(
          providers: [
            BlocProvider<AuthBloc>.value(value: authBloc),
            BlocProvider<BackupBloc>.value(value: backupBloc),
          ],
          child: const BackupPage(),
        ),
      );

  // ── Initial → InProgress → Loaded flow ───────────────────────────────────

  group('BackupPage — Initial → InProgress → Loaded', () {
    testWidgets('transitions from spinner to backup list', (tester) async {
      when(() => authBloc.state)
          .thenReturn(const AuthAuthenticated(_googleUser));
      whenListen(authBloc,
          Stream<AuthState>.fromIterable([const AuthAuthenticated(_googleUser)]),
          initialState: const AuthAuthenticated(_googleUser));

      // State stream: initial → inProgress → loaded
      final loaded = BackupLoaded(backups: [_meta(0), _meta(1)]);
      when(() => backupBloc.state).thenReturn(const BackupInProgress());
      whenListen(
        backupBloc,
        Stream<BackupState>.fromIterable([
          const BackupInitial(),
          const BackupInProgress(),
          loaded,
        ]),
        initialState: const BackupInitial(),
      );

      await tester.pumpWidget(buildPage());
      await tester.pump();
      // After all states resolve, loaded state shows RECENT BACKUPS
      expect(find.text('RECENT BACKUPS'), findsOneWidget);
    });

    testWidgets('BackupLoaded shows correct habit count in tiles', (tester) async {
      when(() => authBloc.state)
          .thenReturn(const AuthAuthenticated(_googleUser));
      whenListen(authBloc,
          Stream<AuthState>.fromIterable([const AuthAuthenticated(_googleUser)]),
          initialState: const AuthAuthenticated(_googleUser));

      final loaded = BackupLoaded(backups: [_meta(0)]);
      when(() => backupBloc.state).thenReturn(loaded);
      whenListen(backupBloc, Stream<BackupState>.fromIterable([loaded]),
          initialState: loaded);

      await tester.pumpWidget(buildPage());
      await tester.pump();
      expect(find.textContaining('5 habits'), findsOneWidget);
    });
  });

  // ── Initial → Error flow ─────────────────────────────────────────────────

  group('BackupPage — Initial → Error', () {
    testWidgets('BackupError shows error message in snackbar', (tester) async {
      when(() => authBloc.state)
          .thenReturn(const AuthAuthenticated(_googleUser));
      whenListen(authBloc,
          Stream<AuthState>.fromIterable([const AuthAuthenticated(_googleUser)]),
          initialState: const AuthAuthenticated(_googleUser));

      when(() => backupBloc.state).thenReturn(const BackupInitial());
      whenListen(
        backupBloc,
        Stream<BackupState>.fromIterable([
          const BackupInitial(),
          const BackupError('Upload failed'),
        ]),
        initialState: const BackupInitial(),
      );

      await tester.pumpWidget(buildPage());
      await tester.pump();
      expect(find.text('Upload failed'), findsOneWidget);
    });
  });

  // ── RestoreSuccess flow ───────────────────────────────────────────────────

  group('BackupPage — RestoreSuccess', () {
    testWidgets('shows success snackbar after restore', (tester) async {
      when(() => authBloc.state)
          .thenReturn(const AuthAuthenticated(_googleUser));
      whenListen(authBloc,
          Stream<AuthState>.fromIterable([const AuthAuthenticated(_googleUser)]),
          initialState: const AuthAuthenticated(_googleUser));

      final restored = RestoreSuccess(BackupSnapshot(
        userId: 'user_001',
        createdAt: DateTime(2025),
        appVersion: '1.0.0',
        userProfile: const {},
        habits: const [],
        streakRecords: const [],
        settings: const {},
      ));
      when(() => backupBloc.state).thenReturn(const BackupInitial());
      whenListen(
        backupBloc,
        Stream<BackupState>.fromIterable([const BackupInitial(), restored]),
        initialState: const BackupInitial(),
      );

      await tester.pumpWidget(buildPage());
      await tester.pump();
      expect(find.textContaining('restored'), findsOneWidget);
    });
  });

  // ── Unauthenticated ───────────────────────────────────────────────────────

  group('BackupPage — unauthenticated shows unavailable screen', () {
    testWidgets('shows Backup Unavailable when not signed in', (tester) async {
      when(() => authBloc.state).thenReturn(const AuthInitial());
      whenListen(authBloc,
          Stream<AuthState>.fromIterable([const AuthInitial()]),
          initialState: const AuthInitial());
      when(() => backupBloc.state).thenReturn(const BackupInitial());
      whenListen(backupBloc,
          Stream<BackupState>.fromIterable([const BackupInitial()]),
          initialState: const BackupInitial());

      await tester.pumpWidget(buildPage());
      await tester.pump();
      expect(find.text('Backup Unavailable'), findsOneWidget);
    });
  });
}
