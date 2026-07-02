import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/backup_snapshot.dart';
import '../../domain/repositories/backup_repository.dart';

/// Firestore implementation of [BackupRepository].
///
/// Collection structure: users/{userId}/backups/{backupId}
class FirebaseBackupRepositoryImpl implements BackupRepository {
  final FirebaseFirestore _db;

  FirebaseBackupRepositoryImpl({FirebaseFirestore? db})
      : _db = db ?? FirebaseFirestore.instance {
    FirebaseFirestore.instance.settings =
        const Settings(persistenceEnabled: true);
  }

  CollectionReference<Map<String, dynamic>> _col(String userId) =>
      _db.collection('users').doc(userId).collection('backups');

  @override
  Future<Either<Failure, Unit>> createBackup(BackupSnapshot snapshot) async {
    try {
      final doc = _col(snapshot.userId).doc();
      await doc.set({
        'userId': snapshot.userId,
        'createdAt': snapshot.createdAt.toIso8601String(),
        'appVersion': snapshot.appVersion,
        'userProfile': snapshot.userProfile,
        'habits': snapshot.habits,
        'streakRecords': snapshot.streakRecords,
        'settings': snapshot.settings,
        'habitCount': snapshot.habits.length,
      });
      return const Right(unit);
    } on FirebaseException catch (e) {
      return Left(BackupFailure('Firestore write failed: ${e.message}'));
    }
  }

  @override
  Future<Either<Failure, BackupSnapshot>> restoreBackup(
      String backupId) async {
    try {
      final parts = backupId.split(':');
      if (parts.length != 2) {
        return Left(BackupFailure('Invalid backupId format: $backupId'));
      }
      final doc = await _col(parts[0]).doc(parts[1]).get();
      if (!doc.exists) return const Left(BackupFailure('Backup not found.'));
      final d = doc.data()!;
      return Right(BackupSnapshot(
        userId: d['userId'] as String,
        createdAt: DateTime.parse(d['createdAt'] as String),
        appVersion: d['appVersion'] as String,
        userProfile: Map<String, dynamic>.from(d['userProfile'] as Map),
        habits: List<Map<String, dynamic>>.from(d['habits'] as List),
        streakRecords:
            List<Map<String, dynamic>>.from(d['streakRecords'] as List),
        settings: Map<String, dynamic>.from(d['settings'] as Map),
      ));
    } on FirebaseException catch (e) {
      return Left(BackupFailure('Firestore read failed: ${e.message}'));
    }
  }

  @override
  Future<Either<Failure, List<BackupMetadata>>> listBackups(
      String userId) async {
    try {
      final query = await _col(userId)
          .orderBy('createdAt', descending: true)
          .limit(10)
          .get();
      final metas = query.docs.map((doc) {
        final d = doc.data();
        return BackupMetadata(
          id: '$userId:${doc.id}',
          createdAt: DateTime.parse(d['createdAt'] as String),
          appVersion: d['appVersion'] as String,
          habitCount: (d['habitCount'] as num).toInt(),
          userId: userId,
        );
      }).toList();
      return Right(metas);
    } on FirebaseException catch (e) {
      return Left(BackupFailure('Firestore list failed: ${e.message}'));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteBackup(String backupId) async {
    try {
      final parts = backupId.split(':');
      if (parts.length != 2) {
        return Left(BackupFailure('Invalid backupId format: $backupId'));
      }
      await _col(parts[0]).doc(parts[1]).delete();
      return const Right(unit);
    } on FirebaseException catch (e) {
      return Left(BackupFailure('Firestore delete failed: ${e.message}'));
    }
  }
}
