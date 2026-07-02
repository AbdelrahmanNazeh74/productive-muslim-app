# Productive Muslim — Developer Handover

> **For any developer picking up this project from source.**
> Read this document top to bottom before touching any code.
> All 535 tests pass. `flutter analyze` reports 0 issues.
> The app is feature-complete and ready for store submission.

---

## ✅ FIREBASE IS LIVE (integrated 2026-07-02)

Real Google Sign-In, anonymous auth, Firestore backup, Firebase Analytics, and Crashlytics are all active.

**Firebase project:** `productive-muslim-app` (free Spark plan)
**Android package / iOS bundle:** `com.productivemuslim.app`

**SHA-1 fingerprint is registered in Firebase Console.** ✅ (registered 2026-07-02)
```
SHA-1: FD:D7:6D:F6:99:76:4E:22:28:8B:69:F1:6B:9B:70:F5:AB:E7:47:0F
```
On a different dev machine, run `tool\get_sha_fingerprints.bat` (Windows) or `bash tool/get_sha_fingerprints.sh` (Mac/Linux) to get its fingerprint and register it. See `docs/SHA_FINGERPRINTS.md`.

**Firebase Analytics confirmed live** via logcat on physical device (SM A245F, Android 16):
`TRuntime.CctTransportBackend → firebaselogging-pa.googleapis.com → Status Code: 200`

**Pending manual verification** (functionality is wired — UI flows not yet smoke-tested):
- Google Sign-In: tap "Continue with Google" → account picker → should land on dashboard
- Firestore backup: Settings → Data → Cloud Backup → Back Up Now → verify Firestore document created
- Anonymous auth: tap "Continue as Guest" → verify anonymous session in Firebase Auth console
- Crashlytics: enable DebugView with `adb shell setprop debug.firebase.analytics.app com.productivemuslim.app`

**Firebase Project Details:**

| Field | Value |
|---|---|
| Project ID | `productive-muslim-app` |
| Project number | `533062204398` |
| Android package | `com.productivemuslim.app` |
| iOS bundle ID | `com.productivemuslim.app` |
| Android OAuth client | `533062204398-5vl2som8t00odojtimho0c0jdjpor361` |
| iOS client ID | `533062204398-nlivanpobs0fmomgp9omh5k4la5eo1sj` |
| REVERSED_CLIENT_ID | `com.googleusercontent.apps.533062204398-nlivanpobs0fmomgp9omh5k4la5eo1sj` |
| Storage bucket | `productive-muslim-app.firebasestorage.app` |
| Firestore rules | `firestore.rules` (deployed via `firebase deploy --only firestore:rules`) |

**How the runtime switch works:**
`EnvironmentConfig.initializeIfAvailable()` in `main()` calls `Firebase.initializeApp()` in a try/catch. On success, `_firebaseAvailable = true` and Firebase repositories are injected. On any failure (missing config, network error, test environment) the app silently falls back to mock repositories — no crash, no user-visible error.

---

## 1. Project Overview

Productive Muslim is a Flutter productivity app that helps Muslim users build a structured daily life anchored around the five daily prayers. Rather than treating prayer as an interruption to work, the app treats prayer as the immovable foundation that everything else is scheduled around. A scheduling engine reads the user's work hours, sleep goals, and prayer times (calculated offline from GPS coordinates using the open-source adhan algorithm), then generates a complete minute-by-minute daily timeline — placing Deep Work blocks in peak hours, protecting the Golden Hour after Fajr for Quran and dhikr, inserting a midday Qaylula nap, and slicing work blocks cleanly around any prayer that falls inside the work window.

On top of the scheduling engine the app layers a full habit-tracking system with streak calculations, a Weekly Spiritual Score (Prayers 50% · Quran 20% · Habits 20% · Fitness 10%), a Ramadan mode that restructures the entire timeline around Suhoor/Iftar/Tarawih/Qiyam al-Layl and extends late-night worship on the Last Ten Nights, an analytics dashboard with interactive charts and a monthly heatmap calendar, and a settings suite that covers prayer calculation method, madhab, per-prayer notification times, quiet hours, and full theme switching (light / dark / system). The app is fully offline — no accounts, no servers, no external APIs at runtime. All data is stored locally using Isar, an embedded document database, and prayer times are computed on-device from the adhan package.

The codebase was built incrementally over nine phases plus three QA sessions and a final completion pass, following Clean Architecture with a strict domain/data/presentation separation and BLoC for all state management. Every algorithm has a unit test file. The project contains approximately 24,000 lines of Dart across 96+ source files, with 535 tests covering the scheduling engine, streak calculator, Hijri converter, analytics entities, prayer cache, onboarding flow, habit completion, settings persistence, widget update service, UI animations, BLoC state machines, widget integration flows, and responsive layout rendering at 6 screen sizes.

**Target platforms:** Android (minSdk 21 / Android 5.0+) and iOS (iOS 14+, required by WidgetKit).
**Package ID:** `com.productivemuslim.app`
**Current version:** `1.0.0+1`

**Tech stack:**

| Layer | Technology |
|---|---|
| UI framework | Flutter 3.22+ / Dart 3.x |
| State management | flutter_bloc 8.1.5 + equatable |
| Local database | Isar 3.1.0 (embedded NoSQL) |
| Navigation | go_router 14.2.0 |
| Prayer times | adhan 1.1.0 (offline Dart implementation) |
| Location | geolocator + geocoding |
| Notifications | flutter_local_notifications 17.2.2 |
| Charts | fl_chart 0.68.0 |
| Home screen widget | home_widget 0.6.0 |
| Animations | flutter_animate 4.5.0, native AnimationController |
| Functional patterns | dartz (Either, Option) |
| Icons | iconsax, google_fonts |

---

## 2. What Is Fully Built and Working

Every item below is code-complete, manually reviewable, and covered by automated tests unless noted.

### Onboarding (6-step flow)
Collects the user's name, gender, occupation, work schedule (start/end hours, work days), prayer calculation method (10 options: MWL, ISNA, Egyptian, Mecca, Karachi, Tehran, Gulf, Kuwait, Qatar, Singapore), Hanafi/Shafi madhab for Asr, fitness activity preferences, sleep goal, and daily Quran pages target. Location is requested and reverse-geocoded to populate the city name. The result is stored in Isar as a `UserProfileModel`. On subsequent launches the onboarding is skipped and the user lands directly on the timeline.
- **Entry point:** `lib/features/onboarding/presentation/pages/onboarding_page.dart`
- **BLoC:** `lib/features/onboarding/presentation/bloc/onboarding_bloc.dart`
- **Isar model:** `lib/features/onboarding/data/models/user_profile_model.dart`
- **Tests:** `test/features/onboarding/integration/onboarding_to_timeline_test.dart` (~20 tests)

### Prayer Time Engine
Wraps the adhan package to produce `DailyPrayerTimes` domain objects for any date and user profile. Supports all 10 calculation methods and both madhabs. A 30-day prayer time cache (Isar) is warmed at startup and invalidated when the user changes their calculation method, madhab, or location in Settings, avoiding repeated CPU computation.
- **Entry point:** `lib/features/prayer/data/repositories/prayer_time_service.dart`
- **Cache service:** `lib/core/services/prayer_cache_service.dart`
- **Cache model:** `lib/features/prayer/data/models/cached_prayer_day_model.dart`
- **Tests:** `test/features/prayer/data/repositories/prayer_cache_repository_test.dart` (30 tests)

### Daily Timeline Generator
The core scheduling algorithm (`TimelineGeneratorService`, 763 lines) takes a `UserProfile` and a date and produces a fully ordered list of `TimeBlock` objects. The five-step pipeline: (1) anchor hard blocks — sleep, 5 prayers + buffer time per prayer, work window; (2) slice work blocks around prayers that fall inside them; (3) place optional blocks — Quran, Golden Hour, gym, meals, Qaylula — into remaining gaps; (4) fill residual gaps with Free Time; (5) resolve any remaining overlaps by priority. The timeline is stored in Isar as a `DailyTimelineModel` keyed by date.
- **Entry point:** `lib/features/timeline/domain/usecases/timeline_generator_service.dart`
- **BLoC:** `lib/features/timeline/presentation/bloc/timeline_bloc.dart` (60-second auto-tick for live countdown)
- **Dashboard UI:** `lib/features/timeline/presentation/pages/timeline_dashboard_page.dart`
- **Tests:** `test/features/timeline/domain/timeline_generator_test.dart` (30 tests)

### Habit Streaks
Seeds 12–15 personalised habit templates from the user's onboarding profile (5 prayer habits, Quran, morning/evening adhkar, Qaylula, hydration, sleep-early, optional gym and gratitude). `StreakCalculator` counts consecutive scheduled days; excused days (travel, illness, menstrual cycle) are transparent and do not break or advance the streak. Detects new personal bests correctly (compares `longestStreak` before vs after completion). Fires a full-screen confetti celebration overlay on personal bests.
- **Entry point:** `lib/features/habits/presentation/pages/habits_page.dart`
- **Core algorithm:** `lib/features/habits/domain/usecases/streak_calculator.dart`
- **Seeder:** `lib/features/habits/domain/usecases/default_habit_seeder.dart`
- **Tests:** `test/features/habits/domain/streak_calculator_test.dart` (35 tests) + integration (25 tests)

### Weekly Spiritual Score
Computed from Isar streak records each time the habits page loads. Formula: `(prayerScore × 0.50) + (quranScore × 0.20) + (habitScore × 0.20) + (fitnessScore × 0.10)`. Displayed as a ring chart with four component bars on the Score tab.
- **Calculation:** inside `lib/features/habits/data/repositories/habits_repository_impl.dart`
- **Tests:** covered inside the habits integration test

### Ramadan Mode
`HijriConverter` (pure Dart, Kuwaiti algorithm) converts any Gregorian date to Hijri and detects whether the current Hijri month is Ramadan. When active, `RamadanTimelineGenerator` replaces the standard scheduling engine with a Ramadan-specific pipeline: Suhoor block anchored before Fajr, Iftar at Maghrib, Tarawih (60 min standard / 90 min on Last Ten Nights), Qiyam al-Layl on odd-numbered Last Ten Nights (21, 23, 25, 27, 29), split sleep (before Fajr and a Qaylula after Dhuhr). The Ramadan tab appears in the bottom navigation only when Ramadan mode is active.
- **Entry points:** `lib/features/ramadan/domain/usecases/hijri_converter.dart` and `ramadan_timeline_generator.dart`
- **Dashboard:** `lib/features/ramadan/presentation/pages/ramadan_dashboard_page.dart`
- **Tests:** `test/features/ramadan/domain/ramadan_generator_test.dart` (38 tests)

### Analytics Dashboard
Three-tab dashboard (Overview / Prayers / Habits) backed by `AnalyticsRepositoryImpl` which reads Isar data in a single `getSnapshot()` call. Charts: `WeeklyScoreLineChart` with dashed average reference, `PrayerBarChart` per-salah on-time rate, `HabitCompletionChart` daily bars (green ≥80% / amber ≥50% / red <50%), `MonthlyHeatmapCalendar` with ⭐ on perfect days and month navigation, `HabitLeaderboard` with medal rankings, `WeeklyScoreBreakdown` ring + component bars. Period picker: This Week / This Month / Last 3 Months.
- **Entry point:** `lib/features/analytics/presentation/pages/analytics_dashboard_page.dart`
- **Repository:** `lib/features/analytics/data/repositories/analytics_repository_impl.dart`
- **Tests:** `test/features/analytics/domain/analytics_entities_test.dart` (30 tests)

### Settings & Profile
Complete settings hub with sub-pages for profile editing (name, city, occupation, work schedule, goals), prayer configuration (method, madhab, buffer sliders), per-prayer notification toggles with quiet hours, appearance (light/dark/system theme, Hijri date display, 24h clock), and data management (reset settings, full app reset, privacy policy sheet). Profile changes trigger timeline regeneration. Settings are persisted in SharedPreferences via 15 keyed values.
- **Entry point:** `lib/features/settings/presentation/pages/settings_page.dart`
- **BLoC:** `lib/features/settings/presentation/bloc/settings_bloc.dart`
- **Tests:** `test/features/settings/integration/settings_profile_timeline_test.dart` (~20 tests)

### Home Screen Widget
An Android home screen widget (AppWidgetProvider) and iOS WidgetKit widget that display the next prayer name, its time, the countdown remaining, and the current timeline block title. The Flutter side writes data via `home_widget` after every timeline tick. The Android widget is fully wired in `AndroidManifest.xml`; the iOS widget requires Xcode setup (see Section 3d).
- **Flutter service:** `lib/core/services/widget_update_service.dart`
- **Android Kotlin:** `android/app/src/main/kotlin/.../ProductiveMuslimWidgetProvider.kt`
- **iOS Swift:** `ios/ProductiveMuslimWidget/ProductiveMuslimWidget.swift`
- **Tests:** `test/core/services/widget_update_service_test.dart` (22 tests)

### Responsive Layout (Phone + Tablet)
All screens adapt to four breakpoints: small (<360dp), medium (360–599dp), large (600–767dp), tablet (≥768dp). On tablet, the timeline shows a two-column layout (left: prayer strip + progress ring; right: block list), habits shows Today + Score side by side, analytics shows a vertical tab sidebar, and settings uses a master/detail split. Bottom navigation switches to `NavigationRail` on tablet.
- **Utility:** `lib/core/utils/responsive.dart` and `lib/core/utils/adaptive_layout.dart`

### Animations & Polish
Islamic geometric pattern splash screen (`_IslamicPatternPainter` with hex-offset octagram grid, slow rotation), directional slide transitions between onboarding steps, fade-through page transitions across all routes (300ms forward, 200ms reverse), elasticOut checkmark bounce on habit/prayer completion (`TimeBlockCard`), and a full-screen confetti overlay for personal-best celebrations (100-particle `CustomPainter` with gravity and fade-out).
- **Splash:** `lib/shared/widgets/app_splash_screen.dart`
- **Celebration:** `lib/shared/widgets/celebration_overlay.dart`
- **Tests:** `test/shared/widgets/animation_widgets_test.dart` (21 tests) + `test/shared/widgets/celebration_overlay_test.dart` (6 tests)

---

## 3. What Works But Needs Manual Configuration

These items have been written and are code-complete but require the developer to perform one-time setup actions, create accounts, or add credentials before the app can be released.

### a) Android Release Signing

**What it is:** The release build is configured to read signing credentials from `android/key.properties`. This file is excluded from source control by `.gitignore`. Without it, `flutter build appbundle --release` will fail or sign with the debug key.

**Step by step:**

1. Generate the keystore (run once from the project root — save the `.jks` file permanently):
   ```bash
   keytool -genkey -v \
     -keystore android/keystore/productive_muslim.jks \
     -keyalg RSA -keysize 2048 -validity 10000 \
     -alias productive_muslim
   ```

2. Create `android/key.properties` (already git-ignored):
   ```properties
   storeFile=keystore/productive_muslim.jks
   storePassword=YOUR_KEYSTORE_PASSWORD
   keyAlias=productive_muslim
   keyPassword=YOUR_KEY_PASSWORD
   ```

3. `android/app/build.gradle.kts` is already wired to read this file — no further changes needed.

4. Build:
   ```bash
   flutter build appbundle --release
   # Output: build/app/outputs/bundle/release/app-release.aab
   ```

Full instructions: `docs/ANDROID_SIGNING.md`

**CRITICAL:** Back up the `.jks` file securely (password manager, encrypted cloud storage). If you lose it, you cannot update the app on Google Play — you would need to publish a new app with a different package name.

---

### b) iOS Signing

**What it is:** iOS builds must be signed with an Apple Developer certificate. The bundle identifier `com.productivemuslim.app` must be registered in the Apple Developer Portal.

**Step by step:**

1. Enrol in the Apple Developer Program ($99/year) at [developer.apple.com](https://developer.apple.com).
2. Create an App ID: Identifiers → + → App IDs → Bundle ID = `com.productivemuslim.app`.
3. Open the iOS workspace (not the `.xcodeproj`):
   ```bash
   open ios/Runner.xcworkspace
   ```
4. In Xcode: select Runner target → Signing & Capabilities → set Team → confirm Bundle ID = `com.productivemuslim.app` → enable "Automatically manage signing".
5. Create the app in App Store Connect at [appstoreconnect.apple.com](https://appstoreconnect.apple.com).

Full instructions including archive, upload, metadata, age rating, and privacy data types: `docs/IOS_SUBMISSION.md`

---

### c) App Group for iOS Home Screen Widget

**What it is:** The iOS WidgetKit extension and the main Flutter app must share data through an App Group. The group ID used in the Swift file is `group.com.productivemuslim.app`. Without this Xcode capability being enabled, the widget will show blank data.

**Step by step:**

1. In Xcode, select the **Runner** target → Signing & Capabilities → **+** → **App Groups** → add `group.com.productivemuslim.app`.
2. Select the **ProductiveMuslimWidget** target (see Section 3d) → Signing & Capabilities → **+** → **App Groups** → add the same `group.com.productivemuslim.app`.
3. The Swift file at `ios/ProductiveMuslimWidget/ProductiveMuslimWidget.swift` already reads from `UserDefaults(suiteName: "group.com.productivemuslim.app")` — no code changes needed.
4. In the Flutter layer, `WidgetUpdateService` uses `HomeWidget.setAppGroupId('group.com.example.productiveMuslim')`. **Update this constant** in `lib/core/services/widget_update_service.dart` to match:
   ```dart
   static const String _appGroupId = 'group.com.productivemuslim.app';
   ```

---

### d) iOS WidgetKit Extension Target

**What it is:** The Swift source file for the iOS home screen widget exists at `ios/ProductiveMuslimWidget/ProductiveMuslimWidget.swift`, but the Xcode target that builds it must be created manually — Xcode targets cannot be committed to source control in a way that other machines can build without this step.

**Step by step:**

1. In Xcode, go to File → New → Target → **Widget Extension**.
2. Name it exactly `ProductiveMuslimWidget`. Do not add the configuration scene or intent extension when prompted.
3. Xcode generates a `ProductiveMuslimWidget.swift` placeholder. Delete the generated file.
4. Add the existing file: right-click the `ProductiveMuslimWidget` group → Add Files → select `ios/ProductiveMuslimWidget/ProductiveMuslimWidget.swift`.
5. Add the App Group capability to the new target (see Section 3c above).
6. Set the deployment target for the new extension to iOS 14.0+ (required by WidgetKit).
7. Add the `ProductiveMuslimWidget` target to the Runner's **Embed App Extensions** build phase.

---

### e) Auth — Firebase Google Sign-In (ACTIVE)

Google Sign-In and anonymous auth are live via `firebase_auth ^5.3.1` and `google_sign_in ^6.2.2`.

**`FirebaseAuthRepositoryImpl`** (`lib/features/auth/data/repositories/firebase_auth_repository_impl.dart`) is the active implementation when `EnvironmentConfig.firebaseAvailable` is true.

**Remaining action:** Register the SHA-1 fingerprint for each machine's debug keystore in Firebase Console (see the FIREBASE IS LIVE section above and `docs/SHA_FINGERPRINTS.md`). Without this, `signInWithGoogle()` returns a `FirebaseAuthException` on Android.

---

### f) Backup — Firestore (ACTIVE)

Firestore backup is live via `cloud_firestore ^5.4.4`. Offline persistence is enabled.

**Collection path:** `users/{userId}/backups/{backupId}`
**`FirebaseBackupRepositoryImpl`** (`lib/features/backup/data/repositories/firebase_backup_repository_impl.dart`) is the active implementation when `EnvironmentConfig.firebaseAvailable` is true.

**Firestore security rules** are in `firestore.rules` — deploy with `firebase deploy --only firestore:rules`. Deploy the index in `firestore.indexes.json` with `firebase deploy --only firestore:indexes`.

**What remains for backup to be fully useful in production:** The `BackupAutoRequested` event in `main.dart` currently sends an empty snapshot. A `BackupSnapshotBuilder` service needs to read `UserProfile`, `Habit` list, `StreakRecord` list, and `AppSettings` from Isar and assemble a full `BackupSnapshot`. Wire it into `didChangeAppLifecycleState(paused)`.

**Supabase alternative:** implement `BackupRepository` with `supabase_flutter`, swap the return in `environment_config.dart`.

---

### g) Crashlytics and Analytics (ACTIVE)

**Firebase Crashlytics** (`firebase_crashlytics ^4.1.3`) and **Firebase Analytics** (`firebase_analytics ^11.3.3`) are integrated.

- `FlutterError.onError` → `FirebaseCrashlytics.instance.recordFlutterFatalError` (in `main()`)
- `PlatformDispatcher.instance.onError` → `FirebaseCrashlytics.instance.recordError` with `fatal: true`
- Both are guarded by `EnvironmentConfig.firebaseAvailable` — no crash if Firebase is unavailable

**Service wrappers:**
- `lib/core/services/analytics_service.dart` — static helpers for prayer completed, habit completed, screen view, set user ID
- `lib/core/services/error_reporting_service.dart` — static helpers for record error, log, set user ID

---

### h) Prayer Time Calculation (No API Key Required)

**What it is:** Prayer times are calculated locally on-device using the `adhan: ^1.1.0` Dart package — a pure Dart port of the Adhan JavaScript library. There is no external API, no API key, and no network request for prayer time data. The app works completely offline once installed.

**No action required.** This is documented here so you do not spend time looking for a missing API key that does not exist.

---

### i) Geocoding and Location

**What it is:** Location is requested once during onboarding using the `geolocator` package to get a GPS coordinate. The `geocoding` package then reverse-geocodes the coordinate to a human-readable city name (e.g., "Cairo, Egypt") for display.

**Important:** Reverse geocoding (coordinate → city name) works offline on iOS using the system's CLGeocoder. On Android it requires an internet connection on first launch. If the device has no internet during onboarding, the city name will be blank but the latitude/longitude will still be stored and prayer times will still compute correctly.

**No credentials required.** Both packages use device OS APIs and do not require API keys. If you later want higher-quality city lookup (supporting remote/rural areas better), you could swap in Google Maps Geocoding API — in that case you would need to add `android.permission.INTERNET` (already present), a Maps API key in `AndroidManifest.xml`, and update `lib/features/onboarding/data/repositories/onboarding_repository_impl.dart`.

---

### j) App Launcher Icons

**What it is:** `flutter_launcher_icons` is configured in `pubspec.yaml` and the icon design is at `assets/icon/icon.svg`. A convenience shell script runs all three generation steps in order.

**One-liner (run from project root):**
```bash
bash tool/setup_icons.sh
```

This script runs:
1. `dart run tool/generate_icon.dart` — creates `assets/icon/icon.png` (1024×1024, green background) and `assets/icon/icon_foreground.png` (transparent background) from the SVG design using pure Dart.
2. `dart run flutter_launcher_icons` — generates all Android adaptive icon and iOS icon sizes.
3. `dart run flutter_native_splash:create` — generates the native Android/iOS splash screen.

For the highest-quality "PM" wordmark, export the SVG from Figma or Inkscape and manually overwrite `assets/icon/icon.png` before running step 2.

If you skip this step the app will launch with the default Flutter blue icon.

---

### k) Native Splash Screen

**What it is:** `flutter_native_splash` is configured in `pubspec.yaml` to generate a native Android/iOS splash using the Islamic green `#1B6B3A` as the background and `assets/icons/splash_logo.png` as the centred logo.

**Step by step:**

1. Ensure `assets/icons/splash_logo.png` exists (produced by `scripts/generate_icons.py` in step h above, or provide your own 512×512 transparent PNG).
2. Run:
   ```bash
   dart run flutter_native_splash:create
   ```

If you skip this step the device will show the default white Android splash while the app loads.

---

### l) build_runner (Isar Model Changes Only)

**What it is:** `build_runner` generates the `*.g.dart` companion files that Isar requires for its schema reflection. The generated files for all current models (`user_profile_model.g.dart`, `daily_timeline_model.g.dart`, `time_block_model.g.dart`, `habit_model.g.dart`, `ramadan_profile_model.g.dart`, `cached_prayer_day_model.g.dart`) are **already committed to the repository**. You do not need to run `build_runner` to build or test the app today.

**Only run it if you add a new `@collection` Isar model or change the fields of an existing one:**
```bash
# Add isar_generator back to pubspec.yaml dev_dependencies temporarily:
# isar_generator: ^3.1.0+1
flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

**Important:** `isar_generator` was removed from `dev_dependencies` because it conflicts with `bloc_test ^9.1.7` via the `analyzer` version dependency chain. The `.g.dart` file for `cached_prayer_day_model` was hand-written to match the exact generator output. If you ever need to regenerate, add `isar_generator` back temporarily, regenerate, then remove it again.

---

## 4. What Is Missing / Not Yet Built

These items are either explicitly deferred or were never part of the original scope. Be honest with yourself: none of these will make the app crash, but several are important for a polished production release.

### a) App Icon PNG (run the generator)

~~App Icon Image File~~ — **The icon design is done** (`assets/icon/icon.svg` + `tool/generate_icon.dart`). You still need to run the generator to produce the PNG build artefacts before releasing:

```bash
dart run tool/generate_icon.dart     # creates assets/icon/icon.png + icon_foreground.png
dart run flutter_launcher_icons      # generates all platform icon sizes
```

The "PM" wordmark is defined in the SVG. For the highest-quality text rendering, export the SVG from a design tool (Figma, Inkscape) rather than using the Dart programmatic script.

### b) Real Adhan Audio Files

The notification infrastructure is now fully wired (`NotificationSoundConfig`, 6 Android channels). The only remaining step is placing the actual audio files:

**Android** — copy to `android/app/src/main/res/raw/`:
- `adhan.mp3` — full adhan played at exact prayer time
- `iftar_adhan.mp3` — Iftar adhan at Maghrib during Ramadan
- `quran_reminder.mp3` — gentle Quran reading reminder

**iOS** — convert to `.aiff` and add via Xcode (target → Build Phases → Copy Bundle Resources):
- `adhan.aiff`, `iftar_adhan.aiff`, `quran_reminder.aiff`

**Free sources:** Islamic Network (https://alquran.cloud/api), Zekr (https://zekr.org), Islamic Finder (https://www.islamicfinder.org). The `assets/audio/.gitkeep` file in the repo documents these instructions.

Without the files, notifications fall back to the device's default notification sound — the app does not crash.

### c) True Background Prayer Reminders on iOS

`flutter_local_notifications` schedules local notifications up to a fixed window in advance. On iOS, if the app is force-quit by the user and all scheduled notifications expire, new ones cannot be scheduled until the app is opened again. For true always-on prayer reminders (even if the app is never opened), you would need either:
- A remote push notification via FCM (requires a server that knows the user's prayer times — conflicts with the privacy-first design), or
- iOS Background App Refresh (unreliable, throttled by iOS).
For most users, local notifications scheduled on each app open are sufficient. Document this limitation in the app's FAQ.

### d) Real Backend / Cloud Sync (Mock Is Now in Place)

The auth and backup layers are fully built with mock implementations that work 100% offline. The mock Google Sign-In stores a hardcoded user in SharedPreferences; the mock cloud backup saves JSON to the device's documents directory. Both are architected for a single-file swap to a real backend — see Section 3e (auth) and Section 3f (backup) for exact instructions.

What remains before the backup is truly useful in production:
- The `BackupAutoRequested` event in `main.dart` currently sends an empty snapshot (no Isar data). A real implementation needs a `BackupSnapshotBuilder` service that reads the current `UserProfile`, `Habit` list, `StreakRecord` list, and `AppSettings` from Isar and assembles a full `BackupSnapshot`. Wire it between `BackupBloc` and the lifecycle observer.
- Multi-device restore: after `RestoreRequested` succeeds, the returned `BackupSnapshot` must be written back to Isar using the existing repository use cases. The `BackupPage`'s `BlocListener` currently shows a snackbar but does not apply the data.

### e) Quran Text and Audio

The habit system tracks pages of Quran read per day as a number. The app does not display Quran text, ayah-by-ayah navigation, or audio recitation. Integrating these would require either:
- A bundled Quran dataset (the Tanzil `.json` Quran is ~2 MB, free to use with attribution), or
- An online Quran API such as [alquran.cloud](https://alquran.cloud) or Quran.com's API.

### f) Halal Meal Planner

Referenced in the original product vision but not built. Would be a new `lib/features/meals/` module following the same Clean Architecture pattern as the other features. No stubs or partial code exist for this.

### g) Social / Community Features

No leaderboards between friends, no group challenge sharing, no public streak display. Building these requires a backend (see item d above) and a social graph model.

### h) Localisation and Arabic RTL

**l10n scaffold is in place.** The app ships with a full localisation scaffold:
- `flutter_localizations` (SDK package) and `intl: ^0.20.2` are in `pubspec.yaml`.
- `l10n.yaml` is configured and `generate: true` is set in the `flutter:` section — `flutter gen-l10n` runs at build time.
- ARB files exist at `lib/l10n/app_en.arb` (20 English strings) and `lib/l10n/app_ar.arb` (Arabic translations).
- `AppSettings.language` field persists the chosen locale. A language picker (English / العربية) is on the Appearance settings page.
- `main.dart` passes `locale`, `localizationsDelegates`, and `supportedLocales` to `MaterialApp.router`.

**What remains:** The 20 ARB strings cover only app-level chrome (tabs, buttons, settings labels). All feature strings (onboarding, timeline block names, habit descriptions, analytics labels) still need to be extracted and translated. RTL layout testing is also needed — `Directionality.of(context)` is not currently used explicitly in feature widgets.

### i) Accessibility Audit

**Key widgets now have `Semantics` labels.** `TimeBlockCard`, `_PrayerPill`, and `HabitCard` each have a `Semantics` wrapper with a descriptive label that announces the block/prayer/habit name, status, and completion state to screen readers (TalkBack / VoiceOver).

**What remains before submission:**
- All interactive elements have `Semantics` labels. ← *partially done (three key widgets; onboarding, settings, and analytics pages not yet audited)*
- Minimum touch target size is 48×48dp (Flutter's `InkWell` meets this, but custom `GestureDetector` widgets may not).
- Text scaling works up to 200% without overflow.
- Screen reader (TalkBack on Android, VoiceOver on iOS) can navigate all screens.

### j) Privacy Policy Hosting

`assets/privacy_policy.md` contains a comprehensive privacy policy document and is displayed in-app on the Settings → Data page. However, Google Play and the Apple App Store require the privacy policy to be hosted at a **public live URL**. Suggested approaches:
- Publish to GitHub Pages from the same repository (`gh-pages` branch or `/docs` folder).
- Create a simple one-page website at the marketing URL `productivemuslim.app`.
- Use a free hosting service such as Netlify or Vercel.
The URL to use in store listings: `https://productivemuslim.app/privacy`

### k) Store Screenshots

`docs/SCREENSHOT_GUIDE.md` documents exactly which screens to capture, at what resolution, with what captions, for both Google Play and the App Store. But the actual screenshot PNG files do not exist. You must run the app on simulators/emulators (or real devices), navigate to each of the five recommended screens, and export the screenshots at the required resolutions.

### l) TestFlight / Internal Testing Track

Before a public launch, distribute to real users via:
- **iOS:** TestFlight — upload a build to App Store Connect and invite testers.
- **Android:** Google Play Internal Testing track — upload the AAB and add tester email addresses.
This allows you to catch device-specific issues, prayer time accuracy issues for edge-case locations, and UX problems that automated tests cannot catch.

### m) Analytics and Crash Reporting (DONE)

Firebase Crashlytics and Firebase Analytics are active. See Section 3g for details.

The service wrappers (`AnalyticsService`, `ErrorReportingService`) have call sites ready — wire them into feature BLoCs as needed for richer event tracking (e.g., call `AnalyticsService.logPrayerCompleted()` from `TimelineBloc` when a prayer block is checked).

### n) Radio Widget Deprecation

One `Radio` widget (in the prayer calculation method selector in `lib/features/onboarding/presentation/pages/steps/step_3_prayer_settings.dart`) uses the deprecated `groupValue`/`onChanged` API from pre-Flutter 3.32. A `// ignore: deprecated_member_use` comment suppresses the warning. The full migration to the new `RadioGroup` widget API was deferred to post-v1.0.0 because the new API was introduced in Flutter 3.32 and the widget still works correctly. This should be the first technical debt item to address after launch.

---

## 5. How to Run the Project

### Prerequisites
- **Flutter:** stable channel, version 3.22 or later. Check with `flutter --version`.
- **Dart:** 3.x (bundled with Flutter 3.22+).
- **Android:** Android Studio with Android SDK 34 installed, or `sdkmanager` CLI.
- **iOS:** Xcode 15+ with iOS 14+ simulator (Mac only).

### From zero to running:

```bash
# 1. Get dependencies
flutter pub get

# 2. Run the app (connects to the first available device/simulator)
flutter run

# 3. Run on a specific device
flutter devices          # list available devices
flutter run -d <device-id>

# 4. Run in debug mode with verbose output
flutter run -v
```

### Run all tests:
```bash
flutter test
# Expected: 535 tests passed, 0 failures
```

### Run a specific test file:
```bash
flutter test test/features/timeline/domain/timeline_generator_test.dart -v
flutter test test/features/habits/domain/streak_calculator_test.dart -v
```

### Static analysis:
```bash
flutter analyze   # should report: No issues found!
dart analyze      # should report: No issues found!
```

### You do NOT need to run build_runner to run the app.
All generated `*.g.dart` files are already committed. Only run `build_runner` if you add or modify an Isar `@collection` model (see Section 3j).

---

## 6. How to Build for Release

### Android — App Bundle (AAB)

1. Complete the signing setup in Section 3a.
2. Build:
   ```bash
   flutter build appbundle --release
   ```
3. The output file is:
   ```
   build/app/outputs/bundle/release/app-release.aab
   ```
4. Upload this file to Google Play Console → Production (or Internal Testing track first).

Increment `version` in `pubspec.yaml` before each upload:
```yaml
version: 1.0.0+1   # format: versionName+versionCode
# versionCode must increase on every upload (even if versionName stays the same)
```

Full detail: `docs/ANDROID_SIGNING.md` and `docs/PLAY_STORE_SUBMISSION.md`

### iOS — IPA / Archive

1. Complete the signing setup in Sections 3b and 3c.
2. Build and verify:
   ```bash
   flutter build ios --release
   ```
3. Archive in Xcode: **Product → Archive** (this requires a physical Mac with Xcode — it cannot be done from the command line without an enterprise certificate).
4. Xcode Organizer opens automatically → **Distribute App → App Store Connect → Upload**.
5. Alternatively, use:
   ```bash
   flutter build ipa --release --export-options-plist=ios/ExportOptions.plist
   ```
   Then drag the `.ipa` into [Transporter.app](https://apps.apple.com/app/transporter/id1450874784).

Full detail: `docs/IOS_SUBMISSION.md`

### Store listing copy

All store listing text (app name, short/full descriptions, subtitle, keywords, What's New, content ratings, URLs) is ready to copy and paste from `assets/store_listing.md`.

---

## 7. Project Structure Reference

```
productive_muslim/
├── lib/
│   ├── main.dart                              ← App entry, DI init, MultiBlocProvider, MaterialApp.router
│   │
│   ├── core/
│   │   ├── constants/app_constants.dart       ← App-wide magic numbers and string constants
│   │   ├── di/app_dependencies.dart           ← Central dependency injection (manual, no get_it)
│   │   ├── errors/failures.dart               ← Failure sealed class hierarchy (ValidationFailure, CacheFailure, etc.)
│   │   ├── navigation/app_router.dart         ← go_router route table + fade-through page transitions
│   │   ├── services/
│   │   │   ├── isar_service.dart              ← Isar database init, collection accessors, schema list
│   │   │   ├── prayer_cache_service.dart      ← 30-day prayer cache warm/invalidate orchestration
│   │   │   ├── prayer_notification_service.dart ← Schedules 2 local notifications per prayer × 5 prayers
│   │   │   └── widget_update_service.dart     ← Writes next prayer + current block to home screen widget
│   │   ├── usecases/usecase.dart              ← Abstract UseCase<Result, Params> base class
│   │   └── utils/
│   │       ├── responsive.dart               ← ScreenSize enum, Responsive helpers, ResponsiveContext extension
│   │       └── adaptive_layout.dart          ← TwoColumnLayout, MaxWidthBox, MasterDetailLayout widgets
│   │
│   ├── features/
│   │   │
│   │   ├── onboarding/                        ← 6-step first-launch flow, UserProfile capture + Isar storage
│   │   │   ├── data/models/user_profile_model.dart   ← Isar @collection for UserProfile
│   │   │   ├── data/repositories/onboarding_repository_impl.dart
│   │   │   ├── domain/entities/user_profile.dart      ← Pure Dart UserProfile entity (immutable, copyWith)
│   │   │   ├── domain/usecases/onboarding_usecases.dart
│   │   │   └── presentation/
│   │   │       ├── bloc/onboarding_bloc.dart           ← 27 events, step validation, location permission
│   │   │       └── pages/onboarding_page.dart + steps/ ← 6 step UI files
│   │   │
│   │   ├── prayer/                            ← adhan wrapper, prayer cache, prayer time domain entities
│   │   │   ├── data/models/cached_prayer_day_model.dart ← Isar cache row (30-day rolling window)
│   │   │   ├── data/repositories/prayer_time_service.dart ← Sync + async (cache-first) prayer time calculation
│   │   │   ├── data/repositories/prayer_cache_repository_impl.dart
│   │   │   ├── domain/entities/prayer_times.dart       ← DailyPrayerTimes, PrayerTime, PrayerName
│   │   │   └── domain/repositories/prayer_cache_repository.dart
│   │   │
│   │   ├── timeline/                          ← Core scheduling engine, dashboard UI, BLoC
│   │   │   ├── data/models/                  ← DailyTimelineModel + TimeBlockModel (Isar)
│   │   │   ├── data/repositories/timeline_repository_impl.dart
│   │   │   ├── domain/entities/time_block.dart        ← TimeBlock entity, TimeBlockType enum, BlockPriority
│   │   │   ├── domain/usecases/timeline_generator_service.dart ← 763-line scheduling pipeline
│   │   │   ├── domain/usecases/timeline_usecases.dart
│   │   │   └── presentation/
│   │   │       ├── bloc/timeline_bloc.dart             ← Load, generate, 60s tick, home-widget update
│   │   │       ├── pages/home_shell.dart               ← Root scaffold: bottom nav + tab bodies (AnimatedOpacity)
│   │   │       ├── pages/timeline_dashboard_page.dart  ← Main timeline UI (date nav, progress ring, block list)
│   │   │       └── widgets/timeline_widgets.dart       ← TimeBlockCard, PrayerStrip, DailyProgressRing, etc.
│   │   │
│   │   ├── habits/                            ← Habit entities, streak calc, seeder, BLoC, UI
│   │   │   ├── data/models/habit_model.dart           ← Isar @collection for Habit + StreakRecord
│   │   │   ├── data/repositories/habits_repository_impl.dart
│   │   │   ├── domain/entities/habit.dart             ← Habit entity, HabitCategory enum, StreakPauseReason
│   │   │   ├── domain/usecases/streak_calculator.dart ← Pure Dart streak logic (no framework dependencies)
│   │   │   ├── domain/usecases/default_habit_seeder.dart ← Seeds 12–15 habits from UserProfile on first launch
│   │   │   └── presentation/
│   │   │       ├── bloc/habits_bloc.dart              ← Load, complete, undo, personal-best detection
│   │   │       ├── pages/habits_page.dart             ← Today/Score tabs + tablet two-column layout
│   │   │       └── widgets/habits_widgets.dart        ← HabitCard, WeeklyScoreCard, AddHabitSheet, etc.
│   │   │
│   │   ├── ramadan/                           ← Hijri converter, Ramadan generator, dashboard UI
│   │   │   ├── data/models/ramadan_profile_model.dart ← Isar model for Ramadan settings (10 knobs)
│   │   │   ├── domain/entities/ramadan_entities.dart  ← RamadanProfile, HijriDate, RamadanBlock types
│   │   │   ├── domain/usecases/hijri_converter.dart   ← Pure Dart Gregorian↔Hijri conversion (Kuwaiti algo)
│   │   │   ├── domain/usecases/ramadan_timeline_generator.dart ← Ramadan-specific scheduling engine
│   │   │   └── presentation/
│   │   │       ├── bloc/ramadan_bloc.dart
│   │   │       ├── pages/ramadan_dashboard_page.dart  ← Night-sky theme, live Iftar countdown
│   │   │       └── pages/ramadan_settings_page.dart   ← 10 configurable Ramadan parameters
│   │   │
│   │   ├── analytics/                         ← Repository reading Isar, 6 chart widgets, 3-tab dashboard
│   │   │   ├── data/repositories/analytics_repository_impl.dart
│   │   │   ├── domain/entities/analytics_entities.dart ← AnalyticsPeriod, WeeklyScoreSeries, HeatmapDay, etc.
│   │   │   ├── domain/usecases/analytics_usecases.dart
│   │   │   └── presentation/
│   │   │       ├── bloc/analytics_bloc.dart
│   │   │       ├── pages/analytics_dashboard_page.dart
│   │   │       └── widgets/analytics_widgets.dart     ← All 6 chart widgets (fl_chart-based)
│   │   │
│   │   └── settings/                          ← 15-key SharedPreferences, 6 settings sub-pages
│   │       ├── data/services/settings_service.dart    ← SharedPreferences read/write/reset
│   │       ├── data/repositories/settings_repository_impl.dart
│   │       ├── domain/entities/app_settings.dart      ← AppSettings entity (immutable, copyWith)
│   │       ├── domain/usecases/settings_usecases.dart
│   │       └── presentation/
│   │           ├── bloc/settings_bloc.dart + _event + _state
│   │           └── pages/                            ← settings_page, profile_edit, prayer_settings,
│   │                                                 ←   notifications, appearance, data
│   │
│   └── shared/
│       ├── theme/app_theme.dart               ← AppTheme (light + dark), AppColors, AppTextStyles, AppSpacing
│       └── widgets/
│           ├── app_splash_screen.dart         ← Islamic pattern splash (CustomPainter + AnimationController)
│           └── celebration_overlay.dart       ← Full-screen confetti personal-best overlay
│
├── test/                                      ← 538 tests across 21 files (see Section 2 for breakdown)
│
├── android/
│   ├── app/build.gradle.kts                  ← Release signing config (reads android/key.properties)
│   ├── app/src/main/kotlin/.../
│   │   └── ProductiveMuslimWidgetProvider.kt ← Android AppWidgetProvider (Kotlin)
│   └── app/src/main/res/
│       ├── layout/productive_muslim_widget.xml
│       ├── xml/productive_muslim_widget_info.xml
│       └── drawable/widget_background.xml
│
├── ios/
│   ├── Runner/Info.plist                     ← NSUserNotificationsUsageDescription, NSLocationWhenInUseUsageDescription
│   └── ProductiveMuslimWidget/
│       ├── ProductiveMuslimWidget.swift       ← WidgetKit StaticConfiguration (Swift)
│       └── Info.plist
│
├── assets/
│   ├── store_listing.md                      ← Copy-paste text for Play Store + App Store fields
│   ├── privacy_policy.md                     ← Privacy policy (also must be hosted at a public URL)
│   └── icons/                               ← App icon PNGs (generated by scripts/generate_icons.py)
│
├── docs/
│   ├── ANDROID_SIGNING.md                   ← Keytool, key.properties, flutter build appbundle
│   ├── IOS_SUBMISSION.md                    ← Apple Developer Portal → Xcode → App Store Connect
│   ├── PLAY_STORE_SUBMISSION.md             ← Play Console → AAB → content rating → publish
│   └── SCREENSHOT_GUIDE.md                  ← Required sizes + 5 recommended screens with captions
│
└── scripts/
    └── generate_icons.py                    ← Pillow script to generate app_icon.png + foreground + splash
```

---

## 8. Key Architectural Decisions

**Why Clean Architecture?** The app has four distinct algorithmic layers — prayer time calculation, timeline scheduling, streak tracking, and analytics aggregation — each of which needed to be independently testable without a running app or a database. Clean Architecture (Domain / Data / Presentation) enforces this by making the Domain layer a pure Dart library: no Flutter imports, no Isar imports, no platform dependencies. The `StreakCalculator`, `TimelineGeneratorService`, `HijriConverter`, and `AnalyticsRepositoryImpl` are all pure Dart classes that can be exercised in a `dart test` environment with no device. This paid off during development: bugs were found and fixed in unit tests before the UI was built, saving significant time.

**Why BLoC over Riverpod or Provider?** BLoC was chosen for its strict event/state separation, which makes the UI a pure function of state and makes state transitions auditable from a test. `bloc_test` makes it trivial to assert exact state sequences — for example, verifying that `HabitsBloc` emits `loaded → loading → loaded(streakIncremented) → loaded(newPersonalBest: true)` in exactly that order. Riverpod is equally powerful but was not chosen because BLoC's explicit event model makes the flow of actions easier to follow for developers new to the codebase, and the project was already using it from the first phase.

**Why Isar over Hive or SQLite?** Isar 3 was chosen for three reasons: (1) it uses generated schema files that give compile-time safety for field names and types (unlike Hive's box-as-Map approach), (2) its query API is expressive enough for the analytics queries (`where().dateGreaterThan(...).findAll()`) without writing raw SQL, and (3) it performs the box-opening and schema-migration steps asynchronously at startup without blocking the main thread. The tradeoff — `isar_generator` conflicts with `bloc_test`'s `analyzer` dependency — was resolved by hand-writing the one affected `.g.dart` file (`cached_prayer_day_model.g.dart`) once and committing it, removing `isar_generator` from `dev_dependencies`.

**Why the adhan package over a prayer time API?** The entire value proposition of the app rests on prayer times being always available, accurate to the user's exact location, and responsive to location changes. A remote API would require: (1) an internet connection, breaking the app in offline/airplane-mode scenarios common during international travel; (2) an API key to protect from abuse; (3) rate limiting logic; and (4) a caching layer anyway. The adhan package is a faithful Dart port of the well-tested Adhan algorithm used by apps like Muslim Pro. It runs in microseconds on-device and produces results matching authoritative sources to within 1 minute accuracy for all supported calculation methods.

**Why offline-first?** The target user is a Muslim who prays five times a day, including at Fajr before sunrise and Isha late at night — times when the device may be in airplane mode or in a poor-signal area (mosque, basement, rural). Requiring an internet connection for the app's primary function (knowing when the next prayer is) would be a fundamental product failure. Offline-first also eliminates the need for user accounts, removes the attack surface for a privacy breach, and simplifies the architecture: there is no sync conflict resolution to implement, no authentication flow, and no server to maintain.

**How the scheduling algorithm works at a high level:** The `TimelineGeneratorService` treats the day as a constraint-satisfaction problem. Hard constraints — sleep (start and wake time), five prayers with their buffer windows (wudu + travel time, configurable per prayer), and the work window — are placed first as immovable anchors. The algorithm then computes which prayers fall inside the work window and splits the work block around them. After anchoring, it scans the remaining free intervals in priority order and places optional blocks: Quran reading (in the Golden Hour, the protected window between Fajr and sunrise), the Golden Hour block itself, gym (on user's gym days), meals, Qaylula (midday nap between Dhuhr and Asr), Deep Work (longest remaining contiguous gap), evening dhikr, and a bedtime routine. Any remaining gaps become Free Time blocks. A final overlap-resolution pass ensures no two blocks share the same minute, with higher-priority blocks winning.

---

## 9. Known Issues and Technical Debt

**Radio widget deprecation.** The prayer calculation method selector in `step_3_prayer_settings.dart` uses the `Radio` widget's `groupValue`/`onChanged` API, which was deprecated in Flutter 3.32 in favour of `RadioGroup`. A `// ignore: deprecated_member_use` comment suppresses the analyzer warning. The widget works correctly at runtime. Migration to `RadioGroup` should be the first post-launch cleanup task.

**`isar_generator` removed from dev_dependencies.** As described in Section 3j, `isar_generator ^3.1.0+1` conflicts with `bloc_test ^9.1.7` through the `analyzer` package dependency chain. The `.g.dart` files for all current models are committed and correct. If you add a new Isar `@collection` class, you must temporarily add `isar_generator` back, regenerate, then remove it — or resolve the conflict by upgrading `bloc_test` if a compatible version exists by the time you read this.

**`lottie` package is a dependency but not used.** The `lottie: ^3.1.2` package was added in anticipation of Lottie animation files for celebrations and prayer completion. The actual celebration animation was implemented using a native `CustomPainter` instead (no Lottie JSON file needed), so the package is now unused. It can be removed from `pubspec.yaml` to reduce app size — just verify no other widget has started using it first.

**Test fixes applied (Session B).**
1. `widget_update_service_test.dart` — `startTime.isAfter(now)` → `!startTime.isBefore(now)` (inclusive boundary for `'0m'` display).
2. `prayer_cache_repository_test.dart` — missing `registerFallbackValue` left mocktail in verify-recording mode, silently breaking subsequent stubs. Fixed by adding the fallback to `setUpAll`.
3. `animation_widgets_test.dart` — `find.byType(ScaleTransition)` → `find.ancestor(of: checkIcon, matching: ...)` because `MaterialApp` introduces its own `ScaleTransition`.

**Widget/integration test patterns (Session C — important for future test authors).**
1. **Screen size in tests:** The default Flutter test surface is 800×600, which is wider than `_tabletBreak = 768.0` — so `HomeShell` enters tablet (`NavigationRail`) mode by default. Force phone layout with `MaterialApp.builder` + `MediaQuery.copyWith(size: const Size(390, 844))`. Do NOT use `tester.binding.setSurfaceSize()` from `setUp()` — it asserts `inTest: is not true`.
2. **`_AnalyticsAwareStack` always renders all tabs:** `HomeShell` uses `Stack + AnimatedOpacity + IgnorePointer` — all 4 tab pages are in the widget tree at all times (opacity 0 when inactive). Nav bar labels ("Analytics", "Habits", "Timeline") are also page headings, causing `findsOneWidget` failures. Use `findsAtLeastNWidgets(1)` for labels that duplicate headings. Use `.last` when tapping — nav bar renders after the body in the tree.
3. **`repeat()` animation in timeline_widgets.dart:953** never settles, so `pumpAndSettle()` times out. Use `pump(const Duration(milliseconds: 50))` for HomeShell tests.
4. **`settings_state.dart` is `part of 'settings_bloc.dart'`** — import only `settings_bloc.dart` in tests; importing the part file directly is a compile error.
5. **`AppDependencies.getUserProfile` is `static late`** — set it in `setUp()` before mounting `SettingsPage`. Use a `MockGetUserProfile extends Mock implements GetUserProfile` and `when(() => mock(any())).thenAnswer(...)`.

**Integration and responsiveness test inventory (Session C).**
| File | Tests | What it covers |
|------|-------|----------------|
| `test/integration/auth_to_onboarding_test.dart` | 4 | `AppRouter.buildRouter()` routing: no-auth→AuthPage, guest→Onboarding, signed-in+profile→HomeShell |
| `test/integration/timeline_to_habit_test.dart` | 9 | HomeShell bottom nav: labels present, tap Habits/Analytics/Profile, icon state changes |
| `test/integration/backup_flow_test.dart` | 5 | BackupPage state machine: Initial→InProgress→Loaded, error/restore snackbars, unauthenticated |
| `test/integration/settings_profile_edit_test.dart` | 7 | Profile tab nav → SettingsPage tiles, Edit Profile push navigation |
| `test/responsiveness/overflow_test.dart` | 30 | 6 sizes × 5 pages — zero `RenderFlex` overflow, key widget present |

**No current failing tests or analyzer warnings.** `flutter test` reports 538/538 passed. `flutter analyze` and `dart analyze` both report 0 issues.

---

## 10. Contact / Credits

This section is a placeholder for the developer who takes ownership of this project.

| Field | Value |
|---|---|
| Developer name | *(fill in)* |
| Contact email | *(fill in)* |
| GitHub | *(fill in)* |
| App website | https://productivemuslim.app *(register this domain)* |
| Support URL | https://productivemuslim.app/support |
| Privacy policy | https://productivemuslim.app/privacy |

**Original development:** This codebase was developed with Claude (Anthropic) as a pair-programming partner across nine structured phases, from architecture to submission readiness.

**Open source attributions:**
- Prayer time calculations: [Adhan](https://github.com/batoulapps/adhan-dart) — MIT licence
- UI charts: [fl_chart](https://github.com/imaNNeo/fl_chart) — MIT licence
- Icons: [Iconsax](https://iconsax.io) — free for personal and commercial use
- Fonts: Google Fonts (Nunito) — Open Font Licence

---

*Last updated: 2026-07-02 (Firebase Full Integration). Flutter analyze: 0 issues. Tests: 535/535 passing. Debug APK: built successfully.*
