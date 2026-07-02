import 'package:equatable/equatable.dart';

// ─── HABIT CATEGORY ───────────────────────────────────────────────────────────
enum HabitCategory { spiritual, fitness, health, work, personal }

extension HabitCategoryX on HabitCategory {
  String get label {
    switch (this) {
      case HabitCategory.spiritual: return 'Spiritual';
      case HabitCategory.fitness:   return 'Fitness';
      case HabitCategory.health:    return 'Health';
      case HabitCategory.work:      return 'Work & Study';
      case HabitCategory.personal:  return 'Personal';
    }
  }

  String get emoji {
    switch (this) {
      case HabitCategory.spiritual: return '🤲';
      case HabitCategory.fitness:   return '🏋️';
      case HabitCategory.health:    return '💚';
      case HabitCategory.work:      return '💼';
      case HabitCategory.personal:  return '🌱';
    }
  }

  // Color hex stored as string so domain stays Flutter-free
  String get colorHex {
    switch (this) {
      case HabitCategory.spiritual: return '#4A235A'; // fajr purple
      case HabitCategory.fitness:   return '#2D7D46'; // success green
      case HabitCategory.health:    return '#1A5276'; // dhuhr blue
      case HabitCategory.work:      return '#1B4F72'; // primary navy
      case HabitCategory.personal:  return '#C9A84C'; // gold
    }
  }
}

// ─── STREAK PAUSE REASON ─────────────────────────────────────────────────────
enum StreakPauseReason {
  none,
  illness,
  travel,
  cycle,       // female cycle — doesn't break streak
  ramadan,     // some habits restructured in Ramadan
  excused,     // user-marked as excused
}

// ─── HABIT ────────────────────────────────────────────────────────────────────
class Habit extends Equatable {
  final String id;           // uuid
  final String name;
  final String emoji;
  final HabitCategory category;
  final String? description;

  /// How many times per week the user aims to do this habit
  final int targetFrequencyPerWeek; // 1–7

  /// Which days of the week (0=Mon…6=Sun). Empty = any day up to frequency.
  final List<int> scheduledDays;

  /// Time-of-day anchor (e.g. 'post_fajr', 'morning', 'evening', 'anytime')
  final String timeAnchor;

  // Streak data (denormalised for quick reads)
  final int currentStreak;
  final int longestStreak;
  final DateTime? lastCompletedDate;
  final DateTime? lastExcusedDate;

  // Settings
  final bool isActive;
  final bool streakPauseOnCycle;   // female users only
  final bool isSystemHabit;        // seeded from user profile (can't delete)
  final bool notificationsEnabled;
  final DateTime createdAt;

  const Habit({
    required this.id,
    required this.name,
    required this.emoji,
    required this.category,
    this.description,
    this.targetFrequencyPerWeek = 7,
    this.scheduledDays = const [],
    this.timeAnchor = 'anytime',
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.lastCompletedDate,
    this.lastExcusedDate,
    this.isActive = true,
    this.streakPauseOnCycle = false,
    this.isSystemHabit = false,
    this.notificationsEnabled = true,
    required this.createdAt,
  });

  // ── Computed ─────────────────────────────────────────────────────────────────
  bool get isScheduledToday {
    if (scheduledDays.isEmpty) return true; // anyday — check frequency separately
    final todayIndex = DateTime.now().weekday - 1; // 0=Mon
    return scheduledDays.contains(todayIndex);
  }

  bool get wasCompletedToday {
    if (lastCompletedDate == null) return false;
    final now = DateTime.now();
    return lastCompletedDate!.year == now.year &&
        lastCompletedDate!.month == now.month &&
        lastCompletedDate!.day == now.day;
  }

  /// Whether this habit's streak is currently on a valid pause
  /// (doesn't count against the streak but doesn't advance it either)
  bool isCurrentlyPaused(bool userCycleActive) {
    return streakPauseOnCycle && userCycleActive;
  }

  /// A streak is considered "at risk" if today is scheduled but not yet done
  bool get isAtRiskToday {
    return isScheduledToday && !wasCompletedToday;
  }

  /// Progress label for the week
  String weekProgressLabel(int completedThisWeek) {
    return '$completedThisWeek / $targetFrequencyPerWeek this week';
  }

  Habit copyWith({
    String? id,
    String? name,
    String? emoji,
    HabitCategory? category,
    String? description,
    int? targetFrequencyPerWeek,
    List<int>? scheduledDays,
    String? timeAnchor,
    int? currentStreak,
    int? longestStreak,
    DateTime? lastCompletedDate,
    DateTime? lastExcusedDate,
    bool? isActive,
    bool? streakPauseOnCycle,
    bool? isSystemHabit,
    bool? notificationsEnabled,
    DateTime? createdAt,
  }) {
    return Habit(
      id: id ?? this.id,
      name: name ?? this.name,
      emoji: emoji ?? this.emoji,
      category: category ?? this.category,
      description: description ?? this.description,
      targetFrequencyPerWeek:
          targetFrequencyPerWeek ?? this.targetFrequencyPerWeek,
      scheduledDays: scheduledDays ?? this.scheduledDays,
      timeAnchor: timeAnchor ?? this.timeAnchor,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      lastCompletedDate: lastCompletedDate ?? this.lastCompletedDate,
      lastExcusedDate: lastExcusedDate ?? this.lastExcusedDate,
      isActive: isActive ?? this.isActive,
      streakPauseOnCycle: streakPauseOnCycle ?? this.streakPauseOnCycle,
      isSystemHabit: isSystemHabit ?? this.isSystemHabit,
      notificationsEnabled:
          notificationsEnabled ?? this.notificationsEnabled,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
        id, name, category, currentStreak, longestStreak,
        lastCompletedDate, isActive,
      ];
}

// ─── STREAK RECORD ────────────────────────────────────────────────────────────
/// One entry per habit per day — the source of truth for streak calculation.
class StreakRecord extends Equatable {
  final String id;           // uuid
  final String habitId;
  final DateTime date;
  final bool completed;
  final bool excused;        // True → doesn't break streak, doesn't advance it
  final StreakPauseReason pauseReason;
  final DateTime? completedAt; // exact timestamp when checked off
  final String? note;

  const StreakRecord({
    required this.id,
    required this.habitId,
    required this.date,
    required this.completed,
    this.excused = false,
    this.pauseReason = StreakPauseReason.none,
    this.completedAt,
    this.note,
  });

  /// A record counts toward the streak only if completed (not just excused)
  bool get countsTowardStreak => completed && !excused;

  /// A record does NOT break the streak if completed OR excused
  bool get preservesStreak => completed || excused;

  @override
  List<Object?> get props =>
      [id, habitId, date, completed, excused, pauseReason];
}

// ─── WEEKLY STATS ────────────────────────────────────────────────────────────
class HabitWeeklyStats extends Equatable {
  final String habitId;
  final DateTime weekStart; // Monday of the week
  final int completedCount;
  final int excusedCount;
  final int targetCount;
  final List<bool> dayMap; // index 0=Mon…6=Sun, true=completed

  const HabitWeeklyStats({
    required this.habitId,
    required this.weekStart,
    required this.completedCount,
    required this.excusedCount,
    required this.targetCount,
    required this.dayMap,
  });

  double get completionRate =>
      targetCount == 0 ? 0 : completedCount / targetCount;

  bool get isFullWeek => completedCount >= targetCount;

  @override
  List<Object?> get props =>
      [habitId, weekStart, completedCount, targetCount];
}

// ─── DAILY HABIT SUMMARY ────────────────────────────────────────────────────
/// Aggregated view for the dashboard — all habits for one day.
class DailyHabitSummary extends Equatable {
  final DateTime date;
  final List<Habit> habits;
  final Map<String, StreakRecord?> recordsByHabitId;

  const DailyHabitSummary({
    required this.date,
    required this.habits,
    required this.recordsByHabitId,
  });

  int get totalScheduled => habits.where((h) => h.isScheduledToday).length;

  int get completedCount => recordsByHabitId.values
      .where((r) => r != null && r.completed)
      .length;

  double get completionRate =>
      totalScheduled == 0 ? 0 : completedCount / totalScheduled;

  bool isCompleted(String habitId) =>
      recordsByHabitId[habitId]?.completed ?? false;

  bool isExcused(String habitId) =>
      recordsByHabitId[habitId]?.excused ?? false;

  @override
  List<Object?> get props => [date, habits, recordsByHabitId];
}

// ─── WEEKLY SPIRITUAL SCORE ──────────────────────────────────────────────────
/// The "score" shown on the analytics / habit page.
/// Weighted composite: prayers dominate (50%), Quran (20%), other habits (30%).
class WeeklySpiritualScore extends Equatable {
  final DateTime weekStart;
  final int prayerScore;    // 0–100: (prayers prayed on time / 35) * 100
  final int quranScore;     // 0–100: (days Quran read / 7) * 100
  final int habitsScore;    // 0–100: habit completion rate * 100
  final int gymScore;       // 0–100: gym sessions / target * 100

  const WeeklySpiritualScore({
    required this.weekStart,
    required this.prayerScore,
    required this.quranScore,
    required this.habitsScore,
    required this.gymScore,
  });

  /// Weighted composite
  int get totalScore =>
      ((prayerScore * 0.50) +
              (quranScore * 0.20) +
              (habitsScore * 0.20) +
              (gymScore * 0.10))
          .round()
          .clamp(0, 100);

  String get grade {
    final s = totalScore;
    if (s >= 90) return 'Excellent 🌟';
    if (s >= 75) return 'Great 💪';
    if (s >= 60) return 'Good 👍';
    if (s >= 45) return 'Fair 📈';
    return 'Keep going 🤲';
  }

  @override
  List<Object?> get props =>
      [weekStart, prayerScore, quranScore, habitsScore, gymScore];
}
