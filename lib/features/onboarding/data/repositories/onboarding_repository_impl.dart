import 'package:dartz/dartz.dart';
import 'package:isar/isar.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/onboarding_repository.dart';
import '../models/user_profile_model.dart';

class OnboardingRepositoryImpl implements OnboardingRepository {
  final Isar isar;

  OnboardingRepositoryImpl({required this.isar});

  @override
  Future<Either<Failure, UserProfile>> saveUserProfile(
      UserProfile profile) async {
    try {
      final model = UserProfileModel.fromEntity(profile);
      await isar.writeTxn(() async {
        await isar.userProfileModels.put(model);
      });
      return Right(model.toEntity());
    } catch (e) {
      return Left(DatabaseFailure('Failed to save user profile: $e'));
    }
  }

  @override
  Future<Either<Failure, UserProfile?>> getUserProfile() async {
    try {
      final model = await isar.userProfileModels.where().findFirst();
      return Right(model?.toEntity());
    } catch (e) {
      return Left(DatabaseFailure('Failed to retrieve user profile: $e'));
    }
  }

  @override
  Future<Either<Failure, UserProfile>> updateUserProfile(
      UserProfile profile) async {
    try {
      if (profile.id == null) {
        return const Left(
            DatabaseFailure('Cannot update a profile without an ID'));
      }
      final model = UserProfileModel.fromEntity(profile);
      await isar.writeTxn(() async {
        await isar.userProfileModels.put(model);
      });
      return Right(model.toEntity());
    } catch (e) {
      return Left(DatabaseFailure('Failed to update user profile: $e'));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteUserProfile() async {
    try {
      await isar.writeTxn(() async {
        await isar.userProfileModels.where().deleteAll();
      });
      return const Right(true);
    } catch (e) {
      return Left(DatabaseFailure('Failed to delete user profile: $e'));
    }
  }
}
