import 'package:shared_preferences/shared_preferences.dart';

import '../../features/auth/data/repositories/mock_auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/backup/data/repositories/mock_backup_repository_impl.dart';
import '../../features/backup/domain/repositories/backup_repository.dart';

// FIREBASE ACTIVATION GUIDE — see HANDOVER.md Section 3e / 3f
//
// When you are ready to activate Firebase:
//   Step 1: Create a Firebase project at console.firebase.google.com (free tier)
//   Step 2: Download google-services.json → android/app/
//           Download GoogleService-Info.plist → ios/Runner/ (via Xcode)
//   Step 3: Uncomment firebase packages in pubspec.yaml, run flutter pub get
//   Step 4: Set useFirebase = true below
//           Uncomment the Firebase import lines in this file
//           Uncomment the return statements in authRepository() and backupRepository()
//
// Imports to uncomment after Step 3:
// import '../../features/auth/data/repositories/firebase_auth_repository_impl.dart';
// import '../../features/backup/data/repositories/firebase_backup_repository_impl.dart';

/// Switches between mock (offline) and Firebase implementations.
///
/// Default is [false] — the app works fully offline with mock data.
/// Flip to [true] only after completing the 4-step Firebase activation above.
class EnvironmentConfig {
  EnvironmentConfig._();

  /// Whether to use Firebase for auth and backup.
  /// Change to [true] after completing Firebase setup — see HANDOVER.md §3e.
  static const bool useFirebase = false;

  /// Returns the correct [AuthRepository] implementation for this environment.
  static AuthRepository authRepository(SharedPreferences prefs) {
    if (useFirebase) {
      // Uncomment after Firebase activation (Step 4 above):
      // return FirebaseAuthRepositoryImpl();
      throw StateError(
        'Firebase not configured. Set useFirebase = true in environment_config.dart '
        'only after completing all 4 activation steps in HANDOVER.md §3e.',
      );
    }
    return MockAuthRepositoryImpl(prefs);
  }

  /// Returns the correct [BackupRepository] implementation for this environment.
  static BackupRepository backupRepository() {
    if (useFirebase) {
      // Uncomment after Firebase activation (Step 4 above):
      // return FirebaseBackupRepositoryImpl();
      throw StateError(
        'Firebase not configured. Set useFirebase = true in environment_config.dart '
        'only after completing all 4 activation steps in HANDOVER.md §3f.',
      );
    }
    return MockBackupRepositoryImpl();
  }
}
