import 'package:isar/isar.dart';

import '../../domain/entities/prayer_times.dart';

part 'cached_prayer_day_model.g.dart';

/// Isar collection — one row per calendar day, per location+method key.
///
/// Stores the six prayer/sunrise times needed to reconstruct a
/// [DailyPrayerTimes] without re-running the adhan calculation.
/// The four key fields (calculationMethod, madhab, latitude, longitude)
/// let [PrayerCacheRepositoryImpl.isValid] detect stale rows instantly
/// by sampling a single record.
@collection
class CachedPrayerDayModel {
  Id id = Isar.autoIncrement;

  /// Noon-stripped date — always `DateTime(y, m, d)` so the unique index
  /// on [date] never conflicts with time-of-day variation.
  @Index(unique: true)
  late DateTime date;

  // ── Prayer / sunrise times ──────────────────────────────────────────────────
  late DateTime fajr;
  late DateTime sunrise;
  late DateTime dhuhr;
  late DateTime asr;
  late DateTime maghrib;
  late DateTime isha;

  // ── Cache-key fields (used for invalidation) ────────────────────────────────
  late String calculationMethod;
  late String madhab;
  late double latitude;
  late double longitude;

  // ── Conversions ──────────────────────────────────────────────────────────────

  static CachedPrayerDayModel fromDailyPrayerTimes(
    DailyPrayerTimes times, {
    required String calculationMethod,
    required String madhab,
    required double latitude,
    required double longitude,
  }) {
    final dateOnly =
        DateTime(times.date.year, times.date.month, times.date.day);
    return CachedPrayerDayModel()
      ..date = dateOnly
      ..fajr = times.fajr.time
      ..sunrise = times.sunrise.time
      ..dhuhr = times.dhuhr.time
      ..asr = times.asr.time
      ..maghrib = times.maghrib.time
      ..isha = times.isha.time
      ..calculationMethod = calculationMethod
      ..madhab = madhab
      ..latitude = latitude
      ..longitude = longitude;
  }

  DailyPrayerTimes toEntity() {
    return DailyPrayerTimes(
      date: date,
      fajr: PrayerTime(name: PrayerName.fajr, time: fajr, date: date),
      // sunrise reuses the fajr enum slot — matches PrayerTimeService._mapToDomain
      sunrise: PrayerTime(name: PrayerName.fajr, time: sunrise, date: date),
      dhuhr: PrayerTime(name: PrayerName.dhuhr, time: dhuhr, date: date),
      asr: PrayerTime(name: PrayerName.asr, time: asr, date: date),
      maghrib: PrayerTime(name: PrayerName.maghrib, time: maghrib, date: date),
      isha: PrayerTime(name: PrayerName.isha, time: isha, date: date),
    );
  }
}
