import 'package:flutter_test/flutter_test.dart';
import 'package:productive_muslim/core/services/widget_update_service.dart';
import 'package:productive_muslim/features/prayer/domain/entities/prayer_times.dart';
import 'package:productive_muslim/features/timeline/domain/entities/time_block.dart';

// ── Helpers ───────────────────────────────────────────────────────────────────

/// Fixed reference instant — all tests share this "now".
final kNow = DateTime(2024, 6, 1, 10, 0); // 10:00 AM

TimeBlock _makePrayerBlock({
  required String title,
  required DateTime startTime,
  bool completed = false,
}) {
  return TimeBlock(
    id: 'prayer-$title',
    type: TimeBlockType.prayer,
    title: title,
    startTime: startTime,
    endTime: startTime.add(const Duration(minutes: 15)),
    priority: BlockPriority.fixed,
    isCompleted: completed,
  );
}

TimeBlock _makeBlock({
  required String title,
  required DateTime startTime,
  required DateTime endTime,
  TimeBlockType type = TimeBlockType.work,
}) {
  return TimeBlock(
    id: 'block-$title',
    type: type,
    title: title,
    startTime: startTime,
    endTime: endTime,
    priority: BlockPriority.flexible,
  );
}

DailyTimeline _makeTimeline(List<TimeBlock> blocks) {
  return DailyTimeline(
    date: DateTime(2024, 6, 1),
    dayType: DayType.weekday,
    blocks: blocks,
    generatedAt: DateTime(2024, 6, 1),
  );
}

DailyPrayerTimes _makePrayerTimes({DateTime? dhuhrOverride}) {
  final d = DateTime(2024, 6, 1);
  return DailyPrayerTimes(
    date: d,
    fajr: PrayerTime(
        name: PrayerName.fajr, time: DateTime(2024, 6, 1, 4, 30), date: d),
    sunrise: PrayerTime(
        name: PrayerName.fajr, time: DateTime(2024, 6, 1, 6, 0), date: d),
    dhuhr: PrayerTime(
        name: PrayerName.dhuhr,
        time: dhuhrOverride ?? DateTime(2024, 6, 1, 12, 30),
        date: d),
    asr: PrayerTime(
        name: PrayerName.asr, time: DateTime(2024, 6, 1, 15, 45), date: d),
    maghrib: PrayerTime(
        name: PrayerName.maghrib, time: DateTime(2024, 6, 1, 19, 30), date: d),
    isha: PrayerTime(
        name: PrayerName.isha, time: DateTime(2024, 6, 1, 21, 0), date: d),
  );
}

// ── Tests ─────────────────────────────────────────────────────────────────────

void main() {
  group('WidgetUpdateService.buildData', () {
    // ── Null / empty inputs ─────────────────────────────────────────────────
    test('all nulls → every field is em-dash', () {
      final d = WidgetUpdateService.buildData(
          timeline: null, prayerTimes: null, now: kNow);
      expect(d.nextPrayerName, '—');
      expect(d.nextPrayerTime, '—');
      expect(d.timeRemaining, '—');
      expect(d.currentBlockTitle, '—');
    });

    test('empty timeline + null prayerTimes → all dashes', () {
      final d = WidgetUpdateService.buildData(
          timeline: _makeTimeline([]), prayerTimes: null, now: kNow);
      expect(d.nextPrayerName, '—');
      expect(d.currentBlockTitle, '—');
    });

    // ── Next prayer from timeline blocks ────────────────────────────────────
    test('picks first upcoming prayer block', () {
      final blocks = [
        _makePrayerBlock(title: 'Dhuhr', startTime: DateTime(2024, 6, 1, 12, 30))
      ];
      final d = WidgetUpdateService.buildData(
          timeline: _makeTimeline(blocks), prayerTimes: null, now: kNow);
      expect(d.nextPrayerName, 'Dhuhr');
      expect(d.nextPrayerTime, '12:30 PM');
      expect(d.timeRemaining, '2h 30m');
    });

    test('skips completed prayer blocks', () {
      final blocks = [
        _makePrayerBlock(
            title: 'Dhuhr',
            startTime: DateTime(2024, 6, 1, 12, 30),
            completed: true),
        _makePrayerBlock(title: 'Asr', startTime: DateTime(2024, 6, 1, 15, 45)),
      ];
      final d = WidgetUpdateService.buildData(
          timeline: _makeTimeline(blocks), prayerTimes: null, now: kNow);
      expect(d.nextPrayerName, 'Asr');
      expect(d.nextPrayerTime, '3:45 PM');
    });

    test('skips prayer blocks that are in the past', () {
      final blocks = [
        // Fajr already passed (before kNow = 10:00)
        _makePrayerBlock(title: 'Fajr', startTime: DateTime(2024, 6, 1, 5, 0)),
        _makePrayerBlock(title: 'Dhuhr', startTime: DateTime(2024, 6, 1, 12, 30)),
      ];
      final d = WidgetUpdateService.buildData(
          timeline: _makeTimeline(blocks), prayerTimes: null, now: kNow);
      expect(d.nextPrayerName, 'Dhuhr');
    });

    test('all prayer blocks completed/past → dash from prayer name', () {
      final blocks = [
        _makePrayerBlock(
            title: 'Fajr',
            startTime: DateTime(2024, 6, 1, 5, 0),
            completed: true),
      ];
      final d = WidgetUpdateService.buildData(
          timeline: _makeTimeline(blocks), prayerTimes: null, now: kNow);
      expect(d.nextPrayerName, '—');
    });

    // ── prayerTimes fallback ────────────────────────────────────────────────
    test('falls back to prayerTimes when timeline has no prayer blocks', () {
      final timeline = _makeTimeline([
        _makeBlock(
            title: 'Work',
            startTime: DateTime(2024, 6, 1, 9, 0),
            endTime: DateTime(2024, 6, 1, 12, 0))
      ]);
      final d = WidgetUpdateService.buildData(
          timeline: timeline,
          prayerTimes: _makePrayerTimes(dhuhrOverride: DateTime(2024, 6, 1, 12, 30)),
          now: kNow);
      expect(d.nextPrayerName, 'Dhuhr');
      expect(d.nextPrayerTime, '12:30 PM');
      expect(d.timeRemaining, '2h 30m');
    });

    test('prayerTimes fallback skips prayers already past', () {
      // now = 10:00; fajr 4:30, dhuhr 12:30 — should skip fajr/sunrise
      final d = WidgetUpdateService.buildData(
          timeline: _makeTimeline([]),
          prayerTimes: _makePrayerTimes(),
          now: kNow);
      expect(d.nextPrayerName, 'Dhuhr');
    });

    test('prayerTimes fallback → null prayerTimes → dashes', () {
      final d = WidgetUpdateService.buildData(
          timeline: null, prayerTimes: null, now: kNow);
      expect(d.nextPrayerName, '—');
      expect(d.timeRemaining, '—');
    });

    // ── Duration formatting ─────────────────────────────────────────────────
    test('formats hours + minutes (e.g. 2h 30m)', () {
      final d = WidgetUpdateService.buildData(
          timeline: _makeTimeline([
            _makePrayerBlock(
                title: 'Dhuhr', startTime: DateTime(2024, 6, 1, 12, 30))
          ]),
          prayerTimes: null,
          now: kNow); // 10:00 → 2h 30m
      expect(d.timeRemaining, '2h 30m');
    });

    test('formats minutes-only when < 1 hour (e.g. 45m)', () {
      final d = WidgetUpdateService.buildData(
          timeline: _makeTimeline([
            _makePrayerBlock(
                title: 'Asr', startTime: DateTime(2024, 6, 1, 10, 45))
          ]),
          prayerTimes: null,
          now: kNow); // 10:00 → 45m
      expect(d.timeRemaining, '45m');
    });

    test('formats 0 minutes as "0m"', () {
      final d = WidgetUpdateService.buildData(
          timeline: _makeTimeline([
            _makePrayerBlock(
                title: 'Asr', startTime: DateTime(2024, 6, 1, 10, 0))
          ]),
          prayerTimes: null,
          now: DateTime(2024, 6, 1, 10, 0)); // exactly now
      expect(d.timeRemaining, '0m');
    });

    test('formats exactly 1h as "1h 0m"', () {
      final d = WidgetUpdateService.buildData(
          timeline: _makeTimeline([
            _makePrayerBlock(
                title: 'Asr', startTime: DateTime(2024, 6, 1, 11, 0))
          ]),
          prayerTimes: null,
          now: kNow); // 10:00 → 1h 0m
      expect(d.timeRemaining, '1h 0m');
    });

    test('formats single-digit minutes within an hour (e.g. 1h 5m)', () {
      final d = WidgetUpdateService.buildData(
          timeline: _makeTimeline([
            _makePrayerBlock(
                title: 'Dhuhr', startTime: DateTime(2024, 6, 1, 11, 5))
          ]),
          prayerTimes: null,
          now: kNow); // 10:00 → 1h 5m
      expect(d.timeRemaining, '1h 5m');
    });

    // ── Time formatting ─────────────────────────────────────────────────────
    test('formats noon as "12:00 PM"', () {
      final d = WidgetUpdateService.buildData(
          timeline: _makeTimeline([
            _makePrayerBlock(
                title: 'Dhuhr', startTime: DateTime(2024, 6, 1, 12, 0))
          ]),
          prayerTimes: null,
          now: kNow);
      expect(d.nextPrayerTime, '12:00 PM');
    });

    test('formats midnight as "12:00 AM"', () {
      final d = WidgetUpdateService.buildData(
          timeline: _makeTimeline([
            _makePrayerBlock(
                title: 'Isha', startTime: DateTime(2024, 6, 2, 0, 0))
          ]),
          prayerTimes: null,
          now: DateTime(2024, 6, 1, 22, 0)); // 10 PM
      expect(d.nextPrayerTime, '12:00 AM');
    });

    test('formats 1:00 AM correctly', () {
      final d = WidgetUpdateService.buildData(
          timeline: _makeTimeline([
            _makePrayerBlock(
                title: 'Isha', startTime: DateTime(2024, 6, 2, 1, 0))
          ]),
          prayerTimes: null,
          now: DateTime(2024, 6, 1, 22, 0));
      expect(d.nextPrayerTime, '1:00 AM');
    });

    test('formats 1:00 PM correctly', () {
      final d = WidgetUpdateService.buildData(
          timeline: _makeTimeline([
            _makePrayerBlock(
                title: 'Asr', startTime: DateTime(2024, 6, 1, 13, 0))
          ]),
          prayerTimes: null,
          now: kNow);
      expect(d.nextPrayerTime, '1:00 PM');
    });

    // ── Current block detection ─────────────────────────────────────────────
    test('shows active block whose range covers now', () {
      final d = WidgetUpdateService.buildData(
          timeline: _makeTimeline([
            _makeBlock(
                title: 'Deep Work',
                startTime: DateTime(2024, 6, 1, 9, 0),
                endTime: DateTime(2024, 6, 1, 11, 0))
          ]),
          prayerTimes: null,
          now: kNow); // 10:00 is inside 09:00–11:00
      expect(d.currentBlockTitle, 'Deep Work');
    });

    test('shows "Up next: X" when no block is currently active', () {
      final d = WidgetUpdateService.buildData(
          timeline: _makeTimeline([
            _makeBlock(
                title: 'Quran',
                startTime: DateTime(2024, 6, 1, 11, 0),
                endTime: DateTime(2024, 6, 1, 11, 30))
          ]),
          prayerTimes: null,
          now: kNow); // 10:00 — Quran starts at 11:00
      expect(d.currentBlockTitle, 'Up next: Quran');
    });

    test('returns dash when all blocks are in the past', () {
      final d = WidgetUpdateService.buildData(
          timeline: _makeTimeline([
            _makeBlock(
                title: 'Fajr Routine',
                startTime: DateTime(2024, 6, 1, 5, 0),
                endTime: DateTime(2024, 6, 1, 6, 0))
          ]),
          prayerTimes: null,
          now: kNow);
      expect(d.currentBlockTitle, '—');
    });

    test('active block wins over future block when both are present', () {
      final d = WidgetUpdateService.buildData(
          timeline: _makeTimeline([
            _makeBlock(
                title: 'Work',
                startTime: DateTime(2024, 6, 1, 8, 0),
                endTime: DateTime(2024, 6, 1, 12, 0)),
            _makeBlock(
                title: 'Gym',
                startTime: DateTime(2024, 6, 1, 13, 0),
                endTime: DateTime(2024, 6, 1, 14, 0)),
          ]),
          prayerTimes: null,
          now: kNow); // 10:00 is inside Work block
      expect(d.currentBlockTitle, 'Work');
    });

    test('prayer block active at now is shown as current block', () {
      final d = WidgetUpdateService.buildData(
          timeline: _makeTimeline([
            _makePrayerBlock(
                title: 'Fajr', startTime: DateTime(2024, 6, 1, 9, 55)),
          ]),
          prayerTimes: null,
          now: kNow); // 10:00 is inside Fajr 09:55–10:10
      expect(d.currentBlockTitle, 'Fajr');
      // Fajr has already started so it won't appear as nextPrayerName
      expect(d.nextPrayerName, '—');
    });
  });
}
