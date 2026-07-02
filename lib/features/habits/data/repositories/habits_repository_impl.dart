import 'package:dartz/dartz.dart';
import 'package:isar/isar.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/habit.dart';
import '../../domain/repositories/habits_repository.dart';
import '../../domain/usecases/default_habit_seeder.dart';
import '../../domain/usecases/streak_calculator.dart';
import '../models/habit_model.dart';

class HabitsRepositoryImpl implements HabitsRepository {
  final Isar isar;
  final StreakCalculator streakCalculator;
  static const _uuid = Uuid();

  HabitsRepositoryImpl({
    required this.isar,
    required this.streakCalculator,
  });

  // ─── HABITS CRUD ─────────────────────────────────────────────────────────────
  @override
  Future<Either<Failure, List<Habit>>> getAllHabits() async {
    try {
      final models = await isar.habitModels
          .filter()
          .isActiveEqualTo(true)
          .sortByCreatedAt()
          .findAll();
      return Right(models.map((m) => m.toEntity()).toList());
    } catch (e) {
      return Left(DatabaseFailure('Failed to load habits: $e'));
    }
  }

  @override
  Future<Either<Failure, Habit>> saveHabit(Habit habit) async {
    try {
      final model = HabitModel.fromEntity(habit);
      // Upsert: preserve Isar integer ID if record already exists,
      // otherwise Isar auto-assigns a new ID (insert path).
      final existing = await isar.habitModels
          .filter()
          .habitIdEqualTo(habit.id)
          .findFirst();
      if (existing != null) model.id = existing.id;
      await isar.writeTxn(() => isar.habitModels.put(model));
      return Right(model.toEntity());
    } catch (e) {
      return Left(DatabaseFailure('Failed to save habit: $e'));
    }
  }

  @override
  Future<Either<Failure, Habit>> updateHabit(Habit habit) async {
    try {
      final existing = await isar.habitModels
          .filter()
          .habitIdEqualTo(habit.id)
          .findFirst();
      if (existing == null) {
        return Left(DatabaseFailure('Habit not found: ${habit.id}'));
      }
      final updated = HabitModel.fromEntity(habit)..id = existing.id;
      await isar.writeTxn(() => isar.habitModels.put(updated));
      return Right(updated.toEntity());
    } catch (e) {
      return Left(DatabaseFailure('Failed to update habit: $e'));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteHabit(String habitId) async {
    try {
      await isar.writeTxn(() async {
        // Delete all streak records for this habit first
        await isar.streakRecordModels
            .filter()
            .habitIdEqualTo(habitId)
            .deleteAll();
        await isar.habitModels
            .filter()
            .habitIdEqualTo(habitId)
            .deleteAll();
      });
      return const Right(true);
    } catch (e) {
      return Left(DatabaseFailure('Failed to delete habit: $e'));
    }
  }

  @override
  Future<Either<Failure, bool>> archiveHabit(String habitId) async {
    try {
      final model = await isar.habitModels
          .filter()
          .habitIdEqualTo(habitId)
          .findFirst();
      if (model == null) return const Right(false);
      await isar.writeTxn(() async {
        model.isActive = false;
        await isar.habitModels.put(model);
      });
      return const Right(true);
    } catch (e) {
      return Left(DatabaseFailure('Failed to archive habit: $e'));
    }
  }

  // ─── STREAK RECORDS ───────────────────────────────────────────────────────────
  @override
  Future<Either<Failure, StreakRecord>> recordCompletion({
    required String habitId,
    required DateTime date,
    String? note,
  }) async {
    try {
      final dateOnly = DateTime(date.year, date.month, date.day);
      StreakRecord? record;

      await isar.writeTxn(() async {
        // Upsert: check if record for today already exists
        final existing = await isar.streakRecordModels
            .filter()
            .habitIdEqualTo(habitId)
            .dateEqualTo(dateOnly)
            .findFirst();

        final model = existing ??
            (StreakRecordModel()
              ..recordId = _uuid.v4()
              ..habitId = habitId
              ..date = dateOnly
              ..excused = false
              ..pauseReason = StreakPauseReason.none.name);

        model
          ..completed = true
          ..completedAt = DateTime.now()
          ..note = note;

        await isar.streakRecordModels.put(model);
        record = model.toEntity();
      });

      // Recalculate and persist streak on the habit
      await _recalculateStreak(habitId);
      return Right(record!);
    } catch (e) {
      return Left(DatabaseFailure('Failed to record completion: $e'));
    }
  }

  @override
  Future<Either<Failure, StreakRecord>> recordExcused({
    required String habitId,
    required DateTime date,
    required StreakPauseReason reason,
    String? note,
  }) async {
    try {
      final dateOnly = DateTime(date.year, date.month, date.day);
      StreakRecord? record;

      await isar.writeTxn(() async {
        final existing = await isar.streakRecordModels
            .filter()
            .habitIdEqualTo(habitId)
            .dateEqualTo(dateOnly)
            .findFirst();

        final model = existing ??
            (StreakRecordModel()
              ..recordId = _uuid.v4()
              ..habitId = habitId
              ..date = dateOnly
              ..completed = false);

        model
          ..excused = true
          ..pauseReason = reason.name
          ..note = note;

        await isar.streakRecordModels.put(model);
        record = model.toEntity();
      });

      await _recalculateStreak(habitId);
      return Right(record!);
    } catch (e) {
      return Left(DatabaseFailure('Failed to record excuse: $e'));
    }
  }

  @override
  Future<Either<Failure, bool>> undoCompletion({
    required String habitId,
    required DateTime date,
  }) async {
    try {
      final dateOnly = DateTime(date.year, date.month, date.day);
      await isar.writeTxn(() async {
        await isar.streakRecordModels
            .filter()
            .habitIdEqualTo(habitId)
            .dateEqualTo(dateOnly)
            .deleteAll();
      });
      await _recalculateStreak(habitId);
      return const Right(true);
    } catch (e) {
      return Left(DatabaseFailure('Failed to undo completion: $e'));
    }
  }

  @override
  Future<Either<Failure, List<StreakRecord>>> getRecordsForHabit({
    required String habitId,
    required DateTime from,
    required DateTime to,
  }) async {
    try {
      final models = await isar.streakRecordModels
          .filter()
          .habitIdEqualTo(habitId)
          .dateBetween(
            DateTime(from.year, from.month, from.day),
            DateTime(to.year, to.month, to.day),
          )
          .sortByDate()
          .findAll();
      return Right(models.map((m) => m.toEntity()).toList());
    } catch (e) {
      return Left(DatabaseFailure('Failed to get records: $e'));
    }
  }

  @override
  Future<Either<Failure, StreakRecord?>> getTodayRecord(
      String habitId) async {
    try {
      final today = DateTime.now();
      final dateOnly =
          DateTime(today.year, today.month, today.day);
      final model = await isar.streakRecordModels
          .filter()
          .habitIdEqualTo(habitId)
          .dateEqualTo(dateOnly)
          .findFirst();
      return Right(model?.toEntity());
    } catch (e) {
      return Left(DatabaseFailure('Failed to get today record: $e'));
    }
  }

  // ─── AGGREGATED QUERIES ───────────────────────────────────────────────────────
  @override
  Future<Either<Failure, DailyHabitSummary>> getDailySummary(
      DateTime date) async {
    try {
      final dateOnly = DateTime(date.year, date.month, date.day);
      final habits = await isar.habitModels
          .filter()
          .isActiveEqualTo(true)
          .sortByCreatedAt()
          .findAll();

      final records = await isar.streakRecordModels
          .filter()
          .dateEqualTo(dateOnly)
          .findAll();

      final recordsByHabitId = <String, StreakRecord?>{};
      for (final h in habits) {
        recordsByHabitId[h.habitId] = null;
      }
      for (final r in records) {
        recordsByHabitId[r.habitId] = r.toEntity();
      }

      return Right(DailyHabitSummary(
        date: dateOnly,
        habits: habits.map((m) => m.toEntity()).toList(),
        recordsByHabitId: recordsByHabitId,
      ));
    } catch (e) {
      return Left(DatabaseFailure('Failed to get daily summary: $e'));
    }
  }

  @override
  Future<Either<Failure, HabitWeeklyStats>> getWeeklyStats({
    required String habitId,
    required DateTime weekStart,
  }) async {
    try {
      final from = DateTime(
          weekStart.year, weekStart.month, weekStart.day);
      final to = from.add(const Duration(days: 6));

      final habitModel = await isar.habitModels
          .filter()
          .habitIdEqualTo(habitId)
          .findFirst();
      if (habitModel == null) {
        return Left(DatabaseFailure('Habit not found: $habitId'));
      }

      final records = await isar.streakRecordModels
          .filter()
          .habitIdEqualTo(habitId)
          .dateBetween(from, to)
          .findAll();

      // Build a 7-item day map
      final dayMap = List.filled(7, false);
      for (final r in records) {
        if (r.completed) {
          final dayIndex = r.date.weekday - 1;
          if (dayIndex >= 0 && dayIndex < 7) dayMap[dayIndex] = true;
        }
      }

      final completed = records.where((r) => r.completed).length;
      final excused = records.where((r) => r.excused).length;

      return Right(HabitWeeklyStats(
        habitId: habitId,
        weekStart: from,
        completedCount: completed,
        excusedCount: excused,
        targetCount: habitModel.targetFrequencyPerWeek,
        dayMap: dayMap,
      ));
    } catch (e) {
      return Left(DatabaseFailure('Failed to get weekly stats: $e'));
    }
  }

  @override
  Future<Either<Failure, WeeklySpiritualScore>> getWeeklySpiritualScore(
      DateTime weekStart) async {
    try {
      final from = DateTime(
          weekStart.year, weekStart.month, weekStart.day);
      final to = from.add(const Duration(days: 6));

      // Pull all records for the week
      final allRecords = await isar.streakRecordModels
          .filter()
          .dateBetween(from, to)
          .findAll();

      // Pull all habits to know categories
      final allHabits = await isar.habitModels
          .filter()
          .isActiveEqualTo(true)
          .findAll();

      final habitById = {for (var h in allHabits) h.habitId: h};

      // Separate records by category
      final prayerRecords = <StreakRecordModel>[];
      final quranRecords = <StreakRecordModel>[];
      final gymRecords = <StreakRecordModel>[];
      final otherRecords = <StreakRecordModel>[];

      for (final r in allRecords) {
        final habit = habitById[r.habitId];
        if (habit == null) continue;
        if (habit.name.contains('Prayer')) {
          prayerRecords.add(r);
        } else if (habit.name.contains('Quran')) {
          quranRecords.add(r);
        } else if (habit.category == HabitCategory.fitness.name) {
          gymRecords.add(r);
        } else {
          otherRecords.add(r);
        }
      }

      // Count targets for other habits
      final otherHabits = allHabits.where((h) =>
          !h.name.contains('Prayer') &&
          !h.name.contains('Quran') &&
          h.category != HabitCategory.fitness.name);
      final otherTarget =
          otherHabits.fold(0, (s, h) => s + h.targetFrequencyPerWeek);

      final gymHabits = allHabits
          .where((h) => h.category == HabitCategory.fitness.name);
      final gymTarget =
          gymHabits.fold(0, (s, h) => s + h.targetFrequencyPerWeek);

      final score = streakCalculator.calculateWeeklyScore(
        weekStart: from,
        prayerRecords: prayerRecords.map((m) => m.toEntity()).toList(),
        quranRecords: quranRecords.map((m) => m.toEntity()).toList(),
        habitRecords: otherRecords.map((m) => m.toEntity()).toList(),
        habitTargetCount: otherTarget,
        gymRecords: gymRecords.map((m) => m.toEntity()).toList(),
        gymTargetCount: gymTarget,
      );

      return Right(score);
    } catch (e) {
      return Left(DatabaseFailure('Failed to get weekly score: $e'));
    }
  }

  // ─── SEEDING ─────────────────────────────────────────────────────────────────
  @override
  Future<Either<Failure, List<Habit>>> seedDefaultHabits({
    required String gender,
    required bool hasFitness,
    required int quranPagesGoal,
    required bool cycleAware,
    required List<int> gymDays,
  }) async {
    try {
      // Only seed if no habits exist yet
      final existing = await isar.habitModels.count();
      if (existing > 0) {
        final all = await isar.habitModels.where().findAll();
        return Right(all.map((m) => m.toEntity()).toList());
      }

      final habits = DefaultHabitSeeder.seed(
        gender: gender,
        hasFitness: hasFitness,
        quranPagesGoal: quranPagesGoal,
        cycleAware: cycleAware,
        gymDays: gymDays,
      );

      final models = habits.map(HabitModel.fromEntity).toList();
      await isar.writeTxn(() => isar.habitModels.putAll(models));
      return Right(habits);
    } catch (e) {
      return Left(DatabaseFailure('Failed to seed habits: $e'));
    }
  }

  // ─── STREAK RECALCULATION ────────────────────────────────────────────────────
  /// Called after every completion/excuse/undo to keep denormalised
  /// streak counts on the HabitModel in sync.
  Future<void> _recalculateStreak(String habitId) async {
    try {
      final habitModel = await isar.habitModels
          .filter()
          .habitIdEqualTo(habitId)
          .findFirst();
      if (habitModel == null) return;

      // Load all records for this habit (full history needed for streak)
      final records = await isar.streakRecordModels
          .filter()
          .habitIdEqualTo(habitId)
          .sortByDate()
          .findAll();

      final result = streakCalculator.calculate(
        records: records.map((m) => m.toEntity()).toList(),
        scheduledDays: habitModel.scheduledDays,
        targetFrequencyPerWeek: habitModel.targetFrequencyPerWeek,
      );

      // Find last completion
      final lastCompleted = records
          .where((r) => r.completed)
          .fold<DateTime?>(null, (prev, r) {
        return prev == null || r.date.isAfter(prev) ? r.date : prev;
      });

      await isar.writeTxn(() async {
        habitModel
          ..currentStreak = result.current
          ..longestStreak = result.longest
          ..lastCompletedDate = lastCompleted;
        await isar.habitModels.put(habitModel);
      });
    } catch (_) {
      // Silently fail — streak recalc is non-critical
    }
  }
}
