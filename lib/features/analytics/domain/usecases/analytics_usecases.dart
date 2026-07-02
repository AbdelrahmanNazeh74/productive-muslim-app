import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/analytics_entities.dart';
import '../repositories/analytics_repository.dart';

// ─── GET FULL SNAPSHOT ───────────────────────────────────────────────────────
class GetAnalyticsSnapshot
    implements UseCase<AnalyticsSnapshot, AnalyticsPeriod> {
  final AnalyticsRepository repository;
  GetAnalyticsSnapshot(this.repository);

  @override
  Future<Either<Failure, AnalyticsSnapshot>> call(AnalyticsPeriod period) =>
      repository.getSnapshot(period);
}

// ─── GET PRAYER ANALYTICS ────────────────────────────────────────────────────
class PrayerAnalyticsParams extends Equatable {
  final DateTime from;
  final DateTime to;
  const PrayerAnalyticsParams({required this.from, required this.to});

  @override
  List<Object?> get props => [from, to];
}

class GetPrayerAnalytics
    implements UseCase<PrayerAnalytics, PrayerAnalyticsParams> {
  final AnalyticsRepository repository;
  GetPrayerAnalytics(this.repository);

  @override
  Future<Either<Failure, PrayerAnalytics>> call(
          PrayerAnalyticsParams params) =>
      repository.getPrayerAnalytics(
          from: params.from, to: params.to);
}

// ─── GET WEEKLY SCORE SERIES ─────────────────────────────────────────────────
class GetWeeklyScoreSeries implements UseCase<WeeklyScoreSeries, int> {
  final AnalyticsRepository repository;
  GetWeeklyScoreSeries(this.repository);

  @override
  Future<Either<Failure, WeeklyScoreSeries>> call(int weeks) =>
      repository.getWeeklyScoreSeries(weeks);
}

// ─── GET MONTHLY HEATMAP ─────────────────────────────────────────────────────
class MonthlyHeatmapParams extends Equatable {
  final int year;
  final int month;
  const MonthlyHeatmapParams({required this.year, required this.month});

  @override
  List<Object?> get props => [year, month];
}

class GetMonthlyHeatmap
    implements UseCase<MonthlyHeatmap, MonthlyHeatmapParams> {
  final AnalyticsRepository repository;
  GetMonthlyHeatmap(this.repository);

  @override
  Future<Either<Failure, MonthlyHeatmap>> call(
          MonthlyHeatmapParams params) =>
      repository.getMonthlyHeatmap(
          year: params.year, month: params.month);
}
