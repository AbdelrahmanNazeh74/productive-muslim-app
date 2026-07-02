import '../../../../features/habits/domain/entities/habit.dart';
import '../../../../features/onboarding/domain/entities/user_profile.dart';
import '../../../../features/settings/domain/entities/app_settings.dart';

// Pure static JSON conversion utilities for backup snapshots.
// Methods operate on domain entities only — no Isar or Flutter dependencies.
class BackupSerialiser {
  const BackupSerialiser._();

  // ── UserProfile ──────────────────────────────────────────────────────────────

  static Map<String, dynamic> userProfileToJson(UserProfile p) => {
        'name': p.name,
        'gender': p.gender,
        'occupationId': p.occupationId,
        'occupationLabel': p.occupationLabel,
        'occupationType': p.occupationType,
        'workStartHour': p.workStartHour,
        'workStartMinute': p.workStartMinute,
        'workEndHour': p.workEndHour,
        'workEndMinute': p.workEndMinute,
        'workDays': p.workDays,
        'latitude': p.latitude,
        'longitude': p.longitude,
        'city': p.city,
        'timezone': p.timezone,
        'calculationMethod': p.calculationMethod,
        'madhab': p.madhab,
        'prayerBufferMinutes': p.prayerBufferMinutes,
        'fitnessActivityIds': p.fitnessActivityIds,
        'gymDays': p.gymDays,
        'gymDurationMinutes': p.gymDurationMinutes,
        'preferredGymTime': p.preferredGymTime,
        'targetSleepHours': p.targetSleepHours,
        'wakeUpOffsetFromFajrMinutes': p.wakeUpOffsetFromFajrMinutes,
        'dailyQuranPagesGoal': p.dailyQuranPagesGoal,
        'isRamadanMode': p.isRamadanMode,
        'cycleAwareStreaks': p.cycleAwareStreaks,
        'createdAt': p.createdAt.toIso8601String(),
        'isOnboardingComplete': p.isOnboardingComplete,
      };

  static UserProfile userProfileFromJson(Map<String, dynamic> m) => UserProfile(
        name: m['name'] as String,
        gender: m['gender'] as String,
        occupationId: m['occupationId'] as String,
        occupationLabel: m['occupationLabel'] as String,
        occupationType: m['occupationType'] as String,
        workStartHour: m['workStartHour'] as int,
        workStartMinute: m['workStartMinute'] as int,
        workEndHour: m['workEndHour'] as int,
        workEndMinute: m['workEndMinute'] as int,
        workDays: List<int>.from(m['workDays'] as List),
        latitude: (m['latitude'] as num).toDouble(),
        longitude: (m['longitude'] as num).toDouble(),
        city: m['city'] as String,
        timezone: m['timezone'] as String,
        calculationMethod: m['calculationMethod'] as String,
        madhab: m['madhab'] as String,
        prayerBufferMinutes: m['prayerBufferMinutes'] as int? ?? 10,
        fitnessActivityIds: List<String>.from(m['fitnessActivityIds'] as List),
        gymDays: List<int>.from(m['gymDays'] as List),
        gymDurationMinutes: m['gymDurationMinutes'] as int? ?? 60,
        preferredGymTime: m['preferredGymTime'] as String,
        targetSleepHours: m['targetSleepHours'] as int? ?? 7,
        wakeUpOffsetFromFajrMinutes:
            m['wakeUpOffsetFromFajrMinutes'] as int? ?? -30,
        dailyQuranPagesGoal: m['dailyQuranPagesGoal'] as int? ?? 2,
        isRamadanMode: m['isRamadanMode'] as bool? ?? false,
        cycleAwareStreaks: m['cycleAwareStreaks'] as bool? ?? false,
        createdAt: DateTime.parse(m['createdAt'] as String),
        isOnboardingComplete: m['isOnboardingComplete'] as bool? ?? false,
      );

  // ── Habit ────────────────────────────────────────────────────────────────────

  static Map<String, dynamic> habitToJson(Habit h) => {
        'id': h.id,
        'name': h.name,
        'emoji': h.emoji,
        'category': h.category.name,
        'description': h.description,
        'targetFrequencyPerWeek': h.targetFrequencyPerWeek,
        'scheduledDays': h.scheduledDays,
        'timeAnchor': h.timeAnchor,
        'currentStreak': h.currentStreak,
        'longestStreak': h.longestStreak,
        'lastCompletedDate': h.lastCompletedDate?.toIso8601String(),
        'lastExcusedDate': h.lastExcusedDate?.toIso8601String(),
        'isActive': h.isActive,
        'streakPauseOnCycle': h.streakPauseOnCycle,
        'isSystemHabit': h.isSystemHabit,
        'notificationsEnabled': h.notificationsEnabled,
        'createdAt': h.createdAt.toIso8601String(),
      };

  static Habit habitFromJson(Map<String, dynamic> m) => Habit(
        id: m['id'] as String,
        name: m['name'] as String,
        emoji: m['emoji'] as String,
        category: HabitCategory.values.byName(m['category'] as String),
        description: m['description'] as String?,
        targetFrequencyPerWeek: m['targetFrequencyPerWeek'] as int? ?? 7,
        scheduledDays: List<int>.from(m['scheduledDays'] as List),
        timeAnchor: m['timeAnchor'] as String? ?? 'anytime',
        currentStreak: m['currentStreak'] as int? ?? 0,
        longestStreak: m['longestStreak'] as int? ?? 0,
        lastCompletedDate: m['lastCompletedDate'] != null
            ? DateTime.parse(m['lastCompletedDate'] as String)
            : null,
        lastExcusedDate: m['lastExcusedDate'] != null
            ? DateTime.parse(m['lastExcusedDate'] as String)
            : null,
        isActive: m['isActive'] as bool? ?? true,
        streakPauseOnCycle: m['streakPauseOnCycle'] as bool? ?? false,
        isSystemHabit: m['isSystemHabit'] as bool? ?? false,
        notificationsEnabled: m['notificationsEnabled'] as bool? ?? true,
        createdAt: DateTime.parse(m['createdAt'] as String),
      );

  // ── StreakRecord ─────────────────────────────────────────────────────────────

  static Map<String, dynamic> streakRecordToJson(StreakRecord r) => {
        'id': r.id,
        'habitId': r.habitId,
        'date': r.date.toIso8601String(),
        'completed': r.completed,
        'excused': r.excused,
        'pauseReason': r.pauseReason.name,
        'completedAt': r.completedAt?.toIso8601String(),
        'note': r.note,
      };

  static StreakRecord streakRecordFromJson(Map<String, dynamic> m) =>
      StreakRecord(
        id: m['id'] as String,
        habitId: m['habitId'] as String,
        date: DateTime.parse(m['date'] as String),
        completed: m['completed'] as bool,
        excused: m['excused'] as bool? ?? false,
        pauseReason:
            StreakPauseReason.values.byName(m['pauseReason'] as String? ?? 'none'),
        completedAt: m['completedAt'] != null
            ? DateTime.parse(m['completedAt'] as String)
            : null,
        note: m['note'] as String?,
      );

  // ── AppSettings ──────────────────────────────────────────────────────────────

  static Map<String, dynamic> settingsToJson(AppSettings s) => {
        'fajrNotification': s.fajrNotification,
        'dhuhrNotification': s.dhuhrNotification,
        'asrNotification': s.asrNotification,
        'maghribNotification': s.maghribNotification,
        'ishaNotification': s.ishaNotification,
        'habitReminders': s.habitReminders,
        'quranReminder': s.quranReminder,
        'quietHoursEnabled': s.quietHoursEnabled,
        'quietHoursStartHour': s.quietHoursStartHour,
        'quietHoursStartMinute': s.quietHoursStartMinute,
        'quietHoursEndHour': s.quietHoursEndHour,
        'quietHoursEndMinute': s.quietHoursEndMinute,
        'themeMode': s.themeMode,
        'showHijriDate': s.showHijriDate,
        'show24HourTime': s.show24HourTime,
      };

  static AppSettings settingsFromJson(Map<String, dynamic> m) => AppSettings(
        fajrNotification: m['fajrNotification'] as bool? ?? true,
        dhuhrNotification: m['dhuhrNotification'] as bool? ?? true,
        asrNotification: m['asrNotification'] as bool? ?? true,
        maghribNotification: m['maghribNotification'] as bool? ?? true,
        ishaNotification: m['ishaNotification'] as bool? ?? true,
        habitReminders: m['habitReminders'] as bool? ?? true,
        quranReminder: m['quranReminder'] as bool? ?? true,
        quietHoursEnabled: m['quietHoursEnabled'] as bool? ?? false,
        quietHoursStartHour: m['quietHoursStartHour'] as int? ?? 22,
        quietHoursStartMinute: m['quietHoursStartMinute'] as int? ?? 0,
        quietHoursEndHour: m['quietHoursEndHour'] as int? ?? 6,
        quietHoursEndMinute: m['quietHoursEndMinute'] as int? ?? 0,
        themeMode: m['themeMode'] as String? ?? 'system',
        showHijriDate: m['showHijriDate'] as bool? ?? true,
        show24HourTime: m['show24HourTime'] as bool? ?? false,
      );
}
