import 'package:equatable/equatable.dart';

// ─── HIJRI DATE ───────────────────────────────────────────────────────────────
/// Lightweight Hijri calendar representation.
/// Full conversion is handled by [HijriConverter].
class HijriDate extends Equatable {
  final int year;
  final int month;  // 1–12
  final int day;    // 1–30

  const HijriDate({
    required this.year,
    required this.month,
    required this.day,
  });

  static const List<String> monthNames = [
    'Muharram', 'Safar', "Rabi' al-Awwal", "Rabi' al-Thani",
    'Jumada al-Awwal', 'Jumada al-Thani', 'Rajab', "Sha'ban",
    'Ramadan', 'Shawwal', "Dhu al-Qi'dah", 'Dhu al-Hijjah',
  ];

  String get monthName =>
      month >= 1 && month <= 12 ? monthNames[month - 1] : 'Unknown';

  bool get isRamadan => month == 9;

  /// Day of Ramadan (1–30), or null if not in Ramadan
  int? get ramadanDay => isRamadan ? day : null;

  @override
  String toString() => '$day $monthName $year AH';

  @override
  List<Object?> get props => [year, month, day];
}

// ─── RAMADAN TIMES ────────────────────────────────────────────────────────────
/// Holds all key Ramadan time anchors for a single day.
class RamadanTimes extends Equatable {
  final DateTime date;

  // Core Ramadan times
  final DateTime suhoorEnd;      // Latest time to eat (= Fajr adhan)
  final DateTime suhoorStart;    // Recommended: ~30–45 min before Fajr
  final DateTime iftarTime;      // = Maghrib adhan (break fast)
  final DateTime tarawihStart;   // After Isha prayer + dhikr (~20 min)
  final DateTime tarawihEnd;     // Tarawih duration (20 rak'ah ≈ 60–90 min)
  final DateTime sehriWakeUp;    // User's Suhoor wake-up alarm

  // Re-exported standard prayer times for convenience
  final DateTime fajr;
  final DateTime maghrib;
  final DateTime isha;

  const RamadanTimes({
    required this.date,
    required this.suhoorEnd,
    required this.suhoorStart,
    required this.iftarTime,
    required this.tarawihStart,
    required this.tarawihEnd,
    required this.sehriWakeUp,
    required this.fajr,
    required this.maghrib,
    required this.isha,
  });

  /// Duration of the fasting window in hours
  double get fastingHours =>
      iftarTime.difference(suhoorEnd).inMinutes / 60.0;

  /// Time remaining until Iftar (can be negative = already broken fast)
  Duration timeUntilIftar(DateTime now) => iftarTime.difference(now);

  /// True if currently in the fasting window
  bool isFasting(DateTime now) =>
      now.isAfter(suhoorEnd) && now.isBefore(iftarTime);

  String get fastingHoursLabel =>
      '${fastingHours.toStringAsFixed(1)}h fast';

  @override
  List<Object?> get props => [date, suhoorEnd, iftarTime, tarawihStart];
}

// ─── RAMADAN PROFILE ─────────────────────────────────────────────────────────
/// User's personalised Ramadan settings — stored once, applied each day.
class RamadanProfile extends Equatable {
  final int id;

  // Suhoor
  final int suhoorWakeMinutesBeforeFajr;   // Default: 45
  final int suhoorDurationMinutes;          // Time to eat: 30

  // Iftar
  final bool hasIftarGathering;            // shifts timeline post-Iftar
  final int iftarDurationMinutes;           // 45 (gathering) or 20 (solo)

  // Tarawih
  final bool praysTarawih;
  final int tarawihDurationMinutes;         // 60 (short) or 90 (full)
  final bool praysWitr;

  // Work
  final bool hasReducedWorkHours;
  final int reducedWorkEndHour;             // e.g. 14 (2 PM) in Ramadan
  final int reducedWorkEndMinute;

  // Sleep — Ramadan sleep pattern typically splits:
  // Night sleep: after Tarawih → before Suhoor (~3–4h)
  // Day sleep:   Qaylula extended (~60–90 min) between Dhuhr and Asr
  final int nightSleepHours;               // 3–5
  final int daySleepMinutes;               // 60–120

  // Quran
  final int ramadanQuranPagesGoal;          // typically 20 (one juz/day)

  // Laylat al-Qadr preparation (last 10 nights)
  final bool hasLaylatAlQadrMode;

  final DateTime createdAt;
  final DateTime updatedAt;

  const RamadanProfile({
    required this.id,
    this.suhoorWakeMinutesBeforeFajr = 45,
    this.suhoorDurationMinutes = 30,
    this.hasIftarGathering = false,
    this.iftarDurationMinutes = 30,
    this.praysTarawih = true,
    this.tarawihDurationMinutes = 75,
    this.praysWitr = true,
    this.hasReducedWorkHours = false,
    this.reducedWorkEndHour = 14,
    this.reducedWorkEndMinute = 0,
    this.nightSleepHours = 4,
    this.daySleepMinutes = 90,
    this.ramadanQuranPagesGoal = 20,
    this.hasLaylatAlQadrMode = true,
    required this.createdAt,
    required this.updatedAt,
  });

  RamadanProfile copyWith({
    int? id,
    int? suhoorWakeMinutesBeforeFajr,
    int? suhoorDurationMinutes,
    bool? hasIftarGathering,
    int? iftarDurationMinutes,
    bool? praysTarawih,
    int? tarawihDurationMinutes,
    bool? praysWitr,
    bool? hasReducedWorkHours,
    int? reducedWorkEndHour,
    int? reducedWorkEndMinute,
    int? nightSleepHours,
    int? daySleepMinutes,
    int? ramadanQuranPagesGoal,
    bool? hasLaylatAlQadrMode,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return RamadanProfile(
      id: id ?? this.id,
      suhoorWakeMinutesBeforeFajr:
          suhoorWakeMinutesBeforeFajr ?? this.suhoorWakeMinutesBeforeFajr,
      suhoorDurationMinutes:
          suhoorDurationMinutes ?? this.suhoorDurationMinutes,
      hasIftarGathering: hasIftarGathering ?? this.hasIftarGathering,
      iftarDurationMinutes:
          iftarDurationMinutes ?? this.iftarDurationMinutes,
      praysTarawih: praysTarawih ?? this.praysTarawih,
      tarawihDurationMinutes:
          tarawihDurationMinutes ?? this.tarawihDurationMinutes,
      praysWitr: praysWitr ?? this.praysWitr,
      hasReducedWorkHours:
          hasReducedWorkHours ?? this.hasReducedWorkHours,
      reducedWorkEndHour:
          reducedWorkEndHour ?? this.reducedWorkEndHour,
      reducedWorkEndMinute:
          reducedWorkEndMinute ?? this.reducedWorkEndMinute,
      nightSleepHours: nightSleepHours ?? this.nightSleepHours,
      daySleepMinutes: daySleepMinutes ?? this.daySleepMinutes,
      ramadanQuranPagesGoal:
          ramadanQuranPagesGoal ?? this.ramadanQuranPagesGoal,
      hasLaylatAlQadrMode:
          hasLaylatAlQadrMode ?? this.hasLaylatAlQadrMode,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id, suhoorWakeMinutesBeforeFajr, praysTarawih,
        tarawihDurationMinutes, hasReducedWorkHours,
        ramadanQuranPagesGoal, hasLaylatAlQadrMode,
      ];
}

// ─── RAMADAN DAY CONTEXT ─────────────────────────────────────────────────────
/// Everything needed to render the Ramadan version of a daily timeline.
class RamadanDayContext extends Equatable {
  final DateTime gregorianDate;
  final HijriDate hijriDate;
  final RamadanTimes times;
  final RamadanProfile profile;
  final int ramadanDayNumber;      // 1–30
  final bool isLastTenNights;      // Day 21–30
  final bool isOddNight;           // 21, 23, 25, 27, 29 — peak Laylat al-Qadr candidates
  final bool isJumuah;             // Friday

  const RamadanDayContext({
    required this.gregorianDate,
    required this.hijriDate,
    required this.times,
    required this.profile,
    required this.ramadanDayNumber,
    required this.isLastTenNights,
    required this.isOddNight,
    required this.isJumuah,
  });

  String get dayLabel => 'Day $ramadanDayNumber of Ramadan';

  String get specialLabel {
    if (isOddNight && isLastTenNights) return '⭐ Potential Laylat al-Qadr';
    if (isLastTenNights) return '🌙 Last Ten Nights';
    if (isJumuah) return '🕌 Jumu\'ah';
    return '';
  }

  @override
  List<Object?> get props =>
      [gregorianDate, ramadanDayNumber, isLastTenNights, isOddNight];
}
