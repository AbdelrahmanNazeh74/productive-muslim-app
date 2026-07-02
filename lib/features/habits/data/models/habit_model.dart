import 'package:isar/isar.dart';
import '../../domain/entities/habit.dart';

part 'habit_model.g.dart';

// ─── HABIT MODEL ─────────────────────────────────────────────────────────────
@collection
class HabitModel {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String habitId;

  late String name;
  late String emoji;
  late String category;       // HabitCategory.name
  String? description;
  late int targetFrequencyPerWeek;
  late List<int> scheduledDays;
  late String timeAnchor;

  // Denormalised streak data (updated on every completion)
  late int currentStreak;
  late int longestStreak;
  DateTime? lastCompletedDate;
  DateTime? lastExcusedDate;

  late bool isActive;
  late bool streakPauseOnCycle;
  late bool isSystemHabit;
  late bool notificationsEnabled;
  late DateTime createdAt;

  // ── Domain → Model ──────────────────────────────────────────────────────────
  static HabitModel fromEntity(Habit e) {
    return HabitModel()
      ..habitId = e.id
      ..name = e.name
      ..emoji = e.emoji
      ..category = e.category.name
      ..description = e.description
      ..targetFrequencyPerWeek = e.targetFrequencyPerWeek
      ..scheduledDays = e.scheduledDays
      ..timeAnchor = e.timeAnchor
      ..currentStreak = e.currentStreak
      ..longestStreak = e.longestStreak
      ..lastCompletedDate = e.lastCompletedDate
      ..lastExcusedDate = e.lastExcusedDate
      ..isActive = e.isActive
      ..streakPauseOnCycle = e.streakPauseOnCycle
      ..isSystemHabit = e.isSystemHabit
      ..notificationsEnabled = e.notificationsEnabled
      ..createdAt = e.createdAt;
  }

  // ── Model → Domain ──────────────────────────────────────────────────────────
  Habit toEntity() {
    return Habit(
      id: habitId,
      name: name,
      emoji: emoji,
      category: HabitCategory.values.byName(category),
      description: description,
      targetFrequencyPerWeek: targetFrequencyPerWeek,
      scheduledDays: scheduledDays,
      timeAnchor: timeAnchor,
      currentStreak: currentStreak,
      longestStreak: longestStreak,
      lastCompletedDate: lastCompletedDate,
      lastExcusedDate: lastExcusedDate,
      isActive: isActive,
      streakPauseOnCycle: streakPauseOnCycle,
      isSystemHabit: isSystemHabit,
      notificationsEnabled: notificationsEnabled,
      createdAt: createdAt,
    );
  }
}

// ─── STREAK RECORD MODEL ─────────────────────────────────────────────────────
@collection
class StreakRecordModel {
  Id id = Isar.autoIncrement;

  @Index()
  late String recordId;

  @Index()
  late String habitId;

  @Index()
  late DateTime date;

  late bool completed;
  late bool excused;
  late String pauseReason;    // StreakPauseReason.name
  DateTime? completedAt;
  String? note;

  // ── Domain → Model ──────────────────────────────────────────────────────────
  static StreakRecordModel fromEntity(StreakRecord e) {
    return StreakRecordModel()
      ..recordId = e.id
      ..habitId = e.habitId
      ..date = DateTime(e.date.year, e.date.month, e.date.day)
      ..completed = e.completed
      ..excused = e.excused
      ..pauseReason = e.pauseReason.name
      ..completedAt = e.completedAt
      ..note = e.note;
  }

  // ── Model → Domain ──────────────────────────────────────────────────────────
  StreakRecord toEntity() {
    return StreakRecord(
      id: recordId,
      habitId: habitId,
      date: date,
      completed: completed,
      excused: excused,
      pauseReason: StreakPauseReason.values.byName(pauseReason),
      completedAt: completedAt,
      note: note,
    );
  }
}
