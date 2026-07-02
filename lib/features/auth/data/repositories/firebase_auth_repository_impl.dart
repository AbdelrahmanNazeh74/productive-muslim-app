import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:google_sign_in/google_sign_in.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/auth_user.dart';
import '../../domain/repositories/auth_repository.dart';

class FirebaseAuthRepositoryImpl implements AuthRepository {
  final fb.FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;

  FirebaseAuthRepositoryImpl({
    fb.FirebaseAuth? auth,
    GoogleSignIn? googleSignIn,
  })  : _auth = auth ?? fb.FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn(scopes: ['email']);

  @override
  Future<Either<Failure, AuthUser>> signInWithGoogle() async {
    try {
      final account = await _googleSignIn.signIn();
      if (account == null) {
        return const Left(AuthFailure('Google Sign-In was cancelled.'));
      }
      final googleAuth = await account.authentication;
      final credential = fb.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final result = await _auth.signInWithCredential(credential);
      final user = result.user;
      if (user == null) return const Left(AuthFailure('Sign-in returned no user.'));
      return Right(_toAuthUser(user));
    } on fb.FirebaseAuthException catch (e) {
      return Left(AuthFailure(e.message ?? 'Firebase auth error: ${e.code}'));
    } catch (e) {
      return Left(AuthFailure('Google Sign-In failed: $e'));
    }
  }

  @override
  Future<Either<Failure, AuthUser>> signInAsGuest() async {
    try {
      final result = await _auth.signInAnonymously();
      final user = result.user;
      if (user == null) return const Left(AuthFailure('Anonymous sign-in failed.'));
      return Right(_toAuthUser(user));
    } on fb.FirebaseAuthException catch (e) {
      return Left(AuthFailure(e.message ?? 'Anonymous auth error: ${e.code}'));
    }
  }

  @override
  Future<Either<Failure, Unit>> signOut() async {
    try {
      await Future.wait([_auth.signOut(), _googleSignIn.signOut()]);
      return const Right(unit);
    } catch (e) {
      return Left(AuthFailure('Sign-out failed: $e'));
    }
  }

  @override
  Future<Either<Failure, AuthUser?>> getCurrentUser() async {
    final user = _auth.currentUser;
    return Right(user == null ? null : _toAuthUser(user));
  }

  @override
  Stream<AuthUser?> authStateChanges() {
    return _auth.authStateChanges().map(
      (user) => user == null ? null : _toAuthUser(user),
    );
  }

  AuthUser _toAuthUser(fb.User user) => AuthUser(
        id: user.uid,
        email: user.email ?? '',
        displayName: user.displayName ?? 'User',
        isAnonymous: user.isAnonymous,
      );
}
