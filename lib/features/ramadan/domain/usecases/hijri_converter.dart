import '../entities/ramadan_entities.dart';

/// Pure Dart Hijri calendar converter.
///
/// Uses the Kuwaiti algorithm (variant of the tabular Islamic calendar)
/// which matches Umm al-Qura within ±1 day for most years.
///
/// For production apps requiring exact Saudi/official Hijri dates,
/// replace [toHijri] with a call to an API (e.g. aladhan.com/v1/gToH).
/// The interface here remains the same so the switch is a one-line change.
class HijriConverter {
  const HijriConverter();

  /// Convert a Gregorian [DateTime] to a [HijriDate].
  HijriDate toHijri(DateTime gregorian) {
    final jd = _gregorianToJulian(gregorian.year, gregorian.month, gregorian.day);
    return _julianToHijri(jd);
  }

  /// Convert a [HijriDate] to a Gregorian [DateTime].
  DateTime toGregorian(HijriDate hijri) {
    final jd = _hijriToJulian(hijri.year, hijri.month, hijri.day);
    return _julianToGregorian(jd);
  }

  /// Returns true if the given Gregorian date falls within Ramadan.
  bool isRamadan(DateTime date) {
    return toHijri(date).isRamadan;
  }

  /// Returns the approximate start of Ramadan for the Hijri year
  /// containing [approximateYear] (Gregorian).
  DateTime ramadanStart(int gregorianYear) {
    // Ramadan 1 of the Hijri year that overlaps with [gregorianYear].
    // The Hijri year ≈ gregorianYear - 622 + (gregorianYear - 622) / 32.
    final estimatedHijriYear = _estimateHijriYear(gregorianYear);
    return toGregorian(HijriDate(year: estimatedHijriYear, month: 9, day: 1));
  }

  /// Returns the first day of Eid al-Fitr (Shawwal 1) for [gregorianYear].
  DateTime eidAlFitr(int gregorianYear) {
    final estimatedHijriYear = _estimateHijriYear(gregorianYear);
    return toGregorian(HijriDate(year: estimatedHijriYear, month: 10, day: 1));
  }

  /// Generate a list of all Ramadan dates for [gregorianYear].
  List<DateTime> ramadanDates(int gregorianYear) {
    final start = ramadanStart(gregorianYear);
    final dates = <DateTime>[];
    for (int i = 0; i < 30; i++) {
      dates.add(start.add(Duration(days: i)));
    }
    return dates;
  }

  /// Returns the Ramadan day number (1–30) for [date], or null if not Ramadan.
  int? ramadanDayNumber(DateTime date) {
    final h = toHijri(date);
    return h.isRamadan ? h.day : null;
  }

  // ─── JULIAN DAY CONVERSIONS ───────────────────────────────────────────────
  int _gregorianToJulian(int year, int month, int day) {
    int a = ((14 - month) / 12).floor();
    int y = year + 4800 - a;
    int m = month + 12 * a - 3;
    return day +
        ((153 * m + 2) / 5).floor() +
        365 * y +
        (y / 4).floor() -
        (y / 100).floor() +
        (y / 400).floor() -
        32045;
  }

  HijriDate _julianToHijri(int jd) {
    final l = jd - 1948440 + 10632;
    final n = ((l - 1) / 10631).floor();
    final l2 = l - 10631 * n + 354;
    final j = (((10985 - l2) / 5316).floor() * ((50 * l2) / 17719).floor()) -
        (((l2) / 5670).floor() * ((43 * l2) / 15238).floor());
    final l3 = l2 -
        (((30 - j) / 15).floor() * ((17719 * j) / 50).floor()) +
        (((j) / 16).floor() * ((15238 * j) / 43).floor()) +
        29;
    final month = (24 * l3 / 709).floor();
    final day = l3 - (709 * month / 24).floor();
    final year = 30 * n + j - 30;
    return HijriDate(year: year, month: month, day: day);
  }

  int _hijriToJulian(int year, int month, int day) {
    // Kuwaiti algorithm (tabular Islamic calendar):
    // JD = (11Y+3)÷30 + 354Y + 30M - ⌊(M-1)/2⌋ + D + 1948440 - 385
    return (11 * year + 3) ~/ 30 +
        354 * year +
        30 * month -
        (month - 1) ~/ 2 +
        day +
        1948440 -
        385;
  }

  DateTime _julianToGregorian(int jd) {
    int l = jd + 68569;
    int n = (4 * l / 146097).floor();
    l = l - (146097 * n + 3) ~/ 4;
    int i = (4000 * (l + 1) / 1461001).floor();
    l = l - (1461 * i / 4).floor() + 31;
    int j = (80 * l / 2447).floor();
    int day = l - (2447 * j / 80).floor();
    l = (j / 11).floor();
    int month = j + 2 - 12 * l;
    int year = 100 * (n - 49) + i + l;
    return DateTime(year, month, day);
  }

  int _estimateHijriYear(int gregorianYear) {
    // Approximate: Hijri year ≈ (Gregorian - 621.5697) × (1 / 0.97022)
    return ((gregorianYear - 621.5697) / 0.97022).round();
  }
}
