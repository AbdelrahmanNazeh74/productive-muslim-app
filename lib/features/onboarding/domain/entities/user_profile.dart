import 'package:equatable/equatable.dart';

class UserProfile extends Equatable {
  final int? id;
  final String name;
  final String gender; // 'male' | 'female'

  // Occupation
  final String occupationId;
  final String occupationLabel;
  final String occupationType; // 'office' | 'remote' | 'student' | 'home'

  // Work schedule
  final int workStartHour;
  final int workStartMinute;
  final int workEndHour;
  final int workEndMinute;
  final List<int> workDays; // 0=Mon … 6=Sun

  // Location
  final double latitude;
  final double longitude;
  final String city;
  final String timezone;

  // Prayer settings
  final String calculationMethod;
  final String madhab; // 'hanafi' | 'shafi'
  final int prayerBufferMinutes;

  // Fitness
  final List<String> fitnessActivityIds;
  final List<int> gymDays; // 0=Mon … 6=Sun
  final int gymDurationMinutes;
  final String preferredGymTime;

  // Sleep
  final int targetSleepHours;
  final int wakeUpOffsetFromFajrMinutes; // negative = before Fajr

  // Quran
  final int dailyQuranPagesGoal;

  // Personalization
  final bool isRamadanMode;
  final bool cycleAwareStreaks; // for female users

  // Meta
  final DateTime createdAt;
  final bool isOnboardingComplete;

  const UserProfile({
    this.id,
    required this.name,
    required this.gender,
    required this.occupationId,
    required this.occupationLabel,
    required this.occupationType,
    required this.workStartHour,
    required this.workStartMinute,
    required this.workEndHour,
    required this.workEndMinute,
    required this.workDays,
    required this.latitude,
    required this.longitude,
    required this.city,
    required this.timezone,
    required this.calculationMethod,
    required this.madhab,
    this.prayerBufferMinutes = 10,
    required this.fitnessActivityIds,
    required this.gymDays,
    this.gymDurationMinutes = 60,
    required this.preferredGymTime,
    this.targetSleepHours = 7,
    this.wakeUpOffsetFromFajrMinutes = -30,
    this.dailyQuranPagesGoal = 2,
    this.isRamadanMode = false,
    this.cycleAwareStreaks = false,
    required this.createdAt,
    this.isOnboardingComplete = false,
  });

  UserProfile copyWith({
    int? id,
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
    bool? isRamadanMode,
    bool? cycleAwareStreaks,
    DateTime? createdAt,
    bool? isOnboardingComplete,
  }) {
    return UserProfile(
      id: id ?? this.id,
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
      isRamadanMode: isRamadanMode ?? this.isRamadanMode,
      cycleAwareStreaks: cycleAwareStreaks ?? this.cycleAwareStreaks,
      createdAt: createdAt ?? this.createdAt,
      isOnboardingComplete: isOnboardingComplete ?? this.isOnboardingComplete,
    );
  }

  // Convenience getters
  bool get hasWorkSchedule =>
      workStartHour != 0 || workEndHour != 0;

  String get workTimeLabel =>
      '${_formatHour(workStartHour, workStartMinute)} – ${_formatHour(workEndHour, workEndMinute)}';

  int get workDurationHours =>
      ((workEndHour * 60 + workEndMinute) -
              (workStartHour * 60 + workStartMinute)) ~/
          60;

  String _formatHour(int hour, int minute) {
    final period = hour < 12 ? 'AM' : 'PM';
    final h = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
    final m = minute.toString().padLeft(2, '0');
    return '$h:$m $period';
  }

  @override
  List<Object?> get props => [
        id,
        name,
        gender,
        occupationId,
        latitude,
        longitude,
        calculationMethod,
        isOnboardingComplete,
      ];
}
