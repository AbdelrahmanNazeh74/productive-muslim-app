import 'package:dartz/dartz.dart';
import 'package:isar/isar.dart';

import '../../../../core/errors/failures.dart';
import '../../../habits/data/models/habit_model.dart';
import '../../../habits/domain/usecases/streak_calculator.dart';
import '../../domain/entities/analytics_entities.dart';
import '../../domain/repositories/analytics_repository.dart';

class AnalyticsRepositoryImpl implements AnalyticsRepository {
  final Isar isar;
  final StreakCalculator streakCalculator;

  // Prayer names in canonical order
  static const _prayerNames = [
    ('fajr', '🌅'),
    ('dhuhr', '☀️'),
    ('asr', '🌤'),
    ('maghrib', '🌆'),
    ('isha', '🌙'),
  ];

  AnalyticsRepositoryImpl({
    required this.isar,
    required this.streakCalculator,
  });

  // ─── FULL SNAPSHOT ────────────────────────────────────────────────────────
  @override
  Future<Either<Failure, AnalyticsSnapshot>> getSnapshot(
      AnalyticsPeriod period) async {
    try {
      final now = DateTime.now();
      final to = DateTime(now.year, now.month, now.day);
      final from = to.subtract(Duration(days: period.days - 1));

      final prayerResult = await getPrayerAnalytics(from: from, to: to);
      final habitResult = await getHabitAnalytics(from: from, to: to);
      final weeklyResult = await getWeeklyScoreSeries(
        period == AnalyticsPeriod.week ? 4 : period == AnalyticsPeriod.month ? 8 : 13,
      );
      final heatmapResult = await getMonthlyHeatmap(
        year: now.year,
        month: now.month,
      );

      late PrayerAnalytics prayers;
      late HabitAnalytics habits;
      late WeeklyScoreSeries weekly;
      late MonthlyHeatmap heatmap;

      prayerResult.fold((f) => throw Exception(f.message), (r) => prayers = r);
      habitResult.fold((f) => throw Exception(f.message), (r) => habits = r);
      weeklyResult.fold((f) => throw Exception(f.message), (r) => weekly = r);
      heatmapResult.fold((f) => throw Exception(f.message), (r) => heatmap = r);

      return Right(AnalyticsSnapshot(
        period: period,
        prayers: prayers,
        habits: habits,
        weeklyScores: weekly,
        heatmap: heatmap,
        generatedAt: DateTime.now(),
      ));
    } catch (e) {
      return Left(DatabaseFailure('Failed to load analytics: $e'));
    }
  }

  // ─── PRAYER ANALYTICS ─────────────────────────────────────────────────────
  @override
  Future<Either<Failure, PrayerAnalytics>> getPrayerAnalytics({
    required DateTime from,
    required DateTime to,
  }) async {
    try {
      // Load all prayer habits
      final allHabits = await isar.habitModels
          .filter()
          .isActiveEqualTo(true)
          .findAll();

      final prayerHabits = allHabits
          .where((h) => _isPrayerHabit(h.name))
          .toList();

      // Load all streak records in the range for prayer habits
      final prayerHabitIds = prayerHabits.map((h) => h.habitId).toList();

      final allRecords = <StreakRecordModel>[];
      for (final id in prayerHabitIds) {
        final recs = await isar.streakRecordModels
            .filter()
            .habitIdEqualTo(id)
            .dateBetween(
              DateTime(from.year, from.month, from.day),
              DateTime(to.year, to.month, to.day),
            )
            .findAll();
        allRecords.addAll(recs);
      }

      final totalDays = to.difference(from).inDays + 1;

      // Per-prayer stats
      final byPrayer = <PrayerStat>[];
      for (final (name, emoji) in _prayerNames) {
        final matchingHabit = prayerHabits.firstWhere(
          (h) => h.name.toLowerCase().contains(name),
          orElse: () => prayerHabits.isNotEmpty
              ? prayerHabits.first
              : HabitModel(),
        );
        final habitRecords = allRecords
            .where((r) => r.habitId == matchingHabit.habitId && r.completed)
            .length;
        final rate = totalDays == 0 ? 0.0 : habitRecords / totalDays;
        byPrayer.add(PrayerStat(
          prayerName: name,
          emoji: emoji,
          completedCount: habitRecords,
          totalDays: totalDays,
          rate: rate.clamp(0.0, 1.0),
        ));
      }

      // Daily rates — one entry per day
      final dailyRates = <DailyPrayerRate>[];
      for (int i = 0; i < totalDays; i++) {
        final day = from.add(Duration(days: i));
        final dayOnly = DateTime(day.year, day.month, day.day);
        final dayRecords = allRecords
            .where((r) =>
                _dateOnly(r.date).isAtSameMomentAs(dayOnly) && r.completed)
            .length;
        dailyRates.add(DailyPrayerRate(
          date: dayOnly,
          rate: (dayRecords / 5).clamp(0.0, 1.0),
          completedCount: dayRecords,
        ));
      }

      final totalCompleted = allRecords.where((r) => r.completed).length;
      final maxPossible = totalDays * 5;
      final overallRate =
          maxPossible == 0 ? 0.0 : totalCompleted / maxPossible;

      final sorted = List<PrayerStat>.from(byPrayer)
        ..sort((a, b) => b.rate.compareTo(a.rate));
      final best = sorted.isNotEmpty ? sorted.first.label : 'Fajr';
      final weakest = sorted.isNotEmpty ? sorted.last.label : 'Fajr';

      return Right(PrayerAnalytics(
        periodStart: from,
        periodEnd: to,
        byPrayer: byPrayer,
        dailyRates: dailyRates,
        overallRate: overallRate.clamp(0.0, 1.0),
        bestPrayer: best,
        weakestPrayer: weakest,
      ));
    } catch (e) {
      return Left(DatabaseFailure('Failed to load prayer analytics: $e'));
    }
  }

  // ─── HABIT ANALYTICS ──────────────────────────────────────────────────────
  @override
  Future<Either<Failure, HabitAnalytics>> getHabitAnalytics({
    required DateTime from,
    required DateTime to,
  }) async {
    try {
      final allHabits = await isar.habitModels
          .filter()
          .isActiveEqualTo(true)
          .findAll();

      // Exclude prayer habits (tracked separately)
      final nonPrayerHabits =
          allHabits.where((h) => !_isPrayerHabit(h.name)).toList();

      final totalDays = to.difference(from).inDays + 1;
      final fromOnly = DateTime(from.year, from.month, from.day);
      final toOnly = DateTime(to.year, to.month, to.day);

      // Load all records for non-prayer habits
      final Map<String, List<StreakRecordModel>> recordsByHabit = {};
      for (final h in nonPrayerHabits) {
        final recs = await isar.streakRecordModels
            .filter()
            .habitIdEqualTo(h.habitId)
            .dateBetween(fromOnly, toOnly)
            .findAll();
        recordsByHabit[h.habitId] = recs;
      }

      // Per-habit stats
      final habitStats = nonPrayerHabits.map((h) {
        final records = recordsByHabit[h.habitId] ?? [];
        final completed = records.where((r) => r.completed).length;
        // Target = frequency × (totalDays / 7) roughly
        final target =
            (h.targetFrequencyPerWeek * totalDays / 7).ceil();
        final rate = target == 0 ? 0.0 : completed / target;
        return HabitStat(
          habitId: h.habitId,
          name: h.name,
          emoji: h.emoji,
          category: h.category,
          currentStreak: h.currentStreak,
          longestStreak: h.longestStreak,
          completionRate: rate.clamp(0.0, 1.0),
          completedDays: completed,
          targetDays: target,
        );
      }).toList();

      // Daily aggregated rates
      final dailyRates = <DailyHabitRate>[];
      for (int i = 0; i < totalDays; i++) {
        final day = from.add(Duration(days: i));
        final dayOnly = DateTime(day.year, day.month, day.day);

        int completed = 0;
        int total = 0;
        for (final h in nonPrayerHabits) {
          final weekdayIdx = dayOnly.weekday - 1;
          final isScheduled = h.scheduledDays.isEmpty ||
              h.scheduledDays.contains(weekdayIdx);
          if (!isScheduled) continue;

          total++;
          final records = recordsByHabit[h.habitId] ?? [];
          final dayRecord = records.firstWhere(
            (r) => _dateOnly(r.date).isAtSameMomentAs(dayOnly),
            orElse: () => StreakRecordModel()
              ..completed = false
              ..excused = false,
          );
          if (dayRecord.completed) completed++;
        }

        dailyRates.add(DailyHabitRate(
          date: dayOnly,
          rate: total == 0 ? 0.0 : (completed / total).clamp(0.0, 1.0),
          completed: completed,
          total: total,
        ));
      }

      final allCompleted = dailyRates.fold(0, (s, d) => s + d.completed);
      final allTotal = dailyRates.fold(0, (s, d) => s + d.total);
      final overallRate =
          allTotal == 0 ? 0.0 : allCompleted / allTotal;

      final totalStreakDays = nonPrayerHabits.fold(
          0, (s, h) => s + h.currentStreak);

      return Right(HabitAnalytics(
        periodStart: from,
        periodEnd: to,
        dailyRates: dailyRates,
        habitStats: habitStats,
        overallRate: overallRate.clamp(0.0, 1.0),
        totalStreakDays: totalStreakDays,
      ));
    } catch (e) {
      return Left(DatabaseFailure('Failed to load habit analytics: $e'));
    }
  }

  // ─── WEEKLY SCORE SERIES ──────────────────────────────────────────────────
  @override
  Future<Either<Failure, WeeklyScoreSeries>> getWeeklyScoreSeries(
      int weeks) async {
    try {
      final now = DateTime.now();
      final points = <WeeklyScorePoint>[];

      for (int w = weeks - 1; w >= 0; w--) {
        final weekStart = _mondayOf(
            now.subtract(Duration(days: w * 7)));
        final weekEnd = weekStart.add(const Duration(days: 6));

        // Load prayer records for this week
        final allHabits = await isar.habitModels
            .filter()
            .isActiveEqualTo(true)
            .findAll();

        int prayerCompleted = 0;
        int quranCompleted = 0;
        int gymCompleted = 0;
        int otherCompleted = 0;
        int otherTarget = 0;
        int gymTarget = 0;

        for (final h in allHabits) {
          final recs = await isar.streakRecordModels
              .filter()
              .habitIdEqualTo(h.habitId)
              .dateBetween(weekStart, weekEnd)
              .findAll();

          final completed = recs.where((r) => r.completed).length;

          if (_isPrayerHabit(h.name)) {
            prayerCompleted += completed;
          } else if (h.name.contains('Quran')) {
            quranCompleted += completed;
          } else if (h.category == 'fitness') {
            gymCompleted += completed;
            gymTarget += h.targetFrequencyPerWeek;
          } else {
            otherCompleted += completed;
            otherTarget += h.targetFrequencyPerWeek;
          }
        }

        final prayerScore =
            ((prayerCompleted / 35) * 100).round().clamp(0, 100);
        final quranScore =
            ((quranCompleted / 7) * 100).round().clamp(0, 100);
        final habitsScore = otherTarget == 0
            ? 100
            : ((otherCompleted / otherTarget) * 100).round().clamp(0, 100);
        final gymScore = gymTarget == 0
            ? 100
            : ((gymCompleted / gymTarget) * 100).round().clamp(0, 100);

        final total = ((prayerScore * 0.50) +
                (quranScore * 0.20) +
                (habitsScore * 0.20) +
                (gymScore * 0.10))
            .round()
            .clamp(0, 100);

        points.add(WeeklyScorePoint(
          weekStart: weekStart,
          totalScore: total,
          prayerScore: prayerScore,
          quranScore: quranScore,
          habitsScore: habitsScore,
          gymScore: gymScore,
        ));
      }

      return Right(WeeklyScoreSeries(points: points));
    } catch (e) {
      return Left(DatabaseFailure('Failed to load weekly scores: $e'));
    }
  }

  // ─── MONTHLY HEATMAP ──────────────────────────────────────────────────────
  @override
  Future<Either<Failure, MonthlyHeatmap>> getMonthlyHeatmap({
    required int year,
    required int month,
  }) async {
    try {
      final daysInMonth = DateTime(year, month + 1, 0).day;
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);

      final allHabits = await isar.habitModels
          .filter()
          .isActiveEqualTo(true)
          .findAll();

      final monthStart = DateTime(year, month, 1);
      final monthEnd = DateTime(year, month, daysInMonth);

      // Load all records for the month
      final allRecords = <StreakRecordModel>[];
      for (final h in allHabits) {
        final recs = await isar.streakRecordModels
            .filter()
            .habitIdEqualTo(h.habitId)
            .dateBetween(monthStart, monthEnd)
            .findAll();
        allRecords.addAll(recs);
      }

      final days = <HeatmapDay>[];
      for (int d = 1; d <= daysInMonth; d++) {
        final date = DateTime(year, month, d);
        final dateOnly = DateTime(year, month, d);
        final hasPassed = !dateOnly.isAfter(today);

        final dayRecs = allRecords
            .where((r) => _dateOnly(r.date).isAtSameMomentAs(dateOnly))
            .toList();

        final prayerCompleted = dayRecs
            .where((r) =>
                r.completed &&
                allHabits.any((h) =>
                    h.habitId == r.habitId && _isPrayerHabit(h.name)))
            .length;

        final habitCompleted = dayRecs
            .where((r) =>
                r.completed &&
                allHabits.any((h) =>
                    h.habitId == r.habitId && !_isPrayerHabit(h.name)))
            .length;

        // Score: 50% prayers (max 5), 50% habits (max from habit count)
        final prayerScore = (prayerCompleted / 5).clamp(0.0, 1.0);
        final habitDenominator = allHabits
            .where((h) => !_isPrayerHabit(h.name))
            .length;
        final habitScore = habitDenominator == 0
            ? 1.0
            : (habitCompleted / habitDenominator).clamp(0.0, 1.0);
        final compositeScore =
            (prayerScore * 0.6 + habitScore * 0.4).clamp(0.0, 1.0);

        days.add(HeatmapDay(
          date: date,
          score: hasPassed ? compositeScore : 0.0,
          prayersCompleted: prayerCompleted,
          habitsCompleted: habitCompleted,
          hasPassed: hasPassed,
        ));
      }

      return Right(MonthlyHeatmap(
        year: year,
        month: month,
        days: days,
      ));
    } catch (e) {
      return Left(DatabaseFailure('Failed to load monthly heatmap: $e'));
    }
  }

  // ─── HELPERS ──────────────────────────────────────────────────────────────
  bool _isPrayerHabit(String name) =>
      name.toLowerCase().contains('prayer') ||
      name.toLowerCase().contains('salah') ||
      name.toLowerCase().contains('namaz');

  DateTime _dateOnly(DateTime dt) =>
      DateTime(dt.year, dt.month, dt.day);

  DateTime _mondayOf(DateTime date) {
    final d = DateTime(date.year, date.month, date.day);
    return d.subtract(Duration(days: d.weekday - 1));
  }
}
