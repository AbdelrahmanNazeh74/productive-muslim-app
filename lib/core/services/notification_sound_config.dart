import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// ── Notification sound types ──────────────────────────────────────────────────

/// Which audio file a notification should play.
///
/// Map each type to actual audio files:
///   Android : android/app/src/main/res/raw/<name>.mp3
///   iOS     : ios/Runner/ (add via Xcode → Copy Bundle Resources)
///
/// Free adhan sources: Islamic Network (al-quran.cloud), zekr.org, islamicfinder.org
enum NotificationSoundType {
  /// Full adhan at exact prayer time.
  adhan,

  /// Iftar adhan at Maghrib during Ramadan (may differ stylistically from regular adhan).
  iftarAdhan,

  /// Gentle Quran reading reminder.
  quranReminder,

  /// Habit reminder — uses system default (non-intrusive).
  habitReminder,

  /// General app notification — uses system default.
  generalReminder,
}

// ── Android notification channels ────────────────────────────────────────────

/// All Android [AndroidNotificationChannel] definitions.
///
/// Register these during [PrayerNotificationService.initialize] by calling:
/// ```dart
/// final android = plugin.resolvePlatformSpecificImplementation
///     <AndroidFlutterLocalNotificationsPlugin>();
/// for (final ch in NotificationChannels.all) {
///   await android?.createNotificationChannel(ch);
/// }
/// ```
class NotificationChannels {
  NotificationChannels._();

  static const prayerAdhan = AndroidNotificationChannel(
    'prayer_adhan',
    'Adhan',
    description: 'Prayer adhan alerts at the exact prayer time',
    importance: Importance.max,
    playSound: true,
    sound: RawResourceAndroidNotificationSound('adhan'),
    enableLights: true,
    enableVibration: true,
    showBadge: true,
  );

  static const prayerBuffer = AndroidNotificationChannel(
    'prayer_buffer',
    'Prayer Reminders',
    description: 'Buffer alerts a few minutes before prayer time',
    importance: Importance.high,
    enableLights: true,
    enableVibration: true,
    showBadge: false,
  );

  static const quranReminder = AndroidNotificationChannel(
    'quran_reminder',
    'Quran Reminders',
    description: 'Daily Quran reading reminders',
    importance: Importance.defaultImportance,
    showBadge: false,
  );

  static const habitReminder = AndroidNotificationChannel(
    'habit_reminder',
    'Habit Reminders',
    description: 'Habit tracking and streak reminders',
    importance: Importance.defaultImportance,
    showBadge: false,
  );

  static const iftarAdhan = AndroidNotificationChannel(
    'iftar_adhan',
    'Iftar Adhan',
    description: 'Iftar adhan alert at Maghrib during Ramadan',
    importance: Importance.max,
    playSound: true,
    sound: RawResourceAndroidNotificationSound('iftar_adhan'),
    enableLights: true,
    enableVibration: true,
    showBadge: true,
  );

  static const general = AndroidNotificationChannel(
    'general',
    'General',
    description: 'General app notifications',
    importance: Importance.low,
    showBadge: false,
  );

  static const List<AndroidNotificationChannel> all = [
    prayerAdhan,
    prayerBuffer,
    quranReminder,
    habitReminder,
    iftarAdhan,
    general,
  ];
}

// ── Per-type sound + thread helpers ──────────────────────────────────────────

class NotificationSoundConfig {
  NotificationSoundConfig._();

  /// Set to [true] only after placing MP3 files in android/app/src/main/res/raw/.
  ///
  /// Required filenames: adhan.mp3, iftar_adhan.mp3, quran_reminder.mp3
  ///
  /// When [false] (the default), all notifications fall back to the system
  /// default notification sound — the app works correctly with no audio files.
  /// See android/app/src/main/res/raw/.gitkeep for detailed instructions.
  static const bool kSoundFilesPresent = false;

  /// Android sound for [type], or null to use the system/channel default.
  ///
  /// Returns null whenever [kSoundFilesPresent] is false, ensuring the app
  /// works correctly even if MP3 files have not been added to res/raw yet.
  /// Files must be placed at android/app/src/main/res/raw/<name>.mp3 before
  /// setting [kSoundFilesPresent] to true.
  static RawResourceAndroidNotificationSound? androidSound(
      NotificationSoundType type) {
    if (!kSoundFilesPresent) return null;
    switch (type) {
      case NotificationSoundType.adhan:
        return const RawResourceAndroidNotificationSound('adhan');
      case NotificationSoundType.iftarAdhan:
        return const RawResourceAndroidNotificationSound('iftar_adhan');
      case NotificationSoundType.quranReminder:
        return const RawResourceAndroidNotificationSound('quran_reminder');
      case NotificationSoundType.habitReminder:
      case NotificationSoundType.generalReminder:
        return null;
    }
  }

  /// iOS sound file name for [type] (including extension), or null for the
  /// system default.  Files must be added to ios/Runner/ via Xcode.
  static String? iosSound(NotificationSoundType type) {
    switch (type) {
      case NotificationSoundType.adhan:
        return 'adhan.aiff';
      case NotificationSoundType.iftarAdhan:
        return 'iftar_adhan.aiff';
      case NotificationSoundType.quranReminder:
        return 'quran_reminder.aiff';
      case NotificationSoundType.habitReminder:
      case NotificationSoundType.generalReminder:
        return null;
    }
  }

  /// iOS thread identifier used to group notifications in Notification Centre.
  static String iosThreadId(NotificationSoundType type) {
    switch (type) {
      case NotificationSoundType.adhan:
        return 'prayer_adhan';
      case NotificationSoundType.iftarAdhan:
        return 'iftar_adhan';
      case NotificationSoundType.quranReminder:
        return 'quran';
      case NotificationSoundType.habitReminder:
        return 'habit';
      case NotificationSoundType.generalReminder:
        return 'general';
    }
  }

  /// All notification types play some sound (custom file or system default).
  static bool playSound(NotificationSoundType type) => true;
}
