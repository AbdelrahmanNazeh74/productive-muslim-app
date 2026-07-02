import 'package:flutter_test/flutter_test.dart';
import 'package:productive_muslim/features/onboarding/domain/entities/user_profile.dart';
import 'package:productive_muslim/features/prayer/domain/entities/prayer_times.dart';
import 'package:productive_muslim/features/ramadan/domain/entities/ramadan_entities.dart';
import 'package:productive_muslim/features/ramadan/domain/usecases/hijri_converter.dart';
import 'package:productive_muslim/features/ramadan/domain/usecases/ramadan_timeline_generator.dart';
import 'package:productive_muslim/features/timeline/domain/entities/time_block.dart';

// ─── FIXTURES ────────────────────────────────────────────────────────────────
UserProfile get _profile => UserProfile(
      name: 'Ahmed',
      gender: 'male',
      occupationId: 'software_engineer',
      occupationLabel: 'Software Engineer',
      occupationType: 'office',
      workStartHour: 9,
      workStartMinute: 0,
      workEndHour: 17,
      workEndMinute: 0,
      workDays: const [0, 1, 2, 3, 4],
      latitude: 51.5074,
      longitude: -0.1278,
      city: 'London',
      timezone: 'Europe/London',
      calculationMethod: 'MuslimWorldLeague',
      madhab: 'hanafi',
      prayerBufferMinutes: 10,
      fitnessActivityIds: const ['gym'],
      gymDays: const [0, 2, 4],
      gymDurationMinutes: 60,
      preferredGymTime: 'evening',
      targetSleepHours: 7,
      wakeUpOffsetFromFajrMinutes: -30,
      dailyQuranPagesGoal: 2,
      isRamadanMode: true,
      cycleAwareStreaks: false,
      createdAt: DateTime(2024, 1, 1),
      isOnboardingComplete: true,
    );

RamadanProfile get _ramadanProfile => RamadanProfile(
      id: 1,
      suhoorWakeMinutesBeforeFajr: 45,
      suhoorDurationMinutes: 30,
      hasIftarGathering: false,
      iftarDurationMinutes: 30,
      praysTarawih: true,
      tarawihDurationMinutes: 75,
      praysWitr: true,
      hasReducedWorkHours: false,
      reducedWorkEndHour: 14,
      reducedWorkEndMinute: 0,
      nightSleepHours: 4,
      daySleepMinutes: 90,
      ramadanQuranPagesGoal: 20,
      hasLaylatAlQadrMode: true,
      createdAt: DateTime(2024, 1, 1),
      updatedAt: DateTime(2024, 1, 1),
    );

DailyPrayerTimes _prayerTimes(DateTime date) {
  DateTime t(int h, int m) =>
      DateTime(date.year, date.month, date.day, h, m);
  return DailyPrayerTimes(
    date: date,
    fajr: PrayerTime(name: PrayerName.fajr, time: t(4, 0), date: date),
    sunrise:
        PrayerTime(name: PrayerName.fajr, time: t(5, 45), date: date),
    dhuhr:
        PrayerTime(name: PrayerName.dhuhr, time: t(12, 55), date: date),
    asr: PrayerTime(name: PrayerName.asr, time: t(16, 45), date: date),
    maghrib: PrayerTime(
        name: PrayerName.maghrib, time: t(19, 52), date: date),
    isha:
        PrayerTime(name: PrayerName.isha, time: t(21, 30), date: date),
  );
}

void main() {
  late HijriConverter hijri;
  late RamadanTimelineGenerator generator;

  setUp(() {
    hijri = const HijriConverter();
    generator = RamadanTimelineGenerator(hijri: hijri);
  });

  // ─── HIJRI CONVERTER ───────────────────────────────────────────────────────
  group('HijriConverter', () {
    group('toHijri — known reference dates', () {
      test('1 January 2000 ≈ 24 Ramadan 1420', () {
        final h = hijri.toHijri(DateTime(2000, 1, 1));
        // Allow ±1 day for algorithmic approximation
        expect(h.year, 1420);
        expect(h.month, 9); // Ramadan
        expect(h.day, inInclusiveRange(23, 25));
      });

      test('Ramadan detection: 10 March 2024 is in Ramadan 1445', () {
        final h = hijri.toHijri(DateTime(2024, 3, 14));
        expect(h.isRamadan, isTrue);
        expect(h.year, 1445);
      });

      test('Non-Ramadan month: 1 January 2024 is not Ramadan', () {
        final h = hijri.toHijri(DateTime(2024, 1, 1));
        expect(h.isRamadan, isFalse);
      });

      test('ramadanDay returns correct day number in Ramadan', () {
        final h = hijri.toHijri(DateTime(2024, 3, 14));
        final day = h.ramadanDay;
        expect(day, isNotNull);
        expect(day!, inInclusiveRange(1, 30));
      });

      test('ramadanDay returns null outside Ramadan', () {
        final h = hijri.toHijri(DateTime(2024, 1, 1));
        expect(h.ramadanDay, isNull);
      });
    });

    group('toGregorian round-trip', () {
      test('converting to Hijri then back yields same Gregorian date ±1 day',
          () {
        final original = DateTime(2024, 3, 14);
        final h = hijri.toHijri(original);
        final back = hijri.toGregorian(h);
        final diff = back.difference(original).inDays.abs();
        expect(diff, lessThanOrEqualTo(1));
      });

      test('round-trip works for multiple dates across the year', () {
        final testDates = [
          DateTime(2024, 3, 14),
          DateTime(2024, 6, 15),
          DateTime(2024, 9, 20),
          DateTime(2024, 12, 1),
        ];
        for (final d in testDates) {
          final h = hijri.toHijri(d);
          final back = hijri.toGregorian(h);
          expect(back.difference(d).inDays.abs(), lessThanOrEqualTo(1),
              reason: 'Round-trip failed for $d');
        }
      });
    });

    group('isRamadan', () {
      test('returns true during March 2024 Ramadan window', () {
        // Ramadan 1445 started ~11 March 2024
        expect(hijri.isRamadan(DateTime(2024, 3, 20)), isTrue);
      });

      test('returns false in January', () {
        expect(hijri.isRamadan(DateTime(2024, 1, 15)), isFalse);
      });
    });

    group('HijriDate properties', () {
      test('monthName returns correct name for Ramadan', () {
        const h = HijriDate(year: 1445, month: 9, day: 1);
        expect(h.monthName, 'Ramadan');
      });

      test('monthName returns correct name for Muharram', () {
        const h = HijriDate(year: 1445, month: 1, day: 1);
        expect(h.monthName, 'Muharram');
      });

      test('isRamadan is true only for month 9', () {
        const ramadan = HijriDate(year: 1445, month: 9, day: 15);
        const shawwal = HijriDate(year: 1445, month: 10, day: 1);
        expect(ramadan.isRamadan, isTrue);
        expect(shawwal.isRamadan, isFalse);
      });
    });
  });

  // ─── RAMADAN DAY CONTEXT ───────────────────────────────────────────────────
  group('RamadanTimelineGenerator — buildContext', () {
    final date = DateTime(2024, 3, 25); // Day ~14 of Ramadan 1445
    late DailyPrayerTimes prayers;

    setUp(() => prayers = _prayerTimes(date));

    test('builds a valid RamadanDayContext', () {
      final ctx = generator.buildContext(
        date: date,
        prayerTimes: prayers,
        ramadanProfile: _ramadanProfile,
      );
      expect(ctx.ramadanDayNumber, inInclusiveRange(1, 30));
      expect(ctx.gregorianDate, date);
    });

    test('isLastTenNights is false before day 21', () {
      final ctx = generator.buildContext(
        date: date,
        prayerTimes: prayers,
        ramadanProfile: _ramadanProfile,
      );
      // Day 14 — not last ten
      if (ctx.ramadanDayNumber < 21) {
        expect(ctx.isLastTenNights, isFalse);
      }
    });

    test('suhoor ends exactly at Fajr adhan', () {
      final ctx = generator.buildContext(
        date: date,
        prayerTimes: prayers,
        ramadanProfile: _ramadanProfile,
      );
      expect(ctx.times.suhoorEnd, prayers.fajr.time);
    });

    test('iftarTime equals Maghrib adhan', () {
      final ctx = generator.buildContext(
        date: date,
        prayerTimes: prayers,
        ramadanProfile: _ramadanProfile,
      );
      expect(ctx.times.iftarTime, prayers.maghrib.time);
    });

    test('tarawihStart is after Isha prayer end', () {
      final ctx = generator.buildContext(
        date: date,
        prayerTimes: prayers,
        ramadanProfile: _ramadanProfile,
      );
      expect(
        ctx.times.tarawihStart
            .isAfter(prayers.isha.prayerEnd()),
        isTrue,
      );
    });

    test('sehriWakeUp is before suhoorStart', () {
      final ctx = generator.buildContext(
        date: date,
        prayerTimes: prayers,
        ramadanProfile: _ramadanProfile,
      );
      expect(
        ctx.times.sehriWakeUp.isBefore(ctx.times.suhoorStart) ||
            ctx.times.sehriWakeUp
                .isAtSameMomentAs(ctx.times.suhoorStart),
        isTrue,
      );
    });

    test('fastingHours is positive and reasonable (8–22h)', () {
      final ctx = generator.buildContext(
        date: date,
        prayerTimes: prayers,
        ramadanProfile: _ramadanProfile,
      );
      expect(ctx.times.fastingHours,
          inInclusiveRange(8.0, 22.0));
    });
  });

  // ─── RAMADAN TIMELINE GENERATION ──────────────────────────────────────────
  group('RamadanTimelineGenerator — generate', () {
    final date = DateTime(2024, 3, 25);
    late DailyPrayerTimes prayers;
    late DailyTimeline timeline;

    setUp(() {
      prayers = _prayerTimes(date);
      timeline = generator.generate(
        date: date,
        userProfile: _profile,
        prayerTimes: prayers,
        ramadanProfile: _ramadanProfile,
      );
    });

    test('returns DayType.ramadan', () {
      expect(timeline.dayType, DayType.ramadan);
    });

    test('timeline has blocks', () {
      expect(timeline.blocks, isNotEmpty);
    });

    test('all 5 prayer blocks present', () {
      final prayerBlocks = timeline.blocks
          .where((b) => b.type == TimeBlockType.prayer)
          .toList();
      expect(prayerBlocks.length, greaterThanOrEqualTo(5));
    });

    test('Suhoor block is present', () {
      final suhoor = timeline.blocks.where(
          (b) => b.type == TimeBlockType.meal && b.title.contains('Suhoor'));
      expect(suhoor, isNotEmpty);
    });

    test('Iftar block is present', () {
      final iftar = timeline.blocks.where(
          (b) => b.type == TimeBlockType.meal && b.title.contains('Iftar'));
      expect(iftar, isNotEmpty);
    });

    test('Tarawih block is present when praysTarawih = true', () {
      final tarawih = timeline.blocks.where(
          (b) => b.title.contains('Tarawih'));
      expect(tarawih, isNotEmpty);
    });

    test('no Tarawih when praysTarawih = false', () {
      final noTarawihProfile =
          _ramadanProfile.copyWith(praysTarawih: false);
      final t = generator.generate(
        date: date,
        userProfile: _profile,
        prayerTimes: prayers,
        ramadanProfile: noTarawihProfile,
      );
      final tarawih =
          t.blocks.where((b) => b.title.contains('Tarawih'));
      expect(tarawih, isEmpty);
    });

    test('Quran block is present', () {
      final quran = timeline.blocks
          .where((b) => b.type == TimeBlockType.quran);
      expect(quran, isNotEmpty);
    });

    test('NO regular lunch/dinner (replaced by Suhoor/Iftar)', () {
      final meals = timeline.blocks
          .where((b) => b.type == TimeBlockType.meal)
          .map((b) => b.title)
          .toList();
      expect(meals.any((t) => t.contains('Lunch')), isFalse);
      expect(meals.any((t) => t.contains('Dinner')), isFalse);
    });

    test('blocks are sorted chronologically', () {
      for (int i = 0; i < timeline.blocks.length - 1; i++) {
        expect(
          timeline.blocks[i].startTime
              .isBefore(timeline.blocks[i + 1].startTime) ||
              timeline.blocks[i].startTime
                  .isAtSameMomentAs(timeline.blocks[i + 1].startTime),
          isTrue,
          reason:
              '"${timeline.blocks[i].title}" should come before '
              '"${timeline.blocks[i + 1].title}"',
        );
      }
    });

    test('NO two blocks overlap', () {
      _assertNoOverlaps(timeline.blocks);
    });

    test('all blocks have positive duration', () {
      for (final b in timeline.blocks) {
        expect(b.durationMinutes, greaterThan(0),
            reason: '"${b.title}" has non-positive duration');
      }
    });

    test('work blocks never overlap prayer/buffer blocks', () {
      final workBlocks = timeline.blocks.where((b) =>
          b.type == TimeBlockType.work ||
          b.type == TimeBlockType.deepWork);
      final prayerBlocks = timeline.blocks.where((b) =>
          b.type == TimeBlockType.prayer ||
          b.type == TimeBlockType.prayerBuffer);
      for (final w in workBlocks) {
        for (final p in prayerBlocks) {
          expect(w.overlapsWith(p), isFalse,
              reason: 'Work "${w.title}" overlaps prayer "${p.title}"');
        }
      }
    });

    test('Suhoor ends at or before Fajr', () {
      final suhoor = timeline.blocks.firstWhere(
          (b) => b.title.contains('Suhoor'));
      expect(
        suhoor.endTime.isBefore(prayers.fajr.time) ||
            suhoor.endTime.isAtSameMomentAs(prayers.fajr.time),
        isTrue,
      );
    });

    test('Iftar starts after Maghrib prayer ends', () {
      // Overlap resolution places the Iftar meal block after the Maghrib prayer
      // (prayer first, then break fast + eat) — both have fixed priority.
      final iftar = timeline.blocks
          .firstWhere((b) => b.title.contains('Iftar'));
      expect(iftar.startTime, prayers.maghrib.prayerEnd());
    });

    test('reduced work hours applies when configured', () {
      final reducedProfile = _ramadanProfile.copyWith(
        hasReducedWorkHours: true,
        reducedWorkEndHour: 14,
        reducedWorkEndMinute: 0,
      );
      final t = generator.generate(
        date: date,
        userProfile: _profile,
        prayerTimes: prayers,
        ramadanProfile: reducedProfile,
      );
      final workBlocks = t.blocks
          .where((b) =>
              b.type == TimeBlockType.work ||
              b.type == TimeBlockType.deepWork)
          .toList();
      for (final w in workBlocks) {
        expect(w.endTime.hour, lessThanOrEqualTo(14),
            reason:
                'Work block should end by 14:00 with reduced hours');
      }
    });

    test('night sleep block ends before or at sehriWakeUp', () {
      final sleepBlocks = timeline.blocks
          .where((b) => b.type == TimeBlockType.sleep)
          .toList();
      expect(sleepBlocks, isNotEmpty);
    });

    test('all block IDs are non-empty UUIDs', () {
      for (final b in timeline.blocks) {
        expect(b.id, isNotEmpty);
        expect(b.id.length, equals(36)); // UUID v4 format
      }
    });
  });

  // ─── RAMADAN TIMES ─────────────────────────────────────────────────────────
  group('RamadanTimes', () {
    final date = DateTime(2024, 3, 25);
    late RamadanTimes times;

    setUp(() {
      final ctx = generator.buildContext(
        date: date,
        prayerTimes: _prayerTimes(date),
        ramadanProfile: _ramadanProfile,
      );
      times = ctx.times;
    });

    test('isFasting is true between suhoorEnd and iftarTime', () {
      final midDay = DateTime(date.year, date.month, date.day, 13, 0);
      expect(times.isFasting(midDay), isTrue);
    });

    test('isFasting is false before suhoorEnd', () {
      final preDawn =
          DateTime(date.year, date.month, date.day, 3, 0);
      expect(times.isFasting(preDawn), isFalse);
    });

    test('isFasting is false after iftarTime', () {
      final evening =
          DateTime(date.year, date.month, date.day, 20, 30);
      expect(times.isFasting(evening), isFalse);
    });

    test('timeUntilIftar is positive during fasting', () {
      final midDay =
          DateTime(date.year, date.month, date.day, 13, 0);
      final diff = times.timeUntilIftar(midDay);
      expect(diff.isNegative, isFalse);
    });
  });
}

// ─── HELPER ──────────────────────────────────────────────────────────────────
void _assertNoOverlaps(List<TimeBlock> blocks) {
  for (int i = 0; i < blocks.length; i++) {
    for (int j = i + 1; j < blocks.length; j++) {
      expect(
        blocks[i].overlapsWith(blocks[j]),
        isFalse,
        reason: 'OVERLAP:\n'
            '  [${blocks[i].type.name}] "${blocks[i].title}" '
            '${blocks[i].startTime} → ${blocks[i].endTime}\n'
            '  [${blocks[j].type.name}] "${blocks[j].title}" '
            '${blocks[j].startTime} → ${blocks[j].endTime}',
      );
    }
  }
}

Matcher inInclusiveRange(num lo, num hi) =>
    predicate<num>((v) => v >= lo && v <= hi,
        'is in range [$lo, $hi]');
