import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../onboarding/domain/entities/user_profile.dart';
import '../../../prayer/data/repositories/prayer_time_service.dart';
import '../entities/time_block.dart';
import '../repositories/timeline_repository.dart';
import 'timeline_generator_service.dart';

// ─── GENERATE TIMELINE ────────────────────────────────────────────────────────
class GenerateTimelineParams extends Equatable {
  final UserProfile profile;
  final DateTime date;

  const GenerateTimelineParams({required this.profile, required this.date});

  @override
  List<Object?> get props => [profile, date];
}

class GenerateAndSaveTimeline
    implements UseCase<DailyTimeline, GenerateTimelineParams> {
  final TimelineRepository repository;
  final PrayerTimeService prayerTimeService;
  final TimelineGeneratorService generatorService;

  GenerateAndSaveTimeline({
    required this.repository,
    required this.prayerTimeService,
    required this.generatorService,
  });

  @override
  Future<Either<Failure, DailyTimeline>> call(
      GenerateTimelineParams params) async {
    // 1. Get prayer times for the date
    final prayerResult = prayerTimeService.getPrayerTimes(
      profile: params.profile,
      date: params.date,
    );

    return prayerResult.fold(
      (failure) => Left(failure),
      (prayerTimes) async {
        // 2. Run the scheduling algorithm
        final timeline = generatorService.generate(
          date: params.date,
          profile: params.profile,
          prayerTimes: prayerTimes,
        );

        // 3. Persist to Isar
        return repository.saveTimeline(timeline);
      },
    );
  }
}

// ─── GET TIMELINE ─────────────────────────────────────────────────────────────
class GetTimeline implements UseCase<DailyTimeline?, DateTime> {
  final TimelineRepository repository;
  GetTimeline(this.repository);

  @override
  Future<Either<Failure, DailyTimeline?>> call(DateTime date) =>
      repository.getTimeline(date);
}

// ─── COMPLETE BLOCK ───────────────────────────────────────────────────────────
class CompleteBlockParams extends Equatable {
  final String blockId;
  final DateTime date;
  const CompleteBlockParams({required this.blockId, required this.date});

  @override
  List<Object?> get props => [blockId, date];
}

class CompleteBlock implements UseCase<TimeBlock, CompleteBlockParams> {
  final TimelineRepository repository;
  CompleteBlock(this.repository);

  @override
  Future<Either<Failure, TimeBlock>> call(CompleteBlockParams params) =>
      repository.completeBlock(params.blockId, params.date);
}

// ─── SKIP BLOCK ───────────────────────────────────────────────────────────────
class SkipBlock implements UseCase<TimeBlock, CompleteBlockParams> {
  final TimelineRepository repository;
  SkipBlock(this.repository);

  @override
  Future<Either<Failure, TimeBlock>> call(CompleteBlockParams params) =>
      repository.skipBlock(params.blockId, params.date);
}

// ─── SET MORNING INTENTION ────────────────────────────────────────────────────
class SetIntentionParams extends Equatable {
  final DateTime date;
  final String text;
  const SetIntentionParams({required this.date, required this.text});

  @override
  List<Object?> get props => [date, text];
}

class SetMorningIntention
    implements UseCase<DailyTimeline, SetIntentionParams> {
  final TimelineRepository repository;
  SetMorningIntention(this.repository);

  @override
  Future<Either<Failure, DailyTimeline>> call(SetIntentionParams params) =>
      repository.setMorningIntention(params.date, params.text);
}

// ─── SET EVENING REFLECTION ───────────────────────────────────────────────────
class SetEveningReflection
    implements UseCase<DailyTimeline, SetIntentionParams> {
  final TimelineRepository repository;
  SetEveningReflection(this.repository);

  @override
  Future<Either<Failure, DailyTimeline>> call(SetIntentionParams params) =>
      repository.setEveningReflection(params.date, params.text);
}
