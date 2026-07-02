import 'package:equatable/equatable.dart';
import '../../../prayer/domain/entities/prayer_times.dart';

// ─── BLOCK TYPE ───────────────────────────────────────────────────────────────
enum TimeBlockType {
  // Fixed / spiritual
  sleep,
  prayerBuffer,  // wudu + travel time before salah
  prayer,
  goldenHour,    // post-Fajr → Sunrise focus window

  // Work / study
  work,
  deepWork,      // high-focus block within work hours
  break_,        // short break within work

  // Health
  gym,
  qaylula,       // midday nap (Sunnah: between Dhuhr & Asr)

  // Spiritual enrichment
  quran,
  dhikr,

  // Life
  meal,
  freeTime,
  morningRoutine,
  eveningRoutine,
}

extension TimeBlockTypeX on TimeBlockType {
  String get label {
    switch (this) {
      case TimeBlockType.sleep:          return 'Sleep';
      case TimeBlockType.prayerBuffer:   return 'Prepare for Prayer';
      case TimeBlockType.prayer:         return 'Prayer';
      case TimeBlockType.goldenHour:     return 'Golden Hour';
      case TimeBlockType.work:           return 'Work';
      case TimeBlockType.deepWork:       return 'Deep Work';
      case TimeBlockType.break_:         return 'Break';
      case TimeBlockType.gym:            return 'Workout';
      case TimeBlockType.qaylula:        return 'Qaylula (Nap)';
      case TimeBlockType.quran:          return 'Quran';
      case TimeBlockType.dhikr:          return 'Dhikr';
      case TimeBlockType.meal:           return 'Meal';
      case TimeBlockType.freeTime:       return 'Free Time';
      case TimeBlockType.morningRoutine: return 'Morning Routine';
      case TimeBlockType.eveningRoutine: return 'Evening Routine';
    }
  }

  String get emoji {
    switch (this) {
      case TimeBlockType.sleep:          return '😴';
      case TimeBlockType.prayerBuffer:   return '🕌';
      case TimeBlockType.prayer:         return '🤲';
      case TimeBlockType.goldenHour:     return '⭐';
      case TimeBlockType.work:           return '💼';
      case TimeBlockType.deepWork:       return '🎯';
      case TimeBlockType.break_:         return '☕';
      case TimeBlockType.gym:            return '🏋️';
      case TimeBlockType.qaylula:        return '💤';
      case TimeBlockType.quran:          return '📖';
      case TimeBlockType.dhikr:          return '📿';
      case TimeBlockType.meal:           return '🍽️';
      case TimeBlockType.freeTime:       return '🌿';
      case TimeBlockType.morningRoutine: return '🌄';
      case TimeBlockType.eveningRoutine: return '🌛';
    }
  }

  bool get isFixed => const {
    TimeBlockType.sleep,
    TimeBlockType.prayer,
    TimeBlockType.prayerBuffer,
    TimeBlockType.work,
  }.contains(this);

  bool get isSpiritual => const {
    TimeBlockType.prayer,
    TimeBlockType.prayerBuffer,
    TimeBlockType.goldenHour,
    TimeBlockType.quran,
    TimeBlockType.dhikr,
  }.contains(this);

  bool get isSuggestedOnly => const {
    TimeBlockType.goldenHour,
    TimeBlockType.qaylula,
    TimeBlockType.freeTime,
    TimeBlockType.dhikr,
  }.contains(this);
}

// ─── BLOCK PRIORITY ───────────────────────────────────────────────────────────
enum BlockPriority {
  fixed,      // Cannot be moved (prayer, sleep, work)
  important,  // Should not be moved (gym, quran)
  flexible,   // Can shift if needed
  suggested,  // Optional, fills gaps
}

// ─── TIME BLOCK ───────────────────────────────────────────────────────────────
class TimeBlock extends Equatable {
  final String id;
  final TimeBlockType type;
  final DateTime startTime;
  final DateTime endTime;
  final String title;
  final String? subtitle;
  final BlockPriority priority;
  final bool isCompleted;
  final bool isSkipped;
  final PrayerName? linkedPrayer;  // non-null for prayer/buffer blocks
  final DateTime? completedAt;
  final String? notes;

  const TimeBlock({
    required this.id,
    required this.type,
    required this.startTime,
    required this.endTime,
    required this.title,
    this.subtitle,
    required this.priority,
    this.isCompleted = false,
    this.isSkipped = false,
    this.linkedPrayer,
    this.completedAt,
    this.notes,
  });

  Duration get duration => endTime.difference(startTime);
  int get durationMinutes => duration.inMinutes;

  DateTimeRange get range =>
      DateTimeRange(start: startTime, end: endTime);

  bool get isActive => !isCompleted && !isSkipped;

  bool overlapsWith(TimeBlock other) =>
      startTime.isBefore(other.endTime) &&
      endTime.isAfter(other.startTime);

  TimeBlock copyWith({
    String? id,
    TimeBlockType? type,
    DateTime? startTime,
    DateTime? endTime,
    String? title,
    String? subtitle,
    BlockPriority? priority,
    bool? isCompleted,
    bool? isSkipped,
    PrayerName? linkedPrayer,
    DateTime? completedAt,
    String? notes,
  }) {
    return TimeBlock(
      id: id ?? this.id,
      type: type ?? this.type,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      priority: priority ?? this.priority,
      isCompleted: isCompleted ?? this.isCompleted,
      isSkipped: isSkipped ?? this.isSkipped,
      linkedPrayer: linkedPrayer ?? this.linkedPrayer,
      completedAt: completedAt ?? this.completedAt,
      notes: notes ?? this.notes,
    );
  }

  @override
  List<Object?> get props =>
      [id, type, startTime, endTime, isCompleted, isSkipped];
}

// ─── DAILY TIMELINE ───────────────────────────────────────────────────────────
enum DayType { weekday, weekend, jumuah, ramadan }

class DailyTimeline extends Equatable {
  final DateTime date;
  final DayType dayType;
  final List<TimeBlock> blocks;
  final String? morningIntention;
  final String? eveningReflection;
  final DateTime generatedAt;

  const DailyTimeline({
    required this.date,
    required this.dayType,
    required this.blocks,
    this.morningIntention,
    this.eveningReflection,
    required this.generatedAt,
  });

  // ── Computed stats ──────────────────────────────────────────────────────────
  List<TimeBlock> get prayerBlocks =>
      blocks.where((b) => b.type == TimeBlockType.prayer).toList();

  List<TimeBlock> get workBlocks =>
      blocks.where((b) =>
          b.type == TimeBlockType.work ||
          b.type == TimeBlockType.deepWork).toList();

  List<TimeBlock> get spiritualBlocks =>
      blocks.where((b) => b.type.isSpiritual).toList();

  int get completedCount =>
      blocks.where((b) => b.isCompleted).length;

  int get totalActionable =>
      blocks.where((b) => !b.type.isSuggestedOnly).length;

  double get completionRatio =>
      totalActionable == 0 ? 0 : completedCount / totalActionable;

  int get prayersCompletedCount =>
      prayerBlocks.where((b) => b.isCompleted).length;

  int get freeMinutes {
    final freeBlocks =
        blocks.where((b) => b.type == TimeBlockType.freeTime);
    return freeBlocks.fold(0, (sum, b) => sum + b.durationMinutes);
  }

  TimeBlock? get nextPrayer {
    final now = DateTime.now();
    final upcoming = prayerBlocks.where(
        (b) => b.startTime.isAfter(now) && !b.isCompleted);
    return upcoming.isEmpty ? null : upcoming.first;
  }

  TimeBlock? get currentBlock {
    final now = DateTime.now();
    try {
      return blocks.firstWhere(
        (b) => b.startTime.isBefore(now) && b.endTime.isAfter(now),
      );
    } catch (_) {
      return null;
    }
  }

  DailyTimeline copyWith({
    DateTime? date,
    DayType? dayType,
    List<TimeBlock>? blocks,
    String? morningIntention,
    String? eveningReflection,
    DateTime? generatedAt,
  }) {
    return DailyTimeline(
      date: date ?? this.date,
      dayType: dayType ?? this.dayType,
      blocks: blocks ?? this.blocks,
      morningIntention: morningIntention ?? this.morningIntention,
      eveningReflection: eveningReflection ?? this.eveningReflection,
      generatedAt: generatedAt ?? this.generatedAt,
    );
  }

  @override
  List<Object?> get props => [date, dayType, blocks, morningIntention];
}
