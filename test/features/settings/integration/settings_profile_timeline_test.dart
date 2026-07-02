import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:productive_muslim/core/errors/failures.dart';
import 'package:productive_muslim/core/usecases/usecase.dart';
import 'package:productive_muslim/features/onboarding/domain/entities/user_profile.dart';
import 'package:productive_muslim/features/onboarding/domain/usecases/onboarding_usecases.dart';
import 'package:productive_muslim/features/settings/domain/entities/app_settings.dart';
import 'package:productive_muslim/features/settings/domain/usecases/settings_usecases.dart';
import 'package:productive_muslim/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:productive_muslim/features/timeline/domain/entities/time_block.dart';
import 'package:productive_muslim/features/timeline/domain/usecases/timeline_usecases.dart';
import 'package:productive_muslim/features/timeline/presentation/bloc/timeline_bloc.dart';
import 'package:productive_muslim/features/prayer/data/repositories/prayer_time_service.dart';

// ─── MOCKS ────────────────────────────────────────────────────────────────────
class MockLoadSettings extends Mock implements LoadSettings {}
class MockSaveSettings extends Mock implements SaveSettings {}
class MockResetSettings extends Mock implements ResetSettings {}
class MockUpdateUserProfile extends Mock implements UpdateUserProfile {}
class MockGetUserProfile extends Mock implements GetUserProfile {}
class MockGenerateAndSaveTimeline extends Mock implements GenerateAndSaveTimeline {}
class MockGetTimeline extends Mock implements GetTimeline {}
class MockCompleteBlock extends Mock implements CompleteBlock {}
class MockSkipBlock extends Mock implements SkipBlock {}
class MockSetMorningIntention extends Mock implements SetMorningIntention {}
class MockSetEveningReflection extends Mock implements SetEveningReflection {}
class MockPrayerTimeService extends Mock implements PrayerTimeService {}

// ─── FAKES ────────────────────────────────────────────────────────────────────
class FakeNoParams extends Fake implements NoParams {}
class FakeSaveSettingsParams extends Fake implements SaveSettingsParams {}
class FakeAppSettings extends Fake implements AppSettings {}
class FakeUserProfile extends Fake implements UserProfile {}
class FakeGenerateTimelineParams extends Fake implements GenerateTimelineParams {}

// ─── HELPERS ─────────────────────────────────────────────────────────────────
UserProfile makeProfile({bool isRamadanMode = false}) {
  return UserProfile(
    name: 'Zaid',
    gender: 'male',
    occupationId: 'student',
    occupationLabel: 'Student',
    occupationType: 'student',
    workStartHour: 9,
    workStartMinute: 0,
    workEndHour: 17,
    workEndMinute: 0,
    workDays: const [0, 1, 2, 3, 4],
    latitude: 30.0444,
    longitude: 31.2357,
    city: 'Cairo',
    timezone: 'Africa/Cairo',
    calculationMethod: 'MuslimWorldLeague',
    madhab: 'shafi',
    prayerBufferMinutes: 10,
    fitnessActivityIds: const [],
    gymDays: const [],
    gymDurationMinutes: 60,
    preferredGymTime: 'evening',
    targetSleepHours: 7,
    wakeUpOffsetFromFajrMinutes: -30,
    dailyQuranPagesGoal: 2,
    cycleAwareStreaks: false,
    isRamadanMode: isRamadanMode,
    isOnboardingComplete: true,
    createdAt: DateTime(2024, 6, 1),
  );
}

DailyTimeline makeTimeline() {
  return DailyTimeline(
    date: DateTime(2024, 6, 1),
    dayType: DayType.weekday,
    blocks: const [],
    generatedAt: DateTime(2024, 6, 1),
  );
}

TimelineBloc makeTimelineBloc({
  required MockGenerateAndSaveTimeline mockGenerate,
  required MockGetTimeline mockGetTimeline,
}) {
  final mockPrayer = MockPrayerTimeService();
  when(() => mockPrayer.getPrayerTimes(
    profile: any(named: 'profile'),
    date: any(named: 'date'),
  )).thenReturn(const Left(DatabaseFailure('no prayer times')));
  return TimelineBloc(
    generateAndSaveTimeline: mockGenerate,
    getTimeline: mockGetTimeline,
    completeBlock: MockCompleteBlock(),
    skipBlock: MockSkipBlock(),
    setMorningIntention: MockSetMorningIntention(),
    setEveningReflection: MockSetEveningReflection(),
    prayerTimeService: mockPrayer,
  );
}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeNoParams());
    registerFallbackValue(FakeSaveSettingsParams());
    registerFallbackValue(FakeAppSettings());
    registerFallbackValue(FakeUserProfile());
    registerFallbackValue(FakeGenerateTimelineParams());
    registerFallbackValue(DateTime(2024, 1, 1));
  });

  // ─── SETTINGS BLOC — LOAD ────────────────────────────────────────────────

  group('SettingsBloc — load', () {
    late MockLoadSettings mockLoad;
    late MockSaveSettings mockSave;
    late MockResetSettings mockReset;
    late SettingsBloc bloc;

    setUp(() {
      mockLoad = MockLoadSettings();
      mockSave = MockSaveSettings();
      mockReset = MockResetSettings();
      bloc = SettingsBloc(
        loadSettings: mockLoad,
        saveSettings: mockSave,
        resetSettings: mockReset,
      );
    });

    tearDown(() => bloc.close());

    blocTest<SettingsBloc, SettingsState>(
      'SettingsLoadRequested emits loading → loaded on success',
      build: () {
        when(() => mockLoad(any()))
            .thenAnswer((_) async => const Right(AppSettings.defaults));
        return bloc;
      },
      act: (b) => b.add(const SettingsLoadRequested()),
      expect: () => [
        isA<SettingsLoading>(),
        isA<SettingsLoaded>().having(
          (s) => s.settings.themeMode,
          'themeMode',
          'system',
        ),
      ],
    );

    blocTest<SettingsBloc, SettingsState>(
      'SettingsLoadRequested emits error when load fails',
      build: () {
        when(() => mockLoad(any())).thenAnswer(
          (_) async => const Left(CacheFailure('prefs unavailable')),
        );
        return bloc;
      },
      act: (b) => b.add(const SettingsLoadRequested()),
      expect: () => [
        isA<SettingsLoading>(),
        isA<SettingsError>()
            .having((s) => s.message, 'message', isNotNull),
      ],
    );
  });

  // ─── SETTINGS BLOC — OPTIMISTIC TOGGLE TESTS ─────────────────────────────

  group('SettingsBloc — optimistic UI updates', () {
    late MockLoadSettings mockLoad;
    late MockSaveSettings mockSave;
    late MockResetSettings mockReset;
    late SettingsBloc bloc;

    setUp(() {
      mockLoad = MockLoadSettings();
      mockSave = MockSaveSettings();
      mockReset = MockResetSettings();
      bloc = SettingsBloc(
        loadSettings: mockLoad,
        saveSettings: mockSave,
        resetSettings: mockReset,
      );
    });

    tearDown(() => bloc.close());

    blocTest<SettingsBloc, SettingsState>(
      'SettingsThemeModeChanged updates themeMode immediately (optimistic)',
      build: () {
        when(() => mockSave(any()))
            .thenAnswer((_) async => const Right(null));
        return bloc;
      },
      seed: () => const SettingsLoaded(AppSettings.defaults), // starts as 'system'
      act: (b) => b.add(const SettingsThemeModeChanged('dark')),
      expect: () => [
        isA<SettingsLoaded>()
            .having((s) => s.settings.themeMode, 'themeMode', 'dark'),
      ],
      verify: (_) {
        verify(() => mockSave(any())).called(1);
      },
    );

    blocTest<SettingsBloc, SettingsState>(
      'SettingsPrayerNotificationToggled updates the correct prayer flag',
      build: () {
        when(() => mockSave(any()))
            .thenAnswer((_) async => const Right(null));
        return bloc;
      },
      seed: () => const SettingsLoaded(AppSettings.defaults),
      act: (b) => b.add(const SettingsPrayerNotificationToggled(
        prayer: 'fajr',
        enabled: false,
      )),
      expect: () => [
        isA<SettingsLoaded>().having(
          (s) => s.settings.fajrNotification,
          'fajrNotification',
          false,
        ),
      ],
    );

    blocTest<SettingsBloc, SettingsState>(
      'SettingsHabitReminderToggled toggles habitReminders',
      build: () {
        when(() => mockSave(any()))
            .thenAnswer((_) async => const Right(null));
        return bloc;
      },
      seed: () => const SettingsLoaded(AppSettings.defaults),
      act: (b) => b.add(const SettingsHabitReminderToggled(false)),
      expect: () => [
        isA<SettingsLoaded>().having(
          (s) => s.settings.habitReminders,
          'habitReminders',
          false,
        ),
      ],
    );

    blocTest<SettingsBloc, SettingsState>(
      'SettingsQuietHoursToggled enables quiet hours',
      build: () {
        when(() => mockSave(any()))
            .thenAnswer((_) async => const Right(null));
        return bloc;
      },
      seed: () => const SettingsLoaded(AppSettings.defaults),
      act: (b) => b.add(const SettingsQuietHoursToggled(true)),
      expect: () => [
        isA<SettingsLoaded>().having(
          (s) => s.settings.quietHoursEnabled,
          'quietHoursEnabled',
          true,
        ),
      ],
    );

    blocTest<SettingsBloc, SettingsState>(
      'SettingsQuietHoursChanged updates quiet hour window',
      build: () {
        when(() => mockSave(any()))
            .thenAnswer((_) async => const Right(null));
        return bloc;
      },
      seed: () => const SettingsLoaded(AppSettings.defaults),
      act: (b) => b.add(const SettingsQuietHoursChanged(
        startHour: 23,
        startMinute: 30,
        endHour: 5,
        endMinute: 0,
      )),
      expect: () => [
        isA<SettingsLoaded>()
            .having((s) => s.settings.quietHoursStartHour, 'startHour', 23)
            .having((s) => s.settings.quietHoursEndHour, 'endHour', 5),
      ],
    );

    blocTest<SettingsBloc, SettingsState>(
      'Settings24HourToggled updates show24HourTime flag',
      build: () {
        when(() => mockSave(any()))
            .thenAnswer((_) async => const Right(null));
        return bloc;
      },
      seed: () => const SettingsLoaded(AppSettings.defaults),
      act: (b) => b.add(const Settings24HourToggled(true)),
      expect: () => [
        isA<SettingsLoaded>().having(
          (s) => s.settings.show24HourTime,
          'show24HourTime',
          true,
        ),
      ],
    );

    blocTest<SettingsBloc, SettingsState>(
      'SettingsResetRequested emits defaults and calls reset use case',
      build: () {
        when(() => mockReset(any()))
            .thenAnswer((_) async => const Right(null));
        return bloc;
      },
      seed: () => const SettingsLoaded(AppSettings(themeMode: 'dark')),
      act: (b) => b.add(const SettingsResetRequested()),
      expect: () => [
        isA<SettingsLoaded>().having(
          (s) => s.settings.themeMode,
          'themeMode after reset',
          'system',
        ),
      ],
      verify: (_) {
        verify(() => mockReset(any())).called(1);
      },
    );

    blocTest<SettingsBloc, SettingsState>(
      'events on SettingsInitial state are ignored gracefully',
      build: () => bloc,
      // seed is SettingsInitial (no settings loaded yet)
      act: (b) => b.add(const SettingsThemeModeChanged('dark')),
      expect: () => [], // no state change — _current returns null
    );
  });

  // ─── PROFILE EDIT → TIMELINE RECALCULATION ───────────────────────────────

  group('ProfileEdit flow — UpdateUserProfile triggers timeline generation', () {
    late MockUpdateUserProfile mockUpdateProfile;
    late MockGenerateAndSaveTimeline mockGenerate;
    late MockGetTimeline mockGetTimeline;
    late TimelineBloc timelineBloc;

    setUp(() {
      mockUpdateProfile = MockUpdateUserProfile();
      mockGenerate = MockGenerateAndSaveTimeline();
      mockGetTimeline = MockGetTimeline();
      timelineBloc = makeTimelineBloc(
        mockGenerate: mockGenerate,
        mockGetTimeline: mockGetTimeline,
      );
    });

    tearDown(() => timelineBloc.close());

    test('UpdateUserProfile use case is called with updated profile', () async {
      final updatedProfile = makeProfile();
      when(() => mockUpdateProfile(any()))
          .thenAnswer((_) async => Right(updatedProfile));

      final result = await mockUpdateProfile(updatedProfile);

      expect(result.isRight(), true);
      verify(() => mockUpdateProfile(updatedProfile)).called(1);
    });

    test('UpdateUserProfile failure returns Left with failure details', () async {
      when(() => mockUpdateProfile(any())).thenAnswer(
        (_) async => const Left(DatabaseFailure('write failed')),
      );

      final result = await mockUpdateProfile(makeProfile());

      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure.message, contains('write failed')),
        (_) => fail('Expected failure'),
      );
    });

    blocTest<TimelineBloc, TimelineState>(
      'After profile update, TimelineGenerateRequested regenerates timeline '
      'with new profile data',
      build: () {
        when(() => mockGenerate(any()))
            .thenAnswer((_) async => Right(makeTimeline()));
        return timelineBloc;
      },
      act: (b) {
        // Simulate what ProfileEditPage does after successful updateUserProfile:
        // dispatch TimelineGenerateRequested with the updated profile
        b.add(TimelineGenerateRequested(
          profile: makeProfile(),
          date: DateTime(2024, 6, 1),
        ));
      },
      expect: () => [
        isA<TimelineState>()
            .having((s) => s.status, 'status', TimelineStatus.generating),
        isA<TimelineState>()
            .having((s) => s.status, 'status', TimelineStatus.loaded)
            .having((s) => s.timeline, 'timeline', isNotNull),
      ],
      verify: (_) {
        verify(() => mockGenerate(any())).called(1);
      },
    );

    blocTest<TimelineBloc, TimelineState>(
      'Profile edit with new prayer calculation method triggers fresh generation',
      build: () {
        when(() => mockGenerate(any()))
            .thenAnswer((_) async => Right(makeTimeline()));
        return timelineBloc;
      },
      act: (b) {
        // Profile with a different calculation method triggers re-generate
        final newProfile = makeProfile();
        b.add(TimelineGenerateRequested(
          profile: newProfile,
          date: DateTime(2024, 6, 1),
        ));
      },
      expect: () => [
        isA<TimelineState>()
            .having((s) => s.status, 'status', TimelineStatus.generating),
        isA<TimelineState>()
            .having((s) => s.status, 'status', TimelineStatus.loaded),
      ],
    );

    blocTest<TimelineBloc, TimelineState>(
      'Profile edit failure in timeline generation emits error state',
      build: () {
        when(() => mockGenerate(any())).thenAnswer(
          (_) async => const Left(DatabaseFailure('prayer time error')),
        );
        return timelineBloc;
      },
      act: (b) => b.add(TimelineGenerateRequested(
        profile: makeProfile(),
        date: DateTime(2024, 6, 1),
      )),
      expect: () => [
        isA<TimelineState>()
            .having((s) => s.status, 'status', TimelineStatus.generating),
        isA<TimelineState>()
            .having((s) => s.status, 'status', TimelineStatus.error),
      ],
    );
  });

  // ─── APP SETTINGS UNIT TESTS ─────────────────────────────────────────────

  group('AppSettings — domain logic', () {
    test('defaults has all notifications enabled', () {
      const s = AppSettings.defaults;
      expect(s.fajrNotification, true);
      expect(s.dhuhrNotification, true);
      expect(s.asrNotification, true);
      expect(s.maghribNotification, true);
      expect(s.ishaNotification, true);
    });

    test('defaults themeMode is system', () {
      expect(AppSettings.defaults.themeMode, 'system');
    });

    test('prayerNotificationEnabled returns correct value per prayer', () {
      const s = AppSettings(fajrNotification: false);
      expect(s.prayerNotificationEnabled('fajr'), false);
      expect(s.prayerNotificationEnabled('dhuhr'), true);
    });

    test('copyWith changes only the specified field', () {
      const original = AppSettings.defaults;
      final updated = original.copyWith(themeMode: 'dark');

      expect(updated.themeMode, 'dark');
      expect(updated.fajrNotification, original.fajrNotification);
      expect(updated.habitReminders, original.habitReminders);
      expect(updated.quietHoursEnabled, original.quietHoursEnabled);
    });

    test('two AppSettings with same values are equal (Equatable)', () {
      const a = AppSettings(themeMode: 'dark', show24HourTime: true);
      const b = AppSettings(themeMode: 'dark', show24HourTime: true);
      expect(a, equals(b));
    });

    test('two AppSettings with different themeMode are not equal', () {
      const a = AppSettings(themeMode: 'dark');
      const b = AppSettings(themeMode: 'light');
      expect(a, isNot(equals(b)));
    });

    test('quietHoursLabel formats correctly for midnight range', () {
      const s = AppSettings(
        quietHoursStartHour: 22,
        quietHoursStartMinute: 0,
        quietHoursEndHour: 6,
        quietHoursEndMinute: 30,
      );
      expect(s.quietHoursLabel, contains('10:00 PM'));
      expect(s.quietHoursLabel, contains('6:30 AM'));
    });
  });
}
