part of 'onboarding_bloc.dart';

enum OnboardingStatus {
  initial,
  loading,
  locationLoading,
  stepValid,
  stepInvalid,
  submitting,
  success,
  failure,
}

class OnboardingState extends Equatable {
  final int currentStep; // 0-indexed, 0=Welcome … 5=Sleep
  final OnboardingStatus status;
  final String? errorMessage;
  final String? successMessage;

  // Step 1 — Personal Info
  final String name;
  final String gender;

  // Step 2 — Occupation
  final String occupationId;
  final String occupationLabel;
  final String occupationType;

  // Step 3 — Work Schedule
  final int workStartHour;
  final int workStartMinute;
  final int workEndHour;
  final int workEndMinute;
  final List<int> workDays;

  // Step 4 — Prayer / Location
  final double? latitude;
  final double? longitude;
  final String city;
  final String timezone;
  final String calculationMethod;
  final String madhab;
  final int prayerBufferMinutes;

  // Step 5 — Fitness
  final List<String> fitnessActivityIds;
  final List<int> gymDays;
  final int gymDurationMinutes;
  final String preferredGymTime;

  // Step 6 — Sleep
  final int targetSleepHours;
  final int wakeUpOffsetFromFajrMinutes;
  final int dailyQuranPagesGoal;
  final bool cycleAwareStreaks;

  const OnboardingState({
    this.currentStep = 0,
    this.status = OnboardingStatus.initial,
    this.errorMessage,
    this.successMessage,
    this.name = '',
    this.gender = 'male',
    this.occupationId = '',
    this.occupationLabel = '',
    this.occupationType = '',
    this.workStartHour = 9,
    this.workStartMinute = 0,
    this.workEndHour = 17,
    this.workEndMinute = 0,
    this.workDays = const [0, 1, 2, 3, 4], // Mon–Fri
    this.latitude,
    this.longitude,
    this.city = '',
    this.timezone = '',
    this.calculationMethod = 'MuslimWorldLeague',
    this.madhab = 'shafi',
    this.prayerBufferMinutes = 10,
    this.fitnessActivityIds = const [],
    this.gymDays = const [],
    this.gymDurationMinutes = 60,
    this.preferredGymTime = 'evening',
    this.targetSleepHours = 7,
    this.wakeUpOffsetFromFajrMinutes = -30,
    this.dailyQuranPagesGoal = 2,
    this.cycleAwareStreaks = false,
  });

  bool get isCurrentStepValid {
    switch (currentStep) {
      case 0:
        return name.trim().length >= 2 && gender.isNotEmpty;
      case 1:
        return occupationId.isNotEmpty;
      case 2:
        return workDays.isNotEmpty &&
            (workEndHour * 60 + workEndMinute) >
                (workStartHour * 60 + workStartMinute);
      case 3:
        return latitude != null && longitude != null && city.isNotEmpty;
      case 4:
        return true; // Fitness is optional
      case 5:
        return true; // Sleep has defaults
      default:
        return false;
    }
  }

  bool get hasLocationPermission => latitude != null && longitude != null;

  bool get hasGymActivities =>
      fitnessActivityIds.isNotEmpty && !fitnessActivityIds.contains('none');

  OnboardingState copyWith({
    int? currentStep,
    OnboardingStatus? status,
    String? errorMessage,
    String? successMessage,
    String? name,
    String? gender,
    String? occupationId,
    String? occupationLabel,
    String? occupationType,
    int? workStartHour,
    int? workStartMinute,
    int? workEndHour,
    int? workEndMinute,
    List<int>? workDays,
    double? latitude,
    double? longitude,
    String? city,
    String? timezone,
    String? calculationMethod,
    String? madhab,
    int? prayerBufferMinutes,
    List<String>? fitnessActivityIds,
    List<int>? gymDays,
    int? gymDurationMinutes,
    String? preferredGymTime,
    int? targetSleepHours,
    int? wakeUpOffsetFromFajrMinutes,
    int? dailyQuranPagesGoal,
    bool? cycleAwareStreaks,
  }) {
    return OnboardingState(
      currentStep: currentStep ?? this.currentStep,
      status: status ?? this.status,
      errorMessage: errorMessage,
      successMessage: successMessage,
      name: name ?? this.name,
      gender: gender ?? this.gender,
      occupationId: occupationId ?? this.occupationId,
      occupationLabel: occupationLabel ?? this.occupationLabel,
      occupationType: occupationType ?? this.occupationType,
      workStartHour: workStartHour ?? this.workStartHour,
      workStartMinute: workStartMinute ?? this.workStartMinute,
      workEndHour: workEndHour ?? this.workEndHour,
      workEndMinute: workEndMinute ?? this.workEndMinute,
      workDays: workDays ?? this.workDays,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      city: city ?? this.city,
      timezone: timezone ?? this.timezone,
      calculationMethod: calculationMethod ?? this.calculationMethod,
      madhab: madhab ?? this.madhab,
      prayerBufferMinutes: prayerBufferMinutes ?? this.prayerBufferMinutes,
      fitnessActivityIds: fitnessActivityIds ?? this.fitnessActivityIds,
      gymDays: gymDays ?? this.gymDays,
      gymDurationMinutes: gymDurationMinutes ?? this.gymDurationMinutes,
      preferredGymTime: preferredGymTime ?? this.preferredGymTime,
      targetSleepHours: targetSleepHours ?? this.targetSleepHours,
      wakeUpOffsetFromFajrMinutes:
          wakeUpOffsetFromFajrMinutes ?? this.wakeUpOffsetFromFajrMinutes,
      dailyQuranPagesGoal: dailyQuranPagesGoal ?? this.dailyQuranPagesGoal,
      cycleAwareStreaks: cycleAwareStreaks ?? this.cycleAwareStreaks,
    );
  }

  @override
  List<Object?> get props => [
        currentStep,
        status,
        errorMessage,
        name,
        gender,
        occupationId,
        workStartHour,
        workEndHour,
        workDays,
        latitude,
        longitude,
        city,
        calculationMethod,
        madhab,
        prayerBufferMinutes,
        fitnessActivityIds,
        gymDays,
        gymDurationMinutes,
        preferredGymTime,
        targetSleepHours,
        wakeUpOffsetFromFajrMinutes,
        dailyQuranPagesGoal,
        cycleAwareStreaks,
      ];
}
