import 'package:isar/isar.dart';
import '../../domain/entities/time_block.dart';
import 'time_block_model.dart';

part 'daily_timeline_model.g.dart';

@collection
class DailyTimelineModel {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late DateTime date;

  late String dayType;       // DayType.name
  late DateTime generatedAt;
  String? morningIntention;
  String? eveningReflection;

  // Isar links to individual time blocks
  final blocks = IsarLinks<TimeBlockModel>();

  // ── Domain → Model (header only, blocks handled separately) ─────────────────
  static DailyTimelineModel fromEntity(DailyTimeline timeline) {
    final m = DailyTimelineModel()
      ..date = DateTime(
          timeline.date.year, timeline.date.month, timeline.date.day)
      ..dayType = timeline.dayType.name
      ..generatedAt = timeline.generatedAt
      ..morningIntention = timeline.morningIntention
      ..eveningReflection = timeline.eveningReflection;
    return m;
  }

  // ── Model → Domain (requires blocks to be loaded) ───────────────────────────
  DailyTimeline toEntity() {
    final blockEntities =
        blocks.map((b) => b.toEntity()).toList()
          ..sort((a, b) => a.startTime.compareTo(b.startTime));
    return DailyTimeline(
      date: date,
      dayType: DayType.values.byName(dayType),
      blocks: blockEntities,
      morningIntention: morningIntention,
      eveningReflection: eveningReflection,
      generatedAt: generatedAt,
    );
  }
}
