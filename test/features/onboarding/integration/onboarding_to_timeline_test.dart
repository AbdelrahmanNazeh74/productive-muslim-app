import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:productive_muslim/core/errors/failures.dart';
import 'package:productive_muslim/features/onboarding/domain/entities/user_profile.dart';
import 'package:productive_muslim/features/onboarding/domain/usecases/onboarding_usecases.dart';
import 'package:productive_muslim/features/onboarding/presentation/bloc/onboarding_bloc.dart';
import 'package:productive_muslim/features/timeline/domain/entities/time_block.dart';
import 'package:productive_muslim/features/timeline/domain/usecases/timeline_usecases.dart';
import 'package:productive_muslim/features/timeline/presentation/bloc/timeline_bloc.dart';
import 'package:productive_muslim/features/prayer/data/repositories/prayer_time_service.dart';
import 'package:productive_muslim/core/usecases/usecase.dart';

// ─── MOCKS ────────────────────────────────────────────────────────────────────
class MockSaveUserProfile extends Mock implements SaveUserProfile {}
class MockGetUserProfile extends Mock implements GetUserProfile {}
class MockGenerateAndSaveTimeline extends Mock implements GenerateAndSaveTimeline {}
class MockGetTimeline extends Mock implements GetTimeline {}
class MockCompleteBlock extends Mock implements CompleteBlock {}
class MockSkipBlock extends Mock implements SkipBlock {}
class MockSetMorningIntention extends Mock implements SetMorningIntention {}
class MockSetEveningReflection extends Mock implements SetEveningReflection {}
class MockPrayerTimeService extends Mock implements PrayerTimeService {}

// ─── FAKES ────────────────────────────────────────────────────────────────────
class FakeUserProfile extends Fake implements UserProfile {}
class FakeNoParams extends Fake implements NoParams {}
class FakeGenerateTimelineParams extends Fake implements GenerateTimelineParams {}

// ─── HELPERS ─────────────────────────────────────────────────────────────────
UserProfile makeProfile() {
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
    isRamadanMode: false,
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

void main() {
  setUpAll(() {
    registerFallbackValue(FakeUserProfile());
    registerFallbackValue(FakeNoParams());
    registerFallbackValue(FakeGenerateTimelineParams());
    registerFallbackValue(DateTime(2024, 1, 1)); // for GetTimeline(DateTime)
  });

  // ─── ONBOARDING STATE UNIT TESTS ─────────────────────────────────────────

  group('OnboardingState — step validation', () {
    test('step 0 invalid with empty name', () {
      const s = OnboardingState(currentStep: 0, name: '', gender: 'male');
      expect(s.isCurrentStepValid, false);
    });

    test('step 0 invalid with name shorter than 2 chars', () {
      const s = OnboardingState(currentStep: 0, name: 'Z', gender: 'male');
      expect(s.isCurrentStepValid, false);
    });

    test('step 0 valid with 2+ char name', () {
      const s = OnboardingState(currentStep: 0, name: 'Za', gender: 'male');
      expect(s.isCurrentStepValid, true);
    });

    test('step 1 invalid without occupation selected', () {
      const s = OnboardingState(currentStep: 1, occupationId: '');
      expect(s.isCurrentStepValid, false);
    });

    test('step 1 valid when occupation set', () {
      const s = OnboardingState(currentStep: 1, occupationId: 'student');
      expect(s.isCurrentStepValid, true);
    });

    test('step 2 invalid when work end is before start', () {
      const s = OnboardingState(
        currentStep: 2,
        workStartHour: 17,
        workEndHour: 9,
        workDays: [0, 1, 2],
      );
      expect(s.isCurrentStepValid, false);
    });

    test('step 3 invalid without location', () {
      const s = OnboardingState(currentStep: 3, city: '');
      expect(s.isCurrentStepValid, false);
    });

    test('step 3 valid when lat/lng/city all set', () {
      const s = OnboardingState(
        currentStep: 3,
        latitude: 30.0444,
        longitude: 31.2357,
        city: 'Cairo',
      );
      expect(s.isCurrentStepValid, true);
    });

    test('steps 4 and 5 are always valid', () {
      expect(const OnboardingState(currentStep: 4).isCurrentStepValid, true);
      expect(const OnboardingState(currentStep: 5).isCurrentStepValid, true);
    });

    test('hasGymActivities false when fitnessActivityIds is empty', () {
      const s = OnboardingState(fitnessActivityIds: []);
      expect(s.hasGymActivities, false);
    });

    test('hasGymActivities false when only "none" activity selected', () {
      const s = OnboardingState(fitnessActivityIds: ['none']);
      expect(s.hasGymActivities, false);
    });

    test('hasGymActivities true with real activity IDs', () {
      const s = OnboardingState(fitnessActivityIds: ['gym', 'running']);
      expect(s.hasGymActivities, true);
    });
  });

  // ─── ONBOARDING BLOC EVENT TESTS ─────────────────────────────────────────

  group('OnboardingBloc — navigation events', () {
    late MockSaveUserProfile mockSave;
    late MockGetUserProfile mockGet;
    late OnboardingBloc bloc;

    setUp(() {
      mockSave = MockSaveUserProfile();
      mockGet = MockGetUserProfile();
      bloc = OnboardingBloc(
        saveUserProfile: mockSave,
        getUserProfile: mockGet,
      );
    });

    tearDown(() => bloc.close());

    test('initial state is step 0', () {
      expect(bloc.state.currentStep, 0);
      expect(bloc.state.status, OnboardingStatus.initial);
    });

    blocTest<OnboardingBloc, OnboardingState>(
      'OnboardingNameChanged updates name',
      build: () => bloc,
      act: (b) => b.add(const OnboardingNameChanged('Zaid')),
      expect: () => [
        isA<OnboardingState>().having((s) => s.name, 'name', 'Zaid'),
      ],
    );

    blocTest<OnboardingBloc, OnboardingState>(
      'OnboardingGenderChanged updates gender',
      build: () => bloc,
      act: (b) => b.add(const OnboardingGenderChanged('female')),
      expect: () => [
        isA<OnboardingState>().having((s) => s.gender, 'gender', 'female'),
      ],
    );

    blocTest<OnboardingBloc, OnboardingState>(
      'OnboardingNextStep from step 0 goes to step 1',
      build: () => bloc,
      seed: () => const OnboardingState(currentStep: 0, name: 'Zaid', gender: 'male'),
      act: (b) => b.add(const OnboardingNextStep()),
      expect: () => [
        isA<OnboardingState>().having((s) => s.currentStep, 'step', 1),
      ],
    );

    blocTest<OnboardingBloc, OnboardingState>(
      'OnboardingPreviousStep decrements step',
      build: () => bloc,
      seed: () => const OnboardingState(currentStep: 3),
      act: (b) => b.add(const OnboardingPreviousStep()),
      expect: () => [
        isA<OnboardingState>().having((s) => s.currentStep, 'step', 2),
      ],
    );

    blocTest<OnboardingBloc, OnboardingState>(
      'OnboardingPreviousStep on step 0 stays at 0',
      build: () => bloc,
      seed: () => const OnboardingState(currentStep: 0),
      act: (b) => b.add(const OnboardingPreviousStep()),
      // bloc does nothing when already at step 0 — no emit is the correct behaviour
      expect: () => [],
    );

    blocTest<OnboardingBloc, OnboardingState>(
      'OnboardingGoToStep jumps to target step directly',
      build: () => bloc,
      act: (b) => b.add(const OnboardingGoToStep(4)),
      expect: () => [
        isA<OnboardingState>().having((s) => s.currentStep, 'step', 4),
      ],
    );
  });

  group('OnboardingBloc — submission flow', () {
    late MockSaveUserProfile mockSave;
    late MockGetUserProfile mockGet;
    late OnboardingBloc bloc;

    const readyState = OnboardingState(
      currentStep: 5,
      name: 'Zaid',
      gender: 'male',
      occupationId: 'student',
      occupationLabel: 'Student',
      occupationType: 'student',
      workStartHour: 9,
      workStartMinute: 0,
      workEndHour: 17,
      workEndMinute: 0,
      workDays: [0, 1, 2, 3, 4],
      latitude: 30.0444,
      longitude: 31.2357,
      city: 'Cairo',
      calculationMethod: 'MuslimWorldLeague',
      madhab: 'shafi',
      prayerBufferMinutes: 10,
      targetSleepHours: 7,
      dailyQuranPagesGoal: 2,
    );

    setUp(() {
      mockSave = MockSaveUserProfile();
      mockGet = MockGetUserProfile();
      bloc = OnboardingBloc(
        saveUserProfile: mockSave,
        getUserProfile: mockGet,
      );
    });

    tearDown(() => bloc.close());

    blocTest<OnboardingBloc, OnboardingState>(
      'OnboardingSubmitted emits submitting then success when save succeeds',
      build: () {
        when(() => mockSave(any()))
            .thenAnswer((_) async => Right(makeProfile()));
        return bloc;
      },
      seed: () => readyState,
      act: (b) => b.add(const OnboardingSubmitted()),
      expect: () => [
        isA<OnboardingState>()
            .having((s) => s.status, 'status', OnboardingStatus.submitting),
        isA<OnboardingState>()
            .having((s) => s.status, 'status', OnboardingStatus.success),
      ],
      verify: (_) {
        verify(() => mockSave(any())).called(1);
      },
    );

    blocTest<OnboardingBloc, OnboardingState>(
      'OnboardingSubmitted emits submitting then failure when save fails',
      build: () {
        when(() => mockSave(any())).thenAnswer(
          (_) async => const Left(DatabaseFailure('disk full')),
        );
        return bloc;
      },
      seed: () => readyState,
      act: (b) => b.add(const OnboardingSubmitted()),
      expect: () => [
        isA<OnboardingState>()
            .having((s) => s.status, 'status', OnboardingStatus.submitting),
        isA<OnboardingState>()
            .having((s) => s.status, 'status', OnboardingStatus.failure)
            .having((s) => s.errorMessage, 'error', isNotNull),
      ],
    );
  });

  // ─── TIMELINE BLOC TESTS ─────────────────────────────────────────────────

  group('TimelineBloc — generate on first launch after onboarding', () {
    late MockGenerateAndSaveTimeline mockGenerate;
    late MockGetTimeline mockGetTimeline;
    late MockPrayerTimeService mockPrayerTimeService;
    late TimelineBloc bloc;

    setUp(() {
      mockGenerate = MockGenerateAndSaveTimeline();
      mockGetTimeline = MockGetTimeline();
      mockPrayerTimeService = MockPrayerTimeService();
      // getPrayerTimes is called synchronously in every handler — stub it globally
      when(() => mockPrayerTimeService.getPrayerTimes(
        profile: any(named: 'profile'),
        date: any(named: 'date'),
      )).thenReturn(const Left(DatabaseFailure('no prayer times')));

      bloc = TimelineBloc(
        generateAndSaveTimeline: mockGenerate,
        getTimeline: mockGetTimeline,
        completeBlock: MockCompleteBlock(),
        skipBlock: MockSkipBlock(),
        setMorningIntention: MockSetMorningIntention(),
        setEveningReflection: MockSetEveningReflection(),
        prayerTimeService: mockPrayerTimeService,
      );
    });

    tearDown(() => bloc.close());

    blocTest<TimelineBloc, TimelineState>(
      'TimelineGenerateRequested transitions generating → loaded on success',
      build: () {
        when(() => mockGenerate(any()))
            .thenAnswer((_) async => Right(makeTimeline()));
        return bloc;
      },
      act: (b) => b.add(TimelineGenerateRequested(
        profile: makeProfile(),
        date: DateTime(2024, 6, 1),
      )),
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
      'TimelineGenerateRequested emits error when generate fails',
      build: () {
        when(() => mockGenerate(any())).thenAnswer(
          (_) async => const Left(DatabaseFailure('isar write failed')),
        );
        return bloc;
      },
      act: (b) => b.add(TimelineGenerateRequested(
        profile: makeProfile(),
        date: DateTime(2024, 6, 1),
      )),
      expect: () => [
        isA<TimelineState>()
            .having((s) => s.status, 'status', TimelineStatus.generating),
        isA<TimelineState>()
            .having((s) => s.status, 'status', TimelineStatus.error)
            .having((s) => s.errorMessage, 'error', isNotNull),
      ],
    );

    blocTest<TimelineBloc, TimelineState>(
      'TimelineLoadRequested uses DB cache and does NOT call generate when cached',
      build: () {
        when(() => mockGetTimeline(any()))
            .thenAnswer((_) async => Right(makeTimeline()));
        return bloc;
      },
      act: (b) => b.add(TimelineLoadRequested(
        profile: makeProfile(),
        date: DateTime(2024, 6, 1),
      )),
      expect: () => [
        isA<TimelineState>()
            .having((s) => s.status, 'status', TimelineStatus.loading),
        isA<TimelineState>()
            .having((s) => s.status, 'status', TimelineStatus.loaded),
      ],
      verify: (_) {
        verify(() => mockGetTimeline(any())).called(1);
        verifyNever(() => mockGenerate(any()));
      },
    );

    blocTest<TimelineBloc, TimelineState>(
      'TimelineLoadRequested auto-generates when DB miss on first launch',
      build: () {
        // Right(null) = "no cached timeline" → triggers auto-generate
        // Left(failure) would emit an error state instead
        when(() => mockGetTimeline(any())).thenAnswer(
          (_) async => const Right(null),
        );
        when(() => mockGenerate(any()))
            .thenAnswer((_) async => Right(makeTimeline()));
        return bloc;
      },
      act: (b) => b.add(TimelineLoadRequested(
        profile: makeProfile(),
        date: DateTime(2024, 6, 1),
      )),
      expect: () => [
        isA<TimelineState>()
            .having((s) => s.status, 'status', TimelineStatus.loading),
        isA<TimelineState>()
            .having((s) => s.status, 'status', TimelineStatus.generating),
        isA<TimelineState>()
            .having((s) => s.status, 'status', TimelineStatus.loaded),
      ],
      verify: (_) {
        verify(() => mockGetTimeline(any())).called(1);
        verify(() => mockGenerate(any())).called(1);
      },
    );
  });
}
