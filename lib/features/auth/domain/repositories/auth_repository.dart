import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/auth_user.dart';

abstract class AuthRepository {
  Future<Either<Failure, AuthUser>> signInWithGoogle();
  Future<Either<Failure, AuthUser>> signInAsGuest();
  Future<Either<Failure, Unit>> signOut();
  Future<Either<Failure, AuthUser?>> getCurrentUser();
  Stream<AuthUser?> authStateChanges();
}
