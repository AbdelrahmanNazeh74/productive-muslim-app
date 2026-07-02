import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/habit.dart';
import '../../domain/usecases/habit_usecases.dart';

// ─── EVENTS ───────────────────────────────────────────────────────────────────
abstract class HabitsEvent extends Equatable {
  const HabitsEvent();
  @override
  List<Object?> get props => [];
}

class HabitsLoadRequested extends HabitsEvent {
  final DateTime date;
  const HabitsLoadRequested({required this.date});
  @override
  List<Object?> get props => [date];
}

class HabitsSeedRequested extends HabitsEvent {
  final SeedDefaultHabitsParams params;
  const HabitsSeedRequested(this.params);
  @override
  List<Object?> get props => [params];
}

class HabitCompleted extends HabitsEvent {
  final String habitId;
  final DateTime date;
  final String? note;
  const HabitCompleted({required this.habitId, required this.date, this.note});
  @override
  List<Object?> get props => [habitId, date];
}

class HabitExcused extends HabitsEvent {
  final String habitId;
  final DateTime date;
  final StreakPauseReason reason;
  final String? note;
  const HabitExcused({
    required this.habitId,
    required this.date,
    required this.reason,
    this.note,
  });
  @override
  List<Object?> get props => [habitId, date, reason];
}

class HabitUndone extends HabitsEvent {
  final String habitId;
  final DateTime date;
  const HabitUndone({required this.habitId, required this.date});
  @override
  List<Object?> get props => [habitId, date];
}

class HabitAdded extends HabitsEvent {
  final Habit habit;
  const HabitAdded(this.habit);
  @override
  List<Object?> get props => [habit.id];
}

class HabitUpdated extends HabitsEvent {
  final Habit habit;
  const HabitUpdated(this.habit);
  @override
  List<Object?> get props => [habit.id];
}

class HabitDeleted extends HabitsEvent {
  final String habitId;
  const HabitDeleted(this.habitId);
  @override
  List<Object?> get props => [habitId];
}

class HabitArchived extends HabitsEvent {
  final String habitId;
  const HabitArchived(this.habitId);
  @override
  List<Object?> get props => [habitId];
}

class HabitsDateChanged extends HabitsEvent {
  final DateTime date;
  const HabitsDateChanged(this.date);
  @override
  List<Object?> get props => [date];
}

class WeeklyScoreRequested extends HabitsEvent {
  final DateTime weekStart;
  const WeeklyScoreRequested(this.weekStart);
  @override
  List<Object?> get props => [weekStart];
}

// ─── STATE ────────────────────────────────────────────────────────────────────
enum HabitsStatus { initial, loading, loaded, error }

class HabitsState extends Equatable {
  final HabitsStatus status;
  final DateTime selectedDate;
  final List<Habit> habits;
  final DailyHabitSummary? dailySummary;
  final WeeklySpiritualScore? weeklyScore;
  final String? errorMessage;
  final String? lastCompletedHabitId; // triggers celebration animation
  final bool newPersonalBest;         // triggers special milestone UI

  const HabitsState({
    this.status = HabitsStatus.initial,
    required this.selectedDate,
    this.habits = const [],
    this.dailySummary,
    this.weeklyScore,
    this.errorMessage,
    this.lastCompletedHabitId,
    this.newPersonalBest = false,
  });

  bool isCompleted(String habitId) =>
      dailySummary?.isCompleted(habitId) ?? false;

  bool isExcused(String habitId) =>
      dailySummary?.isExcused(habitId) ?? false;

  Habit? findHabit(String id) {
    try {
      return habits.firstWhere((h) => h.id == id);
    } catch (_) {
      return null;
    }
  }

  HabitsState copyWith({
    HabitsStatus? status,
    DateTime? selectedDate,
    List<Habit>? habits,
    DailyHabitSummary? dailySummary,
    WeeklySpiritualScore? weeklyScore,
    String? errorMessage,
    String? lastCompletedHabitId,
    bool? newPersonalBest,
  }) {
    return HabitsState(
      status: status ?? this.status,
      selectedDate: selectedDate ?? this.selectedDate,
      habits: habits ?? this.habits,
      dailySummary: dailySummary ?? this.dailySummary,
      weeklyScore: weeklyScore ?? this.weeklyScore,
      errorMessage: errorMessage,
      lastCompletedHabitId: lastCompletedHabitId,
      newPersonalBest: newPersonalBest ?? false,
    );
  }

  @override
  List<Object?> get props => [
        status,
        selectedDate,
        habits,
        dailySummary,
        weeklyScore,
        errorMessage,
        lastCompletedHabitId,
        newPersonalBest,
      ];
}

// ─── BLOC ─────────────────────────────────────────────────────────────────────
class HabitsBloc extends Bloc<HabitsEvent, HabitsState> {
  final GetAllHabits getAllHabits;
  final SaveHabit saveHabit;
  final DeleteHabit deleteHabit;
  final ArchiveHabit archiveHabit;
  final CompleteHabit completeHabit;
  final ExcuseHabit excuseHabit;
  final UndoHabitCompletion undoHabitCompletion;
  final GetDailyHabitSummary getDailyHabitSummary;
  final GetWeeklySpiritualScore getWeeklySpiritualScore;
  final SeedDefaultHabits seedDefaultHabits;

  HabitsBloc({
    required this.getAllHabits,
    required this.saveHabit,
    required this.deleteHabit,
    required this.archiveHabit,
    required this.completeHabit,
    required this.excuseHabit,
    required this.undoHabitCompletion,
    required this.getDailyHabitSummary,
    required this.getWeeklySpiritualScore,
    required this.seedDefaultHabits,
  }) : super(HabitsState(selectedDate: DateTime.now())) {
    on<HabitsLoadRequested>(_onLoad);
    on<HabitsSeedRequested>(_onSeed);
    on<HabitCompleted>(_onComplete);
    on<HabitExcused>(_onExcuse);
    on<HabitUndone>(_onUndo);
    on<HabitAdded>(_onAdd);
    on<HabitUpdated>(_onUpdate);
    on<HabitDeleted>(_onDelete);
    on<HabitArchived>(_onArchive);
    on<HabitsDateChanged>(_onDateChanged);
    on<WeeklyScoreRequested>(_onWeeklyScore);
  }

  // ── LOAD ──────────────────────────────────────────────────────────────────────
  Future<void> _onLoad(
      HabitsLoadRequested event, Emitter<HabitsState> emit) async {
    emit(state.copyWith(
        status: HabitsStatus.loading, selectedDate: event.date));

    final habitsResult = await getAllHabits(const NoParams());
    final summaryResult = await getDailyHabitSummary(event.date);

    habitsResult.fold(
      (f) => emit(state.copyWith(
          status: HabitsStatus.error, errorMessage: f.message)),
      (habits) => summaryResult.fold(
        (f) => emit(state.copyWith(
            status: HabitsStatus.error, errorMessage: f.message)),
        (summary) => emit(state.copyWith(
          status: HabitsStatus.loaded,
          habits: habits,
          dailySummary: summary,
        )),
      ),
    );

    // Load weekly score in background
    final weekStart = _weekStart(event.date);
    add(WeeklyScoreRequested(weekStart));
  }

  // ── SEED ──────────────────────────────────────────────────────────────────────
  Future<void> _onSeed(
      HabitsSeedRequested event, Emitter<HabitsState> emit) async {
    final result = await seedDefaultHabits(event.params);
    result.fold(
      (f) => emit(state.copyWith(errorMessage: f.message)),
      (_) => add(HabitsLoadRequested(date: state.selectedDate)),
    );
  }

  // ── COMPLETE ─────────────────────────────────────────────────────────────────
  Future<void> _onComplete(
      HabitCompleted event, Emitter<HabitsState> emit) async {
    final result = await completeHabit(
      CompleteHabitParams(
          habitId: event.habitId, date: event.date, note: event.note),
    );

    await result.fold(
      (f) async => emit(state.copyWith(errorMessage: f.message)),
      (_) async {
        // Reload to get updated streak counts
        final habitsResult = await getAllHabits(const NoParams());
        final summaryResult = await getDailyHabitSummary(event.date);

        habitsResult.fold((_) {}, (habits) {
          summaryResult.fold((_) {}, (summary) {
            // True new personal best: longestStreak increased vs before completion.
            // After _recalculateStreak, longestStreak == max(prev, current), so
            // comparing against the pre-completion state value is the only reliable check.
            final prevLongest =
                state.findHabit(event.habitId)?.longestStreak ?? 0;
            final habit = habits.firstWhere(
              (h) => h.id == event.habitId,
              orElse: () => habits.first,
            );
            final isNewBest = habit.longestStreak > prevLongest;

            emit(state.copyWith(
              habits: habits,
              dailySummary: summary,
              lastCompletedHabitId: event.habitId,
              newPersonalBest: isNewBest,
            ));
          });
        });
      },
    );
  }

  // ── EXCUSE ────────────────────────────────────────────────────────────────────
  Future<void> _onExcuse(
      HabitExcused event, Emitter<HabitsState> emit) async {
    final result = await excuseHabit(
      ExcuseHabitParams(
        habitId: event.habitId,
        date: event.date,
        reason: event.reason,
        note: event.note,
      ),
    );
    result.fold(
      (f) => emit(state.copyWith(errorMessage: f.message)),
      (_) => add(HabitsLoadRequested(date: event.date)),
    );
  }

  // ── UNDO ──────────────────────────────────────────────────────────────────────
  Future<void> _onUndo(
      HabitUndone event, Emitter<HabitsState> emit) async {
    final result = await undoHabitCompletion(
      UndoHabitParams(habitId: event.habitId, date: event.date),
    );
    result.fold(
      (f) => emit(state.copyWith(errorMessage: f.message)),
      (_) => add(HabitsLoadRequested(date: event.date)),
    );
  }

  // ── ADD / UPDATE / DELETE / ARCHIVE ──────────────────────────────────────────
  Future<void> _onAdd(HabitAdded event, Emitter<HabitsState> emit) async {
    final result = await saveHabit(event.habit);
    result.fold(
      (f) => emit(state.copyWith(errorMessage: f.message)),
      (_) => add(HabitsLoadRequested(date: state.selectedDate)),
    );
  }

  Future<void> _onUpdate(
      HabitUpdated event, Emitter<HabitsState> emit) async {
    final result = await saveHabit(event.habit);
    result.fold(
      (f) => emit(state.copyWith(errorMessage: f.message)),
      (_) => add(HabitsLoadRequested(date: state.selectedDate)),
    );
  }

  Future<void> _onDelete(
      HabitDeleted event, Emitter<HabitsState> emit) async {
    final result = await deleteHabit(event.habitId);
    result.fold(
      (f) => emit(state.copyWith(errorMessage: f.message)),
      (_) => add(HabitsLoadRequested(date: state.selectedDate)),
    );
  }

  Future<void> _onArchive(
      HabitArchived event, Emitter<HabitsState> emit) async {
    final result = await archiveHabit(event.habitId);
    result.fold(
      (f) => emit(state.copyWith(errorMessage: f.message)),
      (_) => add(HabitsLoadRequested(date: state.selectedDate)),
    );
  }

  Future<void> _onDateChanged(
      HabitsDateChanged event, Emitter<HabitsState> emit) async {
    add(HabitsLoadRequested(date: event.date));
  }

  Future<void> _onWeeklyScore(
      WeeklyScoreRequested event, Emitter<HabitsState> emit) async {
    final result = await getWeeklySpiritualScore(event.weekStart);
    result.fold(
      (_) {},
      (score) => emit(state.copyWith(weeklyScore: score)),
    );
  }

  // ── HELPERS ──────────────────────────────────────────────────────────────────
  DateTime _weekStart(DateTime date) {
    final diff = date.weekday - 1;
    return DateTime(date.year, date.month, date.day - diff);
  }
}
