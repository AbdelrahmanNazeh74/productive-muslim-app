import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/prayer_times.dart';

/// Domain contract for the offline prayer-time cache.
///
/// Implementations persist [DailyPrayerTimes] rows to a local store
/// (Isar in production) keyed by date + location/method fingerprint.
abstract class PrayerCacheRepository {
  /// Returns the cached [DailyPrayerTimes] for [date], or `null` if not found.
  Future<Either<Failure, DailyPrayerTimes?>> getDay(DateTime date);

  /// Persists a single day.  The four key fields are stored alongside the
  /// prayer times so [isValid] can detect a stale cache instantly.
  Future<Either<Failure, void>> saveDay(
    DailyPrayerTimes times, {
    required String calculationMethod,
    required String madhab,
    required double latitude,
    required double longitude,
  });

  /// Drops every cached row — called before a full re-warm.
  Future<Either<Failure, void>> clearAll();

  /// Returns `true` when at least one cached row exists AND its key matches
  /// the supplied parameters (within 4-decimal-place lat/lon precision).
  ///
  /// Returns `false` when the cache is empty or was built with different
  /// settings — the caller should [clearAll] then re-warm.
  Future<Either<Failure, bool>> isValid({
    required String calculationMethod,
    required String madhab,
    required double latitude,
    required double longitude,
  });

  /// Number of distinct days currently in the cache.
  Future<Either<Failure, int>> countCachedDays();
}
