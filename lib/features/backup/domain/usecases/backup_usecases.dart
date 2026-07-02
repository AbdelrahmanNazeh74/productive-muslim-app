import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/backup_snapshot.dart';
import '../repositories/backup_repository.dart';

// ─── PARAMS ───────────────────────────────────────────────────────────────────

class CreateBackupParams {
  final BackupSnapshot snapshot;
  const CreateBackupParams({required this.snapshot});
}

class RestoreBackupParams {
  final String backupId;
  const RestoreBackupParams({required this.backupId});
}

class ListBackupsParams {
  final String userId;
  const ListBackupsParams({required this.userId});
}

class DeleteBackupParams {
  final String backupId;
  const DeleteBackupParams({required this.backupId});
}

// ─── USE CASES ────────────────────────────────────────────────────────────────

class CreateBackup extends UseCase<Unit, CreateBackupParams> {
  final BackupRepository _repository;
  CreateBackup(this._repository);

  @override
  Future<Either<Failure, Unit>> call(CreateBackupParams params) =>
      _repository.createBackup(params.snapshot);
}

class RestoreBackup extends UseCase<BackupSnapshot, RestoreBackupParams> {
  final BackupRepository _repository;
  RestoreBackup(this._repository);

  @override
  Future<Either<Failure, BackupSnapshot>> call(RestoreBackupParams params) =>
      _repository.restoreBackup(params.backupId);
}

class ListBackups extends UseCase<List<BackupMetadata>, ListBackupsParams> {
  final BackupRepository _repository;
  ListBackups(this._repository);

  @override
  Future<Either<Failure, List<BackupMetadata>>> call(
          ListBackupsParams params) =>
      _repository.listBackups(params.userId);
}

// ─── THROTTLE ─────────────────────────────────────────────────────────────────
// Abstract so it can be mocked in tests. Impl lives in data layer.

abstract class BackupThrottle {
  bool get shouldBackup;
  Future<void> recordBackup();
  DateTime? get lastBackupAt;
}
