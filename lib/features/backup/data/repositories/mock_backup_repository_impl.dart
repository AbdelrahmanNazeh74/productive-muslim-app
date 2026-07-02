import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/backup_snapshot.dart';
import '../../domain/repositories/backup_repository.dart';
import '../../domain/usecases/backup_usecases.dart';

const _kLastBackupKey = 'last_backup_at';
const _kThrottleHours = 24;

// Serialises BackupSnapshot to JSON and saves in app documents directory.
// Simulates a 1-second network delay to mimic real cloud behaviour.
// To replace: create FirebaseBackupRepositoryImpl using Firestore.
//   Collection path: users/{userId}/backups/{backupId}.
//   Swap binding in app_dependencies.dart. No BLoC or UI changes needed.
class MockBackupRepositoryImpl implements BackupRepository {
  MockBackupRepositoryImpl();

  @override
  Future<Either<Failure, Unit>> createBackup(BackupSnapshot snapshot) async {
    log('MOCK: Backup saved locally — replace with real cloud implementation',
        name: 'MockBackupRepository');
    try {
      // Simulate network latency.
      await Future.delayed(const Duration(seconds: 1));
      final dir = await _backupDir();
      final file = File('${dir.path}/${snapshot.id}.json');
      final json = jsonEncode(_snapshotToJson(snapshot));
      await file.writeAsString(json);
      return const Right(unit);
    } catch (e) {
      return Left(BackupFailure('Failed to save backup: $e'));
    }
  }

  @override
  Future<Either<Failure, BackupSnapshot>> restoreBackup(
      String backupId) async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      final dir = await _backupDir();
      final file = File('${dir.path}/$backupId.json');
      if (!file.existsSync()) {
        return const Left(BackupFailure('Backup file not found'));
      }
      final json = jsonDecode(await file.readAsString()) as Map<String, dynamic>;
      return Right(_snapshotFromJson(json));
    } catch (e) {
      return Left(BackupFailure('Failed to restore backup: $e'));
    }
  }

  @override
  Future<Either<Failure, List<BackupMetadata>>> listBackups(
      String userId) async {
    try {
      final dir = await _backupDir();
      if (!dir.existsSync()) return const Right([]);
      final files = dir
          .listSync()
          .whereType<File>()
          .where((f) => f.path.endsWith('.json'))
          .toList()
        ..sort((a, b) => b.statSync().modified.compareTo(a.statSync().modified));
      final results = <BackupMetadata>[];
      for (final file in files) {
        try {
          final json =
              jsonDecode(await file.readAsString()) as Map<String, dynamic>;
          final snapshot = _snapshotFromJson(json);
          results.add(snapshot.metadata);
        } catch (_) {
          // Skip corrupt files.
        }
      }
      return Right(results);
    } catch (e) {
      return Left(BackupFailure('Failed to list backups: $e'));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteBackup(String backupId) async {
    try {
      final dir = await _backupDir();
      final file = File('${dir.path}/$backupId.json');
      if (file.existsSync()) await file.delete();
      return const Right(unit);
    } catch (e) {
      return Left(BackupFailure('Failed to delete backup: $e'));
    }
  }

  // ── Helpers ──────────────────────────────────────────────────────────────────

  Future<Directory> _backupDir() async {
    final docs = await getApplicationDocumentsDirectory();
    final dir = Directory('${docs.path}/pm_backups');
    if (!dir.existsSync()) dir.createSync(recursive: true);
    return dir;
  }

  Map<String, dynamic> _snapshotToJson(BackupSnapshot s) => {
        'userId': s.userId,
        'createdAt': s.createdAt.toIso8601String(),
        'appVersion': s.appVersion,
        'userProfile': s.userProfile,
        'habits': s.habits,
        'streakRecords': s.streakRecords,
        'settings': s.settings,
      };

  BackupSnapshot _snapshotFromJson(Map<String, dynamic> m) => BackupSnapshot(
        userId: m['userId'] as String,
        createdAt: DateTime.parse(m['createdAt'] as String),
        appVersion: m['appVersion'] as String,
        userProfile: m['userProfile'] as Map<String, dynamic>,
        habits: (m['habits'] as List)
            .cast<Map<String, dynamic>>(),
        streakRecords: (m['streakRecords'] as List)
            .cast<Map<String, dynamic>>(),
        settings: m['settings'] as Map<String, dynamic>,
      );
}

// ─── THROTTLE IMPL ───────────────────────────────────────────────────────────

class BackupThrottleImpl implements BackupThrottle {
  final SharedPreferences _prefs;

  BackupThrottleImpl(this._prefs);

  @override
  bool get shouldBackup {
    final lastMs = _prefs.getInt(_kLastBackupKey);
    if (lastMs == null) return true;
    final diff = DateTime.now().millisecondsSinceEpoch - lastMs;
    return diff >= const Duration(hours: _kThrottleHours).inMilliseconds;
  }

  @override
  Future<void> recordBackup() async {
    await _prefs.setInt(
        _kLastBackupKey, DateTime.now().millisecondsSinceEpoch);
  }

  @override
  DateTime? get lastBackupAt {
    final lastMs = _prefs.getInt(_kLastBackupKey);
    return lastMs != null
        ? DateTime.fromMillisecondsSinceEpoch(lastMs)
        : null;
  }
}
