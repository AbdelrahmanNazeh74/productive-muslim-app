import 'package:equatable/equatable.dart';

/// The 5 canonical prayer names, in order.
enum PrayerName { fajr, dhuhr, asr, maghrib, isha }

extension PrayerNameX on PrayerName {
  String get label {
    switch (this) {
      case PrayerName.fajr:    return 'Fajr';
      case PrayerName.dhuhr:   return 'Dhuhr';
      case PrayerName.asr:     return 'Asr';
      case PrayerName.maghrib: return 'Maghrib';
      case PrayerName.isha:    return 'Isha';
    }
  }

  String get emoji {
    switch (this) {
      case PrayerName.fajr:    return '🌅';
      case PrayerName.dhuhr:   return '☀️';
      case PrayerName.asr:     return '🌤';
      case PrayerName.maghrib: return '🌆';
      case PrayerName.isha:    return '🌙';
    }
  }

  /// Approximate duration of the prayer itself in minutes
  int get typicalDurationMinutes {
    switch (this) {
      case PrayerName.fajr:    return 10;
      case PrayerName.dhuhr:   return 15;
      case PrayerName.asr:     return 15;
      case PrayerName.maghrib: return 10;
      case PrayerName.isha:    return 20;
    }
  }
}

/// A single computed prayer time for a specific date.
class PrayerTime extends Equatable {
  final PrayerName name;
  final DateTime time;   // exact adhan time
  final DateTime date;

  const PrayerTime({
    required this.name,
    required this.time,
    required this.date,
  });

  /// Adhan + wudu buffer start (when to stop work)
  DateTime bufferStart(int bufferMinutes) =>
      time.subtract(Duration(minutes: bufferMinutes));

  /// End of prayer slot (adhan + typical prayer duration)
  DateTime prayerEnd() =>
      time.add(Duration(minutes: name.typicalDurationMinutes));

  String get formattedTime {
    final h = time.hour == 0
        ? 12
        : time.hour > 12
            ? time.hour - 12
            : time.hour;
    final m = time.minute.toString().padLeft(2, '0');
    final period = time.hour < 12 ? 'AM' : 'PM';
    return '$h:$m $period';
  }

  @override
  List<Object?> get props => [name, time, date];
}

/// All 5 prayer times for one day + Sunrise (for Ishraq golden hour).
class DailyPrayerTimes extends Equatable {
  final DateTime date;
  final PrayerTime fajr;
  final PrayerTime sunrise;   // not a salah — used for golden hour block
  final PrayerTime dhuhr;
  final PrayerTime asr;
  final PrayerTime maghrib;
  final PrayerTime isha;

  const DailyPrayerTimes({
    required this.date,
    required this.fajr,
    required this.sunrise,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
  });

  List<PrayerTime> get ordered =>
      [fajr, dhuhr, asr, maghrib, isha];

  PrayerTime byName(PrayerName name) {
    switch (name) {
      case PrayerName.fajr:    return fajr;
      case PrayerName.dhuhr:   return dhuhr;
      case PrayerName.asr:     return asr;
      case PrayerName.maghrib: return maghrib;
      case PrayerName.isha:    return isha;
    }
  }

  /// The window between Fajr end and Sunrise — the "Golden Hour"
  /// Research shows post-Fajr is peak cognitive clarity time.
  DateTimeRange get goldenHour => DateTimeRange(
        start: fajr.prayerEnd(),
        end: sunrise.time,
      );

  bool get hasGoldenHour =>
      sunrise.time.isAfter(fajr.prayerEnd().add(const Duration(minutes: 10)));

  @override
  List<Object?> get props => [date, fajr, dhuhr, asr, maghrib, isha];
}

class DateTimeRange {
  final DateTime start;
  final DateTime end;
  const DateTimeRange({required this.start, required this.end});

  Duration get duration => end.difference(start);
  int get durationMinutes => duration.inMinutes;

  bool overlaps(DateTimeRange other) =>
      start.isBefore(other.end) && end.isAfter(other.start);

  bool contains(DateTime dt) =>
      (dt.isAfter(start) || dt.isAtSameMomentAs(start)) &&
      dt.isBefore(end);
}
