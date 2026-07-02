# SHA Fingerprints — Firebase Console Setup

Google Sign-In on Android requires the SHA-1 fingerprint of your signing certificate
to be registered in the Firebase Console.

## Getting fingerprints

**Windows:**
```bat
tool\get_sha_fingerprints.bat
```

**macOS / Linux:**
```bash
bash tool/get_sha_fingerprints.sh
```

If the debug keystore doesn't exist yet (fresh machine):
```bat
tool\create_debug_keystore.bat
```

## Registering in Firebase Console

1. Open [Firebase Console](https://console.firebase.google.com) → **productive-muslim-app**
2. Go to **Project Settings** (gear icon) → **Your apps** → Android app
3. Click **Add fingerprint**
4. Paste the SHA-1 from the debug keystore output
5. Repeat for the release keystore SHA-1 before publishing to Play Store

## Notes

- The `android/key.properties` file and `android/keystore/` directory are git-ignored.
  Never commit them.
- Each developer's debug SHA-1 is different — every new machine needs its own entry.
- CI/CD pipelines should use a dedicated signing key with its own Firebase SHA entry.
