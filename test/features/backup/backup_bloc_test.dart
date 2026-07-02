import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:productive_muslim/core/errors/failures.dart';
import 'package:productive_muslim/core/usecases/usecase.dart';
import 'package:productive_muslim/features/auth/domain/entities/auth_user.dart';
import 'package:productive_muslim/features/auth/domain/usecases/auth_usecases.dart';
import 'package:productive_muslim/features/backup/domain/entities/backup_snapshot.dart';
import 'package:productive_muslim/features/backup/domain/usecases/backup_usecases.dart';
import 'package:productive_muslim/features/backup/presentation/bloc/backup_bloc.dart';

// ── Mocks ─────────────────────────────────────────────────────────────────────

class MockCreateBackup extends Mock implements CreateBackup {}
class MockRestoreBackup extends Mock implements RestoreBackup {}
class MockListBackups extends Mock implements ListBackups {}
class MockGetCurrentUser extends Mock implements GetCurrentUser {}
class MockBackupThrottle extends Mock implements BackupThrottle {}

// ── Helpers ───────────────────────────────────────────────────────────────────

const _authUser = AuthUser(
  id: 'user_001',
  email: 'user@test.com',
  isAnonymous: false,
);

const _guestUser = AuthUser(
  id: 'guest_001',
  email: '',
  isAnonymous: true,
);

BackupSnapshot _snapshot({String userId = 'user_001'}) => BackupSnapshot(
      userId: userId,
      createdAt: DateTime(2026, 6, 28, 12),
      appVersion: '1.0.0',
      userProfile: const {},
      habits: const [],
      streakRecords: const [],
      settings: const {},
    );

BackupMetadata _meta({String userId = 'user_001', int habitCount = 5}) =>
    BackupMetadata(
      id: '${userId}_1234567890',
      createdAt: DateTime(2026, 6, 28, 10),
      appVersion: '1.0.0',
      habitCount: habitCount,
      userId: userId,
    );

BackupBloc _makeBloc({
  required MockCreateBackup create,
  required MockRestoreBackup restore,
  required MockListBackups list,
  required MockGetCurrentUser getUser,
  required MockBackupThrottle throttle,
}) =>
    BackupBloc(
      createBackup: create,
      restoreBackup: restore,
      listBackups: list,
      getCurrentUser: getUser,
      throttle: throttle,
    );

void main() {
  late MockCreateBackup mockCreate;
  late MockRestoreBackup mockRestore;
  late MockListBackups mockList;
  late MockGetCurrentUser mockGetUser;
  late MockBackupThrottle mockThrottle;

  setUpAll(() {
    registerFallbackValue(const NoParams());
    registerFallbackValue(CreateBackupParams(snapshot: _snapshot()));
    registerFallbackValue(const RestoreBackupParams(backupId: 'id'));
    registerFallbackValue(const ListBackupsParams(userId: 'user_001'));
  });

  setUp(() {
    mockCreate = MockCreateBackup();
    mockRestore = MockRestoreBackup();
    mockList = MockListBackups();
    mockGetUser = MockGetCurrentUser();
    mockThrottle = MockBackupThrottle();
    // Throttle defaults: allowed, no last time.
    when(() => mockThrottle.shouldBackup).thenReturn(true);
    when(() => mockThrottle.lastBackupAt).thenReturn(null);
    when(() => mockThrottle.recordBackup()).thenAnswer((_) async {});
  });

  // 1 ─ Initial state
  test('initial state is BackupInitial', () {
    final bloc = _makeBloc(
        create: mockCreate,
        restore: mockRestore,
        list: mockList,
        getUser: mockGetUser,
        throttle: mockThrottle);
    expect(bloc.state, const BackupInitial());
    bloc.close();
  });

  // 2 ─ BackupRequested success
  blocTest<BackupBloc, BackupState>(
    'BackupRequested emits InProgress → Loaded on success',
    build: () => _makeBloc(
        create: mockCreate,
        restore: mockRestore,
        list: mockList,
        getUser: mockGetUser,
        throttle: mockThrottle),
    setUp: () {
      when(() => mockGetUser(any()))
          .thenAnswer((_) async => const Right(_authUser));
      when(() => mockCreate(any()))
          .thenAnswer((_) async => const Right(unit));
      when(() => mockList(any()))
          .thenAnswer((_) async => Right([_meta()]));
    },
    act: (b) => b.add(BackupRequested(_snapshot())),
    expect: () => [
      const BackupInProgress(),
      BackupLoaded(backups: [_meta()], lastBackupAt: null),
    ],
    verify: (_) {
      verify(() => mockCreate(any())).called(1);
      verify(() => mockThrottle.recordBackup()).called(1);
    },
  );

  // 3 ─ BackupRequested failure
  blocTest<BackupBloc, BackupState>(
    'BackupRequested emits InProgress → Error on failure',
    build: () => _makeBloc(
        create: mockCreate,
        restore: mockRestore,
        list: mockList,
        getUser: mockGetUser,
        throttle: mockThrottle),
    setUp: () {
      when(() => mockGetUser(any()))
          .thenAnswer((_) async => const Right(_authUser));
      when(() => mockCreate(any())).thenAnswer(
          (_) async => const Left(BackupFailure('disk full')));
    },
    act: (b) => b.add(BackupRequested(_snapshot())),
    expect: () =>
        [const BackupInProgress(), const BackupError('disk full')],
    verify: (_) =>
        verifyNever(() => mockThrottle.recordBackup()),
  );

  // 4 ─ BackupRequested: guest cannot backup
  blocTest<BackupBloc, BackupState>(
    'BackupRequested emits Error when user is anonymous guest',
    build: () => _makeBloc(
        create: mockCreate,
        restore: mockRestore,
        list: mockList,
        getUser: mockGetUser,
        throttle: mockThrottle),
    setUp: () => when(() => mockGetUser(any()))
        .thenAnswer((_) async => const Right(_guestUser)),
    act: (b) => b.add(BackupRequested(_snapshot())),
    expect: () => [
      const BackupError('Sign in to enable cloud backup'),
    ],
    verify: (_) => verifyNever(() => mockCreate(any())),
  );

  // 5 ─ BackupListRequested success
  blocTest<BackupBloc, BackupState>(
    'BackupListRequested emits InProgress → Loaded with list',
    build: () => _makeBloc(
        create: mockCreate,
        restore: mockRestore,
        list: mockList,
        getUser: mockGetUser,
        throttle: mockThrottle),
    setUp: () => when(() => mockList(any()))
        .thenAnswer((_) async => Right([_meta(), _meta(habitCount: 3)])),
    act: (b) => b.add(const BackupListRequested('user_001')),
    expect: () => [
      const BackupInProgress(),
      BackupLoaded(
          backups: [_meta(), _meta(habitCount: 3)], lastBackupAt: null),
    ],
  );

  // 6 ─ BackupListRequested empty list
  blocTest<BackupBloc, BackupState>(
    'BackupListRequested emits empty Loaded when no backups',
    build: () => _makeBloc(
        create: mockCreate,
        restore: mockRestore,
        list: mockList,
        getUser: mockGetUser,
        throttle: mockThrottle),
    setUp: () => when(() => mockList(any()))
        .thenAnswer((_) async => const Right([])),
    act: (b) => b.add(const BackupListRequested('user_001')),
    expect: () => [
      const BackupInProgress(),
      const BackupLoaded(backups: [], lastBackupAt: null),
    ],
  );

  // 7 ─ BackupListRequested failure
  blocTest<BackupBloc, BackupState>(
    'BackupListRequested emits BackupError on failure',
    build: () => _makeBloc(
        create: mockCreate,
        restore: mockRestore,
        list: mockList,
        getUser: mockGetUser,
        throttle: mockThrottle),
    setUp: () => when(() => mockList(any()))
        .thenAnswer((_) async => const Left(BackupFailure('io error'))),
    act: (b) => b.add(const BackupListRequested('user_001')),
    expect: () =>
        [const BackupInProgress(), const BackupError('io error')],
  );

  // 8 ─ RestoreRequested success
  blocTest<BackupBloc, BackupState>(
    'RestoreRequested emits InProgress → RestoreSuccess',
    build: () => _makeBloc(
        create: mockCreate,
        restore: mockRestore,
        list: mockList,
        getUser: mockGetUser,
        throttle: mockThrottle),
    setUp: () {
      when(() => mockGetUser(any()))
          .thenAnswer((_) async => const Right(_authUser));
      when(() => mockRestore(any()))
          .thenAnswer((_) async => Right(_snapshot()));
    },
    act: (b) => b.add(const RestoreRequested('user_001_1234567890')),
    expect: () => [
      const BackupInProgress(),
      RestoreSuccess(_snapshot()),
    ],
  );

  // 9 ─ RestoreRequested failure
  blocTest<BackupBloc, BackupState>(
    'RestoreRequested emits BackupError on failure',
    build: () => _makeBloc(
        create: mockCreate,
        restore: mockRestore,
        list: mockList,
        getUser: mockGetUser,
        throttle: mockThrottle),
    setUp: () {
      when(() => mockGetUser(any()))
          .thenAnswer((_) async => const Right(_authUser));
      when(() => mockRestore(any())).thenAnswer(
          (_) async => const Left(BackupFailure('not found')));
    },
    act: (b) => b.add(const RestoreRequested('bad_id')),
    expect: () =>
        [const BackupInProgress(), const BackupError('not found')],
  );

  // 10 ─ RestoreRequested: guest cannot restore
  blocTest<BackupBloc, BackupState>(
    'RestoreRequested emits Error when user is anonymous',
    build: () => _makeBloc(
        create: mockCreate,
        restore: mockRestore,
        list: mockList,
        getUser: mockGetUser,
        throttle: mockThrottle),
    setUp: () => when(() => mockGetUser(any()))
        .thenAnswer((_) async => const Right(_guestUser)),
    act: (b) => b.add(const RestoreRequested('some_id')),
    expect: () => [const BackupError('Sign in to restore backups')],
    verify: (_) => verifyNever(() => mockRestore(any())),
  );

  // 11 ─ Auto-backup: skips when user is anonymous
  blocTest<BackupBloc, BackupState>(
    'BackupAutoRequested emits nothing when user is anonymous',
    build: () => _makeBloc(
        create: mockCreate,
        restore: mockRestore,
        list: mockList,
        getUser: mockGetUser,
        throttle: mockThrottle),
    setUp: () => when(() => mockGetUser(any()))
        .thenAnswer((_) async => const Right(_guestUser)),
    act: (b) => b.add(BackupAutoRequested(_snapshot())),
    expect: () => [],
    verify: (_) => verifyNever(() => mockCreate(any())),
  );

  // 12 ─ Auto-backup: skips when within throttle window
  blocTest<BackupBloc, BackupState>(
    'BackupAutoRequested emits nothing when throttle says no',
    build: () => _makeBloc(
        create: mockCreate,
        restore: mockRestore,
        list: mockList,
        getUser: mockGetUser,
        throttle: mockThrottle),
    setUp: () {
      when(() => mockGetUser(any()))
          .thenAnswer((_) async => const Right(_authUser));
      when(() => mockThrottle.shouldBackup).thenReturn(false);
    },
    act: (b) => b.add(BackupAutoRequested(_snapshot())),
    expect: () => [],
    verify: (_) => verifyNever(() => mockCreate(any())),
  );

  // 13 ─ Auto-backup: proceeds when authenticated + throttle allows
  blocTest<BackupBloc, BackupState>(
    'BackupAutoRequested runs backup when conditions are met',
    build: () => _makeBloc(
        create: mockCreate,
        restore: mockRestore,
        list: mockList,
        getUser: mockGetUser,
        throttle: mockThrottle),
    setUp: () {
      when(() => mockGetUser(any()))
          .thenAnswer((_) async => const Right(_authUser));
      when(() => mockThrottle.shouldBackup).thenReturn(true);
      when(() => mockCreate(any()))
          .thenAnswer((_) async => const Right(unit));
      when(() => mockList(any()))
          .thenAnswer((_) async => Right([_meta()]));
    },
    act: (b) => b.add(BackupAutoRequested(_snapshot())),
    expect: () => [
      const BackupInProgress(),
      BackupLoaded(backups: [_meta()], lastBackupAt: null),
    ],
    verify: (_) {
      verify(() => mockCreate(any())).called(1);
      verify(() => mockThrottle.recordBackup()).called(1);
    },
  );

  // 14 ─ Auto-backup records throttle timestamp on success
  blocTest<BackupBloc, BackupState>(
    'BackupAutoRequested calls throttle.recordBackup on success',
    build: () => _makeBloc(
        create: mockCreate,
        restore: mockRestore,
        list: mockList,
        getUser: mockGetUser,
        throttle: mockThrottle),
    setUp: () {
      when(() => mockGetUser(any()))
          .thenAnswer((_) async => const Right(_authUser));
      when(() => mockCreate(any()))
          .thenAnswer((_) async => const Right(unit));
      when(() => mockList(any()))
          .thenAnswer((_) async => const Right([]));
    },
    act: (b) => b.add(BackupAutoRequested(_snapshot())),
    verify: (_) => verify(() => mockThrottle.recordBackup()).called(1),
  );

  // 15 ─ BackupLoaded state carries correct lastBackupAt
  blocTest<BackupBloc, BackupState>(
    'BackupLoaded exposes lastBackupAt from throttle after list',
    build: () => _makeBloc(
        create: mockCreate,
        restore: mockRestore,
        list: mockList,
        getUser: mockGetUser,
        throttle: mockThrottle),
    setUp: () {
      when(() => mockList(any()))
          .thenAnswer((_) async => const Right([]));
      when(() => mockThrottle.lastBackupAt)
          .thenReturn(DateTime(2026, 6, 28, 8));
    },
    act: (b) => b.add(const BackupListRequested('user_001')),
    verify: (bloc) {
      final state = bloc.state as BackupLoaded;
      expect(state.lastBackupAt, DateTime(2026, 6, 28, 8));
    },
  );
}
