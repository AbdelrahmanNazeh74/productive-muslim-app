# Android Release Signing

Step-by-step guide to sign the Productive Muslim app for Play Store submission.

---

## 1 — Generate the keystore (run once, keep forever)

Run this command from the **project root**:

```bash
keytool -genkey -v \
  -keystore android/keystore/productive_muslim.jks \
  -keyalg RSA \
  -keysize 2048 \
  -validity 10000 \
  -alias productive_muslim
```

You will be prompted for:
- **Keystore password** — choose a strong password, store it in a password manager
- **Key password** — can be the same as keystore password
- **Distinguished Name** fields (name, org, city, country) — enter your real info; these appear in the app certificate

The `.jks` file is written to `android/keystore/productive_muslim.jks`.

> **CRITICAL:** Never commit the `.jks` file or `key.properties` to source control. Both are excluded by `android/.gitignore`. Back the `.jks` file up securely (e.g. encrypted cloud storage). If you lose it you cannot update the app on the Play Store.

---

## 2 — Place the keystore file

```
productive_muslim/
  android/
    keystore/
      productive_muslim.jks   ← put it here
    key.properties            ← create this next
```

---

## 3 — Create `android/key.properties`

Create the file at `android/key.properties` (not inside `android/app/`):

```properties
storeFile=keystore/productive_muslim.jks
storePassword=YOUR_KEYSTORE_PASSWORD
keyAlias=productive_muslim
keyPassword=YOUR_KEY_PASSWORD
```

Replace `YOUR_KEYSTORE_PASSWORD` and `YOUR_KEY_PASSWORD` with the values you chose in Step 1.

The path in `storeFile` is relative to the `android/` directory (i.e. where `build.gradle.kts` resolves `file(storeFilePath)` from the app module).

---

## 4 — Verify `build.gradle.kts`

The `android/app/build.gradle.kts` already loads `key.properties` and wires up the release signing config:

```kotlin
val keyPropertiesFile = rootProject.file("key.properties")
val keyProperties = Properties().apply {
    if (keyPropertiesFile.exists()) {
        load(keyPropertiesFile.inputStream())
    }
}
// ...
signingConfigs {
    create("release") {
        storeFile = file(keyProperties.getProperty("storeFile"))
        storePassword = keyProperties.getProperty("storePassword") ?: ""
        keyAlias = keyProperties.getProperty("keyAlias") ?: "productive_muslim"
        keyPassword = keyProperties.getProperty("keyPassword") ?: ""
    }
}
```

No further changes needed.

---

## 5 — Build the release App Bundle (AAB)

```bash
flutter build appbundle --release
```

Output file:
```
build/app/outputs/bundle/release/app-release.aab
```

This is the file you upload to the Google Play Console.

---

## 6 — Verify the signing (optional)

```bash
bundletool build-apks \
  --bundle=build/app/outputs/bundle/release/app-release.aab \
  --output=verify.apks \
  --ks=android/keystore/productive_muslim.jks \
  --ks-key-alias=productive_muslim
```

Or simply check the certificate embedded in the AAB:

```bash
unzip -p build/app/outputs/bundle/release/app-release.aab META-INF/*.RSA \
  | keytool -printcert
```

---

## CI / CD — Environment variable fallback

If you use a CI pipeline (GitHub Actions, Bitrise, etc.) and do not want to store the `.jks` file in the repo, the `build.gradle.kts` will fall back to environment variables:

| Variable | Value |
|---|---|
| `KEYSTORE_PASSWORD` | keystore password |
| `KEY_ALIAS` | `productive_muslim` |
| `KEY_PASSWORD` | key password |

Decode a base64-encoded `.jks` in CI and write it to `android/keystore/productive_muslim.jks`, then set `storeFile` in a temporary `key.properties` — or just rely on the env var fallback in `build.gradle.kts`.

---

## Checklist before submitting to Play Store

- [ ] `android/keystore/productive_muslim.jks` exists locally (never committed)
- [ ] `android/key.properties` exists locally (never committed)
- [ ] `flutter build appbundle --release` succeeds with exit code 0
- [ ] AAB file exists at `build/app/outputs/bundle/release/app-release.aab`
- [ ] `versionCode` in `pubspec.yaml` is incremented for each upload
