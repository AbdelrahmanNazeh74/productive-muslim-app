import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/backup_snapshot.dart';

abstract class BackupRepository {
  Future<Either<Failure, Unit>> createBackup(BackupSnapshot snapshot);
  Future<Either<Failure, BackupSnapshot>> restoreBackup(String backupId);
  Future<Either<Failure, List<BackupMetadata>>> listBackups(String userId);
  Future<Either<Failure, Unit>> deleteBackup(String backupId);
}
