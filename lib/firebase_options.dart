import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError('Web platform is not supported.');
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions not configured for '
          '${defaultTargetPlatform.name}.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAzlunofNVcR4HB63EWZlLp3COczdj4OA0',
    appId: '1:533062204398:android:2a465e0e8e1f90e1d06cff',
    messagingSenderId: '533062204398',
    projectId: 'productive-muslim-app',
    storageBucket: 'productive-muslim-app.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDlHJCaBXo6xZHqsEWArd5mEExGlSBnNBs',
    appId: '1:533062204398:ios:391ce52625fa7ed0d06cff',
    messagingSenderId: '533062204398',
    projectId: 'productive-muslim-app',
    storageBucket: 'productive-muslim-app.firebasestorage.app',
    iosBundleId: 'com.productivemuslim.app',
    iosClientId:
        '533062204398-nlivanpobs0fmomgp9omh5k4la5eo1sj.apps.googleusercontent.com',
  );
}
