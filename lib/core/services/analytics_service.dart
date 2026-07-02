import 'package:firebase_analytics/firebase_analytics.dart';

import '../di/environment_config.dart';

class AnalyticsService {
  static FirebaseAnalytics get _fa => FirebaseAnalytics.instance;

  static Future<void> logPrayerCompleted(String prayerName) async {
    if (!EnvironmentConfig.firebaseAvailable) return;
    await _fa.logEvent(
      name: 'prayer_completed',
      parameters: {'prayer': prayerName},
    );
  }

  static Future<void> logHabitCompleted(String habitId, int streak) async {
    if (!EnvironmentConfig.firebaseAvailable) return;
    await _fa.logEvent(
      name: 'habit_completed',
      parameters: {'habit_id': habitId, 'streak': streak},
    );
  }

  static Future<void> logScreenView(String screenName) async {
    if (!EnvironmentConfig.firebaseAvailable) return;
    await _fa.logScreenView(screenName: screenName);
  }

  static Future<void> setUserId(String? userId) async {
    if (!EnvironmentConfig.firebaseAvailable) return;
    await _fa.setUserId(id: userId);
  }
}
