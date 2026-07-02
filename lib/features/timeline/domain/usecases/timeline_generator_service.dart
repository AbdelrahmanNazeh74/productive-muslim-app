import 'package:uuid/uuid.dart';

import '../../../../features/onboarding/domain/entities/user_profile.dart';
import '../../../../features/prayer/domain/entities/prayer_times.dart';
import '../entities/time_block.dart';

/// The core scheduling brain of the app.
///
/// Algorithm overview:
/// ─────────────────────────────────────────────────────────────────────────────
/// 1. ANCHOR fixed blocks: sleep window, 5 prayers + buffers, work shift.
///    These define hard constraints — nothing can overlap them.
///
/// 2. IDENTIFY free gaps: scan the 24h day, find all unclaimed intervals
///    between fixed blocks.
///
/// 3. SLOT enrichment blocks into gaps using priority order:
///    Morning routine → Quran (post-Fajr) → Golden Hour → Gym → Meals →
///    Qaylula → Deep Work pockets → Dhikr → Free time (fills remainder).
///
/// 4. VALIDATE: ensure no two blocks overlap, every minute is accounted for,
///    and prayer times are always respected.
///
/// 5. SORT and return the final timeline.
/// ─────────────────────────────────────────────────────────────────────────────

class TimelineGeneratorService {
  static const _uuid = Uuid();

  /// Generate a complete [DailyTimeline] for [date] from user profile + prayer times.
  DailyTimeline generate({
    required DateTime date,
    required UserProfile profile,
    required DailyPrayerTimes prayerTimes,
  }) {
    final dayType = _resolveDayType(date, profile);
    final isWorkDay = profile.workDays.contains(date.weekday - 1);
    final isGymDay = profile.gymDays.contains(date.weekday - 1);
    final hasGym = isGymDay &&
        profile.fitnessActivityIds.isNotEmpty &&
        !profile.fitnessActivityIds.contains('none');

    final blocks = <TimeBlock>[];

    // ── STEP 1: Anchor all fixed blocks ───────────────────────────────────────
    blocks.addAll(_buildSleepBlock(date, profile, prayerTimes));
    blocks.addAll(_buildPrayerBlocks(date, profile, prayerTimes));
    if (isWorkDay) {
      blocks.addAll(_buildWorkBlocks(date, profile, prayerTimes));
    }

    // ── STEP 2 & 3: Find gaps and slot enrichment blocks ──────────────────────
    final gaps = _findFreeGaps(date, blocks);

    // Morning routine (after sleep end, before work/Fajr)
    _tryInsert(
      blocks: blocks,
      gaps: gaps,
      candidate: _morningRoutineBlock(date, prayerTimes, profile),
    );

    // Quran block — prefer the post-Fajr slot
    if (profile.dailyQuranPagesGoal > 0) {
      _tryInsert(
        blocks: blocks,
        gaps: gaps,
        candidate: _quranBlock(date, prayerTimes, profile),
        preferAfter: prayerTimes.fajr.prayerEnd(),
      );
    }

    // Golden Hour (Fajr end → Sunrise) — only if gap is big enough
    if (prayerTimes.hasGoldenHour) {
      final gh = prayerTimes.goldenHour;
      if (gh.durationMinutes >= 20) {
        _tryInsertExact(
          blocks: blocks,
          block: _block(
            date: date,
            type: TimeBlockType.goldenHour,
            start: gh.start,
            end: gh.end,
            title: 'Golden Hour',
            subtitle:
                'Peak clarity window — deep focus or Quran before the world wakes up.',
            priority: BlockPriority.suggested,
          ),
        );
      }
    }

    // Gym block
    if (hasGym) {
      final gymBlock = _gymBlock(date, profile, prayerTimes, isWorkDay);
      if (gymBlock != null) {
        _tryInsert(
          blocks: blocks,
          gaps: gaps,
          candidate: gymBlock,
        );
      }
    }

    // Meals — breakfast, lunch, dinner
    for (final meal in _mealBlocks(date, prayerTimes, isWorkDay)) {
      _tryInsert(blocks: blocks, gaps: gaps, candidate: meal);
    }

    // Qaylula (midday nap between Dhuhr end and Asr buffer start)
    final qaylula = _qaylulaBlock(date, prayerTimes, profile);
    if (qaylula != null) {
      _tryInsert(blocks: blocks, gaps: gaps, candidate: qaylula);
    }

    // Deep work pockets — inject into long work gaps (>90 min unbroken)
    _injectDeepWorkPockets(blocks, date);

    // Dhikr slots — post each prayer if gap exists
    for (final prayer in prayerTimes.ordered) {
      final dhikr = _dhikrBlock(date, prayer);
      _tryInsertExact(blocks: blocks, block: dhikr);
    }

    // Evening routine (after Maghrib prayer, before Isha)
    _tryInsert(
      blocks: blocks,
      gaps: gaps,
      candidate: _eveningRoutineBlock(date, prayerTimes),
    );

    // ── STEP 3b: Fill remaining gaps with Free Time ───────────────────────────
    _fillRemainingGaps(blocks: blocks, date: date);

    // ── STEP 4: Sort ──────────────────────────────────────────────────────────
    blocks.sort((a, b) => a.startTime.compareTo(b.startTime));

    // ── STEP 5: Final overlap validation ─────────────────────────────────────
    _resolveOverlaps(blocks);

    return DailyTimeline(
      date: date,
      dayType: dayType,
      blocks: blocks,
      generatedAt: DateTime.now(),
    );
  }

  // ─── SLEEP BLOCK ────────────────────────────────────────────────────────────
  List<TimeBlock> _buildSleepBlock(
      DateTime date, UserProfile profile, DailyPrayerTimes prayerTimes) {
    // Wake-up time = Fajr + user's offset (negative = before Fajr)
    final wakeTime = prayerTimes.fajr.time
        .add(Duration(minutes: profile.wakeUpOffsetFromFajrMinutes));

    // Bedtime = wakeTime - targetSleep (wraps to previous day)
    final bedTime =
        wakeTime.subtract(Duration(hours: profile.targetSleepHours));

    // Sleep block spans from bedtime (previous night) to wakeup
    // We represent it as starting at midnight if bedtime < midnight
    final sleepStart = bedTime.hour >= 20
        ? bedTime
        : DateTime(date.year, date.month, date.day, 0, 0);
    final sleepEnd = wakeTime;

    if (sleepEnd.isAfter(sleepStart)) {
      return [
        _block(
          date: date,
          type: TimeBlockType.sleep,
          start: sleepStart,
          end: sleepEnd,
          title: 'Sleep',
          subtitle:
              '${profile.targetSleepHours}h rest',
          priority: BlockPriority.fixed,
        ),
      ];
    }
    return [];
  }

  // ─── PRAYER BLOCKS ──────────────────────────────────────────────────────────
  List<TimeBlock> _buildPrayerBlocks(
      DateTime date, UserProfile profile, DailyPrayerTimes prayerTimes) {
    final result = <TimeBlock>[];

    for (final prayer in prayerTimes.ordered) {
      final bufferStart = prayer.bufferStart(profile.prayerBufferMinutes);
      final prayerEnd = prayer.prayerEnd();

      // Buffer block (wudu / travel / wrap-up)
      if (profile.prayerBufferMinutes > 0) {
        result.add(_block(
          date: date,
          type: TimeBlockType.prayerBuffer,
          start: bufferStart,
          end: prayer.time,
          title: 'Prepare for ${prayer.name.label}',
          subtitle: 'Wudu & wrap up — ${profile.prayerBufferMinutes} min',
          priority: BlockPriority.fixed,
          linkedPrayer: prayer.name,
        ));
      }

      // Prayer block
      result.add(_block(
        date: date,
        type: TimeBlockType.prayer,
        start: prayer.time,
        end: prayerEnd,
        title: '${prayer.name.emoji} ${prayer.name.label}',
        subtitle: prayer.formattedTime,
        priority: BlockPriority.fixed,
        linkedPrayer: prayer.name,
      ));
    }

    return result;
  }

  // ─── WORK BLOCKS ────────────────────────────────────────────────────────────
  /// Builds work blocks, splitting around any prayer/buffer that falls
  /// inside the work window. This is the key algorithm that ensures
  /// work never overlaps prayer.
  List<TimeBlock> _buildWorkBlocks(
      DateTime date, UserProfile profile, DailyPrayerTimes prayerTimes) {
    final workStart = DateTime(date.year, date.month, date.day,
        profile.workStartHour, profile.workStartMinute);
    final workEnd = DateTime(date.year, date.month, date.day,
        profile.workEndHour, profile.workEndMinute);

    // Collect all prayer+buffer intervals that intersect the work window
    final prayerInterruptions = <DateTimeRange>[];
    for (final prayer in prayerTimes.ordered) {
      final bufferStart = prayer.bufferStart(profile.prayerBufferMinutes);
      final prayerEnd = prayer.prayerEnd();
      final interval = DateTimeRange(start: bufferStart, end: prayerEnd);
      final workRange = DateTimeRange(start: workStart, end: workEnd);
      if (interval.overlaps(workRange)) {
        // Clamp to work window
        prayerInterruptions.add(DateTimeRange(
          start: bufferStart.isBefore(workStart) ? workStart : bufferStart,
          end: prayerEnd.isAfter(workEnd) ? workEnd : prayerEnd,
        ));
      }
    }

    // Sort interruptions by start time
    prayerInterruptions
        .sort((a, b) => a.start.compareTo(b.start));

    // Build work segments around interruptions
    final segments = <TimeBlock>[];
    var cursor = workStart;

    for (final interruption in prayerInterruptions) {
      if (cursor.isBefore(interruption.start)) {
        final segDuration =
            interruption.start.difference(cursor).inMinutes;
        if (segDuration >= 15) {
          segments.add(_workSegment(
            date: date,
            start: cursor,
            end: interruption.start,
            profile: profile,
          ));
        }
      }
      cursor = interruption.end;
    }

    // Final segment after last interruption
    if (cursor.isBefore(workEnd)) {
      final segDuration = workEnd.difference(cursor).inMinutes;
      if (segDuration >= 15) {
        segments.add(_workSegment(
          date: date,
          start: cursor,
          end: workEnd,
          profile: profile,
        ));
      }
    }

    return segments;
  }

  TimeBlock _workSegment({
    required DateTime date,
    required DateTime start,
    required DateTime end,
    required UserProfile profile,
  }) {
    final mins = end.difference(start).inMinutes;
    final isStudent = profile.occupationType == 'student';
    return _block(
      date: date,
      type: TimeBlockType.work,
      start: start,
      end: end,
      title: isStudent ? 'Study Session' : 'Work Session',
      subtitle: '${_fmtDuration(mins)} — ${profile.occupationLabel}',
      priority: BlockPriority.fixed,
    );
  }

  // ─── GYM BLOCK ──────────────────────────────────────────────────────────────
  TimeBlock? _gymBlock(
    DateTime date,
    UserProfile profile,
    DailyPrayerTimes prayerTimes,
    bool isWorkDay,
  ) {
    final dur = Duration(minutes: profile.gymDurationMinutes);

    DateTime? idealStart;

    switch (profile.preferredGymTime) {
      case 'post_fajr':
        idealStart = prayerTimes.fajr.prayerEnd().add(const Duration(minutes: 5));
        break;
      case 'morning':
        idealStart = DateTime(date.year, date.month, date.day, 7, 0);
        break;
      case 'midday':
        idealStart = DateTime(date.year, date.month, date.day, 11, 0);
        break;
      case 'evening':
        // After Asr prayer end, buffer before Maghrib
        idealStart = prayerTimes.asr.prayerEnd().add(const Duration(minutes: 10));
        break;
      case 'night':
        idealStart = prayerTimes.isha.prayerEnd().add(const Duration(minutes: 15));
        break;
      default:
        idealStart = DateTime(date.year, date.month, date.day, 17, 30);
    }

    final idealEnd = idealStart.add(dur);

    // Verify it fits (doesn't overlap next prayer buffer)
    final nextPrayerConflict = _findNextPrayerConflict(
        idealStart, idealEnd, prayerTimes, profile.prayerBufferMinutes);

    final adjustedEnd = nextPrayerConflict != null &&
            idealEnd.isAfter(nextPrayerConflict)
        ? nextPrayerConflict.subtract(const Duration(minutes: 5))
        : idealEnd;

    if (adjustedEnd.difference(idealStart).inMinutes < 20) return null;

    final activityLabel = profile.fitnessActivityIds.isNotEmpty
        ? _activityLabel(profile.fitnessActivityIds.first)
        : 'Workout';

    return _block(
      date: date,
      type: TimeBlockType.gym,
      start: idealStart,
      end: adjustedEnd,
      title: activityLabel,
      subtitle: _fmtDuration(adjustedEnd.difference(idealStart).inMinutes),
      priority: BlockPriority.important,
    );
  }

  // ─── MEAL BLOCKS ────────────────────────────────────────────────────────────
  List<TimeBlock> _mealBlocks(
      DateTime date, DailyPrayerTimes prayerTimes, bool isWorkDay) {
    final meals = <TimeBlock>[];

    // Breakfast: after Fajr prayer end, 20 min
    final breakfastStart = prayerTimes.fajr.prayerEnd()
        .add(const Duration(minutes: 5));
    meals.add(_block(
      date: date,
      type: TimeBlockType.meal,
      start: breakfastStart,
      end: breakfastStart.add(const Duration(minutes: 20)),
      title: 'Breakfast',
      subtitle: 'Start the day with barakah 🌱',
      priority: BlockPriority.flexible,
    ));

    // Lunch: around Dhuhr (30 min after Dhuhr prayer end)
    final lunchStart =
        prayerTimes.dhuhr.prayerEnd().add(const Duration(minutes: 5));
    meals.add(_block(
      date: date,
      type: TimeBlockType.meal,
      start: lunchStart,
      end: lunchStart.add(const Duration(minutes: 30)),
      title: 'Lunch',
      priority: BlockPriority.flexible,
    ));

    // Dinner: after Maghrib prayer end
    final dinnerStart =
        prayerTimes.maghrib.prayerEnd().add(const Duration(minutes: 5));
    meals.add(_block(
      date: date,
      type: TimeBlockType.meal,
      start: dinnerStart,
      end: dinnerStart.add(const Duration(minutes: 30)),
      title: 'Dinner',
      subtitle: 'Eat with gratitude 🤲',
      priority: BlockPriority.flexible,
    ));

    return meals;
  }

  // ─── QURAN BLOCK ────────────────────────────────────────────────────────────
  TimeBlock _quranBlock(
      DateTime date, DailyPrayerTimes prayerTimes, UserProfile profile) {
    // Prefer: after Fajr prayer end + breakfast gap
    final start = prayerTimes.fajr.prayerEnd()
        .add(const Duration(minutes: 25));
    // ~10 min per page (conservative) — capped at 45 min
    final mins = (profile.dailyQuranPagesGoal * 10).clamp(10, 45);
    return _block(
      date: date,
      type: TimeBlockType.quran,
      start: start,
      end: start.add(Duration(minutes: mins)),
      title: 'Quran Reading',
      subtitle: '${profile.dailyQuranPagesGoal} page${profile.dailyQuranPagesGoal > 1 ? 's' : ''} · Daily goal',
      priority: BlockPriority.important,
    );
  }

  // ─── MORNING ROUTINE ────────────────────────────────────────────────────────
  TimeBlock _morningRoutineBlock(
      DateTime date, DailyPrayerTimes prayerTimes, UserProfile profile) {
    final wakeTime = prayerTimes.fajr.time
        .add(Duration(minutes: profile.wakeUpOffsetFromFajrMinutes));
    final routineEnd = prayerTimes.fajr.bufferStart(profile.prayerBufferMinutes);
    final dur = routineEnd.difference(wakeTime).inMinutes;

    final start = dur > 5 ? wakeTime : routineEnd.subtract(const Duration(minutes: 10));
    final end = routineEnd;

    return _block(
      date: date,
      type: TimeBlockType.morningRoutine,
      start: start,
      end: end,
      title: 'Morning Routine',
      subtitle: 'Freshen up · Miswak · Prepare for Fajr',
      priority: BlockPriority.flexible,
    );
  }

  // ─── EVENING ROUTINE ─────────────────────────────────────────────────────────
  TimeBlock _eveningRoutineBlock(
      DateTime date, DailyPrayerTimes prayerTimes) {
    // Between Maghrib end + dinner and Isha buffer
    final start = prayerTimes.maghrib.prayerEnd()
        .add(const Duration(minutes: 35)); // after dinner
    final end = prayerTimes.isha.bufferStart(10);

    if (end.isBefore(start) || end.difference(start).inMinutes < 10) {
      return _block(
        date: date,
        type: TimeBlockType.eveningRoutine,
        start: start,
        end: start.add(const Duration(minutes: 15)),
        title: 'Evening Wind-Down',
        priority: BlockPriority.suggested,
      );
    }

    return _block(
      date: date,
      type: TimeBlockType.eveningRoutine,
      start: start,
      end: end,
      title: 'Evening Wind-Down',
      subtitle: 'Reflect · Journal · Prepare for Isha',
      priority: BlockPriority.suggested,
    );
  }

  // ─── QAYLULA ────────────────────────────────────────────────────────────────
  TimeBlock? _qaylulaBlock(
      DateTime date, DailyPrayerTimes prayerTimes, UserProfile profile) {
    // Sunnah: nap between Dhuhr and Asr
    final napStart = prayerTimes.dhuhr.prayerEnd()
        .add(const Duration(minutes: 40)); // after lunch
    const napDuration = Duration(minutes: 20);
    final napEnd = napStart.add(napDuration);

    final asrBufferStart =
        prayerTimes.asr.bufferStart(profile.prayerBufferMinutes);

    // Only add if it fits before Asr buffer
    if (napEnd.isBefore(asrBufferStart)) {
      return _block(
        date: date,
        type: TimeBlockType.qaylula,
        start: napStart,
        end: napEnd,
        title: 'Qaylula',
        subtitle: '20-min Sunnah nap · Recharges focus for Asr',
        priority: BlockPriority.suggested,
      );
    }
    return null;
  }

  // ─── DHIKR BLOCKS ───────────────────────────────────────────────────────────
  TimeBlock _dhikrBlock(DateTime date, PrayerTime prayer) {
    final start = prayer.prayerEnd();
    final end = start.add(const Duration(minutes: 10));
    return _block(
      date: date,
      type: TimeBlockType.dhikr,
      start: start,
      end: end,
      title: 'Post-${prayer.name.label} Dhikr',
      subtitle: 'SubhanAllah · Alhamdulillah · Allahu Akbar ×33',
      priority: BlockPriority.suggested,
      linkedPrayer: prayer.name,
    );
  }

  // ─── DEEP WORK INJECTION ────────────────────────────────────────────────────
  /// Within long work blocks (≥90 min), tag the first 90 min as deep work.
  void _injectDeepWorkPockets(List<TimeBlock> blocks, DateTime date) {
    final workBlocks =
        blocks.where((b) => b.type == TimeBlockType.work).toList();

    for (final work in workBlocks) {
      if (work.durationMinutes >= 90) {
        final deepEnd = work.startTime.add(const Duration(minutes: 90));
        // Replace the leading 90 min with a deepWork label
        blocks.remove(work);
        // Deep work segment
        blocks.add(work.copyWith(
          type: TimeBlockType.deepWork,
          endTime: deepEnd,
          title: 'Deep Work',
          subtitle: '🎯 No interruptions · ${work.subtitle}',
        ));
        // Remaining work
        if (work.endTime.isAfter(deepEnd)) {
          blocks.add(work.copyWith(
            startTime: deepEnd,
            title: 'Work Session',
          ));
        }
        break; // Only inject once per day
      }
    }
  }

  // ─── GAP ANALYSIS ───────────────────────────────────────────────────────────
  List<DateTimeRange> _findFreeGaps(DateTime date, List<TimeBlock> blocks) {
    final dayStart = DateTime(date.year, date.month, date.day, 0, 0);
    final dayEnd = DateTime(date.year, date.month, date.day, 23, 59);

    final sorted = List<TimeBlock>.from(blocks)
      ..sort((a, b) => a.startTime.compareTo(b.startTime));

    final gaps = <DateTimeRange>[];
    var cursor = dayStart;

    for (final block in sorted) {
      if (block.startTime.isAfter(cursor)) {
        gaps.add(DateTimeRange(start: cursor, end: block.startTime));
      }
      if (block.endTime.isAfter(cursor)) {
        cursor = block.endTime;
      }
    }

    if (cursor.isBefore(dayEnd)) {
      gaps.add(DateTimeRange(start: cursor, end: dayEnd));
    }

    return gaps.where((g) => g.durationMinutes >= 5).toList();
  }

  // ─── FREE TIME FILL ─────────────────────────────────────────────────────────
  void _fillRemainingGaps({
    required List<TimeBlock> blocks,
    required DateTime date,
  }) {
    final gaps = _findFreeGaps(date, blocks);
    // Skip overnight gaps (midnight–5am) — those are implicit rest
    final daytimeGaps =
        gaps.where((g) => g.start.hour >= 5 && g.start.hour < 23).toList();

    for (final gap in daytimeGaps) {
      if (gap.durationMinutes >= 10) {
        blocks.add(_block(
          date: date,
          type: TimeBlockType.freeTime,
          start: gap.start,
          end: gap.end,
          title: 'Free Time',
          subtitle: _fmtDuration(gap.durationMinutes),
          priority: BlockPriority.suggested,
        ));
      }
    }
  }

  // ─── INSERT HELPERS ─────────────────────────────────────────────────────────

  /// Try to insert [candidate] into the first fitting gap.
  /// If [preferAfter] is specified, skip gaps before that time.
  bool _tryInsert({
    required List<TimeBlock> blocks,
    required List<DateTimeRange> gaps,
    required TimeBlock candidate,
    DateTime? preferAfter,
  }) {
    // First try to find a gap at or after the preferred time
    final candidateDur = candidate.durationMinutes;

    final sortedGaps = List<DateTimeRange>.from(gaps)
      ..sort((a, b) => a.start.compareTo(b.start));

    for (final gap in sortedGaps) {
      if (preferAfter != null && gap.end.isBefore(preferAfter)) continue;
      if (gap.durationMinutes >= candidateDur) {
        final start = preferAfter != null && gap.start.isBefore(preferAfter)
            ? preferAfter
            : gap.start;
        final end = start.add(Duration(minutes: candidateDur));
        if (end.isBefore(gap.end) || end.isAtSameMomentAs(gap.end)) {
          final adjusted = candidate.copyWith(startTime: start, endTime: end);
          if (!_hasOverlap(blocks, adjusted)) {
            blocks.add(adjusted);
            // Shrink or split gap
            gaps.remove(gap);
            if (start.isAfter(gap.start)) {
              gaps.add(DateTimeRange(start: gap.start, end: start));
            }
            if (end.isBefore(gap.end)) {
              gaps.add(DateTimeRange(start: end, end: gap.end));
            }
            return true;
          }
        }
      }
    }
    return false;
  }

  /// Try to insert [block] exactly as-is (no time shifting).
  bool _tryInsertExact({
    required List<TimeBlock> blocks,
    required TimeBlock block,
  }) {
    if (!_hasOverlap(blocks, block)) {
      blocks.add(block);
      return true;
    }
    return false;
  }

  bool _hasOverlap(List<TimeBlock> blocks, TimeBlock candidate) {
    return blocks.any((b) => b.overlapsWith(candidate));
  }

  // ─── OVERLAP RESOLUTION ─────────────────────────────────────────────────────
  /// Last-pass safety: if two blocks overlap, trim the lower-priority one.
  void _resolveOverlaps(List<TimeBlock> blocks) {
    for (int i = 0; i < blocks.length; i++) {
      for (int j = i + 1; j < blocks.length; j++) {
        if (blocks[i].overlapsWith(blocks[j])) {
          final a = blocks[i];
          final b = blocks[j];

          // Higher index (j) is always the one to trim
          final aPriority = a.priority.index;
          final bPriority = b.priority.index;

          if (aPriority <= bPriority) {
            // a wins — trim b to start after a ends
            blocks[j] = b.copyWith(startTime: a.endTime);
          } else {
            // b wins — trim a to end before b starts
            blocks[i] = a.copyWith(endTime: b.startTime);
          }
        }
      }
    }
    // Remove zero-duration blocks
    blocks.removeWhere((b) => b.durationMinutes <= 0);
  }

  // ─── UTILITIES ───────────────────────────────────────────────────────────────
  DayType _resolveDayType(DateTime date, UserProfile profile) {
    if (profile.isRamadanMode) return DayType.ramadan;
    if (date.weekday == DateTime.friday) return DayType.jumuah;
    if (profile.workDays.contains(date.weekday - 1)) return DayType.weekday;
    return DayType.weekend;
  }

  DateTime? _findNextPrayerConflict(
    DateTime start,
    DateTime end,
    DailyPrayerTimes prayerTimes,
    int bufferMinutes,
  ) {
    for (final prayer in prayerTimes.ordered) {
      final bufferStart = prayer.bufferStart(bufferMinutes);
      if (bufferStart.isAfter(start) && bufferStart.isBefore(end)) {
        return bufferStart;
      }
    }
    return null;
  }

  String _activityLabel(String activityId) {
    const labels = {
      'gym': 'Gym Session',
      'running': 'Running',
      'cycling': 'Cycling',
      'swimming': 'Swimming',
      'football': 'Football',
      'basketball': 'Basketball',
      'martial_arts': 'Martial Arts',
      'yoga': 'Yoga & Stretch',
      'walking': 'Walk',
      'home_workout': 'Home Workout',
    };
    return labels[activityId] ?? 'Workout';
  }

  String _fmtDuration(int minutes) {
    if (minutes < 60) return '${minutes}m';
    final h = minutes ~/ 60;
    final m = minutes % 60;
    return m == 0 ? '${h}h' : '${h}h ${m}m';
  }

  TimeBlock _block({
    required DateTime date,
    required TimeBlockType type,
    required DateTime start,
    required DateTime end,
    required String title,
    String? subtitle,
    required BlockPriority priority,
    PrayerName? linkedPrayer,
  }) {
    return TimeBlock(
      id: _uuid.v4(),
      type: type,
      startTime: start,
      endTime: end,
      title: title,
      subtitle: subtitle,
      priority: priority,
      linkedPrayer: linkedPrayer,
    );
  }
}
