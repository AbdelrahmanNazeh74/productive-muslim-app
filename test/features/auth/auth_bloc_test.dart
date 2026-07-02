import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:productive_muslim/core/errors/failures.dart';
import 'package:productive_muslim/core/usecases/usecase.dart';
import 'package:productive_muslim/features/auth/domain/entities/auth_user.dart';
import 'package:productive_muslim/features/auth/domain/usecases/auth_usecases.dart';
import 'package:productive_muslim/features/auth/presentation/bloc/auth_bloc.dart';

// ── Mocks ─────────────────────────────────────────────────────────────────────

class MockSignInWithGoogle extends Mock implements SignInWithGoogle {}
class MockSignInAsGuest extends Mock implements SignInAsGuest {}
class MockSignOut extends Mock implements SignOut {}
class MockGetCurrentUser extends Mock implements GetCurrentUser {}
class MockWatchAuthState extends Mock implements WatchAuthState {}

// ── Helpers ───────────────────────────────────────────────────────────────────

const _googleUser = AuthUser(
  id: 'google_001',
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

AuthBloc _makeBloc({
  required MockSignInWithGoogle signIn,
  required MockSignInAsGuest signInGuest,
  required MockSignOut signOut,
  required MockGetCurrentUser getUser,
  required MockWatchAuthState watch,
}) =>
    AuthBloc(
      signInWithGoogle: signIn,
      signInAsGuest: signInGuest,
      signOut: signOut,
      getCurrentUser: getUser,
      watchAuthState: watch,
    );

void main() {
  late MockSignInWithGoogle mockSignIn;
  late MockSignInAsGuest mockSignInGuest;
  late MockSignOut mockSignOut;
  late MockGetCurrentUser mockGetUser;
  late MockWatchAuthState mockWatch;
  late StreamController<AuthUser?> authStream;

  setUpAll(() {
    registerFallbackValue(const NoParams());
  });

  setUp(() {
    mockSignIn = MockSignInWithGoogle();
    mockSignInGuest = MockSignInAsGuest();
    mockSignOut = MockSignOut();
    mockGetUser = MockGetCurrentUser();
    mockWatch = MockWatchAuthState();
    authStream = StreamController<AuthUser?>.broadcast();
    when(() => mockWatch()).thenAnswer((_) => authStream.stream);
  });

  tearDown(() => authStream.close());

  // 1 ─ Initial state
  test('initial state is AuthInitial', () {
    final bloc = _makeBloc(
        signIn: mockSignIn,
        signInGuest: mockSignInGuest,
        signOut: mockSignOut,
        getUser: mockGetUser,
        watch: mockWatch);
    expect(bloc.state, const AuthInitial());
    bloc.close();
  });

  // 2 ─ AuthCheckRequested: no stored user → Unauthenticated
  blocTest<AuthBloc, AuthState>(
    'AuthCheckRequested emits Loading → Unauthenticated when no user',
    build: () => _makeBloc(
        signIn: mockSignIn,
        signInGuest: mockSignInGuest,
        signOut: mockSignOut,
        getUser: mockGetUser,
        watch: mockWatch),
    setUp: () => when(() => mockGetUser(any()))
        .thenAnswer((_) async => const Right(null)),
    act: (b) => b.add(const AuthCheckRequested()),
    expect: () => [const AuthLoading(), const AuthUnauthenticated()],
  );

  // 3 ─ AuthCheckRequested: stored user → Authenticated
  blocTest<AuthBloc, AuthState>(
    'AuthCheckRequested emits Loading → Authenticated when user exists',
    build: () => _makeBloc(
        signIn: mockSignIn,
        signInGuest: mockSignInGuest,
        signOut: mockSignOut,
        getUser: mockGetUser,
        watch: mockWatch),
    setUp: () => when(() => mockGetUser(any()))
        .thenAnswer((_) async => const Right(_googleUser)),
    act: (b) => b.add(const AuthCheckRequested()),
    expect: () =>
        [const AuthLoading(), const AuthAuthenticated(_googleUser)],
  );

  // 4 ─ AuthCheckRequested: failure → AuthError
  blocTest<AuthBloc, AuthState>(
    'AuthCheckRequested emits AuthError on failure',
    build: () => _makeBloc(
        signIn: mockSignIn,
        signInGuest: mockSignInGuest,
        signOut: mockSignOut,
        getUser: mockGetUser,
        watch: mockWatch),
    setUp: () => when(() => mockGetUser(any()))
        .thenAnswer((_) async => const Left(AuthFailure('load error'))),
    act: (b) => b.add(const AuthCheckRequested()),
    expect: () => [const AuthLoading(), const AuthError('load error')],
  );

  // 5 ─ AuthSignInRequested success
  blocTest<AuthBloc, AuthState>(
    'AuthSignInRequested emits Loading → Authenticated on success',
    build: () => _makeBloc(
        signIn: mockSignIn,
        signInGuest: mockSignInGuest,
        signOut: mockSignOut,
        getUser: mockGetUser,
        watch: mockWatch),
    setUp: () => when(() => mockSignIn(any()))
        .thenAnswer((_) async => const Right(_googleUser)),
    act: (b) => b.add(const AuthSignInRequested()),
    expect: () =>
        [const AuthLoading(), const AuthAuthenticated(_googleUser)],
  );

  // 6 ─ AuthSignInRequested failure
  blocTest<AuthBloc, AuthState>(
    'AuthSignInRequested emits AuthError on failure',
    build: () => _makeBloc(
        signIn: mockSignIn,
        signInGuest: mockSignInGuest,
        signOut: mockSignOut,
        getUser: mockGetUser,
        watch: mockWatch),
    setUp: () => when(() => mockSignIn(any()))
        .thenAnswer(
            (_) async => const Left(AuthFailure('sign-in failed'))),
    act: (b) => b.add(const AuthSignInRequested()),
    expect: () =>
        [const AuthLoading(), const AuthError('sign-in failed')],
  );

  // 7 ─ AuthGuestRequested success → isAnonymous true
  blocTest<AuthBloc, AuthState>(
    'AuthGuestRequested emits Authenticated with isAnonymous=true',
    build: () => _makeBloc(
        signIn: mockSignIn,
        signInGuest: mockSignInGuest,
        signOut: mockSignOut,
        getUser: mockGetUser,
        watch: mockWatch),
    setUp: () => when(() => mockSignInGuest(any()))
        .thenAnswer((_) async => const Right(_guestUser)),
    act: (b) => b.add(const AuthGuestRequested()),
    expect: () =>
        [const AuthLoading(), const AuthAuthenticated(_guestUser)],
    verify: (bloc) {
      final state = bloc.state as AuthAuthenticated;
      expect(state.user.isAnonymous, isTrue);
    },
  );

  // 8 ─ AuthGuestRequested failure
  blocTest<AuthBloc, AuthState>(
    'AuthGuestRequested emits AuthError on failure',
    build: () => _makeBloc(
        signIn: mockSignIn,
        signInGuest: mockSignInGuest,
        signOut: mockSignOut,
        getUser: mockGetUser,
        watch: mockWatch),
    setUp: () => when(() => mockSignInGuest(any()))
        .thenAnswer(
            (_) async => const Left(AuthFailure('guest failed'))),
    act: (b) => b.add(const AuthGuestRequested()),
    expect: () =>
        [const AuthLoading(), const AuthError('guest failed')],
  );

  // 9 ─ AuthSignOutRequested
  blocTest<AuthBloc, AuthState>(
    'AuthSignOutRequested emits Unauthenticated',
    build: () => _makeBloc(
        signIn: mockSignIn,
        signInGuest: mockSignInGuest,
        signOut: mockSignOut,
        getUser: mockGetUser,
        watch: mockWatch),
    setUp: () => when(() => mockSignOut(any()))
        .thenAnswer((_) async => const Right(unit)),
    act: (b) => b.add(const AuthSignOutRequested()),
    expect: () => [const AuthUnauthenticated()],
  );

  // 10 ─ Auth state stream fires a user → Authenticated
  blocTest<AuthBloc, AuthState>(
    'auth stream user event emits Authenticated',
    build: () => _makeBloc(
        signIn: mockSignIn,
        signInGuest: mockSignInGuest,
        signOut: mockSignOut,
        getUser: mockGetUser,
        watch: mockWatch),
    act: (b) => authStream.add(_googleUser),
    expect: () => [const AuthAuthenticated(_googleUser)],
  );

  // 11 ─ Auth state stream fires null → Unauthenticated
  blocTest<AuthBloc, AuthState>(
    'auth stream null event emits Unauthenticated',
    build: () => _makeBloc(
        signIn: mockSignIn,
        signInGuest: mockSignInGuest,
        signOut: mockSignOut,
        getUser: mockGetUser,
        watch: mockWatch),
    act: (b) => authStream.add(null),
    expect: () => [const AuthUnauthenticated()],
  );

  // 12 ─ AuthUser entity equality
  test('AuthUser equality compares all fields', () {
    const a = AuthUser(id: 'x', email: 'a@b.com', isAnonymous: false);
    const b = AuthUser(id: 'x', email: 'a@b.com', isAnonymous: false);
    expect(a, equals(b));
  });

  // 13 ─ AuthUser copyWith
  test('AuthUser.copyWith produces new instance with updated field', () {
    const original = AuthUser(id: '1', email: 'a@b.com', isAnonymous: false);
    final copy = original.copyWith(displayName: 'Ali');
    expect(copy.id, '1');
    expect(copy.displayName, 'Ali');
    expect(copy.isAnonymous, false);
    expect(copy, isNot(same(original)));
  });

  // 14 ─ Google user is NOT anonymous
  test('Google sign-in user has isAnonymous = false', () {
    expect(_googleUser.isAnonymous, isFalse);
    expect(_googleUser.email, isNotEmpty);
  });

  // 15 ─ Guest user IS anonymous
  test('Guest user has isAnonymous = true and empty email', () {
    expect(_guestUser.isAnonymous, isTrue);
    expect(_guestUser.email, isEmpty);
  });

  // 16 ─ Re-auth after sign-out: can sign in again
  blocTest<AuthBloc, AuthState>(
    'sign-in after sign-out emits Authenticated again',
    build: () => _makeBloc(
        signIn: mockSignIn,
        signInGuest: mockSignInGuest,
        signOut: mockSignOut,
        getUser: mockGetUser,
        watch: mockWatch),
    setUp: () {
      when(() => mockSignOut(any()))
          .thenAnswer((_) async => const Right(unit));
      when(() => mockSignIn(any()))
          .thenAnswer((_) async => const Right(_googleUser));
    },
    act: (b) async {
      b.add(const AuthSignOutRequested());
      await Future.delayed(Duration.zero);
      b.add(const AuthSignInRequested());
    },
    expect: () => [
      const AuthUnauthenticated(),
      const AuthLoading(),
      const AuthAuthenticated(_googleUser),
    ],
  );
}
