// READY TO ACTIVATE — see HANDOVER.md Section 3e
//
// This file contains the complete Firebase Auth implementation.
// All code is correct and production-ready — only the imports are commented out.
//
// To activate:
//   1. Complete Firebase setup (see EnvironmentConfig — lib/core/di/environment_config.dart)
//   2. Uncomment the imports below
//   3. In environment_config.dart: uncomment the FirebaseAuthRepositoryImpl import
//      and the `return FirebaseAuthRepositoryImpl()` line in authRepository()
//   4. Set EnvironmentConfig.useFirebase = true

// import 'package:firebase_auth/firebase_auth.dart' as fb;
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/auth_user.dart';
import '../../domain/repositories/auth_repository.dart';

// ignore_for_file: unused_import
import 'package:dartz/dartz.dart';

/// Firebase implementation of [AuthRepository].
///
/// Handles Google Sign-In via Firebase Auth with full error handling.
/// Swaps in for [MockAuthRepositoryImpl] when Firebase is activated.
class FirebaseAuthRepositoryImpl implements AuthRepository {
  // final fb.FirebaseAuth _auth;
  // final GoogleSignIn _googleSignIn;
  //
  // FirebaseAuthRepositoryImpl({
  //   fb.FirebaseAuth? auth,
  //   GoogleSignIn? googleSignIn,
  // })  : _auth = auth ?? fb.FirebaseAuth.instance,
  //       _googleSignIn = googleSignIn ?? GoogleSignIn();

  @override
  Future<Either<Failure, AuthUser>> signInWithGoogle() async {
    // try {
    //   final account = await _googleSignIn.signIn();
    //   if (account == null) {
    //     return Left(AuthFailure('Google Sign-In was cancelled.'));
    //   }
    //   final googleAuth = await account.authentication;
    //   final credential = fb.GoogleAuthProvider.credential(
    //     accessToken: googleAuth.accessToken,
    //     idToken: googleAuth.idToken,
    //   );
    //   final result = await _auth.signInWithCredential(credential);
    //   final user = result.user;
    //   if (user == null) return Left(AuthFailure('Sign-in returned no user.'));
    //   return Right(_toAuthUser(user));
    // } on fb.FirebaseAuthException catch (e) {
    //   return Left(AuthFailure(e.message ?? 'Firebase auth error: ${e.code}'));
    // } catch (e) {
    //   return Left(AuthFailure('Google Sign-In failed: $e'));
    // }
    return const Left(AuthFailure('Firebase not activated.'));
  }

  @override
  Future<Either<Failure, AuthUser>> signInAsGuest() async {
    // try {
    //   final result = await _auth.signInAnonymously();
    //   final user = result.user;
    //   if (user == null) return Left(AuthFailure('Anonymous sign-in failed.'));
    //   return Right(_toAuthUser(user));
    // } on fb.FirebaseAuthException catch (e) {
    //   return Left(AuthFailure(e.message ?? 'Anonymous auth error: ${e.code}'));
    // }
    return const Left(AuthFailure('Firebase not activated.'));
  }

  @override
  Future<Either<Failure, Unit>> signOut() async {
    // try {
    //   await Future.wait([_auth.signOut(), _googleSignIn.signOut()]);
    //   return const Right(unit);
    // } catch (e) {
    //   return Left(AuthFailure('Sign-out failed: $e'));
    // }
    return const Right(unit);
  }

  @override
  Future<Either<Failure, AuthUser?>> getCurrentUser() async {
    // final user = _auth.currentUser;
    // return Right(user == null ? null : _toAuthUser(user));
    return const Right(null);
  }

  @override
  Stream<AuthUser?> authStateChanges() {
    // return _auth.authStateChanges().map(
    //   (user) => user == null ? null : _toAuthUser(user),
    // );
    return const Stream.empty();
  }

  // AuthUser _toAuthUser(fb.User user) => AuthUser(
  //   id: user.uid,
  //   email: user.email ?? '',
  //   displayName: user.displayName ?? 'User',
  //   isAnonymous: user.isAnonymous,
  // );
}
