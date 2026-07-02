import 'package:dartz/dartz.dart';
import 'package:isar/isar.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/time_block.dart';
import '../../domain/repositories/timeline_repository.dart';
import '../models/daily_timeline_model.dart';
import '../models/time_block_model.dart';

class TimelineRepositoryImpl implements TimelineRepository {
  final Isar isar;

  TimelineRepositoryImpl({required this.isar});

  @override
  Future<Either<Failure, DailyTimeline>> saveTimeline(
      DailyTimeline timeline) async {
    try {
      await isar.writeTxn(() async {
        final dateOnly = DateTime(
            timeline.date.year, timeline.date.month, timeline.date.day);

        // Delete existing timeline for this date if any
        final existing = await isar.dailyTimelineModels
            .where()
            .dateEqualTo(dateOnly)
            .findFirst();
        if (existing != null) {
          await existing.blocks.load();
          await isar.timeBlockModels
              .deleteAll(existing.blocks.map((b) => b.id).toList());
          await isar.dailyTimelineModels.delete(existing.id);
        }

        // Save new timeline header
        final timelineModel = DailyTimelineModel.fromEntity(timeline);
        await isar.dailyTimelineModels.put(timelineModel);

        // Save all blocks and link to timeline
        final blockModels = timeline.blocks
            .map((b) => TimeBlockModel.fromEntity(b))
            .toList();
        await isar.timeBlockModels.putAll(blockModels);
        timelineModel.blocks.addAll(blockModels);
        await timelineModel.blocks.save();
      });

      // Reload and return
      return getTimeline(timeline.date).then(
        (result) => result.fold(
          (f) => Left(f),
          (t) => t != null
              ? Right(t)
              : const Left(DatabaseFailure('Failed to reload saved timeline')),
        ),
      );
    } catch (e) {
      return Left(DatabaseFailure('Failed to save timeline: $e'));
    }
  }

  @override
  Future<Either<Failure, DailyTimeline?>> getTimeline(DateTime date) async {
    try {
      final dateOnly = DateTime(date.year, date.month, date.day);
      final model = await isar.dailyTimelineModels
          .where()
          .dateEqualTo(dateOnly)
          .findFirst();

      if (model == null) return const Right(null);

      await model.blocks.load();
      return Right(model.toEntity());
    } catch (e) {
      return Left(DatabaseFailure('Failed to load timeline: $e'));
    }
  }

  @override
  Future<Either<Failure, TimeBlock>> completeBlock(
      String blockId, DateTime date) async {
    try {
      TimeBlock? updated;
      await isar.writeTxn(() async {
        final model = await isar.timeBlockModels
            .where()
            .filter()
            .blockIdEqualTo(blockId)
            .findFirst();

        if (model == null) throw Exception('Block not found: $blockId');

        model.isCompleted = true;
        model.completedAt = DateTime.now();
        await isar.timeBlockModels.put(model);
        updated = model.toEntity();
      });
      return Right(updated!);
    } catch (e) {
      return Left(DatabaseFailure('Failed to complete block: $e'));
    }
  }

  @override
  Future<Either<Failure, TimeBlock>> skipBlock(
      String blockId, DateTime date) async {
    try {
      TimeBlock? updated;
      await isar.writeTxn(() async {
        final model = await isar.timeBlockModels
            .where()
            .filter()
            .blockIdEqualTo(blockId)
            .findFirst();

        if (model == null) throw Exception('Block not found: $blockId');

        model.isSkipped = true;
        await isar.timeBlockModels.put(model);
        updated = model.toEntity();
      });
      return Right(updated!);
    } catch (e) {
      return Left(DatabaseFailure('Failed to skip block: $e'));
    }
  }

  @override
  Future<Either<Failure, DailyTimeline>> setMorningIntention(
      DateTime date, String intention) async {
    try {
      await isar.writeTxn(() async {
        final dateOnly = DateTime(date.year, date.month, date.day);
        final model = await isar.dailyTimelineModels
            .where()
            .dateEqualTo(dateOnly)
            .findFirst();
        if (model == null) throw Exception('Timeline not found for $date');
        model.morningIntention = intention;
        await isar.dailyTimelineModels.put(model);
      });
      final result = await getTimeline(date);
      return result.fold(
        (f) => Left(f),
        (t) => t != null ? Right(t) : const Left(DatabaseFailure('Not found')),
      );
    } catch (e) {
      return Left(DatabaseFailure('Failed to set intention: $e'));
    }
  }

  @override
  Future<Either<Failure, DailyTimeline>> setEveningReflection(
      DateTime date, String reflection) async {
    try {
      await isar.writeTxn(() async {
        final dateOnly = DateTime(date.year, date.month, date.day);
        final model = await isar.dailyTimelineModels
            .where()
            .dateEqualTo(dateOnly)
            .findFirst();
        if (model == null) throw Exception('Timeline not found for $date');
        model.eveningReflection = reflection;
        await isar.dailyTimelineModels.put(model);
      });
      final result = await getTimeline(date);
      return result.fold(
        (f) => Left(f),
        (t) => t != null ? Right(t) : const Left(DatabaseFailure('Not found')),
      );
    } catch (e) {
      return Left(DatabaseFailure('Failed to set reflection: $e'));
    }
  }

  @override
  Future<Either<Failure, int>> pruneOlderThan(int days) async {
    try {
      final cutoff = DateTime.now().subtract(Duration(days: days));
      int count = 0;
      await isar.writeTxn(() async {
        final old = await isar.dailyTimelineModels
            .where()
            .filter()
            .dateLessThan(cutoff)
            .findAll();
        for (final timeline in old) {
          await timeline.blocks.load();
          await isar.timeBlockModels
              .deleteAll(timeline.blocks.map((b) => b.id).toList());
          await isar.dailyTimelineModels.delete(timeline.id);
          count++;
        }
      });
      return Right(count);
    } catch (e) {
      return Left(DatabaseFailure('Failed to prune timelines: $e'));
    }
  }
}
