import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/analytics_entities.dart';

abstract class AnalyticsRepository {
  /// Full snapshot for the dashboard — single call, everything loaded.
  Future<Either<Failure, AnalyticsSnapshot>> getSnapshot(
      AnalyticsPeriod period);

  /// Prayer analytics for a date range.
  Future<Either<Failure, PrayerAnalytics>> getPrayerAnalytics({
    required DateTime from,
    required DateTime to,
  });

  /// Habit analytics for a date range.
  Future<Either<Failure, HabitAnalytics>> getHabitAnalytics({
    required DateTime from,
    required DateTime to,
  });

  /// Weekly score series for the last [weeks] weeks.
  Future<Either<Failure, WeeklyScoreSeries>> getWeeklyScoreSeries(
      int weeks);

  /// Monthly heatmap for [year]/[month].
  Future<Either<Failure, MonthlyHeatmap>> getMonthlyHeatmap({
    required int year,
    required int month,
  });
}
