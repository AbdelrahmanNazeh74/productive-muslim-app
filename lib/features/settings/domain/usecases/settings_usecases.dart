import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/app_settings.dart';
import '../repositories/settings_repository.dart';

class LoadSettings implements UseCase<AppSettings, NoParams> {
  final SettingsRepository repository;
  const LoadSettings(this.repository);

  @override
  Future<Either<Failure, AppSettings>> call(NoParams params) =>
      repository.loadSettings();
}

class SaveSettingsParams extends Equatable {
  final AppSettings settings;
  const SaveSettingsParams(this.settings);
  @override
  List<Object?> get props => [settings];
}

class SaveSettings implements UseCase<void, SaveSettingsParams> {
  final SettingsRepository repository;
  const SaveSettings(this.repository);

  @override
  Future<Either<Failure, void>> call(SaveSettingsParams params) =>
      repository.saveSettings(params.settings);
}

class ResetSettings implements UseCase<void, NoParams> {
  final SettingsRepository repository;
  const ResetSettings(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) =>
      repository.resetSettings();
}
