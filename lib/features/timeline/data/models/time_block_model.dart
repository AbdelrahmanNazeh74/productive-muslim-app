import 'package:isar/isar.dart';
import '../../domain/entities/time_block.dart';
import '../../../prayer/domain/entities/prayer_times.dart';

part 'time_block_model.g.dart';

@collection
class TimeBlockModel {
  Id id = Isar.autoIncrement;

  late String blockId;       // uuid from domain entity
  late String type;          // TimeBlockType.name
  late DateTime startTime;
  late DateTime endTime;
  late String title;
  String? subtitle;
  late String priority;      // BlockPriority.name
  late bool isCompleted;
  late bool isSkipped;
  String? linkedPrayer;      // PrayerName.name or null
  DateTime? completedAt;
  String? notes;

  // ── Domain → Model ──────────────────────────────────────────────────────────
  static TimeBlockModel fromEntity(TimeBlock e) {
    final m = TimeBlockModel()
      ..blockId = e.id
      ..type = e.type.name
      ..startTime = e.startTime
      ..endTime = e.endTime
      ..title = e.title
      ..subtitle = e.subtitle
      ..priority = e.priority.name
      ..isCompleted = e.isCompleted
      ..isSkipped = e.isSkipped
      ..linkedPrayer = e.linkedPrayer?.name
      ..completedAt = e.completedAt
      ..notes = e.notes;
    return m;
  }

  // ── Model → Domain ──────────────────────────────────────────────────────────
  TimeBlock toEntity() {
    return TimeBlock(
      id: blockId,
      type: TimeBlockType.values.byName(type),
      startTime: startTime,
      endTime: endTime,
      title: title,
      subtitle: subtitle,
      priority: BlockPriority.values.byName(priority),
      isCompleted: isCompleted,
      isSkipped: isSkipped,
      linkedPrayer: linkedPrayer != null
          ? PrayerName.values.byName(linkedPrayer!)
          : null,
      completedAt: completedAt,
      notes: notes,
    );
  }
}
