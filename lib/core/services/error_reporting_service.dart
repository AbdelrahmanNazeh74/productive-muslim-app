import 'package:firebase_crashlytics/firebase_crashlytics.dart';

import '../di/environment_config.dart';

class ErrorReportingService {
  static FirebaseCrashlytics get _fc => FirebaseCrashlytics.instance;

  static Future<void> recordError(
    Object error,
    StackTrace? stack, {
    bool fatal = false,
  }) async {
    if (!EnvironmentConfig.firebaseAvailable) return;
    await _fc.recordError(error, stack, fatal: fatal);
  }

  static Future<void> log(String message) async {
    if (!EnvironmentConfig.firebaseAvailable) return;
    await _fc.log(message);
  }

  static Future<void> setUserId(String userId) async {
    if (!EnvironmentConfig.firebaseAvailable) return;
    await _fc.setUserIdentifier(userId);
  }
}
