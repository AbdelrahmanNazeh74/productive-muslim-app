import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/auth_user.dart';
import '../repositories/auth_repository.dart';

class SignInWithGoogle extends UseCase<AuthUser, NoParams> {
  final AuthRepository _repository;
  SignInWithGoogle(this._repository);

  @override
  Future<Either<Failure, AuthUser>> call(NoParams params) =>
      _repository.signInWithGoogle();
}

class SignInAsGuest extends UseCase<AuthUser, NoParams> {
  final AuthRepository _repository;
  SignInAsGuest(this._repository);

  @override
  Future<Either<Failure, AuthUser>> call(NoParams params) =>
      _repository.signInAsGuest();
}

class SignOut extends UseCase<Unit, NoParams> {
  final AuthRepository _repository;
  SignOut(this._repository);

  @override
  Future<Either<Failure, Unit>> call(NoParams params) =>
      _repository.signOut();
}

class GetCurrentUser extends UseCase<AuthUser?, NoParams> {
  final AuthRepository _repository;
  GetCurrentUser(this._repository);

  @override
  Future<Either<Failure, AuthUser?>> call(NoParams params) =>
      _repository.getCurrentUser();
}

// WatchAuthState returns a Stream — not a Future — so it does not extend UseCase.
class WatchAuthState {
  final AuthRepository _repository;
  WatchAuthState(this._repository);

  Stream<AuthUser?> call() => _repository.authStateChanges();
}
