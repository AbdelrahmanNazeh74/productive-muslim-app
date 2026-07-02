// READY TO ACTIVATE — uncomment imports after adding google_sign_in package.
//
// To activate Google Sign-In:
//   1. Add google_sign_in to pubspec.yaml (already listed as commented-out)
//   2. Run flutter pub get
//   3. Uncomment the imports below
//   4. Add your SHA-1 fingerprint to android/app/build.gradle.kts
//      (see comment in that file for exact location)
//   5. Add REVERSED_CLIENT_ID to ios/Runner/Info.plist
//      (see comment in that file for exact location)
//   6. FirebaseAuthRepositoryImpl already calls this flow — no further wiring needed

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';

/// Encapsulates the Google Sign-In OAuth flow.
///
/// Used by [FirebaseAuthRepositoryImpl.signInWithGoogle] to obtain a
/// Firebase credential from the Google Sign-In SDK.
///
/// Usage (after activation):
/// ```dart
/// final service = GoogleSignInService();
/// final credential = await service.getCredential();
/// if (credential != null) {
///   await FirebaseAuth.instance.signInWithCredential(credential);
/// }
/// ```
class GoogleSignInService {
  // final GoogleSignIn _googleSignIn;
  //
  // GoogleSignInService({GoogleSignIn? googleSignIn})
  //     : _googleSignIn = googleSignIn ?? GoogleSignIn(scopes: ['email']);

  /// Runs the Google Sign-In flow and returns a Firebase [AuthCredential].
  ///
  /// Returns null if the user cancels sign-in.
  /// Throws [PlatformException] on network or configuration errors.
  // Future<AuthCredential?> getCredential() async {
  //   final account = await _googleSignIn.signIn();
  //   if (account == null) return null; // User cancelled
  //
  //   final auth = await account.authentication;
  //   return GoogleAuthProvider.credential(
  //     accessToken: auth.accessToken,
  //     idToken: auth.idToken,
  //   );
  // }

  /// Signs out of Google (clears cached account).
  // Future<void> signOut() => _googleSignIn.signOut();
}
