import 'package:uuid/uuid.dart';

import '../../../../features/onboarding/domain/entities/user_profile.dart';
import '../../../../features/prayer/domain/entities/prayer_times.dart';
import '../../../../features/timeline/domain/entities/time_block.dart';
import '../entities/ramadan_entities.dart';
import 'hijri_converter.dart';

/// Ramadan-aware timeline generator.
///
/// Ramadan fundamentally restructures the day around two new fixed anchors:
///   • Suhoor  — pre-dawn meal (ends at Fajr)
///   • Iftar   — breaking fast at Maghrib
///   • Tarawih — nightly prayer after Isha
///
/// Sleep pattern splits into two windows:
///   • Night sleep:  After Tarawih → before Suhoor (~3–5h)
///   • Day sleep:    Extended Qaylula between Dhuhr and Asr (~60–120 min)
///
/// Meals are replaced by:
///   • Suhoor (pre-dawn)
///   • Iftar (sunset) + dinner
///   • No lunch (fasting)
///
/// Work hours may be reduced (configurable in RamadanProfile).
///
/// Last 10 nights: Tarawih extended, more Quran, Qiyam al-Layl added.
class RamadanTimelineGenerator {
  static const _uuid = Uuid();
  final HijriConverter _hijri;

  RamadanTimelineGenerator({HijriConverter? hijri})
      : _hijri = hijri ?? const HijriConverter();

  // ─── BUILD RAMADAN DAY CONTEXT ────────────────────────────────────────────
  RamadanDayContext buildContext({
    required DateTime date,
    required DailyPrayerTimes prayerTimes,
    required RamadanProfile ramadanProfile,
  }) {
    final hijriDate = _hijri.toHijri(date);
    final ramadanDay = hijriDate.ramadanDay ?? 1;
    final isLastTen = ramadanDay >= 21;
    final isOdd = ramadanDay % 2 != 0;

    final times = _buildRamadanTimes(
      date: date,
      prayerTimes: prayerTimes,
      profile: ramadanProfile,
      isLastTen: isLastTen,
    );

    return RamadanDayContext(
      gregorianDate: date,
      hijriDate: hijriDate,
      times: times,
      profile: ramadanProfile,
      ramadanDayNumber: ramadanDay,
      isLastTenNights: isLastTen,
      isOddNight: isOdd,
      isJumuah: date.weekday == DateTime.friday,
    );
  }

  // ─── GENERATE RAMADAN TIMELINE ────────────────────────────────────────────
  DailyTimeline generate({
    required DateTime date,
    required UserProfile userProfile,
    required DailyPrayerTimes prayerTimes,
    required RamadanProfile ramadanProfile,
  }) {
    final ctx = buildContext(
      date: date,
      prayerTimes: prayerTimes,
      ramadanProfile: ramadanProfile,
    );

    final isWorkDay = userProfile.workDays.contains(date.weekday - 1);
    final isLastTen = ctx.isLastTenNights;
    final isOddLastTen = ctx.isLastTenNights && ctx.isOddNight;

    final blocks = <TimeBlock>[];

    // ── 1. ANCHOR: Night sleep (after previous Tarawih, ends at Suhoor) ──────
    blocks.add(_nightSleepBlock(date, ctx));

    // ── 2. ANCHOR: Suhoor ────────────────────────────────────────────────────
    blocks.add(_suhoorBlock(date, ctx));

    // ── 3. ANCHOR: All 5 prayers + buffers ───────────────────────────────────
    blocks.addAll(_prayerBlocks(date, userProfile, prayerTimes));

    // ── 4. ANCHOR: Work (possibly reduced hours) ──────────────────────────────
    if (isWorkDay) {
      blocks.addAll(
          _workBlocks(date, userProfile, prayerTimes, ramadanProfile));
    }

    // ── 5. ANCHOR: Iftar ─────────────────────────────────────────────────────
    blocks.add(_iftarBlock(date, ctx));

    // ── 6. ANCHOR: Tarawih ───────────────────────────────────────────────────
    if (ramadanProfile.praysTarawih) {
      blocks.add(_tarawihBlock(date, ctx, isOddLastTen));
      if (ramadanProfile.praysWitr) {
        blocks.add(_witrBlock(date, ctx));
      }
    }

    // ── 7. ENRICHMENT in gaps ────────────────────────────────────────────────
    final gaps = _findFreeGaps(date, blocks);

    // Extended Quran — post-Fajr and post-Tarawih
    _tryInsert(
      blocks: blocks,
      gaps: gaps,
      candidate: _quranBlock(date, ctx, prayerTimes, isLastTen),
      preferAfter: prayerTimes.fajr.prayerEnd(),
    );

    // Second Quran block (last 10 nights — additional after Tarawih)
    if (isLastTen && ramadanProfile.praysTarawih) {
      _tryInsert(
        blocks: blocks,
        gaps: gaps,
        candidate: _quranBlock(
          date, ctx, prayerTimes, true,
          afterTarawih: true,
        ),
        preferAfter: ctx.times.tarawihEnd,
      );
    }

    // Golden Hour (Fajr → Sunrise) — very productive in Ramadan
    if (prayerTimes.hasGoldenHour &&
        prayerTimes.goldenHour.durationMinutes >= 20) {
      _tryInsertExact(
        blocks: blocks,
        block: _goldenHourBlock(date, prayerTimes),
      );
    }

    // Morning dhikr (post-Fajr)
    _tryInsertExact(
      blocks: blocks,
      block: _dhikrBlock(date, prayerTimes.fajr, label: 'Fajr Adhkar + Du\'a'),
    );

    // Extended Qaylula (Ramadan nap is longer — ~60–120 min)
    final qaylula = _ramadanQaylulaBlock(date, prayerTimes, ramadanProfile, ctx);
    if (qaylula != null) {
      _tryInsert(blocks: blocks, gaps: gaps, candidate: qaylula);
    }

    // Dhikr after each prayer
    for (final prayer in prayerTimes.ordered) {
      _tryInsertExact(
        blocks: blocks,
        block: _dhikrBlock(date, prayer),
      );
    }

    // Qiyam al-Layl (last 10 odd nights only — after Tarawih)
    if (isOddLastTen && ramadanProfile.praysTarawih) {
      final qiyam = _qiyamBlock(date, ctx);
      if (qiyam != null) {
        _tryInsert(
          blocks: blocks,
          gaps: gaps,
          candidate: qiyam,
          preferAfter: ctx.times.tarawihEnd,
        );
      }
    }

    // Free time
    _fillRemainingGaps(blocks: blocks, date: date);

    // ── 8. Sort + validate ────────────────────────────────────────────────────
    blocks.sort((a, b) => a.startTime.compareTo(b.startTime));
    _resolveOverlaps(blocks);

    return DailyTimeline(
      date: date,
      dayType: DayType.ramadan,
      blocks: blocks,
      generatedAt: DateTime.now(),
    );
  }

  // ─── BLOCK BUILDERS ────────────────────────────────────────────────────────

  /// Split night sleep: ends at Suhoor wake-up time.
  TimeBlock _nightSleepBlock(DateTime date, RamadanDayContext ctx) {
    final sleepEnd = ctx.times.sehriWakeUp;
    // Sleep starts ~30 min after Tarawih ends (wind-down)
    final sleepStart = ctx.times.tarawihEnd.add(const Duration(minutes: 30));

    // If sleep window crosses midnight, anchor to midnight of this date
    final anchoredStart = sleepStart.isAfter(sleepEnd)
        ? DateTime(date.year, date.month, date.day, 0, 0)
        : sleepStart;

    return _block(
      date: date,
      type: TimeBlockType.sleep,
      start: anchoredStart,
      end: sleepEnd,
      title: 'Night Sleep',
      subtitle:
          '${_fmt(anchoredStart)} – ${_fmt(sleepEnd)} · ${ctx.profile.nightSleepHours}h',
      priority: BlockPriority.fixed,
    );
  }

  TimeBlock _suhoorBlock(DateTime date, RamadanDayContext ctx) {
    return _block(
      date: date,
      type: TimeBlockType.meal,
      start: ctx.times.suhoorStart,
      end: ctx.times.suhoorEnd,
      title: '🌙 Suhoor',
      subtitle: 'Pre-dawn meal · Ends at Fajr adhan · Make du\'a for the fast',
      priority: BlockPriority.fixed,
    );
  }

  List<TimeBlock> _prayerBlocks(
      DateTime date, UserProfile profile, DailyPrayerTimes prayerTimes) {
    final result = <TimeBlock>[];
    for (final prayer in prayerTimes.ordered) {
      if (profile.prayerBufferMinutes > 0) {
        result.add(_block(
          date: date,
          type: TimeBlockType.prayerBuffer,
          start: prayer.bufferStart(profile.prayerBufferMinutes),
          end: prayer.time,
          title: 'Prepare for ${prayer.name.label}',
          subtitle: '${profile.prayerBufferMinutes} min',
          priority: BlockPriority.fixed,
          linkedPrayer: prayer.name,
        ));
      }
      result.add(_block(
        date: date,
        type: TimeBlockType.prayer,
        start: prayer.time,
        end: prayer.prayerEnd(),
        title: '${prayer.name.emoji} ${prayer.name.label}',
        subtitle: prayer.formattedTime,
        priority: BlockPriority.fixed,
        linkedPrayer: prayer.name,
      ));
    }
    return result;
  }

  /// Work blocks with possible Ramadan reduced hours and prayer splits.
  List<TimeBlock> _workBlocks(
    DateTime date,
    UserProfile user,
    DailyPrayerTimes prayerTimes,
    RamadanProfile ramadan,
  ) {
    final workStart = DateTime(date.year, date.month, date.day,
        user.workStartHour, user.workStartMinute);

    // Use reduced end hour if configured
    final workEndHour =
        ramadan.hasReducedWorkHours ? ramadan.reducedWorkEndHour : user.workEndHour;
    final workEndMin = ramadan.hasReducedWorkHours
        ? ramadan.reducedWorkEndMinute
        : user.workEndMinute;
    final workEnd =
        DateTime(date.year, date.month, date.day, workEndHour, workEndMin);

    if (workEnd.isBefore(workStart)) return [];

    // Collect prayer+buffer interruptions inside the work window
    final interruptions = <DateTimeRange>[];
    for (final prayer in prayerTimes.ordered) {
      final bufStart = prayer.bufferStart(user.prayerBufferMinutes);
      final pEnd = prayer.prayerEnd();
      final pRange = DateTimeRange(start: bufStart, end: pEnd);
      final wRange = DateTimeRange(start: workStart, end: workEnd);
      if (pRange.overlaps(wRange)) {
        interruptions.add(DateTimeRange(
          start: bufStart.isBefore(workStart) ? workStart : bufStart,
          end: pEnd.isAfter(workEnd) ? workEnd : pEnd,
        ));
      }
    }
    interruptions.sort((a, b) => a.start.compareTo(b.start));

    final segments = <TimeBlock>[];
    var cursor = workStart;

    for (final interr in interruptions) {
      if (cursor.isBefore(interr.start) &&
          interr.start.difference(cursor).inMinutes >= 15) {
        segments.add(_workSegment(date, cursor, interr.start, user, ramadan));
      }
      cursor = interr.end;
    }
    if (cursor.isBefore(workEnd) &&
        workEnd.difference(cursor).inMinutes >= 15) {
      segments.add(_workSegment(date, cursor, workEnd, user, ramadan));
    }

    return segments;
  }

  TimeBlock _workSegment(
    DateTime date,
    DateTime start,
    DateTime end,
    UserProfile user,
    RamadanProfile ramadan,
  ) {
    final mins = end.difference(start).inMinutes;
    final isStudent = user.occupationType == 'student';
    final reducedLabel =
        ramadan.hasReducedWorkHours ? ' · Reduced hours' : '';
    return _block(
      date: date,
      type: TimeBlockType.work,
      start: start,
      end: end,
      title: isStudent ? 'Study Session' : 'Work Session',
      subtitle: '${_fmtDur(mins)} — ${user.occupationLabel}$reducedLabel',
      priority: BlockPriority.fixed,
    );
  }

  TimeBlock _iftarBlock(DateTime date, RamadanDayContext ctx) {
    final start = ctx.times.iftarTime;
    final end =
        start.add(Duration(minutes: ctx.profile.iftarDurationMinutes));
    final gatheringNote =
        ctx.profile.hasIftarGathering ? ' · With family/community' : '';
    return _block(
      date: date,
      type: TimeBlockType.meal,
      start: start,
      end: end,
      title: '🌅 Iftar — Break Fast',
      subtitle:
          'Maghrib adhan · ${_fmtDur(ctx.profile.iftarDurationMinutes)}$gatheringNote',
      priority: BlockPriority.fixed,
    );
  }

  TimeBlock _tarawihBlock(
      DateTime date, RamadanDayContext ctx, bool isOddLastTen) {
    final start = ctx.times.tarawihStart;
    // Last ten odd nights: extend Tarawih by 30 min for Qiyam prep
    final dur = isOddLastTen
        ? ctx.profile.tarawihDurationMinutes + 30
        : ctx.profile.tarawihDurationMinutes;
    final end = start.add(Duration(minutes: dur));

    return _block(
      date: date,
      type: TimeBlockType.prayer,
      start: start,
      end: end,
      title: '🌙 Tarawih Prayer',
      subtitle: isOddLastTen
          ? '${_fmtDur(dur)} · Seek Laylat al-Qadr tonight'
          : '${_fmtDur(dur)} · 20 rak\'ah + du\'a',
      priority: BlockPriority.fixed,
    );
  }

  TimeBlock _witrBlock(DateTime date, RamadanDayContext ctx) {
    final start = ctx.times.tarawihEnd;
    const witrDur = 10;
    return _block(
      date: date,
      type: TimeBlockType.prayer,
      start: start,
      end: start.add(const Duration(minutes: witrDur)),
      title: '🌙 Witr Prayer',
      subtitle: '3 rak\'ah · Seal the night with du\'a',
      priority: BlockPriority.fixed,
    );
  }

  TimeBlock _quranBlock(
    DateTime date,
    RamadanDayContext ctx,
    DailyPrayerTimes prayerTimes,
    bool isLastTen, {
    bool afterTarawih = false,
  }) {
    final pages = ctx.profile.ramadanQuranPagesGoal;
    // ~8 min/page estimate; split across 2 sessions in last 10 nights
    final sessionPages = isLastTen ? (pages / 2).ceil() : pages;
    final mins = (sessionPages * 8).clamp(20, 90);

    final start = afterTarawih
        ? ctx.times.tarawihEnd.add(const Duration(minutes: 12))
        : prayerTimes.fajr.prayerEnd().add(const Duration(minutes: 15));

    return _block(
      date: date,
      type: TimeBlockType.quran,
      start: start,
      end: start.add(Duration(minutes: mins)),
      title: afterTarawih ? 'Quran After Tarawih' : 'Quran — Morning Session',
      subtitle: isLastTen
          ? '$sessionPages pages · Last Ten Nights goal'
          : '$pages pages · Aim for 1 juz/day',
      priority: BlockPriority.important,
    );
  }

  TimeBlock _goldenHourBlock(DateTime date, DailyPrayerTimes prayerTimes) {
    return _block(
      date: date,
      type: TimeBlockType.goldenHour,
      start: prayerTimes.fajr.prayerEnd(),
      end: prayerTimes.sunrise.time,
      title: '⭐ Golden Hour',
      subtitle: 'Peak focus · Ramadan barakah window · Quran or du\'a',
      priority: BlockPriority.suggested,
    );
  }

  TimeBlock? _ramadanQaylulaBlock(
    DateTime date,
    DailyPrayerTimes prayerTimes,
    RamadanProfile ramadan,
    RamadanDayContext ctx,
  ) {
    final napStart =
        prayerTimes.dhuhr.prayerEnd().add(const Duration(minutes: 20));
    final napEnd = napStart.add(Duration(minutes: ramadan.daySleepMinutes));
    final asrBuffer = prayerTimes.asr.bufferStart(10);

    if (napEnd.isAfter(asrBuffer)) return null;

    return _block(
      date: date,
      type: TimeBlockType.qaylula,
      start: napStart,
      end: napEnd,
      title: 'Ramadan Qaylula',
      subtitle:
          '${_fmtDur(ramadan.daySleepMinutes)} · Extended nap · Recharge for Iftar',
      priority: BlockPriority.important,
    );
  }

  TimeBlock? _qiyamBlock(DateTime date, RamadanDayContext ctx) {
    // Qiyam al-Layl: last third of the night, before Suhoor
    final lastThird = ctx.times.sehriWakeUp
        .subtract(const Duration(hours: 1, minutes: 30));
    final end = ctx.times.suhoorStart
        .subtract(const Duration(minutes: 5));

    if (end.isBefore(lastThird) ||
        end.difference(lastThird).inMinutes < 20) {
      return null;
    }

    return _block(
      date: date,
      type: TimeBlockType.prayer,
      start: lastThird,
      end: end,
      title: '⭐ Qiyam al-Layl',
      subtitle: 'Night vigil prayer · Seek Laylat al-Qadr',
      priority: BlockPriority.important,
    );
  }

  TimeBlock _dhikrBlock(DateTime date, PrayerTime prayer,
      {String? label}) {
    final start = prayer.prayerEnd();
    final end = start.add(const Duration(minutes: 15));
    return _block(
      date: date,
      type: TimeBlockType.dhikr,
      start: start,
      end: end,
      title: label ?? 'Post-${prayer.name.label} Dhikr',
      subtitle: 'SubhanAllah · Alhamdulillah · Allahu Akbar · Istighfar',
      priority: BlockPriority.suggested,
      linkedPrayer: prayer.name,
    );
  }

  // ─── RAMADAN TIMES BUILDER ────────────────────────────────────────────────
  RamadanTimes _buildRamadanTimes({
    required DateTime date,
    required DailyPrayerTimes prayerTimes,
    required RamadanProfile profile,
    required bool isLastTen,
  }) {
    // Suhoor ends at Fajr (last moment to eat)
    final suhoorEnd = prayerTimes.fajr.time;

    // Suhoor starts [X] minutes before Fajr
    final suhoorStart = suhoorEnd.subtract(
      Duration(minutes: profile.suhoorDurationMinutes),
    );

    // Wake up even earlier to have time before Suhoor
    final sehriWakeUp = suhoorEnd.subtract(
      Duration(minutes: profile.suhoorWakeMinutesBeforeFajr),
    );

    // Iftar = Maghrib adhan
    final iftarTime = prayerTimes.maghrib.time;

    // Tarawih starts after Isha prayer + ~20 min dhikr
    final tarawihStart =
        prayerTimes.isha.prayerEnd().add(const Duration(minutes: 20));

    // Tarawih duration (extended on last 10 odd nights)
    final tarawihDur = isLastTen
        ? profile.tarawihDurationMinutes + 30
        : profile.tarawihDurationMinutes;
    final tarawihEnd = tarawihStart.add(Duration(minutes: tarawihDur));

    // Add Witr after Tarawih
    final witrEnd = profile.praysWitr
        ? tarawihEnd.add(const Duration(minutes: 10))
        : tarawihEnd;

    return RamadanTimes(
      date: date,
      suhoorEnd: suhoorEnd,
      suhoorStart: suhoorStart,
      iftarTime: iftarTime,
      tarawihStart: tarawihStart,
      tarawihEnd: witrEnd,
      sehriWakeUp: sehriWakeUp,
      fajr: prayerTimes.fajr.time,
      maghrib: prayerTimes.maghrib.time,
      isha: prayerTimes.isha.time,
    );
  }

  // ─── GAP / INSERT / FILL (mirrors base generator) ────────────────────────
  List<DateTimeRange> _findFreeGaps(DateTime date, List<TimeBlock> blocks) {
    final dayStart = DateTime(date.year, date.month, date.day, 0, 0);
    final dayEnd = DateTime(date.year, date.month, date.day, 23, 59);
    final sorted = List<TimeBlock>.from(blocks)
      ..sort((a, b) => a.startTime.compareTo(b.startTime));

    final gaps = <DateTimeRange>[];
    var cursor = dayStart;
    for (final b in sorted) {
      if (b.startTime.isAfter(cursor)) {
        gaps.add(DateTimeRange(start: cursor, end: b.startTime));
      }
      if (b.endTime.isAfter(cursor)) cursor = b.endTime;
    }
    if (cursor.isBefore(dayEnd)) {
      gaps.add(DateTimeRange(start: cursor, end: dayEnd));
    }
    return gaps.where((g) => g.durationMinutes >= 5).toList();
  }

  bool _tryInsert({
    required List<TimeBlock> blocks,
    required List<DateTimeRange> gaps,
    required TimeBlock candidate,
    DateTime? preferAfter,
  }) {
    final dur = candidate.durationMinutes;
    final sorted = List<DateTimeRange>.from(gaps)
      ..sort((a, b) => a.start.compareTo(b.start));

    for (final gap in sorted) {
      if (preferAfter != null && gap.end.isBefore(preferAfter)) continue;
      if (gap.durationMinutes >= dur) {
        final start = preferAfter != null && gap.start.isBefore(preferAfter)
            ? preferAfter
            : gap.start;
        final end = start.add(Duration(minutes: dur));
        if (!end.isAfter(gap.end)) {
          final adjusted = candidate.copyWith(startTime: start, endTime: end);
          if (!_hasOverlap(blocks, adjusted)) {
            blocks.add(adjusted);
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

  bool _hasOverlap(List<TimeBlock> blocks, TimeBlock candidate) =>
      blocks.any((b) => b.overlapsWith(candidate));

  void _fillRemainingGaps({
    required List<TimeBlock> blocks,
    required DateTime date,
  }) {
    final gaps = _findFreeGaps(date, blocks);
    for (final gap in gaps) {
      if (gap.start.hour >= 5 &&
          gap.start.hour < 23 &&
          gap.durationMinutes >= 10) {
        blocks.add(_block(
          date: date,
          type: TimeBlockType.freeTime,
          start: gap.start,
          end: gap.end,
          title: 'Free Time',
          subtitle: _fmtDur(gap.durationMinutes),
          priority: BlockPriority.suggested,
        ));
      }
    }
  }

  void _resolveOverlaps(List<TimeBlock> blocks) {
    for (int i = 0; i < blocks.length; i++) {
      for (int j = i + 1; j < blocks.length; j++) {
        if (blocks[i].overlapsWith(blocks[j])) {
          if (blocks[i].priority.index <= blocks[j].priority.index) {
            blocks[j] = blocks[j].copyWith(startTime: blocks[i].endTime);
          } else {
            blocks[i] = blocks[i].copyWith(endTime: blocks[j].startTime);
          }
        }
      }
    }
    blocks.removeWhere((b) => b.durationMinutes <= 0);
  }

  // ─── HELPERS ─────────────────────────────────────────────────────────────
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

  String _fmt(DateTime dt) {
    final h = dt.hour == 0 ? 12 : dt.hour > 12 ? dt.hour - 12 : dt.hour;
    final m = dt.minute.toString().padLeft(2, '0');
    final p = dt.hour < 12 ? 'AM' : 'PM';
    return '$h:$m $p';
  }

  String _fmtDur(int minutes) {
    if (minutes < 60) return '${minutes}m';
    final h = minutes ~/ 60;
    final m = minutes % 60;
    return m == 0 ? '${h}h' : '${h}h ${m}m';
  }
}
