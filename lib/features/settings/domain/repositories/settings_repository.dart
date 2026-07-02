import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/app_settings.dart';

abstract class SettingsRepository {
  Future<Either<Failure, AppSettings>> loadSettings();
  Future<Either<Failure, void>> saveSettings(AppSettings settings);
  Future<Either<Failure, void>> resetSettings();
}
