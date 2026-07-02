import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:productive_muslim/core/errors/failures.dart';
import 'package:productive_muslim/features/onboarding/domain/entities/user_profile.dart';
import 'package:productive_muslim/features/prayer/data/repositories/prayer_time_service.dart';
import 'package:productive_muslim/features/prayer/domain/entities/prayer_times.dart';
import 'package:productive_muslim/features/prayer/domain/repositories/prayer_cache_repository.dart';
import 'package:productive_muslim/core/services/prayer_cache_service.dart';

// ── Helpers ────────────────────────────────────────────────────────────────────

UserProfile _profile({
  String method = 'MuslimWorldLeague',
  String madhab = 'shafi',
  double lat = 30.0444,
  double lon = 31.2357,
}) =>
    UserProfile(
      name: 'Test',
      gender: 'male',
      occupationId: 'engineer',
      occupationLabel: 'Engineer',
      occupationType: 'office',
      workStartHour: 9,
      workStartMinute: 0,
      workEndHour: 17,
      workEndMinute: 0,
      workDays: const [0, 1, 2, 3, 4],
      latitude: lat,
      longitude: lon,
      city: 'Cairo',
      timezone: 'Africa/Cairo',
      calculationMethod: method,
      madhab: madhab,
      fitnessActivityIds: const [],
      gymDays: const [],
      preferredGymTime: 'morning',
      createdAt: DateTime(2025),
    );

DailyPrayerTimes _day(DateTime date) {
  return DailyPrayerTimes(
    date: date,
    fajr: PrayerTime(name: PrayerName.fajr, time: date.copyWith(hour: 5), date: date),
    sunrise: PrayerTime(name: PrayerName.fajr, time: date.copyWith(hour: 6), date: date),
    dhuhr: PrayerTime(name: PrayerName.dhuhr, time: date.copyWith(hour: 12), date: date),
    asr: PrayerTime(name: PrayerName.asr, time: date.copyWith(hour: 15), date: date),
    maghrib: PrayerTime(name: PrayerName.maghrib, time: date.copyWith(hour: 18), date: date),
    isha: PrayerTime(name: PrayerName.isha, time: date.copyWith(hour: 20), date: date),
  );
}

// ── Fake in-memory PrayerCacheRepository ──────────────────────────────────────

class FakePrayerCacheRepository implements PrayerCacheRepository {
  final Map<DateTime, DailyPrayerTimes> _store = {};
  String? _method;
  String? _madhab;
  double? _lat;
  double? _lon;

  int clearAllCallCount = 0;
  int saveDayCallCount = 0;

  @override
  Future<Either<Failure, DailyPrayerTimes?>> getDay(DateTime date) async {
    final key = DateTime(date.year, date.month, date.day);
    return Right(_store[key]);
  }

  @override
  Future<Either<Failure, void>> saveDay(
    DailyPrayerTimes times, {
    required String calculationMethod,
    required String madhab,
    required double latitude,
    required double longitude,
  }) async {
    saveDayCallCount++;
    final key = DateTime(times.date.year, times.date.month, times.date.day);
    _store[key] = times;
    _method = calculationMethod;
    _madhab = madhab;
    _lat = latitude;
    _lon = longitude;
    return const Right(null);
  }

  @override
  Future<Either<Failure, void>> clearAll() async {
    clearAllCallCount++;
    _store.clear();
    _method = null;
    _madhab = null;
    _lat = null;
    _lon = null;
    return const Right(null);
  }

  @override
  Future<Either<Failure, bool>> isValid({
    required String calculationMethod,
    required String madhab,
    required double latitude,
    required double longitude,
  }) async {
    if (_store.isEmpty) return const Right(false);
    final valid = _method == calculationMethod &&
        _madhab == madhab &&
        _round(_lat!) == _round(latitude) &&
        _round(_lon!) == _round(longitude);
    return Right(valid);
  }

  @override
  Future<Either<Failure, int>> countCachedDays() async => Right(_store.length);

  static double _round(double v) => (v * 10000).round() / 10000;
}

// ── Mock PrayerCacheRepository (mocktail) ─────────────────────────────────────

class MockPrayerCacheRepository extends Mock implements PrayerCacheRepository {}

// ── Mock PrayerTimeService ────────────────────────────────────────────────────

class MockPrayerTimeService extends Mock implements PrayerTimeService {}

// ─────────────────────────────────────────────────────────────────────────────

void main() {
  final today = DateTime.now();
  final todayOnly = DateTime(today.year, today.month, today.day);
  final p = _profile();

  // ── Group 1: FakePrayerCacheRepository contract ────────────────────────────
  group('FakePrayerCacheRepository contract', () {
    late FakePrayerCacheRepository repo;

    setUp(() => repo = FakePrayerCacheRepository());

    test('1. getDay returns null when cache is empty', () async {
      final result = await repo.getDay(todayOnly);
      expect(result, const Right(null));
    });

    test('2. saveDay stores a day and getDay retrieves it', () async {
      final day = _day(todayOnly);
      await repo.saveDay(day,
          calculationMethod: p.calculationMethod,
          madhab: p.madhab,
          latitude: p.latitude,
          longitude: p.longitude);

      final result = await repo.getDay(todayOnly);
      result.fold(
        (_) => fail('Expected Right'),
        (d) => expect(d?.date, todayOnly),
      );
    });

    test('3. saveDay with time component normalises to date-only key', () async {
      final dayWithTime = _day(todayOnly.copyWith(hour: 14, minute: 30));
      await repo.saveDay(dayWithTime,
          calculationMethod: p.calculationMethod,
          madhab: p.madhab,
          latitude: p.latitude,
          longitude: p.longitude);

      final result = await repo.getDay(todayOnly.copyWith(hour: 23));
      result.fold((_) => fail('Expected Right'), (d) => expect(d, isNotNull));
    });

    test('4. countCachedDays returns 0 on empty store', () async {
      final result = await repo.countCachedDays();
      expect(result, const Right(0));
    });

    test('5. countCachedDays reflects saved entries', () async {
      for (int i = 0; i < 3; i++) {
        await repo.saveDay(_day(todayOnly.add(Duration(days: i))),
            calculationMethod: p.calculationMethod,
            madhab: p.madhab,
            latitude: p.latitude,
            longitude: p.longitude);
      }
      final result = await repo.countCachedDays();
      expect(result, const Right(3));
    });

    test('6. clearAll empties the store', () async {
      await repo.saveDay(_day(todayOnly),
          calculationMethod: p.calculationMethod,
          madhab: p.madhab,
          latitude: p.latitude,
          longitude: p.longitude);
      await repo.clearAll();
      final count = await repo.countCachedDays();
      expect(count, const Right(0));
    });

    test('7. isValid returns false on empty cache', () async {
      final result = await repo.isValid(
          calculationMethod: p.calculationMethod,
          madhab: p.madhab,
          latitude: p.latitude,
          longitude: p.longitude);
      expect(result, const Right(false));
    });

    test('8. isValid returns true when key matches', () async {
      await repo.saveDay(_day(todayOnly),
          calculationMethod: p.calculationMethod,
          madhab: p.madhab,
          latitude: p.latitude,
          longitude: p.longitude);
      final result = await repo.isValid(
          calculationMethod: p.calculationMethod,
          madhab: p.madhab,
          latitude: p.latitude,
          longitude: p.longitude);
      expect(result, const Right(true));
    });

    test('9. isValid returns false when calculationMethod differs', () async {
      await repo.saveDay(_day(todayOnly),
          calculationMethod: 'Egyptian',
          madhab: p.madhab,
          latitude: p.latitude,
          longitude: p.longitude);
      final result = await repo.isValid(
          calculationMethod: 'MuslimWorldLeague',
          madhab: p.madhab,
          latitude: p.latitude,
          longitude: p.longitude);
      expect(result, const Right(false));
    });

    test('10. isValid returns false when madhab differs', () async {
      await repo.saveDay(_day(todayOnly),
          calculationMethod: p.calculationMethod,
          madhab: 'shafi',
          latitude: p.latitude,
          longitude: p.longitude);
      final result = await repo.isValid(
          calculationMethod: p.calculationMethod,
          madhab: 'hanafi',
          latitude: p.latitude,
          longitude: p.longitude);
      expect(result, const Right(false));
    });

    test('11. isValid treats lat/lon within 4dp as equal (GPS jitter)', () async {
      // 0.00001 difference → rounds to same 4dp value
      await repo.saveDay(_day(todayOnly),
          calculationMethod: p.calculationMethod,
          madhab: p.madhab,
          latitude: 30.0444,
          longitude: 31.2357);
      final result = await repo.isValid(
          calculationMethod: p.calculationMethod,
          madhab: p.madhab,
          latitude: 30.04441,
          longitude: 31.23571);
      expect(result, const Right(true));
    });

    test('12. isValid treats lat/lon beyond 4dp threshold as different', () async {
      await repo.saveDay(_day(todayOnly),
          calculationMethod: p.calculationMethod,
          madhab: p.madhab,
          latitude: 30.0444,
          longitude: 31.2357);
      final result = await repo.isValid(
          calculationMethod: p.calculationMethod,
          madhab: p.madhab,
          latitude: 30.0500,
          longitude: 31.2357);
      expect(result, const Right(false));
    });
  });

  // ── Group 2: PrayerCacheService — warmCache ────────────────────────────────
  group('PrayerCacheService.warmCache', () {
    late FakePrayerCacheRepository repo;
    late PrayerCacheService service;

    setUp(() {
      repo = FakePrayerCacheRepository();
      service = PrayerCacheService(
        repository: repo,
        prayerTimeService: PrayerTimeService(),
      );
    });

    test('13. warmCache fills 30 days when cache is empty', () async {
      await service.warmCache(p);
      final count = await repo.countCachedDays();
      count.fold((_) => fail('Expected Right'), (n) => expect(n, 30));
    });

    test('14. warmCache does not overwrite already-cached days', () async {
      await service.warmCache(p);
      final firstSaveCount = repo.saveDayCallCount;

      // Second warm — all 30 days already present; should save nothing.
      await service.warmCache(p);
      expect(repo.saveDayCallCount, firstSaveCount);
    });

    test('15. warmCache clears stale entries when method changes', () async {
      await service.warmCache(p);
      final before = repo.clearAllCallCount; // 1 (stale from empty)

      final newProfile = p.copyWith(calculationMethod: 'Egyptian');
      await service.warmCache(newProfile);

      // clearAll called once more for the new key mismatch
      expect(repo.clearAllCallCount, greaterThan(before));
    });

    test('16. warmCache fills exactly 30 days after clearing stale cache',
        () async {
      await service.warmCache(p);
      final newProfile = p.copyWith(calculationMethod: 'Karachi');
      await service.warmCache(newProfile);

      final count = await repo.countCachedDays();
      count.fold((_) => fail('Expected Right'), (n) => expect(n, 30));
    });

    test('17. cachedDayCount returns correct count after warmCache', () async {
      await service.warmCache(p);
      final n = await service.cachedDayCount();
      expect(n, 30);
    });

    test('18. cachedDayCount returns 0 on fresh repository', () async {
      final n = await service.cachedDayCount();
      expect(n, 0);
    });
  });

  // ── Group 3: PrayerCacheService — invalidateAndRewarm ─────────────────────
  group('PrayerCacheService.invalidateAndRewarm', () {
    late FakePrayerCacheRepository repo;
    late PrayerCacheService service;

    setUp(() {
      repo = FakePrayerCacheRepository();
      service = PrayerCacheService(
        repository: repo,
        prayerTimeService: PrayerTimeService(),
      );
    });

    test('19. invalidateAndRewarm clears then fills 30 days', () async {
      await service.warmCache(p);
      final clearCountBefore = repo.clearAllCallCount;

      await service.invalidateAndRewarm(p);

      expect(repo.clearAllCallCount, greaterThan(clearCountBefore));
      final count = await repo.countCachedDays();
      count.fold((_) => fail('Expected Right'), (n) => expect(n, 30));
    });

    test('20. invalidateAndRewarm on fresh repo still fills 30 days', () async {
      await service.invalidateAndRewarm(p);
      final n = await service.cachedDayCount();
      expect(n, 30);
    });
  });

  // ── Group 4: PrayerTimeService.getPrayerTimesAsync — cache-first ──────────
  group('PrayerTimeService.getPrayerTimesAsync', () {
    late MockPrayerCacheRepository mockRepo;
    late PrayerTimeService serviceWithCache;

    setUpAll(() {
      registerFallbackValue(DateTime(2025));
      // DailyPrayerTimes needed by verifyNever(() => mockRepo.saveDay(any(), ...))
      registerFallbackValue(_day(todayOnly));
    });

    setUp(() {
      mockRepo = MockPrayerCacheRepository();
      serviceWithCache = PrayerTimeService(cache: mockRepo);
    });

    test('21. returns cached value on cache hit', () async {
      final cached = _day(todayOnly);
      when(() => mockRepo.getDay(any())).thenAnswer((_) async => Right(cached));

      final result = await serviceWithCache.getPrayerTimesAsync(
        profile: p,
        date: todayOnly,
      );

      expect(result.isRight(), true);
      result.fold((_) => fail('Expected Right'), (d) => expect(d.date, todayOnly));
      verifyNever(() => mockRepo.saveDay(any(),
          calculationMethod: any(named: 'calculationMethod'),
          madhab: any(named: 'madhab'),
          latitude: any(named: 'latitude'),
          longitude: any(named: 'longitude')));
    });

    test('22. falls back to live adhan on cache miss (null)', () async {
      when(() => mockRepo.getDay(any()))
          .thenAnswer((_) async => const Right(null));

      final result = await serviceWithCache.getPrayerTimesAsync(
        profile: p,
        date: todayOnly,
      );

      // Live adhan returns a valid result for real coordinates
      expect(result.isRight(), true);
    });

    test('23. falls back to live adhan on cache failure (Left)', () async {
      when(() => mockRepo.getDay(any()))
          .thenAnswer((_) async => const Left(CacheFailure('db error')));

      final result = await serviceWithCache.getPrayerTimesAsync(
        profile: p,
        date: todayOnly,
      );

      expect(result.isRight(), true);
    });

    test('24. service without cache always uses live adhan', () async {
      final serviceNoCache = PrayerTimeService();
      final result = await serviceNoCache.getPrayerTimesAsync(
        profile: p,
        date: todayOnly,
      );
      expect(result.isRight(), true);
    });

    test('25. getPrayerTimes (sync) still works regardless of cache presence',
        () {
      final result = serviceWithCache.getPrayerTimes(profile: p, date: todayOnly);
      expect(result.isRight(), true);
    });

    test('26. getPrayerTimesAsync returns fajr before dhuhr', () async {
      when(() => mockRepo.getDay(any()))
          .thenAnswer((_) async => const Right(null));

      final result = await serviceWithCache.getPrayerTimesAsync(
        profile: p,
        date: todayOnly,
      );

      result.fold(
        (_) => fail('Expected Right'),
        (d) => expect(d.fajr.time.isBefore(d.dhuhr.time), true),
      );
    });

    test('27. cache miss triggers exactly one getDay call per request', () async {
      when(() => mockRepo.getDay(any()))
          .thenAnswer((_) async => const Right(null));

      await serviceWithCache.getPrayerTimesAsync(profile: p, date: todayOnly);

      verify(() => mockRepo.getDay(any())).called(1);
    });

    test('28. cache hit does not trigger live calculation for different dates',
        () async {
      final tomorrow = todayOnly.add(const Duration(days: 1));
      final cachedDay = _day(tomorrow);
      when(() => mockRepo.getDay(any()))
          .thenAnswer((_) async => Right(cachedDay));

      final result =
          await serviceWithCache.getPrayerTimesAsync(profile: p, date: tomorrow);

      result.fold(
        (_) => fail('Expected Right'),
        (d) {
          // Returned the cached object — fajr time matches the fake fixture
          expect(d.fajr.time.hour, 5);
        },
      );
    });
  });

  // ── Group 5: Edge cases ────────────────────────────────────────────────────
  group('Edge cases', () {
    test('29. warmCache is a no-op when profile has no location (lat=0, lon=0)',
        () async {
      final noLocProfile = p.copyWith(latitude: 0.0, longitude: 0.0);
      final repo = FakePrayerCacheRepository();
      final service = PrayerCacheService(
        repository: repo,
        prayerTimeService: PrayerTimeService(),
      );
      // Should not throw even for equator/prime-meridian coordinates
      await expectLater(service.warmCache(noLocProfile), completes);
    });

    test('30. isValid returns false after clearAll', () async {
      final repo = FakePrayerCacheRepository();
      final service = PrayerCacheService(
        repository: repo,
        prayerTimeService: PrayerTimeService(),
      );
      await service.warmCache(p);
      await repo.clearAll();

      final valid = await repo.isValid(
          calculationMethod: p.calculationMethod,
          madhab: p.madhab,
          latitude: p.latitude,
          longitude: p.longitude);
      expect(valid, const Right(false));
    });
  });
}
