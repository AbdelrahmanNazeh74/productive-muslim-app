import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/habit.dart';
import '../repositories/habits_repository.dart';

// ─── GET ALL HABITS ───────────────────────────────────────────────────────────
class GetAllHabits implements UseCase<List<Habit>, NoParams> {
  final HabitsRepository repository;
  GetAllHabits(this.repository);

  @override
  Future<Either<Failure, List<Habit>>> call(NoParams _) =>
      repository.getAllHabits();
}

// ─── SAVE HABIT ───────────────────────────────────────────────────────────────
class SaveHabit implements UseCase<Habit, Habit> {
  final HabitsRepository repository;
  SaveHabit(this.repository);

  @override
  Future<Either<Failure, Habit>> call(Habit habit) =>
      repository.saveHabit(habit);
}

// ─── DELETE HABIT ─────────────────────────────────────────────────────────────
class DeleteHabit implements UseCase<bool, String> {
  final HabitsRepository repository;
  DeleteHabit(this.repository);

  @override
  Future<Either<Failure, bool>> call(String habitId) =>
      repository.deleteHabit(habitId);
}

// ─── ARCHIVE HABIT ────────────────────────────────────────────────────────────
class ArchiveHabit implements UseCase<bool, String> {
  final HabitsRepository repository;
  ArchiveHabit(this.repository);

  @override
  Future<Either<Failure, bool>> call(String habitId) =>
      repository.archiveHabit(habitId);
}

// ─── COMPLETE HABIT ───────────────────────────────────────────────────────────
class CompleteHabitParams extends Equatable {
  final String habitId;
  final DateTime date;
  final String? note;
  const CompleteHabitParams(
      {required this.habitId, required this.date, this.note});

  @override
  List<Object?> get props => [habitId, date];
}

class CompleteHabit implements UseCase<StreakRecord, CompleteHabitParams> {
  final HabitsRepository repository;
  CompleteHabit(this.repository);

  @override
  Future<Either<Failure, StreakRecord>> call(CompleteHabitParams params) =>
      repository.recordCompletion(
        habitId: params.habitId,
        date: params.date,
        note: params.note,
      );
}

// ─── EXCUSE HABIT ────────────────────────────────────────────────────────────
class ExcuseHabitParams extends Equatable {
  final String habitId;
  final DateTime date;
  final StreakPauseReason reason;
  final String? note;
  const ExcuseHabitParams({
    required this.habitId,
    required this.date,
    required this.reason,
    this.note,
  });

  @override
  List<Object?> get props => [habitId, date, reason];
}

class ExcuseHabit implements UseCase<StreakRecord, ExcuseHabitParams> {
  final HabitsRepository repository;
  ExcuseHabit(this.repository);

  @override
  Future<Either<Failure, StreakRecord>> call(ExcuseHabitParams params) =>
      repository.recordExcused(
        habitId: params.habitId,
        date: params.date,
        reason: params.reason,
        note: params.note,
      );
}

// ─── UNDO COMPLETION ─────────────────────────────────────────────────────────
class UndoHabitParams extends Equatable {
  final String habitId;
  final DateTime date;
  const UndoHabitParams({required this.habitId, required this.date});

  @override
  List<Object?> get props => [habitId, date];
}

class UndoHabitCompletion implements UseCase<bool, UndoHabitParams> {
  final HabitsRepository repository;
  UndoHabitCompletion(this.repository);

  @override
  Future<Either<Failure, bool>> call(UndoHabitParams params) =>
      repository.undoCompletion(
          habitId: params.habitId, date: params.date);
}

// ─── GET DAILY SUMMARY ────────────────────────────────────────────────────────
class GetDailyHabitSummary implements UseCase<DailyHabitSummary, DateTime> {
  final HabitsRepository repository;
  GetDailyHabitSummary(this.repository);

  @override
  Future<Either<Failure, DailyHabitSummary>> call(DateTime date) =>
      repository.getDailySummary(date);
}

// ─── GET WEEKLY SPIRITUAL SCORE ───────────────────────────────────────────────
class GetWeeklySpiritualScore
    implements UseCase<WeeklySpiritualScore, DateTime> {
  final HabitsRepository repository;
  GetWeeklySpiritualScore(this.repository);

  @override
  Future<Either<Failure, WeeklySpiritualScore>> call(DateTime weekStart) =>
      repository.getWeeklySpiritualScore(weekStart);
}

// ─── GET WEEKLY STATS ─────────────────────────────────────────────────────────
class GetWeeklyStatsParams extends Equatable {
  final String habitId;
  final DateTime weekStart;
  const GetWeeklyStatsParams(
      {required this.habitId, required this.weekStart});

  @override
  List<Object?> get props => [habitId, weekStart];
}

class GetHabitWeeklyStats
    implements UseCase<HabitWeeklyStats, GetWeeklyStatsParams> {
  final HabitsRepository repository;
  GetHabitWeeklyStats(this.repository);

  @override
  Future<Either<Failure, HabitWeeklyStats>> call(
          GetWeeklyStatsParams params) =>
      repository.getWeeklyStats(
          habitId: params.habitId, weekStart: params.weekStart);
}

// ─── SEED DEFAULT HABITS ──────────────────────────────────────────────────────
class SeedDefaultHabitsParams extends Equatable {
  final String gender;
  final bool hasFitness;
  final int quranPagesGoal;
  final bool cycleAware;
  final List<int> gymDays;

  const SeedDefaultHabitsParams({
    required this.gender,
    required this.hasFitness,
    required this.quranPagesGoal,
    required this.cycleAware,
    required this.gymDays,
  });

  @override
  List<Object?> get props =>
      [gender, hasFitness, quranPagesGoal, cycleAware, gymDays];
}

class SeedDefaultHabits
    implements UseCase<List<Habit>, SeedDefaultHabitsParams> {
  final HabitsRepository repository;
  SeedDefaultHabits(this.repository);

  @override
  Future<Either<Failure, List<Habit>>> call(
          SeedDefaultHabitsParams params) =>
      repository.seedDefaultHabits(
        gender: params.gender,
        hasFitness: params.hasFitness,
        quranPagesGoal: params.quranPagesGoal,
        cycleAware: params.cycleAware,
        gymDays: params.gymDays,
      );
}
