import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:productive_muslim/features/auth/data/repositories/mock_auth_repository_impl.dart';
import 'package:productive_muslim/features/auth/domain/entities/auth_user.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  // ── signInWithGoogle ─────────────────────────────────────────────────────────

  group('MockAuthRepositoryImpl.signInWithGoogle', () {
    test('returns Right(AuthUser) with correct mock fields', () async {
      final prefs = await SharedPreferences.getInstance();
      final repo = MockAuthRepositoryImpl(prefs);
      final result = await repo.signInWithGoogle();
      expect(result.isRight(), isTrue);
      final user = result.getOrElse(() => throw Exception());
      expect(user.id, 'mock_google_user_001');
      expect(user.email, 'test@mock.com');
      expect(user.displayName, 'Test User (Mock)');
      expect(user.isAnonymous, isFalse);
    });

    test('persists user to SharedPreferences after sign-in', () async {
      final prefs = await SharedPreferences.getInstance();
      final repo = MockAuthRepositoryImpl(prefs);
      await repo.signInWithGoogle();
      expect(prefs.getString('auth_user_json'), isNotNull);
    });

    test('getCurrentUser returns the same user after signInWithGoogle', () async {
      final prefs = await SharedPreferences.getInstance();
      final repo = MockAuthRepositoryImpl(prefs);
      await repo.signInWithGoogle();
      final current = await repo.getCurrentUser();
      expect(current.isRight(), isTrue);
      final user = current.getOrElse(() => throw Exception());
      expect(user?.id, 'mock_google_user_001');
    });
  });

  // ── signInAsGuest ────────────────────────────────────────────────────────────

  group('MockAuthRepositoryImpl.signInAsGuest', () {
    test('returns Right(AuthUser) with isAnonymous = true', () async {
      final prefs = await SharedPreferences.getInstance();
      final repo = MockAuthRepositoryImpl(prefs);
      final result = await repo.signInAsGuest();
      expect(result.isRight(), isTrue);
      final user = result.getOrElse(() => throw Exception());
      expect(user.isAnonymous, isTrue);
    });

    test('guest user has empty email', () async {
      final prefs = await SharedPreferences.getInstance();
      final repo = MockAuthRepositoryImpl(prefs);
      final result = await repo.signInAsGuest();
      final user = result.getOrElse(() => throw Exception());
      expect(user.email, '');
    });

    test('guest user has "Guest" displayName', () async {
      final prefs = await SharedPreferences.getInstance();
      final repo = MockAuthRepositoryImpl(prefs);
      final result = await repo.signInAsGuest();
      final user = result.getOrElse(() => throw Exception());
      expect(user.displayName, 'Guest');
    });

    test('guest user ID starts with "guest_"', () async {
      final prefs = await SharedPreferences.getInstance();
      final repo = MockAuthRepositoryImpl(prefs);
      final result = await repo.signInAsGuest();
      final user = result.getOrElse(() => throw Exception());
      expect(user.id, startsWith('guest_'));
    });

    test('two guest sign-ins produce different IDs (UUID)', () async {
      final prefs = await SharedPreferences.getInstance();
      final repo = MockAuthRepositoryImpl(prefs);
      final r1 = await repo.signInAsGuest();
      final r2 = await repo.signInAsGuest();
      final u1 = r1.getOrElse(() => throw Exception());
      final u2 = r2.getOrElse(() => throw Exception());
      expect(u1.id, isNot(u2.id));
    });
  });

  // ── signOut ──────────────────────────────────────────────────────────────────

  group('MockAuthRepositoryImpl.signOut', () {
    test('returns Right(unit)', () async {
      final prefs = await SharedPreferences.getInstance();
      final repo = MockAuthRepositoryImpl(prefs);
      await repo.signInWithGoogle();
      final result = await repo.signOut();
      expect(result.isRight(), isTrue);
    });

    test('clears user from SharedPreferences', () async {
      final prefs = await SharedPreferences.getInstance();
      final repo = MockAuthRepositoryImpl(prefs);
      await repo.signInWithGoogle();
      expect(prefs.getString('auth_user_json'), isNotNull);
      await repo.signOut();
      expect(prefs.getString('auth_user_json'), isNull);
    });

    test('getCurrentUser returns null after signOut', () async {
      final prefs = await SharedPreferences.getInstance();
      final repo = MockAuthRepositoryImpl(prefs);
      await repo.signInWithGoogle();
      await repo.signOut();
      final result = await repo.getCurrentUser();
      expect(result.isRight(), isTrue);
      final user = result.getOrElse(() => throw Exception());
      expect(user, isNull);
    });
  });

  // ── getCurrentUser ───────────────────────────────────────────────────────────

  group('MockAuthRepositoryImpl.getCurrentUser', () {
    test('returns Right(null) on fresh prefs (no stored user)', () async {
      final prefs = await SharedPreferences.getInstance();
      final repo = MockAuthRepositoryImpl(prefs);
      final result = await repo.getCurrentUser();
      expect(result.isRight(), isTrue);
      final user = result.getOrElse(() => throw Exception());
      expect(user, isNull);
    });

    test('returns user correctly after signInAsGuest (isAnonymous preserved)', () async {
      final prefs = await SharedPreferences.getInstance();
      final repo = MockAuthRepositoryImpl(prefs);
      await repo.signInAsGuest();
      final result = await repo.getCurrentUser();
      final user = result.getOrElse(() => throw Exception());
      expect(user?.isAnonymous, isTrue);
    });

    test('survives new instance created with same SharedPreferences', () async {
      final prefs = await SharedPreferences.getInstance();
      final repo1 = MockAuthRepositoryImpl(prefs);
      await repo1.signInWithGoogle();

      final repo2 = MockAuthRepositoryImpl(prefs);
      final result = await repo2.getCurrentUser();
      final user = result.getOrElse(() => throw Exception());
      expect(user?.id, 'mock_google_user_001');
    });
  });

  // ── authStateChanges stream ──────────────────────────────────────────────────

  group('MockAuthRepositoryImpl.authStateChanges', () {
    test('stream emits user after signInWithGoogle', () async {
      final prefs = await SharedPreferences.getInstance();
      final repo = MockAuthRepositoryImpl(prefs);
      final events = <AuthUser?>[];
      final sub = repo.authStateChanges().listen(events.add);
      await repo.signInWithGoogle();
      await Future<void>.delayed(const Duration(milliseconds: 10));
      await sub.cancel();
      expect(events, contains(isA<AuthUser>()));
    });

    test('stream emits null after signOut', () async {
      final prefs = await SharedPreferences.getInstance();
      final repo = MockAuthRepositoryImpl(prefs);
      await repo.signInWithGoogle();
      final events = <AuthUser?>[];
      final sub = repo.authStateChanges().listen(events.add);
      await repo.signOut();
      await Future<void>.delayed(const Duration(milliseconds: 10));
      await sub.cancel();
      expect(events, contains(isNull));
    });

    test('stream replays current user on first subscription', () async {
      final prefs = await SharedPreferences.getInstance();
      final repo = MockAuthRepositoryImpl(prefs);
      await repo.signInWithGoogle();

      final events = <AuthUser?>[];
      final sub = repo.authStateChanges().listen(events.add);
      await Future<void>.delayed(const Duration(milliseconds: 30));
      await sub.cancel();
      // Should have replayed the stored user
      expect(events.any((u) => u?.id == 'mock_google_user_001'), isTrue);
    });
  });
}
