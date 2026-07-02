import 'package:equatable/equatable.dart';

class AppSettings extends Equatable {
  // Prayer notifications
  final bool fajrNotification;
  final bool dhuhrNotification;
  final bool asrNotification;
  final bool maghribNotification;
  final bool ishaNotification;

  // Daily reminders
  final bool habitReminders;
  final bool quranReminder;

  // Quiet hours
  final bool quietHoursEnabled;
  final int quietHoursStartHour;
  final int quietHoursStartMinute;
  final int quietHoursEndHour;
  final int quietHoursEndMinute;

  // Appearance
  final String themeMode; // 'light' | 'dark' | 'system'
  final bool showHijriDate;
  final bool show24HourTime;

  // Localisation
  final String language; // BCP-47 language code: 'en' | 'ar'

  const AppSettings({
    this.fajrNotification = true,
    this.dhuhrNotification = true,
    this.asrNotification = true,
    this.maghribNotification = true,
    this.ishaNotification = true,
    this.habitReminders = true,
    this.quranReminder = true,
    this.quietHoursEnabled = false,
    this.quietHoursStartHour = 22,
    this.quietHoursStartMinute = 0,
    this.quietHoursEndHour = 6,
    this.quietHoursEndMinute = 0,
    this.themeMode = 'system',
    this.showHijriDate = true,
    this.show24HourTime = false,
    this.language = 'en',
  });

  static const AppSettings defaults = AppSettings();

  bool prayerNotificationEnabled(String prayerName) {
    switch (prayerName.toLowerCase()) {
      case 'fajr':
        return fajrNotification;
      case 'dhuhr':
        return dhuhrNotification;
      case 'asr':
        return asrNotification;
      case 'maghrib':
        return maghribNotification;
      case 'isha':
        return ishaNotification;
      default:
        return true;
    }
  }

  String get quietHoursLabel {
    final start = _formatTime(quietHoursStartHour, quietHoursStartMinute);
    final end = _formatTime(quietHoursEndHour, quietHoursEndMinute);
    return '$start – $end';
  }

  static String _formatTime(int hour, int minute) {
    final period = hour < 12 ? 'AM' : 'PM';
    final h = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
    final m = minute.toString().padLeft(2, '0');
    return '$h:$m $period';
  }

  AppSettings copyWith({
    bool? fajrNotification,
    bool? dhuhrNotification,
    bool? asrNotification,
    bool? maghribNotification,
    bool? ishaNotification,
    bool? habitReminders,
    bool? quranReminder,
    bool? quietHoursEnabled,
    int? quietHoursStartHour,
    int? quietHoursStartMinute,
    int? quietHoursEndHour,
    int? quietHoursEndMinute,
    String? themeMode,
    bool? showHijriDate,
    bool? show24HourTime,
    String? language,
  }) {
    return AppSettings(
      fajrNotification: fajrNotification ?? this.fajrNotification,
      dhuhrNotification: dhuhrNotification ?? this.dhuhrNotification,
      asrNotification: asrNotification ?? this.asrNotification,
      maghribNotification: maghribNotification ?? this.maghribNotification,
      ishaNotification: ishaNotification ?? this.ishaNotification,
      habitReminders: habitReminders ?? this.habitReminders,
      quranReminder: quranReminder ?? this.quranReminder,
      quietHoursEnabled: quietHoursEnabled ?? this.quietHoursEnabled,
      quietHoursStartHour: quietHoursStartHour ?? this.quietHoursStartHour,
      quietHoursStartMinute:
          quietHoursStartMinute ?? this.quietHoursStartMinute,
      quietHoursEndHour: quietHoursEndHour ?? this.quietHoursEndHour,
      quietHoursEndMinute: quietHoursEndMinute ?? this.quietHoursEndMinute,
      themeMode: themeMode ?? this.themeMode,
      showHijriDate: showHijriDate ?? this.showHijriDate,
      show24HourTime: show24HourTime ?? this.show24HourTime,
      language: language ?? this.language,
    );
  }

  @override
  List<Object?> get props => [
        fajrNotification,
        dhuhrNotification,
        asrNotification,
        maghribNotification,
        ishaNotification,
        habitReminders,
        quranReminder,
        quietHoursEnabled,
        quietHoursStartHour,
        quietHoursStartMinute,
        quietHoursEndHour,
        quietHoursEndMinute,
        themeMode,
        showHijriDate,
        show24HourTime,
        language,
      ];
}
