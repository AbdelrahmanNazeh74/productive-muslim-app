part of 'onboarding_bloc.dart';

abstract class OnboardingEvent extends Equatable {
  const OnboardingEvent();

  @override
  List<Object?> get props => [];
}

// Navigation
class OnboardingNextStep extends OnboardingEvent {
  const OnboardingNextStep();
}

class OnboardingPreviousStep extends OnboardingEvent {
  const OnboardingPreviousStep();
}

class OnboardingGoToStep extends OnboardingEvent {
  final int step;
  const OnboardingGoToStep(this.step);

  @override
  List<Object?> get props => [step];
}

// Step 1 — Personal Info
class OnboardingNameChanged extends OnboardingEvent {
  final String name;
  const OnboardingNameChanged(this.name);

  @override
  List<Object?> get props => [name];
}

class OnboardingGenderChanged extends OnboardingEvent {
  final String gender;
  const OnboardingGenderChanged(this.gender);

  @override
  List<Object?> get props => [gender];
}

// Step 2 — Occupation
class OnboardingOccupationSelected extends OnboardingEvent {
  final String occupationId;
  final String occupationLabel;
  final String occupationType;

  const OnboardingOccupationSelected({
    required this.occupationId,
    required this.occupationLabel,
    required this.occupationType,
  });

  @override
  List<Object?> get props => [occupationId];
}

// Step 3 — Work Schedule
class OnboardingWorkStartTimeChanged extends OnboardingEvent {
  final int hour;
  final int minute;
  const OnboardingWorkStartTimeChanged(this.hour, this.minute);

  @override
  List<Object?> get props => [hour, minute];
}

class OnboardingWorkEndTimeChanged extends OnboardingEvent {
  final int hour;
  final int minute;
  const OnboardingWorkEndTimeChanged(this.hour, this.minute);

  @override
  List<Object?> get props => [hour, minute];
}

class OnboardingWorkDayToggled extends OnboardingEvent {
  final int dayIndex; // 0=Mon … 6=Sun
  const OnboardingWorkDayToggled(this.dayIndex);

  @override
  List<Object?> get props => [dayIndex];
}

// Step 4 — Prayer Settings
class OnboardingLocationRequested extends OnboardingEvent {
  const OnboardingLocationRequested();
}

class OnboardingLocationReceived extends OnboardingEvent {
  final double latitude;
  final double longitude;
  final String city;
  final String timezone;

  const OnboardingLocationReceived({
    required this.latitude,
    required this.longitude,
    required this.city,
    required this.timezone,
  });

  @override
  List<Object?> get props => [latitude, longitude, city];
}

class OnboardingCalculationMethodChanged extends OnboardingEvent {
  final String method;
  const OnboardingCalculationMethodChanged(this.method);

  @override
  List<Object?> get props => [method];
}

class OnboardingMadhabChanged extends OnboardingEvent {
  final String madhab;
  const OnboardingMadhabChanged(this.madhab);

  @override
  List<Object?> get props => [madhab];
}

class OnboardingPrayerBufferChanged extends OnboardingEvent {
  final int minutes;
  const OnboardingPrayerBufferChanged(this.minutes);

  @override
  List<Object?> get props => [minutes];
}

// Step 5 — Fitness
class OnboardingFitnessActivityToggled extends OnboardingEvent {
  final String activityId;
  const OnboardingFitnessActivityToggled(this.activityId);

  @override
  List<Object?> get props => [activityId];
}

class OnboardingGymDayToggled extends OnboardingEvent {
  final int dayIndex;
  const OnboardingGymDayToggled(this.dayIndex);

  @override
  List<Object?> get props => [dayIndex];
}

class OnboardingGymDurationChanged extends OnboardingEvent {
  final int minutes;
  const OnboardingGymDurationChanged(this.minutes);

  @override
  List<Object?> get props => [minutes];
}

class OnboardingPreferredGymTimeChanged extends OnboardingEvent {
  final String timeId;
  const OnboardingPreferredGymTimeChanged(this.timeId);

  @override
  List<Object?> get props => [timeId];
}

// Step 6 — Sleep
class OnboardingTargetSleepHoursChanged extends OnboardingEvent {
  final int hours;
  const OnboardingTargetSleepHoursChanged(this.hours);

  @override
  List<Object?> get props => [hours];
}

class OnboardingFajrOffsetChanged extends OnboardingEvent {
  final int minutes;
  const OnboardingFajrOffsetChanged(this.minutes);

  @override
  List<Object?> get props => [minutes];
}

class OnboardingQuranGoalChanged extends OnboardingEvent {
  final int pages;
  const OnboardingQuranGoalChanged(this.pages);

  @override
  List<Object?> get props => [pages];
}

class OnboardingCycleAwareToggled extends OnboardingEvent {
  final bool enabled;
  const OnboardingCycleAwareToggled(this.enabled);

  @override
  List<Object?> get props => [enabled];
}

// Submit
class OnboardingSubmitted extends OnboardingEvent {
  const OnboardingSubmitted();
}
