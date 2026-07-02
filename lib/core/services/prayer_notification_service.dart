import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

import '../../features/prayer/domain/entities/prayer_times.dart';
import '../../features/onboarding/domain/entities/user_profile.dart';
import 'notification_sound_config.dart';

/// Schedules prayer adhan notifications using flutter_local_notifications.
///
/// Each prayer gets two notifications:
///  1. Buffer alert — "Asr in 10 minutes — time to make Wudu"
///  2. Adhan alert  — "Asr prayer time — Allahu Akbar"
///
/// Android notification channels are created on [initialize].
/// Sound files must be placed at android/app/src/main/res/raw/:
///   adhan.mp3, iftar_adhan.mp3, quran_reminder.mp3
/// iOS sound files must be added to ios/Runner/ via Xcode (Copy Bundle Resources):
///   adhan.aiff, iftar_adhan.aiff, quran_reminder.aiff
class PrayerNotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static bool _initialized = false;

  // ID ranges — 0-based dayIndex keeps ranges non-overlapping for 30 days.
  // Buffer : 100 + prayer(0–4) + dayIndex(0–29)*10  →  [100, 394]
  // Adhan  : 500 + prayer(0–4) + dayIndex(0–29)*10  →  [500, 894]
  static const _bufferBaseId = 100;
  static const _prayerBaseId = 500;

  /// Must be called once at app startup (before any scheduling).
  static Future<void> initialize() async {
    if (_initialized) return;

    tz.initializeTimeZones();

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    await _plugin.initialize(
      const InitializationSettings(android: androidSettings, iOS: iosSettings),
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Register all channels on Android (no-op on iOS).
    final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    for (final channel in NotificationChannels.all) {
      await androidPlugin?.createNotificationChannel(channel);
    }

    _initialized = true;
  }

  /// Schedule all prayer notifications for the supplied days.
  static Future<void> schedulePrayerNotifications({
    required UserProfile profile,
    required List<DailyPrayerTimes> upcomingPrayerTimes,
  }) async {
    await initialize();
    await cancelAllPrayerNotifications();

    for (int dayIndex = 0; dayIndex < upcomingPrayerTimes.length; dayIndex++) {
      await _scheduleForDay(upcomingPrayerTimes[dayIndex], profile, dayIndex);
    }
  }

  static Future<void> _scheduleForDay(
      DailyPrayerTimes day, UserProfile profile, int dayIndex) async {
    for (int i = 0; i < day.ordered.length; i++) {
      final prayer = day.ordered[i];
      final now = DateTime.now();

      if (prayer.time.isBefore(now)) continue;

      // ── Buffer notification ───────────────────────────────────────────────
      if (profile.prayerBufferMinutes > 0) {
        final bufferTime = prayer.bufferStart(profile.prayerBufferMinutes);
        if (bufferTime.isAfter(now)) {
          await _scheduleNotification(
            id: _bufferBaseId + i + (dayIndex * 10),
            title: '${prayer.name.emoji} ${prayer.name.label} soon',
            body:
                '${prayer.name.label} in ${profile.prayerBufferMinutes} min — time to make Wudu',
            scheduledTime: bufferTime,
            channelId: NotificationChannels.prayerBuffer.id,
            channelName: NotificationChannels.prayerBuffer.name,
            importance: Importance.high,
            soundType: NotificationSoundType.generalReminder,
          );
        }
      }

      // ── Adhan notification ────────────────────────────────────────────────
      await _scheduleNotification(
        id: _prayerBaseId + i + (dayIndex * 10),
        title: '${prayer.name.emoji} ${prayer.name.label} — Allahu Akbar',
        body: _adhanMessage(prayer.name),
        scheduledTime: prayer.time,
        channelId: NotificationChannels.prayerAdhan.id,
        channelName: NotificationChannels.prayerAdhan.name,
        importance: Importance.max,
        soundType: NotificationSoundType.adhan,
      );
    }
  }

  static Future<void> _scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
    required String channelId,
    required String channelName,
    Importance importance = Importance.high,
    NotificationSoundType soundType = NotificationSoundType.generalReminder,
  }) async {
    final tzTime = tz.TZDateTime.from(scheduledTime, tz.local);
    final androidSound = NotificationSoundConfig.androidSound(soundType);

    final androidDetails = AndroidNotificationDetails(
      channelId,
      channelName,
      importance: importance,
      priority: Priority.high,
      playSound: true,
      sound: androidSound,
      // App icon shown as the large icon in the expanded notification view.
      largeIcon: const DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
      enableLights: true,
      enableVibration: importance == Importance.max,
      styleInformation: const BigTextStyleInformation(''),
    );

    final iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      sound: NotificationSoundConfig.iosSound(soundType),
      threadIdentifier: NotificationSoundConfig.iosThreadId(soundType),
    );

    await _plugin.zonedSchedule(
      id,
      title,
      body,
      tzTime,
      NotificationDetails(android: androidDetails, iOS: iosDetails),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  /// Cancel all scheduled prayer notifications (covers both ID ranges × 30 days).
  static Future<void> cancelAllPrayerNotifications() async {
    for (int day = 0; day < 30; day++) {
      for (int prayer = 0; prayer < 5; prayer++) {
        await _plugin.cancel(_bufferBaseId + prayer + (day * 10));
        await _plugin.cancel(_prayerBaseId + prayer + (day * 10));
      }
    }
  }

  static void _onNotificationTapped(NotificationResponse response) {
    // TODO: navigate to timeline dashboard when notification is tapped.
    // Use GoRouter with a GlobalKey<NavigatorState> or a navigation service.
  }

  static String _adhanMessage(PrayerName prayer) {
    switch (prayer) {
      case PrayerName.fajr:
        return 'As-salatu Khayrun Minan-Nawm — Prayer is better than sleep 🌅';
      case PrayerName.dhuhr:
        return 'Pause, stand, and reconnect with Allah ☀️';
      case PrayerName.asr:
        return 'The afternoon prayer — do not let the sun set before you pray 🌤';
      case PrayerName.maghrib:
        return 'The sun has set — Maghrib prayer time 🌆';
      case PrayerName.isha:
        return 'End your day with gratitude and Isha prayer 🌙';
    }
  }
}
