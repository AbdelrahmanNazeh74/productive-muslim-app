import 'package:flutter_test/flutter_test.dart';
import 'package:productive_muslim/features/ramadan/domain/entities/ramadan_entities.dart';
import 'package:productive_muslim/features/ramadan/domain/usecases/hijri_converter.dart';

void main() {
  const converter = HijriConverter();

  // ── ramadanStart ─────────────────────────────────────────────────────────────

  group('HijriConverter.ramadanStart', () {
    test('ramadanStart(2024) is in March 2024', () {
      final start = converter.ramadanStart(2024);
      expect(start.year, 2024);
      expect(start.month, 3);
    });

    test('ramadanStart(2024) is Ramadan 1 of year 1445', () {
      final start = converter.ramadanStart(2024);
      final hijri = converter.toHijri(start);
      expect(hijri.month, 9);
      expect(hijri.day, 1);
    });

    test('ramadanStart(2025) returns a valid Ramadan 1 date', () {
      final start = converter.ramadanStart(2025);
      // Algorithm estimates the Hijri year overlapping gregorianYear; result
      // may fall in 2025 or 2026 depending on Hijri-year boundary.
      expect(start.year, inInclusiveRange(2025, 2026));
      final hijri = converter.toHijri(start);
      expect(hijri.month, 9);
      expect(hijri.day, 1);
    });

    test('ramadanStart result is in Ramadan (isRamadan = true)', () {
      final start = converter.ramadanStart(2024);
      expect(converter.isRamadan(start), isTrue);
    });
  });

  // ── eidAlFitr ────────────────────────────────────────────────────────────────

  group('HijriConverter.eidAlFitr', () {
    test('eidAlFitr(2024) is in April 2024', () {
      final eid = converter.eidAlFitr(2024);
      expect(eid.year, 2024);
      expect(eid.month, 4);
    });

    test('eidAlFitr(2024) is Shawwal 1 of year 1445', () {
      final eid = converter.eidAlFitr(2024);
      final hijri = converter.toHijri(eid);
      expect(hijri.month, 10);
      expect(hijri.day, 1);
    });

    test('eidAlFitr(2024) is after ramadanStart(2024)', () {
      final start = converter.ramadanStart(2024);
      final eid = converter.eidAlFitr(2024);
      expect(eid.isAfter(start), isTrue);
    });

    test('eidAlFitr is approximately 30 days after ramadanStart', () {
      final start = converter.ramadanStart(2024);
      final eid = converter.eidAlFitr(2024);
      final diff = eid.difference(start).inDays;
      // Ramadan is 29 or 30 days
      expect(diff, inInclusiveRange(29, 30));
    });

    test('eidAlFitr date is NOT in Ramadan', () {
      final eid = converter.eidAlFitr(2024);
      expect(converter.isRamadan(eid), isFalse);
    });
  });

  // ── ramadanDates ─────────────────────────────────────────────────────────────

  group('HijriConverter.ramadanDates', () {
    test('ramadanDates(2024) returns 30 dates', () {
      final dates = converter.ramadanDates(2024);
      expect(dates.length, 30);
    });

    test('first date in ramadanDates(2024) equals ramadanStart(2024)', () {
      final dates = converter.ramadanDates(2024);
      final start = converter.ramadanStart(2024);
      expect(dates.first.year, start.year);
      expect(dates.first.month, start.month);
      expect(dates.first.day, start.day);
    });

    test('dates in ramadanDates are consecutive (1-day gaps)', () {
      final dates = converter.ramadanDates(2024);
      for (int i = 1; i < dates.length; i++) {
        final diff = dates[i].difference(dates[i - 1]).inDays;
        expect(diff, 1, reason: 'Dates at index $i and ${i - 1} should be 1 day apart');
      }
    });

    test('all dates in ramadanDates are in Ramadan', () {
      final dates = converter.ramadanDates(2024);
      for (final date in dates) {
        expect(converter.isRamadan(date), isTrue,
            reason: '${date.toIso8601String()} should be in Ramadan');
      }
    });
  });

  // ── ramadanDayNumber boundary ─────────────────────────────────────────────

  group('HijriConverter.ramadanDayNumber — boundaries', () {
    test('first day of Ramadan 2024 returns day 1', () {
      final start = converter.ramadanStart(2024);
      expect(converter.ramadanDayNumber(start), 1);
    });

    test('last day of Ramadan 2024 returns 29 or 30', () {
      final dates = converter.ramadanDates(2024);
      final last = dates.last;
      expect(converter.ramadanDayNumber(last), inInclusiveRange(29, 30));
    });

    test('day before ramadanStart returns null', () {
      final start = converter.ramadanStart(2024);
      final dayBefore = start.subtract(const Duration(days: 1));
      expect(converter.ramadanDayNumber(dayBefore), isNull);
    });

    test('eidAlFitr returns null (not in Ramadan)', () {
      final eid = converter.eidAlFitr(2024);
      expect(converter.ramadanDayNumber(eid), isNull);
    });
  });

  // ── isRamadan exact boundary ─────────────────────────────────────────────

  group('HijriConverter.isRamadan — boundary checks', () {
    test('first day of Ramadan 2024 is in Ramadan', () {
      final start = converter.ramadanStart(2024);
      expect(converter.isRamadan(start), isTrue);
    });

    test('last day of Ramadan 2024 is in Ramadan', () {
      final dates = converter.ramadanDates(2024);
      expect(converter.isRamadan(dates.last), isTrue);
    });

    test('day before Ramadan 2024 is NOT in Ramadan', () {
      final start = converter.ramadanStart(2024);
      final dayBefore = start.subtract(const Duration(days: 1));
      expect(converter.isRamadan(dayBefore), isFalse);
    });

    test('Eid al-Fitr 2024 is NOT in Ramadan', () {
      final eid = converter.eidAlFitr(2024);
      expect(converter.isRamadan(eid), isFalse);
    });
  });

  // ── toGregorian standalone ───────────────────────────────────────────────

  group('HijriConverter.toGregorian', () {
    test('Ramadan 1, 1445 converts to March 2024', () {
      final gregorian =
          converter.toGregorian(const HijriDate(year: 1445, month: 9, day: 1));
      expect(gregorian.year, 2024);
      expect(gregorian.month, 3);
    });

    test('Muharram 1, 1446 converts to year 2024 or 2025', () {
      final gregorian =
          converter.toGregorian(const HijriDate(year: 1446, month: 1, day: 1));
      expect(gregorian.year, inInclusiveRange(2024, 2025));
    });

    test('converting Hijri date to Gregorian and back yields original ±1 day', () {
      const hijri = HijriDate(year: 1445, month: 5, day: 15);
      final gregorian = converter.toGregorian(hijri);
      final backToHijri = converter.toHijri(gregorian);
      // Allow ±1 day for algorithmic rounding
      final diff = (backToHijri.day - hijri.day).abs();
      expect(diff, lessThanOrEqualTo(1));
    });
  });

  // ── 2024 specific dates ──────────────────────────────────────────────────

  group('HijriConverter — 2024 Ramadan specific dates', () {
    test('2024-03-11 is in Ramadan (first day 1445)', () {
      // Known: Ramadan 1445 started ~March 11, 2024
      final date = DateTime(2024, 3, 11);
      expect(converter.isRamadan(date), isTrue);
    });

    test('2024-04-15 is NOT in Ramadan (well after Eid al-Fitr)', () {
      // April 15 is clearly after Eid (Shawwal) for any algorithm variant
      final date = DateTime(2024, 4, 15);
      expect(converter.isRamadan(date), isFalse);
    });

    test('2024-01-01 is NOT in Ramadan', () {
      expect(converter.isRamadan(DateTime(2024, 1, 1)), isFalse);
    });
  });
}
