import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:productive_muslim/features/backup/data/repositories/mock_backup_repository_impl.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('BackupThrottleImpl — shouldBackup', () {
    test('returns true when never backed up (no key in prefs)', () async {
      final prefs = await SharedPreferences.getInstance();
      final throttle = BackupThrottleImpl(prefs);
      expect(throttle.shouldBackup, isTrue);
    });

    test('returns false when backed up less than 24 hours ago', () async {
      final prefs = await SharedPreferences.getInstance();
      final throttle = BackupThrottleImpl(prefs);
      await throttle.recordBackup();
      // 1 hour ago — still within 24h window
      final oneHourAgo =
          DateTime.now().subtract(const Duration(hours: 1)).millisecondsSinceEpoch;
      await prefs.setInt('last_backup_at', oneHourAgo);
      expect(throttle.shouldBackup, isFalse);
    });

    test('returns false when backed up 23h 59m ago', () async {
      final prefs = await SharedPreferences.getInstance();
      final throttle = BackupThrottleImpl(prefs);
      final almostDay = DateTime.now()
          .subtract(const Duration(hours: 23, minutes: 59))
          .millisecondsSinceEpoch;
      await prefs.setInt('last_backup_at', almostDay);
      expect(throttle.shouldBackup, isFalse);
    });

    test('returns true when backed up exactly 24 hours ago', () async {
      final prefs = await SharedPreferences.getInstance();
      final throttle = BackupThrottleImpl(prefs);
      final exactlyDay =
          DateTime.now().subtract(const Duration(hours: 24)).millisecondsSinceEpoch;
      await prefs.setInt('last_backup_at', exactlyDay);
      expect(throttle.shouldBackup, isTrue);
    });

    test('returns true when backed up more than 24 hours ago', () async {
      final prefs = await SharedPreferences.getInstance();
      final throttle = BackupThrottleImpl(prefs);
      final twoDaysAgo =
          DateTime.now().subtract(const Duration(hours: 48)).millisecondsSinceEpoch;
      await prefs.setInt('last_backup_at', twoDaysAgo);
      expect(throttle.shouldBackup, isTrue);
    });
  });

  group('BackupThrottleImpl — recordBackup', () {
    test('recordBackup sets lastBackupAt to approximately now', () async {
      final prefs = await SharedPreferences.getInstance();
      final throttle = BackupThrottleImpl(prefs);
      final before = DateTime.now();
      await throttle.recordBackup();
      final after = DateTime.now();
      expect(throttle.lastBackupAt, isNotNull);
      expect(throttle.lastBackupAt!.isAfter(before.subtract(const Duration(seconds: 1))),
          isTrue);
      expect(throttle.lastBackupAt!.isBefore(after.add(const Duration(seconds: 1))),
          isTrue);
    });

    test('recordBackup persists across instances (same SharedPreferences)', () async {
      final prefs = await SharedPreferences.getInstance();
      final throttle1 = BackupThrottleImpl(prefs);
      await throttle1.recordBackup();

      // New instance reading same prefs
      final throttle2 = BackupThrottleImpl(prefs);
      expect(throttle2.lastBackupAt, isNotNull);
      expect(throttle2.shouldBackup, isFalse);
    });

    test('after recordBackup, shouldBackup becomes false', () async {
      final prefs = await SharedPreferences.getInstance();
      final throttle = BackupThrottleImpl(prefs);
      expect(throttle.shouldBackup, isTrue);
      await throttle.recordBackup();
      expect(throttle.shouldBackup, isFalse);
    });
  });

  group('BackupThrottleImpl — lastBackupAt', () {
    test('returns null when never backed up', () async {
      final prefs = await SharedPreferences.getInstance();
      final throttle = BackupThrottleImpl(prefs);
      expect(throttle.lastBackupAt, isNull);
    });

    test('returns correct DateTime after recordBackup', () async {
      final prefs = await SharedPreferences.getInstance();
      final throttle = BackupThrottleImpl(prefs);
      await throttle.recordBackup();
      expect(throttle.lastBackupAt, isA<DateTime>());
    });

    test('returns correct timestamp stored manually in prefs', () async {
      final prefs = await SharedPreferences.getInstance();
      final known = DateTime(2025, 6, 15, 10, 30);
      await prefs.setInt('last_backup_at', known.millisecondsSinceEpoch);
      final throttle = BackupThrottleImpl(prefs);
      expect(throttle.lastBackupAt!.millisecondsSinceEpoch,
          known.millisecondsSinceEpoch);
    });
  });
}
