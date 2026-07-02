import 'package:flutter_test/flutter_test.dart';
import 'package:productive_muslim/features/habits/domain/usecases/streak_calculator.dart';

void main() {
  const calc = StreakCalculator();
  final today = DateTime.now();

  DateTime d(int daysAgo) =>
      DateTime(today.year, today.month, today.day - daysAgo);

  StreakRecord excused(int daysAgo) => StreakRecord(
        id: 'r$daysAgo',
        habitId: 'h',
        date: d(daysAgo),
        completed: false,
        excused: true,
      );

  StreakRecord completed(int daysAgo) => StreakRecord(
        id: 'r$daysAgo',
        habitId: 'h',
        date: d(daysAgo),
        completed: true,
      );

  // ── remainingThisWeek ──────────────────────────────────────────────────────

  group('StreakCalculator.remainingThisWeek', () {
    test('0 completed, target 7 → 7 remaining', () {
      expect(
          calc.remainingThisWeek(completedThisWeek: 0, targetFrequencyPerWeek: 7),
          7);
    });

    test('3 completed, target 5 → 2 remaining', () {
      expect(
          calc.remainingThisWeek(completedThisWeek: 3, targetFrequencyPerWeek: 5),
          2);
    });

    test('5 completed, target 5 → 0 remaining', () {
      expect(
          calc.remainingThisWeek(completedThisWeek: 5, targetFrequencyPerWeek: 5),
          0);
    });

    test('7 completed, target 7 → 0 remaining', () {
      expect(
          calc.remainingThisWeek(completedThisWeek: 7, targetFrequencyPerWeek: 7),
          0);
    });

    test('completed > target → clamped to 0, never negative', () {
      expect(
          calc.remainingThisWeek(completedThisWeek: 8, targetFrequencyPerWeek: 5),
          0);
    });

    test('target exceeds 7 → clamped to 7', () {
      expect(
          calc.remainingThisWeek(completedThisWeek: 0, targetFrequencyPerWeek: 10),
          7);
    });

    test('1 completed, target 3 → 2 remaining', () {
      expect(
          calc.remainingThisWeek(completedThisWeek: 1, targetFrequencyPerWeek: 3),
          2);
    });
  });

  // ── all-excused records → streak 0 ────────────────────────────────────────

  group('StreakCalculator.calculate — all-excused records', () {
    test('all excused days → current streak is 0', () {
      final records = [excused(3), excused(2), excused(1)];
      final result = calc.calculate(
        records: records,
        scheduledDays: const [],
        targetFrequencyPerWeek: 7,
        asOf: today,
      );
      expect(result.current, 0);
    });

    test('all excused days → longest streak is 0', () {
      final records = [excused(5), excused(4), excused(3)];
      final result = calc.calculate(
        records: records,
        scheduledDays: const [],
        targetFrequencyPerWeek: 7,
        asOf: today,
      );
      expect(result.longest, 0);
    });

    test('mixed excused + one completion → streak is 1', () {
      final records = [excused(3), completed(2), excused(1)];
      final result = calc.calculate(
        records: records,
        scheduledDays: const [],
        targetFrequencyPerWeek: 7,
        asOf: today,
      );
      // excused(1) is transparent so streak from completed(2) survives
      expect(result.current, greaterThanOrEqualTo(1));
    });
  });

  // ── buildRecentHeatMap — empty scheduledDays ──────────────────────────────

  group('StreakCalculator.buildRecentHeatMap — empty scheduledDays', () {
    test('empty scheduledDays treats every day as scheduled', () {
      final records = [completed(0)]; // today completed
      final heatmap = calc.buildRecentHeatMap(
        records: records,
        scheduledDays: const [],
      );
      // No days should be notScheduled
      expect(
          heatmap.any((d) => d.status == DayStatusType.notScheduled), isFalse);
    });

    test('returns 7 entries regardless of empty scheduledDays', () {
      final heatmap = calc.buildRecentHeatMap(
        records: const [],
        scheduledDays: const [],
      );
      expect(heatmap.length, 7);
    });
  });

  // ── buildRecentHeatMap — heatmap dates are never in the future ────────────

  group('StreakCalculator.buildRecentHeatMap — date bounds', () {
    test('all heatmap dates are today or in the past', () {
      final heatmap = calc.buildRecentHeatMap(
        records: const [],
        scheduledDays: const [],
      );
      final todayDate = DateTime(today.year, today.month, today.day);
      for (final day in heatmap) {
        expect(
            day.date.isAfter(todayDate), isFalse,
            reason: 'Heatmap must not include future dates');
      }
    });

    test('most recent entry in heatmap is today', () {
      final heatmap = calc.buildRecentHeatMap(
        records: const [],
        scheduledDays: const [],
      );
      final todayDate = DateTime(today.year, today.month, today.day);
      expect(heatmap.last.date, todayDate);
    });
  });
}
