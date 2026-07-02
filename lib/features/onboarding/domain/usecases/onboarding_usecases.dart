import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user_profile.dart';
import '../repositories/onboarding_repository.dart';

// ─── SAVE USER PROFILE ────────────────────────────────────────────────────────
class SaveUserProfile implements UseCase<UserProfile, UserProfile> {
  final OnboardingRepository repository;
  SaveUserProfile(this.repository);

  @override
  Future<Either<Failure, UserProfile>> call(UserProfile params) {
    return repository.saveUserProfile(params);
  }
}

// ─── GET USER PROFILE ─────────────────────────────────────────────────────────
class GetUserProfile implements UseCase<UserProfile?, NoParams> {
  final OnboardingRepository repository;
  GetUserProfile(this.repository);

  @override
  Future<Either<Failure, UserProfile?>> call(NoParams params) {
    return repository.getUserProfile();
  }
}

// ─── UPDATE USER PROFILE ──────────────────────────────────────────────────────
class UpdateUserProfile implements UseCase<UserProfile, UserProfile> {
  final OnboardingRepository repository;
  UpdateUserProfile(this.repository);

  @override
  Future<Either<Failure, UserProfile>> call(UserProfile params) {
    return repository.updateUserProfile(params);
  }
}
