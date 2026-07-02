import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

import '../../domain/entities/user_profile.dart';
import '../../domain/usecases/onboarding_usecases.dart';

part 'onboarding_event.dart';
part 'onboarding_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  final SaveUserProfile saveUserProfile;
  final GetUserProfile getUserProfile;

  static const int totalSteps = 6;

  OnboardingBloc({
    required this.saveUserProfile,
    required this.getUserProfile,
  }) : super(const OnboardingState()) {
    on<OnboardingNextStep>(_onNextStep);
    on<OnboardingPreviousStep>(_onPreviousStep);
    on<OnboardingGoToStep>(_onGoToStep);

    // Personal Info
    on<OnboardingNameChanged>(_onNameChanged);
    on<OnboardingGenderChanged>(_onGenderChanged);

    // Occupation
    on<OnboardingOccupationSelected>(_onOccupationSelected);

    // Work Schedule
    on<OnboardingWorkStartTimeChanged>(_onWorkStartTimeChanged);
    on<OnboardingWorkEndTimeChanged>(_onWorkEndTimeChanged);
    on<OnboardingWorkDayToggled>(_onWorkDayToggled);

    // Prayer / Location
    on<OnboardingLocationRequested>(_onLocationRequested);
    on<OnboardingLocationReceived>(_onLocationReceived);
    on<OnboardingCalculationMethodChanged>(_onCalculationMethodChanged);
    on<OnboardingMadhabChanged>(_onMadhabChanged);
    on<OnboardingPrayerBufferChanged>(_onPrayerBufferChanged);

    // Fitness
    on<OnboardingFitnessActivityToggled>(_onFitnessActivityToggled);
    on<OnboardingGymDayToggled>(_onGymDayToggled);
    on<OnboardingGymDurationChanged>(_onGymDurationChanged);
    on<OnboardingPreferredGymTimeChanged>(_onPreferredGymTimeChanged);

    // Sleep
    on<OnboardingTargetSleepHoursChanged>(_onTargetSleepHoursChanged);
    on<OnboardingFajrOffsetChanged>(_onFajrOffsetChanged);
    on<OnboardingQuranGoalChanged>(_onQuranGoalChanged);
    on<OnboardingCycleAwareToggled>(_onCycleAwareToggled);

    // Submit
    on<OnboardingSubmitted>(_onSubmitted);
  }

  // ─── NAVIGATION ─────────────────────────────────────────────────────────────
  void _onNextStep(OnboardingNextStep event, Emitter<OnboardingState> emit) {
    if (!state.isCurrentStepValid) {
      emit(state.copyWith(
        status: OnboardingStatus.stepInvalid,
        errorMessage: _getValidationMessage(state.currentStep),
      ));
      return;
    }

    if (state.currentStep < totalSteps - 1) {
      emit(state.copyWith(
        currentStep: state.currentStep + 1,
        status: OnboardingStatus.initial,
      ));
    } else {
      add(const OnboardingSubmitted());
    }
  }

  void _onPreviousStep(
      OnboardingPreviousStep event, Emitter<OnboardingState> emit) {
    if (state.currentStep > 0) {
      emit(state.copyWith(
        currentStep: state.currentStep - 1,
        status: OnboardingStatus.initial,
      ));
    }
  }

  void _onGoToStep(OnboardingGoToStep event, Emitter<OnboardingState> emit) {
    if (event.step >= 0 && event.step < totalSteps) {
      emit(state.copyWith(
        currentStep: event.step,
        status: OnboardingStatus.initial,
      ));
    }
  }

  // ─── PERSONAL INFO ──────────────────────────────────────────────────────────
  void _onNameChanged(
      OnboardingNameChanged event, Emitter<OnboardingState> emit) {
    emit(state.copyWith(name: event.name, status: OnboardingStatus.initial));
  }

  void _onGenderChanged(
      OnboardingGenderChanged event, Emitter<OnboardingState> emit) {
    emit(state.copyWith(
        gender: event.gender, status: OnboardingStatus.initial));
  }

  // ─── OCCUPATION ─────────────────────────────────────────────────────────────
  void _onOccupationSelected(
      OnboardingOccupationSelected event, Emitter<OnboardingState> emit) {
    emit(state.copyWith(
      occupationId: event.occupationId,
      occupationLabel: event.occupationLabel,
      occupationType: event.occupationType,
      status: OnboardingStatus.initial,
    ));
  }

  // ─── WORK SCHEDULE ──────────────────────────────────────────────────────────
  void _onWorkStartTimeChanged(
      OnboardingWorkStartTimeChanged event, Emitter<OnboardingState> emit) {
    emit(state.copyWith(
      workStartHour: event.hour,
      workStartMinute: event.minute,
      status: OnboardingStatus.initial,
    ));
  }

  void _onWorkEndTimeChanged(
      OnboardingWorkEndTimeChanged event, Emitter<OnboardingState> emit) {
    emit(state.copyWith(
      workEndHour: event.hour,
      workEndMinute: event.minute,
      status: OnboardingStatus.initial,
    ));
  }

  void _onWorkDayToggled(
      OnboardingWorkDayToggled event, Emitter<OnboardingState> emit) {
    final days = List<int>.from(state.workDays);
    if (days.contains(event.dayIndex)) {
      days.remove(event.dayIndex);
    } else {
      days.add(event.dayIndex);
      days.sort();
    }
    emit(state.copyWith(workDays: days, status: OnboardingStatus.initial));
  }

  // ─── LOCATION & PRAYER ──────────────────────────────────────────────────────
  Future<void> _onLocationRequested(
      OnboardingLocationRequested event, Emitter<OnboardingState> emit) async {
    emit(state.copyWith(status: OnboardingStatus.locationLoading));

    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        emit(state.copyWith(
          status: OnboardingStatus.failure,
          errorMessage:
              'Location services are disabled. Please enable Location in your device settings.',
        ));
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever ||
          permission == LocationPermission.denied) {
        emit(state.copyWith(
          status: OnboardingStatus.failure,
          errorMessage:
              'Location permission is required for accurate prayer times. '
              'Please enable it in your device settings.',
        ));
        return;
      }

      // Try last known position first (instant); fall back to fresh fix with timeout.
      Position? position;
      try {
        position = await Geolocator.getLastKnownPosition();
      } catch (_) {}

      position ??= await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
      ).timeout(
        const Duration(seconds: 15),
        onTimeout: () => throw TimeoutException('Location request timed out'),
      );

      // Reverse geocode to get city name
      String city = 'Your City';
      String timezone = DateTime.now().timeZoneName;
      try {
        final placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );
        if (placemarks.isNotEmpty) {
          final place = placemarks.first;
          city = [
            place.locality,
            place.subAdministrativeArea,
            place.administrativeArea,
          ].firstWhere((s) => s != null && s.isNotEmpty, orElse: () => 'Your City') ?? 'Your City';
        }
      } catch (_) {
        // Geocoding failed — use coordinates silently
      }

      add(OnboardingLocationReceived(
        latitude: position.latitude,
        longitude: position.longitude,
        city: city,
        timezone: timezone,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: OnboardingStatus.failure,
        errorMessage: 'Could not get your location. Please try again.',
      ));
    }
  }

  void _onLocationReceived(
      OnboardingLocationReceived event, Emitter<OnboardingState> emit) {
    emit(state.copyWith(
      latitude: event.latitude,
      longitude: event.longitude,
      city: event.city,
      timezone: event.timezone,
      status: OnboardingStatus.stepValid,
    ));
  }

  void _onCalculationMethodChanged(
      OnboardingCalculationMethodChanged event, Emitter<OnboardingState> emit) {
    emit(state.copyWith(
        calculationMethod: event.method, status: OnboardingStatus.initial));
  }

  void _onMadhabChanged(
      OnboardingMadhabChanged event, Emitter<OnboardingState> emit) {
    emit(state.copyWith(
        madhab: event.madhab, status: OnboardingStatus.initial));
  }

  void _onPrayerBufferChanged(
      OnboardingPrayerBufferChanged event, Emitter<OnboardingState> emit) {
    emit(state.copyWith(
        prayerBufferMinutes: event.minutes, status: OnboardingStatus.initial));
  }

  // ─── FITNESS ────────────────────────────────────────────────────────────────
  void _onFitnessActivityToggled(
      OnboardingFitnessActivityToggled event, Emitter<OnboardingState> emit) {
    final activities = List<String>.from(state.fitnessActivityIds);

    if (event.activityId == 'none') {
      // Selecting "none" clears everything else
      emit(state.copyWith(
        fitnessActivityIds: ['none'],
        gymDays: [],
        status: OnboardingStatus.initial,
      ));
      return;
    }

    // Remove 'none' if another activity is selected
    activities.remove('none');

    if (activities.contains(event.activityId)) {
      activities.remove(event.activityId);
    } else {
      activities.add(event.activityId);
    }
    emit(state.copyWith(
        fitnessActivityIds: activities, status: OnboardingStatus.initial));
  }

  void _onGymDayToggled(
      OnboardingGymDayToggled event, Emitter<OnboardingState> emit) {
    final days = List<int>.from(state.gymDays);
    if (days.contains(event.dayIndex)) {
      days.remove(event.dayIndex);
    } else {
      days.add(event.dayIndex);
      days.sort();
    }
    emit(state.copyWith(gymDays: days, status: OnboardingStatus.initial));
  }

  void _onGymDurationChanged(
      OnboardingGymDurationChanged event, Emitter<OnboardingState> emit) {
    emit(state.copyWith(
        gymDurationMinutes: event.minutes, status: OnboardingStatus.initial));
  }

  void _onPreferredGymTimeChanged(
      OnboardingPreferredGymTimeChanged event, Emitter<OnboardingState> emit) {
    emit(state.copyWith(
        preferredGymTime: event.timeId, status: OnboardingStatus.initial));
  }

  // ─── SLEEP ──────────────────────────────────────────────────────────────────
  void _onTargetSleepHoursChanged(
      OnboardingTargetSleepHoursChanged event, Emitter<OnboardingState> emit) {
    emit(state.copyWith(
        targetSleepHours: event.hours, status: OnboardingStatus.initial));
  }

  void _onFajrOffsetChanged(
      OnboardingFajrOffsetChanged event, Emitter<OnboardingState> emit) {
    emit(state.copyWith(
        wakeUpOffsetFromFajrMinutes: event.minutes,
        status: OnboardingStatus.initial));
  }

  void _onQuranGoalChanged(
      OnboardingQuranGoalChanged event, Emitter<OnboardingState> emit) {
    emit(state.copyWith(
        dailyQuranPagesGoal: event.pages, status: OnboardingStatus.initial));
  }

  void _onCycleAwareToggled(
      OnboardingCycleAwareToggled event, Emitter<OnboardingState> emit) {
    emit(state.copyWith(
        cycleAwareStreaks: event.enabled, status: OnboardingStatus.initial));
  }

  // ─── SUBMIT ─────────────────────────────────────────────────────────────────
  Future<void> _onSubmitted(
      OnboardingSubmitted event, Emitter<OnboardingState> emit) async {
    emit(state.copyWith(status: OnboardingStatus.submitting));

    final profile = UserProfile(
      name: state.name.trim(),
      gender: state.gender,
      occupationId: state.occupationId,
      occupationLabel: state.occupationLabel,
      occupationType: state.occupationType,
      workStartHour: state.workStartHour,
      workStartMinute: state.workStartMinute,
      workEndHour: state.workEndHour,
      workEndMinute: state.workEndMinute,
      workDays: state.workDays,
      latitude: state.latitude ?? 0.0,
      longitude: state.longitude ?? 0.0,
      city: state.city,
      timezone: state.timezone,
      calculationMethod: state.calculationMethod,
      madhab: state.madhab,
      prayerBufferMinutes: state.prayerBufferMinutes,
      fitnessActivityIds: state.fitnessActivityIds,
      gymDays: state.gymDays,
      gymDurationMinutes: state.gymDurationMinutes,
      preferredGymTime: state.preferredGymTime,
      targetSleepHours: state.targetSleepHours,
      wakeUpOffsetFromFajrMinutes: state.wakeUpOffsetFromFajrMinutes,
      dailyQuranPagesGoal: state.dailyQuranPagesGoal,
      isRamadanMode: false,
      cycleAwareStreaks: state.cycleAwareStreaks,
      createdAt: DateTime.now(),
      isOnboardingComplete: true,
    );

    final result = await saveUserProfile(profile);

    result.fold(
      (failure) => emit(state.copyWith(
        status: OnboardingStatus.failure,
        errorMessage: failure.message,
      )),
      (savedProfile) => emit(state.copyWith(
        status: OnboardingStatus.success,
        successMessage: 'Profile saved successfully',
      )),
    );
  }

  // ─── HELPERS ────────────────────────────────────────────────────────────────
  String _getValidationMessage(int step) {
    switch (step) {
      case 0:
        return 'Please enter your name (at least 2 characters) and select your gender.';
      case 1:
        return 'Please select your occupation.';
      case 2:
        return 'Please select at least one work day and a valid time range.';
      case 3:
        return 'Tap "Use My Location" to fetch your coordinates before continuing.';
      default:
        return 'Please complete all required fields.';
    }
  }
}
