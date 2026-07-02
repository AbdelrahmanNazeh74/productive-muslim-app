import 'package:dartz/dartz.dart';
import 'package:isar/isar.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/prayer_times.dart';
import '../../domain/repositories/prayer_cache_repository.dart';
import '../models/cached_prayer_day_model.dart';

/// Isar-backed implementation of [PrayerCacheRepository].
///
/// Cache-key precision: latitude and longitude are rounded to **4 decimal
/// places** (~11 m) for the stale-detection comparison.  Prayer times don't
/// meaningfully change within that radius, so this avoids spurious re-warms
/// caused by minor GPS jitter.
class PrayerCacheRepositoryImpl implements PrayerCacheRepository {
  final Isar isar;

  const PrayerCacheRepositoryImpl({required this.isar});

  // 4 decimal places ≈ 11 m precision — more than enough for prayer times.
  static const double _latLonPrecision = 10000;

  static double _round(double v) =>
      (v * _latLonPrecision).round() / _latLonPrecision;

  // ── Interface ──────────────────────────────────────────────────────────────

  @override
  Future<Either<Failure, DailyPrayerTimes?>> getDay(DateTime date) async {
    try {
      final dateOnly = DateTime(date.year, date.month, date.day);
      final model = await isar.cachedPrayerDayModels
          .where()
          .dateEqualTo(dateOnly)
          .findFirst();
      return Right(model?.toEntity());
    } catch (e) {
      return Left(CacheFailure('Failed to read prayer cache: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> saveDay(
    DailyPrayerTimes times, {
    required String calculationMethod,
    required String madhab,
    required double latitude,
    required double longitude,
  }) async {
    try {
      final model = CachedPrayerDayModel.fromDailyPrayerTimes(
        times,
        calculationMethod: calculationMethod,
        madhab: madhab,
        latitude: latitude,
        longitude: longitude,
      );

      await isar.writeTxn(() async {
        // Upsert by unique date index — delete old row if present
        final existing = await isar.cachedPrayerDayModels
            .where()
            .dateEqualTo(model.date)
            .findFirst();
        if (existing != null) {
          await isar.cachedPrayerDayModels.delete(existing.id);
        }
        await isar.cachedPrayerDayModels.put(model);
      });

      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('Failed to save prayer cache entry: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> clearAll() async {
    try {
      await isar.writeTxn(() => isar.cachedPrayerDayModels.clear());
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('Failed to clear prayer cache: $e'));
    }
  }

  @override
  Future<Either<Failure, bool>> isValid({
    required String calculationMethod,
    required String madhab,
    required double latitude,
    required double longitude,
  }) async {
    try {
      // Sample the first row — all rows share the same key because clearAll()
      // is always called before re-warming with new settings.
      final sample =
          await isar.cachedPrayerDayModels.where().findFirst();

      if (sample == null) return const Right(false);

      final valid = sample.calculationMethod == calculationMethod &&
          sample.madhab == madhab &&
          _round(sample.latitude) == _round(latitude) &&
          _round(sample.longitude) == _round(longitude);

      return Right(valid);
    } catch (e) {
      return Left(CacheFailure('Failed to validate prayer cache: $e'));
    }
  }

  @override
  Future<Either<Failure, int>> countCachedDays() async {
    try {
      final count = await isar.cachedPrayerDayModels.count();
      return Right(count);
    } catch (e) {
      return Left(CacheFailure('Failed to count cached prayer days: $e'));
    }
  }
}
