import 'package:equatable/equatable.dart';

// Lightweight record used for listing available backups.
class BackupMetadata extends Equatable {
  final String id;
  final DateTime createdAt;
  final String appVersion;
  final int habitCount;
  final String userId;

  const BackupMetadata({
    required this.id,
    required this.createdAt,
    required this.appVersion,
    required this.habitCount,
    required this.userId,
  });

  @override
  List<Object?> get props => [id, createdAt, appVersion, habitCount, userId];
}

// Full snapshot of all user data, used for backup and restore.
class BackupSnapshot extends Equatable {
  final String userId;
  final DateTime createdAt;
  final String appVersion;
  final Map<String, dynamic> userProfile;
  final List<Map<String, dynamic>> habits;
  final List<Map<String, dynamic>> streakRecords;
  final Map<String, dynamic> settings;

  const BackupSnapshot({
    required this.userId,
    required this.createdAt,
    required this.appVersion,
    required this.userProfile,
    required this.habits,
    required this.streakRecords,
    required this.settings,
  });

  String get id => '${userId}_${createdAt.millisecondsSinceEpoch}';

  BackupMetadata get metadata => BackupMetadata(
        id: id,
        createdAt: createdAt,
        appVersion: appVersion,
        habitCount: habits.length,
        userId: userId,
      );

  @override
  List<Object?> get props =>
      [userId, createdAt, appVersion, habits.length, streakRecords.length];
}
