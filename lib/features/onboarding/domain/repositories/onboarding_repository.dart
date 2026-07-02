import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user_profile.dart';

abstract class OnboardingRepository {
  Future<Either<Failure, UserProfile>> saveUserProfile(UserProfile profile);
  Future<Either<Failure, UserProfile?>> getUserProfile();
  Future<Either<Failure, bool>> deleteUserProfile();
  Future<Either<Failure, UserProfile>> updateUserProfile(UserProfile profile);
}
