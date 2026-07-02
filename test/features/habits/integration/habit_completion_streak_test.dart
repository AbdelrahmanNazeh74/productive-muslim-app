import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:productive_muslim/core/errors/failures.dart';
import 'package:productive_muslim/core/usecases/usecase.dart';
import 'package:productive_muslim/features/habits/domain/entities/habit.dart';
import 'package:productive_muslim/features/habits/domain/usecases/habit_usecases.dart';
import 'package:productive_muslim/features/habits/domain/usecases/streak_calculator.dart';
import 'package:productive_muslim/features/habits/presentation/bloc/habits_bloc.dart';

// ─── MOCKS ────────────────────────────────────────────────────────────────────
class MockGetAllHabits extends Mock implements GetAllHabits {}
class MockSaveHabit extends Mock implements SaveHabit {}
class MockDeleteHabit extends Mock implements DeleteHabit {}
class MockArchiveHabit extends Mock implements ArchiveHabit {}
class MockCompleteHabit extends Mock implements CompleteHabit {}
class MockExcuseHabit extends Mock implements ExcuseHabit {}
class MockUndoHabitCompletion extends Mock implements UndoHabitCompletion {}
class MockGetDailyHabitSummary extends Mock implements GetDailyHabitSummary {}
class MockGetWeeklySpiritualScore extends Mock implements GetWeeklySpiritualScore {}
class MockSeedDefaultHabits extends Mock implements SeedDefaultHabits {}

// ─── FAKES ────────────────────────────────────────────────────────────────────
class FakeHabit extends Fake implements Habit {}
class FakeCompleteHabitParams extends Fake implements CompleteHabitParams {}
class FakeExcuseHabitParams extends Fake implements ExcuseHabitParams {}
class FakeUndoHabitParams extends Fake implements UndoHabitParams {}
class FakeNoParams extends Fake implements NoParams {}
class FakeSeedDefaultHabitsParams extends Fake implements SeedDefaultHabitsParams {}

// ─── HELPERS ─────────────────────────────────────────────────────────────────
Habit makeHabit({
  String id = 'habit-1',
  String name = 'Fajr Prayer',
  HabitCategory category = HabitCategory.spiritual,
  int currentStreak = 0,
  int longestStreak = 0,
  bool isActive = true,
  List<int> scheduledDays = const [0, 1, 2, 3, 4, 5, 6],
}) {
  return Habit(
    id: id,
    name: name,
    emoji: '🕌',
    category: category,
    targetFrequencyPerWeek: 7,
    scheduledDays: scheduledDays,
    timeAnchor: 'fajr',
    currentStreak: currentStreak,
    longestStreak: longestStreak,
    isActive: isActive,
    streakPauseOnCycle: false,
    isSystemHabit: true,
    notificationsEnabled: true,
    createdAt: DateTime(2024, 1, 1),
  );
}

StreakRecord makeStreakRecord({
  String habitId = 'habit-1',
  bool completed = true,
}) {
  return StreakRecord(
    id: 'record-1',
    habitId: habitId,
    date: DateTime(2024, 6, 1),
    completed: completed,
    excused: false,
    pauseReason: StreakPauseReason.none,
    completedAt: completed ? DateTime(2024, 6, 1, 6, 0) : null,
  );
}

DailyHabitSummary makeSummary({
  String habitId = 'habit-1',
  bool completed = true,
}) {
  final habit = makeHabit(id: habitId);
  final record = completed ? makeStreakRecord(habitId: habitId) : null;
  return DailyHabitSummary(
    date: DateTime(2024, 6, 1),
    habits: [habit],
    recordsByHabitId: {habitId: record},
  );
}

WeeklySpiritualScore makeScore({double overall = 0.85}) {
  return WeeklySpiritualScore(
    weekStart: DateTime(2024, 5, 27),
    prayerScore: 85,
    quranScore: 70,
    habitsScore: 80,
    gymScore: 50,
  );
}

HabitsBloc makeBloc({
  required MockGetAllHabits getAllHabits,
  required MockCompleteHabit completeHabit,
  required MockGetDailyHabitSummary getDailySummary,
  required MockGetWeeklySpiritualScore getWeeklyScore,
  MockSaveHabit? saveHabit,
  MockExcuseHabit? excuseHabit,
  MockUndoHabitCompletion? undoCompletion,
}) {
  return HabitsBloc(
    getAllHabits: getAllHabits,
    saveHabit: saveHabit ?? MockSaveHabit(),
    deleteHabit: MockDeleteHabit(),
    archiveHabit: MockArchiveHabit(),
    completeHabit: completeHabit,
    excuseHabit: excuseHabit ?? MockExcuseHabit(),
    undoHabitCompletion: undoCompletion ?? MockUndoHabitCompletion(),
    getDailyHabitSummary: getDailySummary,
    getWeeklySpiritualScore: getWeeklyScore,
    seedDefaultHabits: MockSeedDefaultHabits(),
  );
}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeHabit());
    registerFallbackValue(FakeCompleteHabitParams());
    registerFallbackValue(FakeExcuseHabitParams());
    registerFallbackValue(FakeUndoHabitParams());
    registerFallbackValue(FakeNoParams());
    registerFallbackValue(FakeSeedDefaultHabitsParams());
    registerFallbackValue(DateTime(2024, 1, 1));
  });

  // ─── HABIT LOAD TESTS ────────────────────────────────────────────────────

  group('HabitsBloc — load', () {
    late MockGetAllHabits mockGetAll;
    late MockCompleteHabit mockComplete;
    late MockGetDailyHabitSummary mockSummary;
    late MockGetWeeklySpiritualScore mockScore;
    late HabitsBloc bloc;

    setUp(() {
      mockGetAll = MockGetAllHabits();
      mockComplete = MockCompleteHabit();
      mockSummary = MockGetDailyHabitSummary();
      mockScore = MockGetWeeklySpiritualScore();
      bloc = makeBloc(
        getAllHabits: mockGetAll,
        completeHabit: mockComplete,
        getDailySummary: mockSummary,
        getWeeklyScore: mockScore,
      );
    });

    tearDown(() => bloc.close());

    blocTest<HabitsBloc, HabitsState>(
      'HabitsLoadRequested emits loading → loaded with habits and summary',
      build: () {
        when(() => mockGetAll(any()))
            .thenAnswer((_) async => Right([makeHabit()]));
        when(() => mockSummary(any()))
            .thenAnswer((_) async => Right(makeSummary(completed: false)));
        when(() => mockScore(any()))
            .thenAnswer((_) async => Right(makeScore()));
        return bloc;
      },
      act: (b) => b.add(HabitsLoadRequested(date: DateTime(2024, 6, 1))),
      expect: () => [
        isA<HabitsState>()
            .having((s) => s.status, 'status', HabitsStatus.loading),
        isA<HabitsState>()
            .having((s) => s.status, 'status', HabitsStatus.loaded)
            .having((s) => s.habits.length, 'habits count', 1),
        isA<HabitsState>()
            .having((s) => s.weeklyScore, 'weekly score', isNotNull),
      ],
    );

    blocTest<HabitsBloc, HabitsState>(
      'HabitsLoadRequested emits error when getAllHabits fails',
      build: () {
        when(() => mockGetAll(any())).thenAnswer(
          (_) async => const Left(DatabaseFailure('db error')),
        );
        when(() => mockSummary(any()))
            .thenAnswer((_) async => Right(makeSummary(completed: false)));
        // _onLoad always dispatches WeeklyScoreRequested even on error;
        // returning Left means _onWeeklyScore emits nothing extra
        when(() => mockScore(any()))
            .thenAnswer((_) async => const Left(DatabaseFailure('no score')));
        return bloc;
      },
      act: (b) => b.add(HabitsLoadRequested(date: DateTime(2024, 6, 1))),
      expect: () => [
        isA<HabitsState>()
            .having((s) => s.status, 'status', HabitsStatus.loading),
        isA<HabitsState>()
            .having((s) => s.status, 'status', HabitsStatus.error)
            .having((s) => s.errorMessage, 'error', isNotNull),
      ],
    );
  });

  // ─── HABIT COMPLETION → STREAK UPDATE TESTS ───────────────────────────────

  group('HabitsBloc — completion and streak update', () {
    late MockGetAllHabits mockGetAll;
    late MockCompleteHabit mockComplete;
    late MockGetDailyHabitSummary mockSummary;
    late MockGetWeeklySpiritualScore mockScore;
    late HabitsBloc bloc;

    final date = DateTime(2024, 6, 1);

    setUp(() {
      mockGetAll = MockGetAllHabits();
      mockComplete = MockCompleteHabit();
      mockSummary = MockGetDailyHabitSummary();
      mockScore = MockGetWeeklySpiritualScore();
      bloc = makeBloc(
        getAllHabits: mockGetAll,
        completeHabit: mockComplete,
        getDailySummary: mockSummary,
        getWeeklyScore: mockScore,
      );
    });

    tearDown(() => bloc.close());

    blocTest<HabitsBloc, HabitsState>(
      'HabitCompleted emits updated habits with incremented streak',
      build: () {
        // Before completion: streak = 0
        // After completion: streak = 1
        when(() => mockComplete(any()))
            .thenAnswer((_) async => Right(makeStreakRecord()));
        when(() => mockGetAll(any()))
            .thenAnswer((_) async => Right([makeHabit(currentStreak: 1, longestStreak: 1)]));
        when(() => mockSummary(any()))
            .thenAnswer((_) async => Right(makeSummary(completed: true)));
        when(() => mockScore(any()))
            .thenAnswer((_) async => Right(makeScore()));
        return bloc;
      },
      seed: () => HabitsState(
        selectedDate: date,
        status: HabitsStatus.loaded,
        habits: [makeHabit(currentStreak: 0, longestStreak: 0)],
        dailySummary: makeSummary(completed: false),
      ),
      act: (b) => b.add(HabitCompleted(habitId: 'habit-1', date: date)),
      expect: () => [
        isA<HabitsState>()
            .having((s) => s.lastCompletedHabitId, 'completedId', 'habit-1')
            .having(
              (s) => s.habits.first.currentStreak,
              'streak after completion',
              1,
            ),
      ],
    );

    blocTest<HabitsBloc, HabitsState>(
      'HabitCompleted sets newPersonalBest when longestStreak increases',
      build: () {
        // longestStreak goes from 5 → 6 (new record)
        when(() => mockComplete(any()))
            .thenAnswer((_) async => Right(makeStreakRecord()));
        when(() => mockGetAll(any()))
            .thenAnswer((_) async => Right([
              makeHabit(currentStreak: 6, longestStreak: 6),
            ]));
        when(() => mockSummary(any()))
            .thenAnswer((_) async => Right(makeSummary(completed: true)));
        when(() => mockScore(any()))
            .thenAnswer((_) async => Right(makeScore()));
        return bloc;
      },
      seed: () => HabitsState(
        selectedDate: date,
        status: HabitsStatus.loaded,
        habits: [makeHabit(currentStreak: 5, longestStreak: 5)],
        dailySummary: makeSummary(completed: false),
      ),
      act: (b) => b.add(HabitCompleted(habitId: 'habit-1', date: date)),
      expect: () => [
        isA<HabitsState>()
            .having((s) => s.newPersonalBest, 'newPersonalBest', true),
      ],
    );

    blocTest<HabitsBloc, HabitsState>(
      'HabitCompleted does NOT set newPersonalBest when streak is below record',
      build: () {
        // currentStreak goes from 3 → 4, but longestStreak is already 10
        when(() => mockComplete(any()))
            .thenAnswer((_) async => Right(makeStreakRecord()));
        when(() => mockGetAll(any()))
            .thenAnswer((_) async => Right([
              makeHabit(currentStreak: 4, longestStreak: 10),
            ]));
        when(() => mockSummary(any()))
            .thenAnswer((_) async => Right(makeSummary(completed: true)));
        when(() => mockScore(any()))
            .thenAnswer((_) async => Right(makeScore()));
        return bloc;
      },
      seed: () => HabitsState(
        selectedDate: date,
        status: HabitsStatus.loaded,
        habits: [makeHabit(currentStreak: 3, longestStreak: 10)],
        dailySummary: makeSummary(completed: false),
      ),
      act: (b) => b.add(HabitCompleted(habitId: 'habit-1', date: date)),
      expect: () => [
        isA<HabitsState>()
            .having((s) => s.newPersonalBest, 'newPersonalBest', false),
      ],
    );

    blocTest<HabitsBloc, HabitsState>(
      'HabitCompleted does NOT set newPersonalBest when on streak equal to record '
      '(staying at same record, not surpassing)',
      build: () {
        // Bug fix regression: before fix, currentStreak >= longestStreak
        // always triggered newPersonalBest when on an active streak.
        // After fix, longestStreak must INCREASE vs pre-completion value.
        when(() => mockComplete(any()))
            .thenAnswer((_) async => Right(makeStreakRecord()));
        when(() => mockGetAll(any()))
            .thenAnswer((_) async => Right([
              // longestStreak stays at 5 (no increase)
              makeHabit(currentStreak: 5, longestStreak: 5),
            ]));
        when(() => mockSummary(any()))
            .thenAnswer((_) async => Right(makeSummary(completed: true)));
        when(() => mockScore(any()))
            .thenAnswer((_) async => Right(makeScore()));
        return bloc;
      },
      seed: () => HabitsState(
        selectedDate: date,
        status: HabitsStatus.loaded,
        // Pre-completion: already at longestStreak = 5
        habits: [makeHabit(currentStreak: 4, longestStreak: 5)],
        dailySummary: makeSummary(completed: false),
      ),
      act: (b) => b.add(HabitCompleted(habitId: 'habit-1', date: date)),
      expect: () => [
        isA<HabitsState>()
            .having((s) => s.newPersonalBest, 'newPersonalBest', false),
      ],
    );

    blocTest<HabitsBloc, HabitsState>(
      'HabitUndone triggers reload after undoing completion',
      build: () {
        final mockUndo = MockUndoHabitCompletion();
        when(() => mockUndo(any())).thenAnswer((_) async => const Right(true));
        when(() => mockGetAll(any()))
            .thenAnswer((_) async => Right([makeHabit()]));
        when(() => mockSummary(any()))
            .thenAnswer((_) async => Right(makeSummary(completed: false)));
        when(() => mockScore(any()))
            .thenAnswer((_) async => Right(makeScore()));

        return HabitsBloc(
          getAllHabits: mockGetAll,
          saveHabit: MockSaveHabit(),
          deleteHabit: MockDeleteHabit(),
          archiveHabit: MockArchiveHabit(),
          completeHabit: mockComplete,
          excuseHabit: MockExcuseHabit(),
          undoHabitCompletion: mockUndo,
          getDailyHabitSummary: mockSummary,
          getWeeklySpiritualScore: mockScore,
          seedDefaultHabits: MockSeedDefaultHabits(),
        );
      },
      act: (b) => b.add(HabitUndone(habitId: 'habit-1', date: date)),
      expect: () => [
        isA<HabitsState>()
            .having((s) => s.status, 'status', HabitsStatus.loading),
        isA<HabitsState>()
            .having((s) => s.status, 'status', HabitsStatus.loaded),
        isA<HabitsState>()
            .having((s) => s.status, 'status', HabitsStatus.loaded)
            .having((s) => s.weeklyScore, 'weeklyScore', isNotNull),
      ],
    );
  });

  // ─── WEEKLY SCORE TESTS (analytics reflection) ────────────────────────────

  group('HabitsBloc — weekly score reflects completions', () {
    late MockGetAllHabits mockGetAll;
    late MockCompleteHabit mockComplete;
    late MockGetDailyHabitSummary mockSummary;
    late MockGetWeeklySpiritualScore mockScore;
    late HabitsBloc bloc;

    final date = DateTime(2024, 6, 1);

    setUp(() {
      mockGetAll = MockGetAllHabits();
      mockComplete = MockCompleteHabit();
      mockSummary = MockGetDailyHabitSummary();
      mockScore = MockGetWeeklySpiritualScore();
      bloc = makeBloc(
        getAllHabits: mockGetAll,
        completeHabit: mockComplete,
        getDailySummary: mockSummary,
        getWeeklyScore: mockScore,
      );
    });

    tearDown(() => bloc.close());

    blocTest<HabitsBloc, HabitsState>(
      'WeeklyScoreRequested loads and emits weekly score into state',
      build: () {
        when(() => mockScore(any()))
            .thenAnswer((_) async => Right(makeScore()));
        return bloc;
      },
      act: (b) => b.add(WeeklyScoreRequested(DateTime(2024, 5, 27))),
      expect: () => [
        isA<HabitsState>()
            .having((s) => s.weeklyScore, 'weeklyScore', isNotNull),
      ],
    );

    blocTest<HabitsBloc, HabitsState>(
      'After HabitCompleted, habits and summary are refreshed inline',
      build: () {
        when(() => mockComplete(any()))
            .thenAnswer((_) async => Right(makeStreakRecord()));
        when(() => mockGetAll(any()))
            .thenAnswer((_) async => Right([makeHabit(currentStreak: 1, longestStreak: 1)]));
        when(() => mockSummary(any()))
            .thenAnswer((_) async => Right(makeSummary(completed: true)));
        when(() => mockScore(any()))
            .thenAnswer((_) async => Right(makeScore()));
        return bloc;
      },
      seed: () => HabitsState(
        selectedDate: date,
        status: HabitsStatus.loaded,
        habits: [makeHabit()],
        dailySummary: makeSummary(completed: false),
      ),
      act: (b) => b.add(HabitCompleted(habitId: 'habit-1', date: date)),
      expect: () => [
        // _onComplete does an inline reload (not via HabitsLoadRequested),
        // emitting one updated state with refreshed habits + summary
        isA<HabitsState>()
            .having((s) => s.lastCompletedHabitId, 'completedId', 'habit-1')
            .having((s) => s.habits.first.currentStreak, 'streak', 1),
      ],
    );
  });

  // ─── STREAK CALCULATOR UNIT TESTS ─────────────────────────────────────────

  group('StreakCalculator — core streak logic', () {
    const calc = StreakCalculator();

    List<StreakRecord> makeRecords(List<int> offsetDaysCompleted) {
      return offsetDaysCompleted.map((offset) {
        final d = DateTime(2024, 6, 1).subtract(Duration(days: offset));
        return StreakRecord(
          id: 'r-$offset',
          habitId: 'h1',
          date: d,
          completed: true,
          excused: false,
          pauseReason: StreakPauseReason.none,
        );
      }).toList();
    }

    test('empty records → streak 0', () {
      final result = calc.calculate(
        records: [],
        scheduledDays: [0, 1, 2, 3, 4, 5, 6],
        targetFrequencyPerWeek: 7,
      );
      expect(result.current, 0);
      expect(result.longest, 0);
    });

    test('one completion today → streak 1', () {
      final records = [makeRecords([0]).first]; // today
      final result = calc.calculate(
        records: records,
        scheduledDays: [0, 1, 2, 3, 4, 5, 6],
        targetFrequencyPerWeek: 7,
        asOf: DateTime(2024, 6, 1),
      );
      expect(result.current, greaterThanOrEqualTo(1));
    });

    test('five consecutive completions → streak 5', () {
      final records = makeRecords([0, 1, 2, 3, 4]); // today + 4 days back
      final result = calc.calculate(
        records: records,
        scheduledDays: [0, 1, 2, 3, 4, 5, 6],
        targetFrequencyPerWeek: 7,
        asOf: DateTime(2024, 6, 1),
      );
      expect(result.current, 5);
      expect(result.longest, 5);
    });

    test('gap in completions resets current streak', () {
      // Completed today and 2 days ago, but NOT yesterday (gap)
      final records = makeRecords([0, 2]);
      final result = calc.calculate(
        records: records,
        scheduledDays: [0, 1, 2, 3, 4, 5, 6],
        targetFrequencyPerWeek: 7,
        asOf: DateTime(2024, 6, 1),
      );
      expect(result.current, 1); // only today counts
    });

    test('excused day is transparent — does not break streak', () {
      final excusedRecord = StreakRecord(
        id: 'excused',
        habitId: 'h1',
        date: DateTime(2024, 6, 1).subtract(const Duration(days: 1)),
        completed: false,
        excused: true,
        pauseReason: StreakPauseReason.travel,
      );
      final todayRecord = makeRecords([0]).first;
      final dayBeforeRecord = makeRecords([2]).first;

      final result = calc.calculate(
        records: [todayRecord, excusedRecord, dayBeforeRecord],
        scheduledDays: [0, 1, 2, 3, 4, 5, 6],
        targetFrequencyPerWeek: 7,
        asOf: DateTime(2024, 6, 1),
      );
      // Excused day is transparent; streak should span through it
      expect(result.current, greaterThanOrEqualTo(2));
    });

    test('longestStreak tracks the all-time high independently', () {
      // 5 completions from 10-14 days ago (old record), only 2 recent
      final oldRun = makeRecords([10, 11, 12, 13, 14]);
      final recentRun = makeRecords([0, 1]);
      final result = calc.calculate(
        records: [...oldRun, ...recentRun],
        scheduledDays: [0, 1, 2, 3, 4, 5, 6],
        targetFrequencyPerWeek: 7,
        asOf: DateTime(2024, 6, 1),
      );
      expect(result.longest, 5);
      expect(result.current, 2);
    });

    test('wouldSetNewRecord returns true when current equals longest', () {
      expect(
        calc.wouldSetNewRecord(currentStreak: 5, longestStreak: 5),
        true,
      );
    });

    test('wouldSetNewRecord returns false when current is below record', () {
      expect(
        calc.wouldSetNewRecord(currentStreak: 3, longestStreak: 7),
        false,
      );
    });
  });
}
