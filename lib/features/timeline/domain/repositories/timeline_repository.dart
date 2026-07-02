import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/time_block.dart';

abstract class TimelineRepository {
  /// Save or replace the full timeline for the given date.
  Future<Either<Failure, DailyTimeline>> saveTimeline(DailyTimeline timeline);

  /// Load the timeline for a specific date (null if not yet generated).
  Future<Either<Failure, DailyTimeline?>> getTimeline(DateTime date);

  /// Mark a single block as completed.
  Future<Either<Failure, TimeBlock>> completeBlock(
      String blockId, DateTime date);

  /// Mark a single block as skipped.
  Future<Either<Failure, TimeBlock>> skipBlock(
      String blockId, DateTime date);

  /// Update morning intention for a date.
  Future<Either<Failure, DailyTimeline>> setMorningIntention(
      DateTime date, String intention);

  /// Update evening reflection for a date.
  Future<Either<Failure, DailyTimeline>> setEveningReflection(
      DateTime date, String reflection);

  /// Delete all timelines older than [days] days (cache pruning).
  Future<Either<Failure, int>> pruneOlderThan(int days);
}
