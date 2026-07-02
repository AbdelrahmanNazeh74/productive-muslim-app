import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/auth_user.dart';
import '../../domain/repositories/auth_repository.dart';

const _kAuthUserKey = 'auth_user_json';

// Stores auth state in SharedPreferences. signInWithGoogle returns a hardcoded
// mock user instantly with no network call.
// To replace: create GoogleAuthRepositoryImpl, swap binding in app_dependencies.dart.
class MockAuthRepositoryImpl implements AuthRepository {
  final SharedPreferences _prefs;
  final _controller = StreamController<AuthUser?>.broadcast();

  MockAuthRepositoryImpl(this._prefs) {
    // Replay current state into the stream on first subscription.
    _controller.onListen = () async {
      final current = await getCurrentUser();
      current.fold((_) => null, (u) => _controller.add(u));
    };
  }

  @override
  Future<Either<Failure, AuthUser>> signInWithGoogle() async {
    log('MOCK: Google Sign-In — replace with real implementation',
        name: 'MockAuthRepository');
    const user = AuthUser(
      id: 'mock_google_user_001',
      email: 'user@productivemuslim.app',
      displayName: 'Productive Muslim',
      isAnonymous: false,
    );
    await _persist(user);
    return const Right(user);
  }

  @override
  Future<Either<Failure, AuthUser>> signInAsGuest() async {
    log('MOCK: Guest Sign-In', name: 'MockAuthRepository');
    final user = AuthUser(
      id: 'guest_${const Uuid().v4()}',
      email: '',
      displayName: 'Guest',
      isAnonymous: true,
    );
    await _persist(user);
    return Right(user);
  }

  @override
  Future<Either<Failure, Unit>> signOut() async {
    log('MOCK: Sign-Out', name: 'MockAuthRepository');
    await _prefs.remove(_kAuthUserKey);
    _controller.add(null);
    return const Right(unit);
  }

  @override
  Future<Either<Failure, AuthUser?>> getCurrentUser() async {
    final json = _prefs.getString(_kAuthUserKey);
    if (json == null) return const Right(null);
    try {
      final map = jsonDecode(json) as Map<String, dynamic>;
      return Right(_fromJson(map));
    } catch (e) {
      return Left(AuthFailure('Failed to load user: $e'));
    }
  }

  @override
  Stream<AuthUser?> authStateChanges() => _controller.stream;

  // ── Private helpers ──────────────────────────────────────────────────────────

  Future<void> _persist(AuthUser user) async {
    await _prefs.setString(_kAuthUserKey, jsonEncode(_toJson(user)));
    _controller.add(user);
  }

  Map<String, dynamic> _toJson(AuthUser u) => {
        'id': u.id,
        'email': u.email,
        'displayName': u.displayName,
        'photoUrl': u.photoUrl,
        'isAnonymous': u.isAnonymous,
      };

  AuthUser _fromJson(Map<String, dynamic> m) => AuthUser(
        id: m['id'] as String,
        email: m['email'] as String,
        displayName: m['displayName'] as String?,
        photoUrl: m['photoUrl'] as String?,
        isAnonymous: m['isAnonymous'] as bool? ?? false,
      );
}
