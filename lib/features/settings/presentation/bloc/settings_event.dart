part of 'settings_bloc.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();
  @override
  List<Object?> get props => [];
}

class SettingsLoadRequested extends SettingsEvent {
  const SettingsLoadRequested();
}

class SettingsPrayerNotificationToggled extends SettingsEvent {
  final String prayer; // 'fajr' | 'dhuhr' | 'asr' | 'maghrib' | 'isha'
  final bool enabled;
  const SettingsPrayerNotificationToggled(
      {required this.prayer, required this.enabled});
  @override
  List<Object?> get props => [prayer, enabled];
}

class SettingsHabitReminderToggled extends SettingsEvent {
  final bool enabled;
  const SettingsHabitReminderToggled(this.enabled);
  @override
  List<Object?> get props => [enabled];
}

class SettingsQuranReminderToggled extends SettingsEvent {
  final bool enabled;
  const SettingsQuranReminderToggled(this.enabled);
  @override
  List<Object?> get props => [enabled];
}

class SettingsQuietHoursToggled extends SettingsEvent {
  final bool enabled;
  const SettingsQuietHoursToggled(this.enabled);
  @override
  List<Object?> get props => [enabled];
}

class SettingsQuietHoursChanged extends SettingsEvent {
  final int startHour;
  final int startMinute;
  final int endHour;
  final int endMinute;
  const SettingsQuietHoursChanged({
    required this.startHour,
    required this.startMinute,
    required this.endHour,
    required this.endMinute,
  });
  @override
  List<Object?> get props => [startHour, startMinute, endHour, endMinute];
}

class SettingsThemeModeChanged extends SettingsEvent {
  final String themeMode; // 'light' | 'dark' | 'system'
  const SettingsThemeModeChanged(this.themeMode);
  @override
  List<Object?> get props => [themeMode];
}

class SettingsHijriDisplayToggled extends SettingsEvent {
  final bool enabled;
  const SettingsHijriDisplayToggled(this.enabled);
  @override
  List<Object?> get props => [enabled];
}

class Settings24HourToggled extends SettingsEvent {
  final bool enabled;
  const Settings24HourToggled(this.enabled);
  @override
  List<Object?> get props => [enabled];
}

class SettingsLanguageChanged extends SettingsEvent {
  final String languageCode; // 'en' | 'ar'
  const SettingsLanguageChanged(this.languageCode);
  @override
  List<Object?> get props => [languageCode];
}

class SettingsResetRequested extends SettingsEvent {
  const SettingsResetRequested();
}
