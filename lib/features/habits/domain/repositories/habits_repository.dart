import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/habit.dart';

abstract class HabitsRepository {
  // ── Habits CRUD ──────────────────────────────────────────────────────────────
  Future<Either<Failure, List<Habit>>> getAllHabits();
  Future<Either<Failure, Habit>> saveHabit(Habit habit);
  Future<Either<Failure, Habit>> updateHabit(Habit habit);
  Future<Either<Failure, bool>> deleteHabit(String habitId);
  Future<Either<Failure, bool>> archiveHabit(String habitId);

  // ── Streak Records ───────────────────────────────────────────────────────────
  Future<Either<Failure, StreakRecord>> recordCompletion({
    required String habitId,
    required DateTime date,
    String? note,
  });

  Future<Either<Failure, StreakRecord>> recordExcused({
    required String habitId,
    required DateTime date,
    required StreakPauseReason reason,
    String? note,
  });

  Future<Either<Failure, bool>> undoCompletion({
    required String habitId,
    required DateTime date,
  });

  Future<Either<Failure, List<StreakRecord>>> getRecordsForHabit({
    required String habitId,
    required DateTime from,
    required DateTime to,
  });

  Future<Either<Failure, StreakRecord?>> getTodayRecord(String habitId);

  // ── Aggregated queries ───────────────────────────────────────────────────────
  Future<Either<Failure, DailyHabitSummary>> getDailySummary(DateTime date);

  Future<Either<Failure, HabitWeeklyStats>> getWeeklyStats({
    required String habitId,
    required DateTime weekStart,
  });

  Future<Either<Failure, WeeklySpiritualScore>> getWeeklySpiritualScore(
      DateTime weekStart);

  // ── Seeding ──────────────────────────────────────────────────────────────────
  /// Create default system habits from user profile on first launch.
  Future<Either<Failure, List<Habit>>> seedDefaultHabits({
    required String gender,
    required bool hasFitness,
    required int quranPagesGoal,
    required bool cycleAware,
    required List<int> gymDays,
  });
}
