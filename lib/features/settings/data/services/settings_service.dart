import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/app_settings.dart';

class SettingsService {
  static const _kFajr = 'notif_fajr';
  static const _kDhuhr = 'notif_dhuhr';
  static const _kAsr = 'notif_asr';
  static const _kMaghrib = 'notif_maghrib';
  static const _kIsha = 'notif_isha';
  static const _kHabits = 'notif_habits';
  static const _kQuran = 'notif_quran';
  static const _kQuietEnabled = 'quiet_enabled';
  static const _kQuietStartH = 'quiet_start_h';
  static const _kQuietStartM = 'quiet_start_m';
  static const _kQuietEndH = 'quiet_end_h';
  static const _kQuietEndM = 'quiet_end_m';
  static const _kThemeMode = 'theme_mode';
  static const _kShowHijri = 'show_hijri';
  static const _kShow24H = 'show_24h';
  static const _kLanguage = 'language';

  Future<AppSettings> load() async {
    final p = await SharedPreferences.getInstance();
    return AppSettings(
      fajrNotification: p.getBool(_kFajr) ?? true,
      dhuhrNotification: p.getBool(_kDhuhr) ?? true,
      asrNotification: p.getBool(_kAsr) ?? true,
      maghribNotification: p.getBool(_kMaghrib) ?? true,
      ishaNotification: p.getBool(_kIsha) ?? true,
      habitReminders: p.getBool(_kHabits) ?? true,
      quranReminder: p.getBool(_kQuran) ?? true,
      quietHoursEnabled: p.getBool(_kQuietEnabled) ?? false,
      quietHoursStartHour: p.getInt(_kQuietStartH) ?? 22,
      quietHoursStartMinute: p.getInt(_kQuietStartM) ?? 0,
      quietHoursEndHour: p.getInt(_kQuietEndH) ?? 6,
      quietHoursEndMinute: p.getInt(_kQuietEndM) ?? 0,
      themeMode: p.getString(_kThemeMode) ?? 'system',
      showHijriDate: p.getBool(_kShowHijri) ?? true,
      show24HourTime: p.getBool(_kShow24H) ?? false,
      language: p.getString(_kLanguage) ?? 'en',
    );
  }

  Future<void> save(AppSettings s) async {
    final p = await SharedPreferences.getInstance();
    await Future.wait([
      p.setBool(_kFajr, s.fajrNotification),
      p.setBool(_kDhuhr, s.dhuhrNotification),
      p.setBool(_kAsr, s.asrNotification),
      p.setBool(_kMaghrib, s.maghribNotification),
      p.setBool(_kIsha, s.ishaNotification),
      p.setBool(_kHabits, s.habitReminders),
      p.setBool(_kQuran, s.quranReminder),
      p.setBool(_kQuietEnabled, s.quietHoursEnabled),
      p.setInt(_kQuietStartH, s.quietHoursStartHour),
      p.setInt(_kQuietStartM, s.quietHoursStartMinute),
      p.setInt(_kQuietEndH, s.quietHoursEndHour),
      p.setInt(_kQuietEndM, s.quietHoursEndMinute),
      p.setString(_kThemeMode, s.themeMode),
      p.setBool(_kShowHijri, s.showHijriDate),
      p.setBool(_kShow24H, s.show24HourTime),
      p.setString(_kLanguage, s.language),
    ]);
  }

  Future<void> reset() async {
    final p = await SharedPreferences.getInstance();
    for (final key in [
      _kFajr, _kDhuhr, _kAsr, _kMaghrib, _kIsha,
      _kHabits, _kQuran, _kQuietEnabled,
      _kQuietStartH, _kQuietStartM, _kQuietEndH, _kQuietEndM,
      _kThemeMode, _kShowHijri, _kShow24H, _kLanguage,
    ]) {
      await p.remove(key);
    }
  }
}
