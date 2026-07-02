import 'package:adhan/adhan.dart' as adhan;
import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../onboarding/domain/entities/user_profile.dart';
import '../../domain/entities/prayer_times.dart' as domain;
import '../../domain/repositories/prayer_cache_repository.dart';

/// Wraps the `adhan` package and returns clean domain [DailyPrayerTimes].
///
/// Optionally takes a [PrayerCacheRepository].  When present,
/// [getPrayerTimesAsync] performs a cache-first lookup and falls back to the
/// live adhan calculation only on a miss.  The synchronous [getPrayerTimes]
/// always uses live calculation — it remains unchanged so existing callers
/// (TimelineBloc, GenerateAndSaveTimeline, etc.) are unaffected.
class PrayerTimeService {
  final PrayerCacheRepository? _cache;

  PrayerTimeService({PrayerCacheRepository? cache}) : _cache = cache;

  // ── Cache-first async path ──────────────────────────────────────────────────

  /// Returns prayer times from the Isar cache when available; otherwise
  /// falls back to [getPrayerTimes].  Use this in flows that run after the
  /// cache has been warmed (e.g. notification scheduling).
  Future<Either<Failure, domain.DailyPrayerTimes>> getPrayerTimesAsync({
    required UserProfile profile,
    required DateTime date,
  }) async {
    if (_cache != null) {
      final cached = await _cache!.getDay(date);
      final hit = cached.fold((_) => null, (d) => d);
      if (hit != null) return Right(hit);
    }
    return getPrayerTimes(profile: profile, date: date);
  }

  // ── Synchronous live-calculation path (unchanged) ───────────────────────────

  /// Compute prayer times for [date] based on the user's saved [profile].
  Either<Failure, domain.DailyPrayerTimes> getPrayerTimes({
    required UserProfile profile,
    required DateTime date,
  }) {
    if (profile.latitude == 0.0 && profile.longitude == 0.0) {
      return const Left(ValidationFailure(
        'Location not set — please update your location in Settings.',
      ));
    }
    try {
      final coordinates =
          adhan.Coordinates(profile.latitude, profile.longitude);

      final params = _buildCalculationParameters(
        profile.calculationMethod,
        profile.madhab,
      );

      final dateComponents = adhan.DateComponents(
        date.year,
        date.month,
        date.day,
      );

      final times = adhan.PrayerTimes(
        coordinates,
        dateComponents,
        params,
      );

      return Right(_mapToDomain(times, date));
    } catch (e) {
      return Left(
          ValidationFailure('Failed to calculate prayer times: $e'));
    }
  }

  /// Batch: generate prayer times for the next [days] days.
  Either<Failure, List<domain.DailyPrayerTimes>> getPrayerTimesRange({
    required UserProfile profile,
    required DateTime startDate,
    required int days,
  }) {
    try {
      final result = <domain.DailyPrayerTimes>[];
      for (int i = 0; i < days; i++) {
        final date = startDate.add(Duration(days: i));
        final prayerResult = getPrayerTimes(profile: profile, date: date);
        prayerResult.fold(
          (failure) => throw Exception(failure.message),
          (times) => result.add(times),
        );
      }
      return Right(result);
    } catch (e) {
      return Left(
          ValidationFailure('Failed to calculate prayer times range: $e'));
    }
  }

  // ─── CALCULATION METHOD MAPPING ─────────────────────────────────────────────
  adhan.CalculationParameters _buildCalculationParameters(
      String methodId, String madhab) {
    adhan.CalculationParameters params;

    switch (methodId) {
      case 'MuslimWorldLeague':
        params = adhan.CalculationMethod.muslim_world_league.getParameters();
        break;
      case 'Egyptian':
        params = adhan.CalculationMethod.egyptian.getParameters();
        break;
      case 'Karachi':
        params = adhan.CalculationMethod.karachi.getParameters();
        break;
      case 'UmmAlQura':
        params = adhan.CalculationMethod.umm_al_qura.getParameters();
        break;
      case 'Dubai':
        params = adhan.CalculationMethod.dubai.getParameters();
        break;
      case 'Kuwait':
        params = adhan.CalculationMethod.kuwait.getParameters();
        break;
      case 'Qatar':
        params = adhan.CalculationMethod.qatar.getParameters();
        break;
      case 'Singapore':
        params = adhan.CalculationMethod.singapore.getParameters();
        break;
      case 'NorthAmerica':
        params = adhan.CalculationMethod.north_america.getParameters();
        break;
      case 'Turkey':
        params = adhan.CalculationMethod.turkey.getParameters();
        break;
      default:
        params = adhan.CalculationMethod.muslim_world_league.getParameters();
    }

    // Apply madhab for Asr shadow ratio
    params.madhab =
        madhab == 'hanafi' ? adhan.Madhab.hanafi : adhan.Madhab.shafi;

    return params;
  }

  // ─── DOMAIN MAPPING ─────────────────────────────────────────────────────────
  domain.DailyPrayerTimes _mapToDomain(
      adhan.PrayerTimes times, DateTime date) {
    return domain.DailyPrayerTimes(
      date: date,
      fajr: domain.PrayerTime(
        name: domain.PrayerName.fajr,
        time: times.fajr,
        date: date,
      ),
      sunrise: domain.PrayerTime(
        name: domain.PrayerName.fajr, // sunrise reuses fajr enum slot
        time: times.sunrise,
        date: date,
      ),
      dhuhr: domain.PrayerTime(
        name: domain.PrayerName.dhuhr,
        time: times.dhuhr,
        date: date,
      ),
      asr: domain.PrayerTime(
        name: domain.PrayerName.asr,
        time: times.asr,
        date: date,
      ),
      maghrib: domain.PrayerTime(
        name: domain.PrayerName.maghrib,
        time: times.maghrib,
        date: date,
      ),
      isha: domain.PrayerTime(
        name: domain.PrayerName.isha,
        time: times.isha,
        date: date,
      ),
    );
  }

}
