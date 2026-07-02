import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/auth/data/repositories/firebase_auth_repository_impl.dart';
import '../../features/auth/data/repositories/mock_auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/backup/data/repositories/firebase_backup_repository_impl.dart';
import '../../features/backup/data/repositories/mock_backup_repository_impl.dart';
import '../../features/backup/domain/repositories/backup_repository.dart';
import '../../firebase_options.dart';

class EnvironmentConfig {
  EnvironmentConfig._();

  static bool _firebaseAvailable = false;
  static bool get firebaseAvailable => _firebaseAvailable;

  /// Call once at app startup before [AppDependencies.init].
  /// Initialises Firebase; on any failure the app continues with mock repositories.
  static Future<void> initializeIfAvailable() async {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      _firebaseAvailable = true;
    } catch (_) {
      _firebaseAvailable = false;
    }
  }

  static AuthRepository authRepository(SharedPreferences prefs) {
    if (_firebaseAvailable) return FirebaseAuthRepositoryImpl();
    return MockAuthRepositoryImpl(prefs);
  }

  static BackupRepository backupRepository() {
    if (_firebaseAvailable) return FirebaseBackupRepositoryImpl();
    return MockBackupRepositoryImpl();
  }
}
