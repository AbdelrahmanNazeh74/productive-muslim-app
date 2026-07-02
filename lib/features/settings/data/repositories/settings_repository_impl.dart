import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/app_settings.dart';
import '../../domain/repositories/settings_repository.dart';
import '../services/settings_service.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsService _service;
  const SettingsRepositoryImpl(this._service);

  @override
  Future<Either<Failure, AppSettings>> loadSettings() async {
    try {
      return Right(await _service.load());
    } catch (e) {
      return const Left(CacheFailure('Failed to load settings'));
    }
  }

  @override
  Future<Either<Failure, void>> saveSettings(AppSettings settings) async {
    try {
      await _service.save(settings);
      return const Right(null);
    } catch (e) {
      return const Left(CacheFailure('Failed to save settings'));
    }
  }

  @override
  Future<Either<Failure, void>> resetSettings() async {
    try {
      await _service.reset();
      return const Right(null);
    } catch (e) {
      return const Left(CacheFailure('Failed to reset settings'));
    }
  }
}
