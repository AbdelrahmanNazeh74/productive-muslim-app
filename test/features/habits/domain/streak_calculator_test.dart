import 'package:flutter_test/flutter_test.dart';
import 'package:productive_muslim/features/habits/domain/entities/habit.dart';
import 'package:productive_muslim/features/habits/domain/usecases/streak_calculator.dart';

void main() {
  late StreakCalculator calc;

  // Helper to build a StreakRecord
  StreakRecord rec(DateTime date,
          {bool completed = true, bool excused = false}) =>
      StreakRecord(
        id: 'r_${date.millisecondsSinceEpoch}',
        habitId: 'h1',
        date: date,
        completed: completed,
        excused: excused,
        pauseReason:
            excused ? StreakPauseReason.illness : StreakPauseReason.none,
      );

  DateTime d(int daysAgo) {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day)
        .subtract(Duration(days: daysAgo));
  }

  setUp(() => calc = const StreakCalculator());

  // ── Empty records ─────────────────────────────────────────────────────────
  group('empty records', () {
    test('returns 0/0 for empty records', () {
      final result = calc.calculate(
        records: [],
        scheduledDays: [],
        targetFrequencyPerWeek: 7,
      );
      expect(result.current, 0);
      expect(result.longest, 0);
    });
  });

  // ── Daily habit (all days scheduled) ─────────────────────────────────────
  group('daily habit — every day scheduled', () {
    test('streak of 1 for single completion today', () {
      final result = calc.calculate(
        records: [rec(d(0))],
        scheduledDays: [],
        targetFrequencyPerWeek: 7,
        asOf: d(0),
      );
      expect(result.current, 1);
      expect(result.longest, 1);
    });

    test('streak of 3 for 3 consecutive days', () {
      final result = calc.calculate(
        records: [rec(d(2)), rec(d(1)), rec(d(0))],
        scheduledDays: [],
        targetFrequencyPerWeek: 7,
        asOf: d(0),
      );
      expect(result.current, 3);
      expect(result.longest, 3);
    });

    test('streak resets after a missed day', () {
      // Completed days 4,3,2 ago then missed yesterday — streak = 0
      final result = calc.calculate(
        records: [rec(d(4)), rec(d(3)), rec(d(2))],
        scheduledDays: [],
        targetFrequencyPerWeek: 7,
        asOf: d(0),
      );
      expect(result.current, 0);
      expect(result.longest, 3);
    });

    test('streak not broken by missing today (still time)', () {
      // Completed 3 days ago, 2 ago, yesterday — today not yet done
      final result = calc.calculate(
        records: [rec(d(3)), rec(d(2)), rec(d(1))],
        scheduledDays: [],
        targetFrequencyPerWeek: 7,
        asOf: d(0),
      );
      expect(result.current, 3);
    });

    test('longest streak tracked correctly across multiple runs', () {
      // Run of 5, then miss, then run of 2
      final records = [
        rec(d(10)),
        rec(d(9)),
        rec(d(8)),
        rec(d(7)),
        rec(d(6)),
        // gap at d(5) — miss
        rec(d(4)),
        rec(d(3)),
        rec(d(2)),
        rec(d(1)),
        rec(d(0)),
      ];
      final result = calc.calculate(
        records: records,
        scheduledDays: [],
        targetFrequencyPerWeek: 7,
        asOf: d(0),
      );
      expect(result.longest, 5);
      expect(result.current, 5);
    });

    test('streak of 0 when only old completions', () {
      // Completed 10 and 9 days ago, then long gap
      final result = calc.calculate(
        records: [rec(d(10)), rec(d(9))],
        scheduledDays: [],
        targetFrequencyPerWeek: 7,
        asOf: d(0),
      );
      expect(result.current, 0);
      expect(result.longest, 2);
    });
  });

  // ── Excused days ──────────────────────────────────────────────────────────
  group('excused days — streak preservation', () {
    test('excused day does not break streak', () {
      final result = calc.calculate(
        records: [
          rec(d(3)),
          rec(d(2)),
          rec(d(1), excused: true, completed: false),
          rec(d(0)),
        ],
        scheduledDays: [],
        targetFrequencyPerWeek: 7,
        asOf: d(0),
      );
      // Streak should continue through the excused day
      expect(result.current, greaterThanOrEqualTo(3));
    });

    test('excused day does not advance streak', () {
      // Only excused days — no actual completions
      final result = calc.calculate(
        records: [
          rec(d(2), excused: true, completed: false),
          rec(d(1), excused: true, completed: false),
        ],
        scheduledDays: [],
        targetFrequencyPerWeek: 7,
        asOf: d(0),
      );
      expect(result.current, 0);
    });

    test('multiple consecutive excused days are transparent', () {
      final result = calc.calculate(
        records: [
          rec(d(5)),
          rec(d(4), excused: true, completed: false),
          rec(d(3), excused: true, completed: false),
          rec(d(2), excused: true, completed: false),
          rec(d(1)),
          rec(d(0)),
        ],
        scheduledDays: [],
        targetFrequencyPerWeek: 7,
        asOf: d(0),
      );
      expect(result.current, greaterThanOrEqualTo(3));
    });
  });

  // ── Scheduled days (not every day) ───────────────────────────────────────
  group('scheduled days subset', () {
    // Mon=0, Wed=2, Fri=4
    const mwf = [0, 2, 4];

    test('missing a non-scheduled day does not break streak', () {
      // If Monday was done but Tuesday isn't scheduled, no break
      final monday = _getLastWeekday(DateTime.monday);
      final result = calc.calculate(
        records: [rec(monday)],
        scheduledDays: mwf,
        targetFrequencyPerWeek: 3,
        asOf: monday,
      );
      expect(result.current, 1);
    });

    test('streak counts only scheduled days', () {
      final mon = _getLastWeekday(DateTime.monday);
      final wed = mon.add(const Duration(days: 2));
      final fri = mon.add(const Duration(days: 4));

      final result = calc.calculate(
        records: [rec(mon), rec(wed), rec(fri)],
        scheduledDays: mwf,
        targetFrequencyPerWeek: 3,
        asOf: fri,
      );
      expect(result.current, 3);
    });

    test('missing a scheduled day breaks streak', () {
      final mon = _getLastWeekday(DateTime.monday);
      // Wednesday was missed
      final fri = mon.add(const Duration(days: 4));

      final result = calc.calculate(
        records: [rec(mon), rec(fri)],
        scheduledDays: mwf,
        targetFrequencyPerWeek: 3,
        asOf: fri,
      );
      expect(result.current, 1); // only Friday counts
      expect(result.longest, greaterThanOrEqualTo(1));
    });
  });

  // ── Heat map ──────────────────────────────────────────────────────────────
  group('buildRecentHeatMap', () {
    test('returns 7 items for 7-day lookback', () {
      final heatMap = calc.buildRecentHeatMap(
        records: [],
        scheduledDays: [],
      );
      expect(heatMap.length, 7);
    });

    test('today with no record = pending', () {
      final heatMap = calc.buildRecentHeatMap(
        records: [],
        scheduledDays: [],
      );
      final todayStatus = heatMap.last;
      expect(todayStatus.status, DayStatusType.pending);
    });

    test('past day with no record = missed', () {
      final heatMap = calc.buildRecentHeatMap(
        records: [],
        scheduledDays: [],
      );
      // Second-to-last is yesterday
      expect(heatMap[heatMap.length - 2].status, DayStatusType.missed);
    });

    test('completed day shows completed status', () {
      final yesterday = d(1);
      final heatMap = calc.buildRecentHeatMap(
        records: [rec(yesterday)],
        scheduledDays: [],
      );
      final yesterdayStatus = heatMap[heatMap.length - 2];
      expect(yesterdayStatus.status, DayStatusType.completed);
    });

    test('excused day shows excused status', () {
      final yesterday = d(1);
      final heatMap = calc.buildRecentHeatMap(
        records: [rec(yesterday, excused: true, completed: false)],
        scheduledDays: [],
      );
      final yesterdayStatus = heatMap[heatMap.length - 2];
      expect(yesterdayStatus.status, DayStatusType.excused);
    });

    test('not-scheduled day shows notScheduled status', () {
      // Schedule only Monday; check a non-Monday day
      final heatMap = calc.buildRecentHeatMap(
        records: [],
        scheduledDays: [DateTime.monday - 1], // 0=Mon
        lookbackDays: 7,
      );
      // Find Tuesday in results
      final tuesdayStatus =
          heatMap.firstWhere((s) => s.date.weekday == DateTime.tuesday,
              orElse: () => heatMap.first);
      if (tuesdayStatus.date.weekday == DateTime.tuesday) {
        expect(tuesdayStatus.status, DayStatusType.notScheduled);
      }
    });
  });

  // ── Weekly spiritual score ────────────────────────────────────────────────
  group('calculateWeeklyScore', () {
    final weekStart = _getLastWeekday(DateTime.monday);

    test('perfect prayer attendance = 100 prayer score', () {
      // 5 prayers × 7 days = 35
      final prayerRecords = List.generate(
        35,
        (i) => StreakRecord(
          id: 'pr_$i',
          habitId: 'prayer',
          date: weekStart.add(Duration(days: i ~/ 5)),
          completed: true,
        ),
      );
      final score = calc.calculateWeeklyScore(
        weekStart: weekStart,
        prayerRecords: prayerRecords,
        quranRecords: [],
        habitRecords: [],
        habitTargetCount: 0,
        gymRecords: [],
        gymTargetCount: 0,
      );
      expect(score.prayerScore, 100);
    });

    test('zero completions = 0 score', () {
      final score = calc.calculateWeeklyScore(
        weekStart: weekStart,
        prayerRecords: [],
        quranRecords: [],
        habitRecords: [],
        habitTargetCount: 7,
        gymRecords: [],
        gymTargetCount: 3,
      );
      expect(score.prayerScore, 0);
      expect(score.quranScore, 0);
    });

    test('total score is weighted correctly', () {
      // 50% prayers + 20% quran + 20% habits + 10% gym
      // All at 80 → total = 80
      final score = WeeklySpiritualScore(
        weekStart: weekStart,
        prayerScore: 80,
        quranScore: 80,
        habitsScore: 80,
        gymScore: 80,
      );
      expect(score.totalScore, 80);
    });

    test('grade reflects total score correctly', () {
      expect(
          WeeklySpiritualScore(
            weekStart: weekStart,
            prayerScore: 95,
            quranScore: 95,
            habitsScore: 95,
            gymScore: 95,
          ).grade,
          contains('Excellent'));

      expect(
          WeeklySpiritualScore(
            weekStart: weekStart,
            prayerScore: 30,
            quranScore: 20,
            habitsScore: 30,
            gymScore: 20,
          ).grade,
          contains('Keep going'));
    });

    test('total score is clamped to 0–100', () {
      final score = WeeklySpiritualScore(
        weekStart: weekStart,
        prayerScore: 100,
        quranScore: 100,
        habitsScore: 100,
        gymScore: 100,
      );
      expect(score.totalScore, lessThanOrEqualTo(100));
      expect(score.totalScore, greaterThanOrEqualTo(0));
    });
  });

  // ── wouldSetNewRecord ─────────────────────────────────────────────────────
  group('wouldSetNewRecord', () {
    test('returns true when current streak + 1 > longest', () {
      expect(calc.wouldSetNewRecord(currentStreak: 9, longestStreak: 9),
          isTrue);
    });

    test('returns false when current + 1 <= longest', () {
      expect(calc.wouldSetNewRecord(currentStreak: 5, longestStreak: 10),
          isFalse);
    });
  });

  // ── Habit entity helpers ──────────────────────────────────────────────────
  group('Habit entity', () {
    final habit = Habit(
      id: 'h1',
      name: 'Quran',
      emoji: '📖',
      category: HabitCategory.spiritual,
      targetFrequencyPerWeek: 7,
      createdAt: DateTime.now(),
    );

    test('wasCompletedToday is false when lastCompletedDate is null', () {
      expect(habit.wasCompletedToday, isFalse);
    });

    test('wasCompletedToday is true when lastCompletedDate is today', () {
      final today = DateTime.now();
      final h = habit.copyWith(lastCompletedDate: today);
      expect(h.wasCompletedToday, isTrue);
    });

    test('weekProgressLabel formats correctly', () {
      expect(habit.weekProgressLabel(3), '3 / 7 this week');
    });
  });
}

// ─── HELPERS ─────────────────────────────────────────────────────────────────
/// Returns the most recent occurrence of [weekday] (1=Mon … 7=Sun)
/// at or before today.
DateTime _getLastWeekday(int weekday) {
  final today = DateTime.now();
  final todayOnly = DateTime(today.year, today.month, today.day);
  var offset = (todayOnly.weekday - weekday) % 7;
  return todayOnly.subtract(Duration(days: offset));
}
