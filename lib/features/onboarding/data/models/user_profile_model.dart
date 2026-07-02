import 'package:isar/isar.dart';
import '../../domain/entities/user_profile.dart';

part 'user_profile_model.g.dart';

@collection
class UserProfileModel {
  Id id = Isar.autoIncrement;

  late String name;
  late String gender;

  // Occupation
  late String occupationId;
  late String occupationLabel;
  late String occupationType;

  // Work schedule
  late int workStartHour;
  late int workStartMinute;
  late int workEndHour;
  late int workEndMinute;
  late List<int> workDays;

  // Location
  late double latitude;
  late double longitude;
  late String city;
  late String timezone;

  // Prayer settings
  late String calculationMethod;
  late String madhab;
  late int prayerBufferMinutes;

  // Fitness
  late List<String> fitnessActivityIds;
  late List<int> gymDays;
  late int gymDurationMinutes;
  late String preferredGymTime;

  // Sleep
  late int targetSleepHours;
  late int wakeUpOffsetFromFajrMinutes;

  // Quran
  late int dailyQuranPagesGoal;

  // Personalization
  late bool isRamadanMode;
  late bool cycleAwareStreaks;

  // Meta
  late DateTime createdAt;
  late bool isOnboardingComplete;

  // ─── MAPPER: Model → Entity ─────────────────────────────────────────────────
  UserProfile toEntity() {
    return UserProfile(
      id: id,
      name: name,
      gender: gender,
      occupationId: occupationId,
      occupationLabel: occupationLabel,
      occupationType: occupationType,
      workStartHour: workStartHour,
      workStartMinute: workStartMinute,
      workEndHour: workEndHour,
      workEndMinute: workEndMinute,
      workDays: workDays,
      latitude: latitude,
      longitude: longitude,
      city: city,
      timezone: timezone,
      calculationMethod: calculationMethod,
      madhab: madhab,
      prayerBufferMinutes: prayerBufferMinutes,
      fitnessActivityIds: fitnessActivityIds,
      gymDays: gymDays,
      gymDurationMinutes: gymDurationMinutes,
      preferredGymTime: preferredGymTime,
      targetSleepHours: targetSleepHours,
      wakeUpOffsetFromFajrMinutes: wakeUpOffsetFromFajrMinutes,
      dailyQuranPagesGoal: dailyQuranPagesGoal,
      isRamadanMode: isRamadanMode,
      cycleAwareStreaks: cycleAwareStreaks,
      createdAt: createdAt,
      isOnboardingComplete: isOnboardingComplete,
    );
  }

  // ─── MAPPER: Entity → Model ─────────────────────────────────────────────────
  static UserProfileModel fromEntity(UserProfile entity) {
    final model = UserProfileModel();
    if (entity.id != null) model.id = entity.id!;
    model.name = entity.name;
    model.gender = entity.gender;
    model.occupationId = entity.occupationId;
    model.occupationLabel = entity.occupationLabel;
    model.occupationType = entity.occupationType;
    model.workStartHour = entity.workStartHour;
    model.workStartMinute = entity.workStartMinute;
    model.workEndHour = entity.workEndHour;
    model.workEndMinute = entity.workEndMinute;
    model.workDays = entity.workDays;
    model.latitude = entity.latitude;
    model.longitude = entity.longitude;
    model.city = entity.city;
    model.timezone = entity.timezone;
    model.calculationMethod = entity.calculationMethod;
    model.madhab = entity.madhab;
    model.prayerBufferMinutes = entity.prayerBufferMinutes;
    model.fitnessActivityIds = entity.fitnessActivityIds;
    model.gymDays = entity.gymDays;
    model.gymDurationMinutes = entity.gymDurationMinutes;
    model.preferredGymTime = entity.preferredGymTime;
    model.targetSleepHours = entity.targetSleepHours;
    model.wakeUpOffsetFromFajrMinutes = entity.wakeUpOffsetFromFajrMinutes;
    model.dailyQuranPagesGoal = entity.dailyQuranPagesGoal;
    model.isRamadanMode = entity.isRamadanMode;
    model.cycleAwareStreaks = entity.cycleAwareStreaks;
    model.createdAt = entity.createdAt;
    model.isOnboardingComplete = entity.isOnboardingComplete;
    return model;
  }
}
