import 'package:flutter_test/flutter_test.dart';
import 'package:productive_muslim/features/backup/data/services/backup_serialiser.dart';
import 'package:productive_muslim/features/habits/domain/entities/habit.dart';
import 'package:productive_muslim/features/onboarding/domain/entities/user_profile.dart';
import 'package:productive_muslim/features/settings/domain/entities/app_settings.dart';

void main() {
  // ── Helpers ───────────────────────────────────────────────────────────────
  UserProfile makeProfile({
    String name = 'Ahmed',
    String gender = 'male',
    String calculationMethod = 'MuslimWorldLeague',
    int dailyQuranPagesGoal = 2,
    bool isRamadanMode = false,
    bool cycleAwareStreaks = false,
  }) =>
      UserProfile(
        name: name,
        gender: gender,
        occupationId: 'engineer',
        occupationLabel: 'Software Engineer',
        occupationType: 'office',
        workStartHour: 9,
        workStartMinute: 0,
        workEndHour: 17,
        workEndMinute: 0,
        workDays: const [0, 1, 2, 3, 4],
        latitude: 30.0444,
        longitude: 31.2357,
        city: 'Cairo',
        timezone: 'Africa/Cairo',
        calculationMethod: calculationMethod,
        madhab: 'shafi',
        fitnessActivityIds: const ['running'],
        gymDays: const [1, 3],
        preferredGymTime: 'morning',
        dailyQuranPagesGoal: dailyQuranPagesGoal,
        isRamadanMode: isRamadanMode,
        cycleAwareStreaks: cycleAwareStreaks,
        createdAt: DateTime(2026, 1, 1),
        isOnboardingComplete: true,
      );

  Habit makeHabit({String id = 'h1', String name = 'Fajr Prayer', int streak = 5}) =>
      Habit(
        id: id,
        name: name,
        emoji: '🕌',
        category: HabitCategory.spiritual,
        targetFrequencyPerWeek: 7,
        scheduledDays: const [0, 1, 2, 3, 4, 5, 6],
        timeAnchor: 'post_fajr',
        currentStreak: streak,
        longestStreak: streak + 2,
        isActive: true,
        isSystemHabit: true,
        notificationsEnabled: true,
        createdAt: DateTime(2026, 1, 1),
      );

  StreakRecord makeRecord({
    String id = 'r1',
    String habitId = 'h1',
    bool completed = true,
  }) =>
      StreakRecord(
        id: id,
        habitId: habitId,
        date: DateTime(2026, 6, 1),
        completed: completed,
        excused: false,
        pauseReason: StreakPauseReason.none,
        completedAt: DateTime(2026, 6, 1, 5, 30),
        note: null,
      );

  // ── UserProfile roundtrip ─────────────────────────────────────────────────

  test('1. UserProfile basic fields roundtrip', () {
    final p = makeProfile();
    final json = BackupSerialiser.userProfileToJson(p);
    final restored = BackupSerialiser.userProfileFromJson(json);
    expect(restored.name, p.name);
    expect(restored.gender, p.gender);
    expect(restored.city, p.city);
    expect(restored.calculationMethod, p.calculationMethod);
    expect(restored.isOnboardingComplete, true);
  });

  test('2. UserProfile work schedule roundtrip', () {
    final p = makeProfile();
    final json = BackupSerialiser.userProfileToJson(p);
    final restored = BackupSerialiser.userProfileFromJson(json);
    expect(restored.workStartHour, 9);
    expect(restored.workEndHour, 17);
    expect(restored.workDays, [0, 1, 2, 3, 4]);
  });

  test('3. UserProfile location roundtrip preserves precision', () {
    final p = makeProfile();
    final json = BackupSerialiser.userProfileToJson(p);
    final restored = BackupSerialiser.userProfileFromJson(json);
    expect(restored.latitude, closeTo(30.0444, 0.0001));
    expect(restored.longitude, closeTo(31.2357, 0.0001));
  });

  test('4. UserProfile with Ramadan mode and cycle awareness roundtrip', () {
    final p = makeProfile(isRamadanMode: true, cycleAwareStreaks: true, gender: 'female');
    final json = BackupSerialiser.userProfileToJson(p);
    final restored = BackupSerialiser.userProfileFromJson(json);
    expect(restored.isRamadanMode, true);
    expect(restored.cycleAwareStreaks, true);
    expect(restored.gender, 'female');
  });

  test('5. UserProfile Quran pages goal roundtrip', () {
    final p = makeProfile(dailyQuranPagesGoal: 10);
    final json = BackupSerialiser.userProfileToJson(p);
    final restored = BackupSerialiser.userProfileFromJson(json);
    expect(restored.dailyQuranPagesGoal, 10);
  });

  test('6. UserProfile all 10 calculation methods roundtrip', () {
    const methods = [
      'MuslimWorldLeague', 'NorthAmerica', 'Egyptian', 'UmmAlQura',
      'Karachi', 'Tehran', 'Gulf', 'Kuwait', 'Qatar', 'Singapore',
    ];
    for (final method in methods) {
      final p = makeProfile(calculationMethod: method);
      final json = BackupSerialiser.userProfileToJson(p);
      final restored = BackupSerialiser.userProfileFromJson(json);
      expect(restored.calculationMethod, method,
          reason: 'method $method failed roundtrip');
    }
  });

  // ── Habit roundtrip ───────────────────────────────────────────────────────

  test('7. Habit basic fields roundtrip', () {
    final h = makeHabit();
    final json = BackupSerialiser.habitToJson(h);
    final restored = BackupSerialiser.habitFromJson(json);
    expect(restored.id, h.id);
    expect(restored.name, h.name);
    expect(restored.emoji, h.emoji);
    expect(restored.category, HabitCategory.spiritual);
    expect(restored.currentStreak, 5);
    expect(restored.longestStreak, 7);
  });

  test('8. Habit with null optional fields roundtrip', () {
    final h = makeHabit();
    expect(h.lastCompletedDate, isNull);
    expect(h.description, isNull);
    final json = BackupSerialiser.habitToJson(h);
    final restored = BackupSerialiser.habitFromJson(json);
    expect(restored.lastCompletedDate, isNull);
    expect(restored.description, isNull);
  });

  test('9. Habit with completed dates roundtrip', () {
    final h = makeHabit().copyWith(
      lastCompletedDate: DateTime(2026, 6, 28),
      lastExcusedDate: DateTime(2026, 6, 20),
    );
    final json = BackupSerialiser.habitToJson(h);
    final restored = BackupSerialiser.habitFromJson(json);
    expect(restored.lastCompletedDate, DateTime(2026, 6, 28));
    expect(restored.lastExcusedDate, DateTime(2026, 6, 20));
  });

  test('10. Habit all categories roundtrip', () {
    for (final category in HabitCategory.values) {
      final h = makeHabit().copyWith(category: category);
      final json = BackupSerialiser.habitToJson(h);
      final restored = BackupSerialiser.habitFromJson(json);
      expect(restored.category, category,
          reason: 'category ${category.name} failed roundtrip');
    }
  });

  // ── StreakRecord roundtrip ────────────────────────────────────────────────

  test('11. StreakRecord basic fields roundtrip', () {
    final r = makeRecord();
    final json = BackupSerialiser.streakRecordToJson(r);
    final restored = BackupSerialiser.streakRecordFromJson(json);
    expect(restored.id, r.id);
    expect(restored.habitId, r.habitId);
    expect(restored.completed, true);
    expect(restored.excused, false);
    expect(restored.pauseReason, StreakPauseReason.none);
  });

  test('12. StreakRecord excused with cycle pause roundtrip', () {
    final r = StreakRecord(
      id: 'r2',
      habitId: 'h1',
      date: DateTime(2026, 6, 5),
      completed: false,
      excused: true,
      pauseReason: StreakPauseReason.cycle,
      note: 'cycle day',
    );
    final json = BackupSerialiser.streakRecordToJson(r);
    final restored = BackupSerialiser.streakRecordFromJson(json);
    expect(restored.excused, true);
    expect(restored.pauseReason, StreakPauseReason.cycle);
    expect(restored.note, 'cycle day');
  });

  // ── AppSettings roundtrip ─────────────────────────────────────────────────

  test('13. AppSettings defaults roundtrip', () {
    const s = AppSettings.defaults;
    final json = BackupSerialiser.settingsToJson(s);
    final restored = BackupSerialiser.settingsFromJson(json);
    expect(restored.fajrNotification, s.fajrNotification);
    expect(restored.themeMode, s.themeMode);
    expect(restored.showHijriDate, s.showHijriDate);
    expect(restored.show24HourTime, s.show24HourTime);
  });

  test('14. AppSettings custom quiet hours roundtrip', () {
    const s = AppSettings(
      quietHoursEnabled: true,
      quietHoursStartHour: 23,
      quietHoursStartMinute: 30,
      quietHoursEndHour: 5,
      quietHoursEndMinute: 0,
      themeMode: 'dark',
    );
    final json = BackupSerialiser.settingsToJson(s);
    final restored = BackupSerialiser.settingsFromJson(json);
    expect(restored.quietHoursEnabled, true);
    expect(restored.quietHoursStartHour, 23);
    expect(restored.quietHoursStartMinute, 30);
    expect(restored.themeMode, 'dark');
  });

  test('15. AppSettings all notifications disabled roundtrip', () {
    const s = AppSettings(
      fajrNotification: false,
      dhuhrNotification: false,
      asrNotification: false,
      maghribNotification: false,
      ishaNotification: false,
      habitReminders: false,
      quranReminder: false,
    );
    final json = BackupSerialiser.settingsToJson(s);
    final restored = BackupSerialiser.settingsFromJson(json);
    expect(restored.fajrNotification, false);
    expect(restored.ishaNotification, false);
    expect(restored.habitReminders, false);
    expect(restored.quranReminder, false);
  });
}
