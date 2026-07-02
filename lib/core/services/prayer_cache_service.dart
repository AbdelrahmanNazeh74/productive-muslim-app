import '../../features/onboarding/domain/entities/user_profile.dart';
import '../../features/prayer/data/repositories/prayer_time_service.dart';
import '../../features/prayer/domain/repositories/prayer_cache_repository.dart';

/// Orchestrates warming and invalidating the 30-day offline prayer cache.
///
/// Call [warmCache] once at app startup (after loading [UserProfile]) and
/// again from any flow that changes prayer-affecting profile fields
/// (calculation method, madhab, latitude, longitude).
///
/// Design:
/// - On a valid, fully-warm cache → no-op (fast, ~0 ms).
/// - On a stale cache (different settings) → [clearAll] then fill 30 days.
/// - On a partial cache (e.g. first launch) → fill only the missing days.
/// - All errors are swallowed so the app never crashes on a cache failure;
///   [PrayerTimeService.getPrayerTimesAsync] will fall back to live adhan.
class PrayerCacheService {
  final PrayerCacheRepository repository;
  final PrayerTimeService prayerTimeService;

  /// Number of upcoming days to keep cached (today inclusive).
  static const int cacheDays = 30;

  PrayerCacheService({
    required this.repository,
    required this.prayerTimeService,
  });

  // ── Public API ─────────────────────────────────────────────────────────────

  /// Ensures [cacheDays] days of prayer times are in the Isar cache for
  /// [profile].  Clears stale entries first if the cache key changed.
  Future<void> warmCache(UserProfile profile) async {
    // 1. Validate existing cache against the current profile key.
    final validityResult = await repository.isValid(
      calculationMethod: profile.calculationMethod,
      madhab: profile.madhab,
      latitude: profile.latitude,
      longitude: profile.longitude,
    );

    final isValid = validityResult.fold((_) => false, (v) => v);
    if (!isValid) {
      // Settings changed or cache is empty — wipe before re-filling.
      await repository.clearAll();
    }

    // 2. Fill in any missing days within the upcoming window.
    final today = DateTime.now();
    for (int i = 0; i < cacheDays; i++) {
      final date = today.add(Duration(days: i));

      // Check whether this day is already present.
      final existing = await repository.getDay(date);
      final alreadyCached = existing.fold((_) => false, (d) => d != null);
      if (alreadyCached) continue;

      // Compute via the synchronous adhan path (no cache read — avoids loop).
      final prayerResult = prayerTimeService.getPrayerTimes(
        profile: profile,
        date: date,
      );

      // Ignore individual day failures; the cache stays partial rather than
      // crashing — live calculation is always the fallback.
      prayerResult.fold(
        (_) => null,
        (times) => repository.saveDay(
          times,
          calculationMethod: profile.calculationMethod,
          madhab: profile.madhab,
          latitude: profile.latitude,
          longitude: profile.longitude,
        ),
      );
    }
  }

  /// Force-clears the entire cache and re-warms from scratch.
  ///
  /// Use this when the user explicitly changes their calculation method,
  /// madhab, or location in Settings so new times take effect immediately.
  Future<void> invalidateAndRewarm(UserProfile profile) async {
    await repository.clearAll();
    await warmCache(profile);
  }

  // ── Helper ─────────────────────────────────────────────────────────────────

  /// Convenience: returns the number of cached days, or 0 on error.
  Future<int> cachedDayCount() async {
    final result = await repository.countCachedDays();
    return result.fold((_) => 0, (n) => n);
  }
}
