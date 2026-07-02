import 'package:isar/isar.dart';
import '../../domain/entities/ramadan_entities.dart';

part 'ramadan_profile_model.g.dart';

@collection
class RamadanProfileModel {
  Id id = Isar.autoIncrement;

  late int suhoorWakeMinutesBeforeFajr;
  late int suhoorDurationMinutes;
  late bool hasIftarGathering;
  late int iftarDurationMinutes;
  late bool praysTarawih;
  late int tarawihDurationMinutes;
  late bool praysWitr;
  late bool hasReducedWorkHours;
  late int reducedWorkEndHour;
  late int reducedWorkEndMinute;
  late int nightSleepHours;
  late int daySleepMinutes;
  late int ramadanQuranPagesGoal;
  late bool hasLaylatAlQadrMode;
  late DateTime createdAt;
  late DateTime updatedAt;

  static RamadanProfileModel fromEntity(RamadanProfile e) {
    final m = RamadanProfileModel()
      ..suhoorWakeMinutesBeforeFajr = e.suhoorWakeMinutesBeforeFajr
      ..suhoorDurationMinutes = e.suhoorDurationMinutes
      ..hasIftarGathering = e.hasIftarGathering
      ..iftarDurationMinutes = e.iftarDurationMinutes
      ..praysTarawih = e.praysTarawih
      ..tarawihDurationMinutes = e.tarawihDurationMinutes
      ..praysWitr = e.praysWitr
      ..hasReducedWorkHours = e.hasReducedWorkHours
      ..reducedWorkEndHour = e.reducedWorkEndHour
      ..reducedWorkEndMinute = e.reducedWorkEndMinute
      ..nightSleepHours = e.nightSleepHours
      ..daySleepMinutes = e.daySleepMinutes
      ..ramadanQuranPagesGoal = e.ramadanQuranPagesGoal
      ..hasLaylatAlQadrMode = e.hasLaylatAlQadrMode
      ..createdAt = e.createdAt
      ..updatedAt = e.updatedAt;
    if (e.id > 0) m.id = e.id;
    return m;
  }

  RamadanProfile toEntity() => RamadanProfile(
        id: id,
        suhoorWakeMinutesBeforeFajr: suhoorWakeMinutesBeforeFajr,
        suhoorDurationMinutes: suhoorDurationMinutes,
        hasIftarGathering: hasIftarGathering,
        iftarDurationMinutes: iftarDurationMinutes,
        praysTarawih: praysTarawih,
        tarawihDurationMinutes: tarawihDurationMinutes,
        praysWitr: praysWitr,
        hasReducedWorkHours: hasReducedWorkHours,
        reducedWorkEndHour: reducedWorkEndHour,
        reducedWorkEndMinute: reducedWorkEndMinute,
        nightSleepHours: nightSleepHours,
        daySleepMinutes: daySleepMinutes,
        ramadanQuranPagesGoal: ramadanQuranPagesGoal,
        hasLaylatAlQadrMode: hasLaylatAlQadrMode,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}
