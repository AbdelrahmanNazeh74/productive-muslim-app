import 'package:equatable/equatable.dart';

// ─── TIME RANGE ───────────────────────────────────────────────────────────────
enum AnalyticsPeriod { week, month, quarter }

extension AnalyticsPeriodX on AnalyticsPeriod {
  String get label {
    switch (this) {
      case AnalyticsPeriod.week:    return 'This Week';
      case AnalyticsPeriod.month:   return 'This Month';
      case AnalyticsPeriod.quarter: return 'Last 3 Months';
    }
  }

  int get days {
    switch (this) {
      case AnalyticsPeriod.week:    return 7;
      case AnalyticsPeriod.month:   return 30;
      case AnalyticsPeriod.quarter: return 90;
    }
  }
}

// ─── PRAYER ANALYTICS ────────────────────────────────────────────────────────
/// Prayer on-time rate per prayer per day, aggregated over a period.
class PrayerAnalytics extends Equatable {
  final DateTime periodStart;
  final DateTime periodEnd;

  /// 5 entries — one per prayer name (fajr, dhuhr, asr, maghrib, isha)
  final List<PrayerStat> byPrayer;

  /// Daily completion rate for all 5 prayers (0.0–1.0), ordered oldest→newest
  final List<DailyPrayerRate> dailyRates;

  /// Overall on-time rate for the period (0.0–1.0)
  final double overallRate;

  /// Best prayer (highest on-time rate)
  final String bestPrayer;

  /// Prayer most frequently missed
  final String weakestPrayer;

  const PrayerAnalytics({
    required this.periodStart,
    required this.periodEnd,
    required this.byPrayer,
    required this.dailyRates,
    required this.overallRate,
    required this.bestPrayer,
    required this.weakestPrayer,
  });

  @override
  List<Object?> get props =>
      [periodStart, periodEnd, overallRate, byPrayer];
}

class PrayerStat extends Equatable {
  final String prayerName; // 'fajr' | 'dhuhr' | 'asr' | 'maghrib' | 'isha'
  final String emoji;
  final int completedCount;
  final int totalDays;
  final double rate; // 0.0–1.0

  const PrayerStat({
    required this.prayerName,
    required this.emoji,
    required this.completedCount,
    required this.totalDays,
    required this.rate,
  });

  String get label => prayerName[0].toUpperCase() + prayerName.substring(1);

  @override
  List<Object?> get props => [prayerName, completedCount, totalDays];
}

class DailyPrayerRate extends Equatable {
  final DateTime date;
  final double rate; // 0.0–1.0 (completed / 5)
  final int completedCount;

  const DailyPrayerRate({
    required this.date,
    required this.rate,
    required this.completedCount,
  });

  @override
  List<Object?> get props => [date, rate];
}

// ─── HABIT ANALYTICS ─────────────────────────────────────────────────────────
class HabitAnalytics extends Equatable {
  final DateTime periodStart;
  final DateTime periodEnd;

  /// Completion rate per day (0.0–1.0), ordered oldest→newest
  final List<DailyHabitRate> dailyRates;

  /// Per-habit breakdown
  final List<HabitStat> habitStats;

  /// Overall completion rate for the period
  final double overallRate;

  /// Total active streak days across all habits
  final int totalStreakDays;

  const HabitAnalytics({
    required this.periodStart,
    required this.periodEnd,
    required this.dailyRates,
    required this.habitStats,
    required this.overallRate,
    required this.totalStreakDays,
  });

  @override
  List<Object?> get props =>
      [periodStart, periodEnd, overallRate, habitStats];
}

class DailyHabitRate extends Equatable {
  final DateTime date;
  final double rate;
  final int completed;
  final int total;

  const DailyHabitRate({
    required this.date,
    required this.rate,
    required this.completed,
    required this.total,
  });

  @override
  List<Object?> get props => [date, rate];
}

class HabitStat extends Equatable {
  final String habitId;
  final String name;
  final String emoji;
  final String category;
  final int currentStreak;
  final int longestStreak;
  final double completionRate; // over the period
  final int completedDays;
  final int targetDays;

  const HabitStat({
    required this.habitId,
    required this.name,
    required this.emoji,
    required this.category,
    required this.currentStreak,
    required this.longestStreak,
    required this.completionRate,
    required this.completedDays,
    required this.targetDays,
  });

  @override
  List<Object?> get props => [habitId, completionRate, currentStreak];
}

// ─── WEEKLY SCORE SERIES ──────────────────────────────────────────────────────
/// Multiple weeks of spiritual scores for a trend line.
class WeeklyScoreSeries extends Equatable {
  final List<WeeklyScorePoint> points; // ordered oldest→newest

  const WeeklyScoreSeries({required this.points});

  double get averageScore => points.isEmpty
      ? 0
      : points.map((p) => p.totalScore).reduce((a, b) => a + b) /
          points.length;

  double get trend {
    // Slope of last 4 weeks vs first 4 weeks
    if (points.length < 2) return 0;
    final half = points.length ~/ 2;
    final firstHalf = points.take(half).map((p) => p.totalScore);
    final secondHalf = points.skip(half).map((p) => p.totalScore);
    final firstAvg =
        firstHalf.reduce((a, b) => a + b) / firstHalf.length;
    final secondAvg =
        secondHalf.reduce((a, b) => a + b) / secondHalf.length;
    return secondAvg - firstAvg;
  }

  String get trendLabel {
    final t = trend;
    if (t > 5) return '📈 Improving';
    if (t < -5) return '📉 Declining';
    return '➡️ Steady';
  }

  @override
  List<Object?> get props => [points];
}

class WeeklyScorePoint extends Equatable {
  final DateTime weekStart;
  final int totalScore;
  final int prayerScore;
  final int quranScore;
  final int habitsScore;
  final int gymScore;

  const WeeklyScorePoint({
    required this.weekStart,
    required this.totalScore,
    required this.prayerScore,
    required this.quranScore,
    required this.habitsScore,
    required this.gymScore,
  });

  String get shortLabel {
    final d = weekStart;
    return '${_months[d.month - 1]} ${d.day}';
  }

  static const _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  @override
  List<Object?> get props => [weekStart, totalScore];
}

// ─── MONTHLY HEATMAP ─────────────────────────────────────────────────────────
/// 30-day calendar of completion scores — used for the heatmap.
class MonthlyHeatmap extends Equatable {
  final int year;
  final int month;
  final List<HeatmapDay> days; // 1–31, only days in the month

  const MonthlyHeatmap({
    required this.year,
    required this.month,
    required this.days,
  });

  String get monthLabel {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December',
    ];
    return '${months[month - 1]} $year';
  }

  int get perfectDays =>
      days.where((d) => d.score >= 0.9).length;

  int get missedDays =>
      days.where((d) => d.score == 0 && d.hasPassed).length;

  @override
  List<Object?> get props => [year, month, days];
}

class HeatmapDay extends Equatable {
  final DateTime date;
  final double score; // 0.0–1.0 composite of prayers + habits
  final int prayersCompleted;
  final int habitsCompleted;
  final bool hasPassed;

  const HeatmapDay({
    required this.date,
    required this.score,
    required this.prayersCompleted,
    required this.habitsCompleted,
    required this.hasPassed,
  });

  bool get isPerfect => score >= 0.9;
  bool get isGood => score >= 0.6;
  bool get isDim => score > 0 && score < 0.6;
  bool get isEmpty => score == 0;

  @override
  List<Object?> get props => [date, score];
}

// ─── FULL ANALYTICS SNAPSHOT ─────────────────────────────────────────────────
/// Everything needed to render the analytics dashboard — loaded once.
class AnalyticsSnapshot extends Equatable {
  final AnalyticsPeriod period;
  final PrayerAnalytics prayers;
  final HabitAnalytics habits;
  final WeeklyScoreSeries weeklyScores;
  final MonthlyHeatmap heatmap;
  final DateTime generatedAt;

  const AnalyticsSnapshot({
    required this.period,
    required this.prayers,
    required this.habits,
    required this.weeklyScores,
    required this.heatmap,
    required this.generatedAt,
  });

  @override
  List<Object?> get props => [period, generatedAt];
}
