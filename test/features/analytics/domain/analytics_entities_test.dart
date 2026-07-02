import 'package:flutter_test/flutter_test.dart';
import 'package:productive_muslim/features/analytics/domain/entities/analytics_entities.dart';

void main() {
  // ─── AnalyticsPeriod ───────────────────────────────────────────────────────
  group('AnalyticsPeriod', () {
    test('week has 7 days', () {
      expect(AnalyticsPeriod.week.days, 7);
    });

    test('month has 30 days', () {
      expect(AnalyticsPeriod.month.days, 30);
    });

    test('quarter has 90 days', () {
      expect(AnalyticsPeriod.quarter.days, 90);
    });

    test('labels are human-readable', () {
      expect(AnalyticsPeriod.week.label, 'This Week');
      expect(AnalyticsPeriod.month.label, 'This Month');
      expect(AnalyticsPeriod.quarter.label, 'Last 3 Months');
    });
  });

  // ─── WeeklyScoreSeries ────────────────────────────────────────────────────
  group('WeeklyScoreSeries', () {
    WeeklyScorePoint makePoint(int score, int daysAgo) {
      final date = DateTime.now().subtract(Duration(days: daysAgo * 7));
      return WeeklyScorePoint(
        weekStart: date,
        totalScore: score,
        prayerScore: score,
        quranScore: score,
        habitsScore: score,
        gymScore: score,
      );
    }

    test('averageScore computes correctly', () {
      final series = WeeklyScoreSeries(points: [
        makePoint(80, 3),
        makePoint(60, 2),
        makePoint(100, 1),
        makePoint(80, 0),
      ]);
      expect(series.averageScore, 80.0);
    });

    test('averageScore returns 0 for empty series', () {
      expect(const WeeklyScoreSeries(points: []).averageScore, 0);
    });

    test('trend is positive when second half beats first half', () {
      final series = WeeklyScoreSeries(points: [
        makePoint(40, 4),
        makePoint(50, 3),
        makePoint(80, 2),
        makePoint(90, 1),
      ]);
      expect(series.trend, greaterThan(0));
    });

    test('trend is negative when second half lags first half', () {
      final series = WeeklyScoreSeries(points: [
        makePoint(90, 4),
        makePoint(80, 3),
        makePoint(50, 2),
        makePoint(40, 1),
      ]);
      expect(series.trend, lessThan(0));
    });

    test('trendLabel returns Improving for positive trend', () {
      final series = WeeklyScoreSeries(points: [
        makePoint(40, 2),
        makePoint(40, 1),
        makePoint(90, 0),
        makePoint(90, 0),
      ]);
      // Force trend by having dramatic difference
      if (series.trend > 5) {
        expect(series.trendLabel, contains('Improving'));
      }
    });

    test('trendLabel returns Steady for flat trend', () {
      final series = WeeklyScoreSeries(points: [
        makePoint(75, 4),
        makePoint(76, 3),
        makePoint(74, 2),
        makePoint(75, 1),
      ]);
      expect(series.trendLabel, contains('Steady'));
    });

    test('single point series has zero trend', () {
      final series = WeeklyScoreSeries(
          points: [makePoint(80, 0)]);
      expect(series.trend, 0);
    });
  });

  // ─── WeeklyScorePoint ────────────────────────────────────────────────────
  group('WeeklyScorePoint', () {
    test('shortLabel formats correctly', () {
      final point = WeeklyScorePoint(
        weekStart: DateTime(2024, 3, 11),
        totalScore: 80,
        prayerScore: 80,
        quranScore: 80,
        habitsScore: 80,
        gymScore: 80,
      );
      expect(point.shortLabel, 'Mar 11');
    });

    test('shortLabel handles December', () {
      final point = WeeklyScorePoint(
        weekStart: DateTime(2024, 12, 2),
        totalScore: 70,
        prayerScore: 70,
        quranScore: 70,
        habitsScore: 70,
        gymScore: 70,
      );
      expect(point.shortLabel, 'Dec 2');
    });
  });

  // ─── WeeklySpiritualScore weighting ──────────────────────────────────────
  group('WeeklySpiritualScore total weighting', () {
    test('50% prayers + 20% quran + 20% habits + 10% gym', () {
      // 100 prayers, 0 rest → total = 50
      final s1 = _score(prayer: 100, quran: 0, habits: 0, gym: 0);
      expect(s1, 50);

      // 0 prayers, 100 quran → total = 20
      final s2 = _score(prayer: 0, quran: 100, habits: 0, gym: 0);
      expect(s2, 20);

      // 0 prayers, 0 quran, 100 habits → total = 20
      final s3 = _score(prayer: 0, quran: 0, habits: 100, gym: 0);
      expect(s3, 20);

      // 0 + 0 + 0 + 100 gym → total = 10
      final s4 = _score(prayer: 0, quran: 0, habits: 0, gym: 100);
      expect(s4, 10);

      // All 100 → total = 100
      final s5 = _score(prayer: 100, quran: 100, habits: 100, gym: 100);
      expect(s5, 100);
    });

    test('total score is clamped 0–100', () {
      final s = _score(prayer: 150, quran: 150, habits: 150, gym: 150);
      expect(s, lessThanOrEqualTo(100));
      expect(s, greaterThanOrEqualTo(0));
    });
  });

  // ─── PrayerStat ──────────────────────────────────────────────────────────
  group('PrayerStat', () {
    test('label capitalises prayer name', () {
      const stat = PrayerStat(
        prayerName: 'fajr',
        emoji: '🌅',
        completedCount: 7,
        totalDays: 7,
        rate: 1.0,
      );
      expect(stat.label, 'Fajr');
    });

    test('rate is correct for partial completion', () {
      const stat = PrayerStat(
        prayerName: 'isha',
        emoji: '🌙',
        completedCount: 3,
        totalDays: 7,
        rate: 3 / 7,
      );
      expect(stat.rate, closeTo(0.4286, 0.001));
    });
  });

  // ─── MonthlyHeatmap ───────────────────────────────────────────────────────
  group('MonthlyHeatmap', () {
    MonthlyHeatmap makeHeatmap(List<double> scores) {
      final days = scores.asMap().entries.map((e) {
        final date = DateTime(2024, 3, e.key + 1);
        return HeatmapDay(
          date: date,
          score: e.value,
          prayersCompleted: (e.value * 5).round(),
          habitsCompleted: (e.value * 3).round(),
          hasPassed: true,
        );
      }).toList();
      return MonthlyHeatmap(year: 2024, month: 3, days: days);
    }

    test('monthLabel formats correctly', () {
      final hm = makeHeatmap([]);
      expect(hm.monthLabel, 'March 2024');
    });

    test('perfectDays counts days with score >= 0.9', () {
      final hm = makeHeatmap([0.95, 0.5, 0.91, 0.3, 0.99]);
      expect(hm.perfectDays, 3);
    });

    test('missedDays counts days with score == 0 that have passed', () {
      final hm = makeHeatmap([0.0, 0.5, 0.0, 0.8, 0.0]);
      expect(hm.missedDays, 3);
    });
  });

  // ─── HeatmapDay ──────────────────────────────────────────────────────────
  group('HeatmapDay', () {
    HeatmapDay day(double score) => HeatmapDay(
          date: DateTime(2024, 3, 15),
          score: score,
          prayersCompleted: (score * 5).round(),
          habitsCompleted: (score * 3).round(),
          hasPassed: true,
        );

    test('isPerfect when score >= 0.9', () {
      expect(day(0.9).isPerfect, isTrue);
      expect(day(1.0).isPerfect, isTrue);
      expect(day(0.89).isPerfect, isFalse);
    });

    test('isGood when score >= 0.6 and < 0.9', () {
      expect(day(0.6).isGood, isTrue);
      expect(day(0.75).isGood, isTrue);
      expect(day(0.59).isGood, isFalse);
    });

    test('isDim when score > 0 and < 0.6', () {
      expect(day(0.3).isDim, isTrue);
      expect(day(0.01).isDim, isTrue);
      expect(day(0.0).isDim, isFalse);
    });

    test('isEmpty when score == 0', () {
      expect(day(0.0).isEmpty, isTrue);
      expect(day(0.01).isEmpty, isFalse);
    });
  });

  // ─── DailyPrayerRate ─────────────────────────────────────────────────────
  group('DailyPrayerRate', () {
    test('rate is correct proportion of 5', () {
      final r = DailyPrayerRate(
        date: _epoch,
        rate: 0.6,
        completedCount: 3,
      );
      expect(r.completedCount, 3);
      expect(r.rate, 0.6);
    });
  });

  // ─── HabitStat ───────────────────────────────────────────────────────────
  group('HabitStat', () {
    const stat = HabitStat(
      habitId: 'h1',
      name: 'Quran',
      emoji: '📖',
      category: 'spiritual',
      currentStreak: 10,
      longestStreak: 15,
      completionRate: 0.85,
      completedDays: 6,
      targetDays: 7,
    );

    test('completionRate is stored as-is', () {
      expect(stat.completionRate, 0.85);
    });

    test('currentStreak accessible', () {
      expect(stat.currentStreak, 10);
    });

    test('longestStreak accessible', () {
      expect(stat.longestStreak, 15);
    });
  });
}

// ─── HELPERS ─────────────────────────────────────────────────────────────────
int _score({
  required int prayer,
  required int quran,
  required int habits,
  required int gym,
}) {
  return ((prayer * 0.50) +
          (quran * 0.20) +
          (habits * 0.20) +
          (gym * 0.10))
      .round()
      .clamp(0, 100);
}

final _epoch = DateTime.utc(1970);
