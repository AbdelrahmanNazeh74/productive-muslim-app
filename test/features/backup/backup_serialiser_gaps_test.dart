import 'package:flutter_test/flutter_test.dart';
import 'package:productive_muslim/features/backup/data/services/backup_serialiser.dart';
import 'package:productive_muslim/features/settings/domain/entities/app_settings.dart';

void main() {
  // ── AppSettings — all 15 fields verified individually ───────────────────────

  group('BackupSerialiser — AppSettings individual fields', () {
    test('fajrNotification roundtrip (false)', () {
      const s = AppSettings(fajrNotification: false);
      final out = BackupSerialiser.settingsFromJson(BackupSerialiser.settingsToJson(s));
      expect(out.fajrNotification, isFalse);
    });

    test('dhuhrNotification roundtrip (false)', () {
      const s = AppSettings(dhuhrNotification: false);
      final out = BackupSerialiser.settingsFromJson(BackupSerialiser.settingsToJson(s));
      expect(out.dhuhrNotification, isFalse);
    });

    test('asrNotification roundtrip (false)', () {
      const s = AppSettings(asrNotification: false);
      final out = BackupSerialiser.settingsFromJson(BackupSerialiser.settingsToJson(s));
      expect(out.asrNotification, isFalse);
    });

    test('maghribNotification roundtrip (false)', () {
      const s = AppSettings(maghribNotification: false);
      final out = BackupSerialiser.settingsFromJson(BackupSerialiser.settingsToJson(s));
      expect(out.maghribNotification, isFalse);
    });

    test('ishaNotification roundtrip (false)', () {
      const s = AppSettings(ishaNotification: false);
      final out = BackupSerialiser.settingsFromJson(BackupSerialiser.settingsToJson(s));
      expect(out.ishaNotification, isFalse);
    });

    test('habitReminders roundtrip (false)', () {
      const s = AppSettings(habitReminders: false);
      final out = BackupSerialiser.settingsFromJson(BackupSerialiser.settingsToJson(s));
      expect(out.habitReminders, isFalse);
    });

    test('quranReminder roundtrip (false)', () {
      const s = AppSettings(quranReminder: false);
      final out = BackupSerialiser.settingsFromJson(BackupSerialiser.settingsToJson(s));
      expect(out.quranReminder, isFalse);
    });

    test('quietHoursEnabled roundtrip (true)', () {
      const s = AppSettings(quietHoursEnabled: true);
      final out = BackupSerialiser.settingsFromJson(BackupSerialiser.settingsToJson(s));
      expect(out.quietHoursEnabled, isTrue);
    });

    test('quietHoursStartHour + StartMinute roundtrip', () {
      const s = AppSettings(quietHoursStartHour: 23, quietHoursStartMinute: 30);
      final out = BackupSerialiser.settingsFromJson(BackupSerialiser.settingsToJson(s));
      expect(out.quietHoursStartHour, 23);
      expect(out.quietHoursStartMinute, 30);
    });

    test('quietHoursEndHour + EndMinute roundtrip', () {
      const s = AppSettings(quietHoursEndHour: 5, quietHoursEndMinute: 45);
      final out = BackupSerialiser.settingsFromJson(BackupSerialiser.settingsToJson(s));
      expect(out.quietHoursEndHour, 5);
      expect(out.quietHoursEndMinute, 45);
    });

    test('themeMode "light" roundtrip', () {
      const s = AppSettings(themeMode: 'light');
      final out = BackupSerialiser.settingsFromJson(BackupSerialiser.settingsToJson(s));
      expect(out.themeMode, 'light');
    });

    test('themeMode "dark" roundtrip', () {
      const s = AppSettings(themeMode: 'dark');
      final out = BackupSerialiser.settingsFromJson(BackupSerialiser.settingsToJson(s));
      expect(out.themeMode, 'dark');
    });

    test('showHijriDate roundtrip (false)', () {
      const s = AppSettings(showHijriDate: false);
      final out = BackupSerialiser.settingsFromJson(BackupSerialiser.settingsToJson(s));
      expect(out.showHijriDate, isFalse);
    });

    test('show24HourTime roundtrip (true)', () {
      const s = AppSettings(show24HourTime: true);
      final out = BackupSerialiser.settingsFromJson(BackupSerialiser.settingsToJson(s));
      expect(out.show24HourTime, isTrue);
    });
  });

  // ── Missing fields in JSON → defaults applied ────────────────────────────────

  group('BackupSerialiser — settingsFromJson missing field defaults', () {
    test('empty map → all fields use defaults', () {
      final out = BackupSerialiser.settingsFromJson({});
      expect(out.fajrNotification, isTrue);
      expect(out.dhuhrNotification, isTrue);
      expect(out.asrNotification, isTrue);
      expect(out.maghribNotification, isTrue);
      expect(out.ishaNotification, isTrue);
      expect(out.habitReminders, isTrue);
      expect(out.quranReminder, isTrue);
      expect(out.quietHoursEnabled, isFalse);
      expect(out.quietHoursStartHour, 22);
      expect(out.quietHoursEndHour, 6);
      expect(out.themeMode, 'system');
      expect(out.showHijriDate, isTrue);
      expect(out.show24HourTime, isFalse);
    });

    test('map with only themeMode "dark" → rest use defaults', () {
      final out = BackupSerialiser.settingsFromJson({'themeMode': 'dark'});
      expect(out.themeMode, 'dark');
      expect(out.fajrNotification, isTrue);
      expect(out.show24HourTime, isFalse);
    });

    test('settingsToJson produces exactly 15 keys', () {
      final map = BackupSerialiser.settingsToJson(const AppSettings());
      expect(map.keys.length, 15);
    });
  });
}
