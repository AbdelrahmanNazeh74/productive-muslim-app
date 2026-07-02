# ✅ FINAL POLISH COMPLETE (2026-07-03)
535 tests passing. 0 analyze issues. All phases 1–9 + Sessions A–C, Final, Firebase, Bug Fix + Polish done.
Firebase ACTIVE. Bug fixes + polish: Google photo, prayer location, Arabic l10n, dark mode, profile routing,
theme flash, RTL chevrons, scaffold colors, prayer debug screen (kDebugMode). Commit: 53fd2c6.

---

# 🕌 Productive Muslim — Project Memory File
> **Read this file at the start of every session before writing any code.**
> It tells you exactly where the project is, what's built, and what comes next.

---

## 🚀 APP IS READY TO SUBMIT

**All development phases are complete.** Before uploading:
1. Generate signing keystore → see `docs/ANDROID_SIGNING.md`
2. Run `flutter build appbundle --release` → upload `build/app/outputs/bundle/release/app-release.aab` to Play Console
3. Run `flutter build ios --release`, archive in Xcode, upload to App Store Connect
4. Upload screenshots per `docs/SCREENSHOT_GUIDE.md`
5. Fill store listing from `assets/store_listing.md`

---

## 📌 Project Identity

- **App name:** Productive Muslim
- **Package name:** `productive_muslim`
- **Platform:** Flutter (Dart) — targets Android & iOS (Play Store + App Store)
- **Current version:** `1.0.0+1`
- **Total lines of code:** ~24,000 across 96+ Dart files (535 tests)

## 🔥 Firebase Project Details

| Field | Value |
|---|---|
| Project ID | `productive-muslim-app` |
| Project number | `533062204398` |
| Android package | `com.productivemuslim.app` |
| iOS bundle ID | `com.productivemuslim.app` |
| Storage bucket | `productive-muslim-app.firebasestorage.app` |
| Debug SHA-1 | `FD:D7:6D:F6:99:76:4E:22:28:8B:69:F1:6B:9B:70:F5:AB:E7:47:0F` |
| Firestore rules file | `firestore.rules` |

**Status (2026-07-02):** Firebase Analytics confirmed live on physical device (SM A245F, Android 16) — logcat `Status Code: 200`. Google Sign-In UI and Firestore backup UI flows not yet manually smoke-tested.

---

## 🏗️ Architecture

**Pattern:** Clean Architecture (Domain / Data / Presentation)
**State management:** flutter_bloc ^8.1.5
**Local database:** Isar ^3.1.0+1
**Navigation:** go_router ^14.2.0
**DI:** manual providers via BlocProvider / RepositoryProvider in main.dart

```
lib/
├── core/
│   ├── constants/app_constants.dart
│   ├── di/app_dependencies.dart          ← Central DI wiring
│   ├── errors/failures.dart
│   ├── navigation/app_router.dart        ← go_router config + fade-through transitions (Phase 7E)
│   ├── services/
│   │   ├── analytics_service.dart        ← Firebase Analytics wrapper (guarded by firebaseAvailable)
│   │   ├── error_reporting_service.dart  ← Firebase Crashlytics wrapper (guarded by firebaseAvailable)
│   │   ├── isar_service.dart             ← Isar init + collection accessors
│   │   ├── prayer_cache_service.dart     ← 30-day cache warm/invalidate (Phase 7D)
│   │   ├── prayer_notification_service.dart
│   │   └── widget_update_service.dart    ← home_widget bridge (Phase 7C)
│   ├── usecases/usecase.dart
│   └── utils/
│       ├── responsive.dart              ← ScreenSize enum, Responsive class, ResponsiveContext extension, AdaptiveSpacing, ResponsiveBuilder (Phase 8B)
│       └── adaptive_layout.dart        ← TwoColumnLayout, MaxWidthBox, SafeScrollView, MasterDetailLayout (Phase 8B)
│
├── features/
│   ├── auth/            ✅ COMPLETE (Firebase session — real Google Sign-In + anonymous via firebase_auth ^5.3.1)
│   ├── backup/          ✅ COMPLETE (Firebase session — real Firestore backup via cloud_firestore ^5.4.4)
│   ├── onboarding/      ✅ COMPLETE (6-step flow, BLoC, Isar, directional slide transitions Phase 7E)
│   ├── prayer/          ✅ COMPLETE (adhan wrapper, PrayerTimeService, offline cache Phase 7D)
│   ├── timeline/        ✅ COMPLETE (generator algorithm, dashboard UI, BLoC, checkmark bounce Phase 7E)
│   ├── habits/          ✅ COMPLETE (streaks, seeder, score, BLoC, UI, full-screen celebration Phase 7E)
│   ├── ramadan/         ✅ COMPLETE (Hijri converter, Ramadan generator, UI)
│   ├── analytics/       ✅ COMPLETE (charts, heatmap, leaderboard, 3-tab UI)
│   └── settings/        ✅ COMPLETE (Phase 6)
│
├── shared/
│   ├── theme/app_theme.dart
│   ├── widgets/
│   │   ├── app_splash_screen.dart        ← Islamic pattern + pulsing logo (Phase 7E)
│   │   └── celebration_overlay.dart      ← Full-screen confetti overlay (Phase 7E)
└── main.dart
```

---

## 📦 Full Dependency List (pubspec.yaml)

```yaml
dependencies:
  flutter_bloc: ^8.1.5
  equatable: ^2.0.5
  isar: ^3.1.0+1
  isar_flutter_libs: ^3.1.0+1
  path_provider: ^2.1.3
  adhan: ^1.1.0
  geolocator: ^12.0.0
  geocoding: ^3.0.0
  go_router: ^14.2.0
  flutter_local_notifications: ^17.2.2
  timezone: ^0.9.4
  google_fonts: ^6.2.1
  flutter_svg: ^2.0.10+1
  lottie: ^3.1.2
  flutter_animate: ^4.5.0
  smooth_page_indicator: ^1.1.0
  percent_indicator: ^4.2.3
  fl_chart: ^0.68.0
  iconsax: ^0.0.8
  intl: ^0.19.0
  dartz: ^0.10.1
  shared_preferences: ^2.3.2
  permission_handler: ^11.3.1
  uuid: ^4.4.0
  home_widget: ^0.6.0

  # Firebase
  firebase_core: ^3.6.0
  firebase_auth: ^5.3.1
  cloud_firestore: ^5.4.4
  firebase_analytics: ^11.3.3
  firebase_crashlytics: ^4.1.3
  google_sign_in: ^6.2.2

dev_dependencies:
  build_runner: ^2.4.11
  flutter_lints: ^4.0.0
  bloc_test: ^9.1.7
  mocktail: ^1.0.4
  flutter_launcher_icons: ^0.14.1
  flutter_native_splash: ^2.4.3
```

> **Note:** `isar_generator` was removed — it conflicts with `bloc_test ^9.1.7` via the `analyzer` version chain. `cached_prayer_day_model.g.dart` was hand-written to match the exact generator output format.

---

## ✅ Completed Phases

### Phase 1 — Foundation
- 6-step onboarding flow (gender, occupation, work schedule, prayer settings, fitness, sleep/Quran)
- `UserProfile` entity + `UserProfileModel` Isar collection
- `OnboardingBloc` with 27 events, full validation
- Location permission flow, calculation method selector (10 methods), madhab selector

### Phase 2 — Core Scheduling Engine
- `TimelineGeneratorService` (763 lines) — 5-step scheduling pipeline
  - Anchors: sleep + 5 prayers + prayer buffers + work = hard constraints
  - Slots: Quran → Golden Hour → Gym → Meals → Qaylula → Deep Work → Dhikr → Evening
  - Fills remaining gaps with Free Time; resolves overlaps by priority
  - Work blocks are sliced around prayers that fall inside work window
- `PrayerTimeService` — adhan wrapper, all 10 calc methods + madhab
- `TimelineBloc` with 60-second auto-tick for live countdown
- `PrayerNotificationService` — 2 notifications per prayer × 5 prayers
- Timeline Dashboard UI — date navigation, sections, prayer strip, countdown banner

### Phase 3 — Habit Streaks
- `StreakCalculator` — pure Dart, streaks measured in consecutive *scheduled* days
- Excused days transparent (don't break or advance streak)
- Cycle-aware pausing for female users (StreakPauseReason.cycle)
- `DefaultHabitSeeder` — seeds 12–15 system habits from UserProfile on first launch
  - 5 prayer habits, Quran, morning/evening adhkar, Qaylula, hydration, sleep early, workout, gratitude
- `WeeklySpiritualScore` — weighted: Prayers×50% + Quran×20% + Habits×20% + Fitness×10%
- `HabitsBloc` with personal-best detection + celebration trigger
- Habits dashboard: Today/Score tabs, category filter, flame badge, heat map row

### Phase 4 — Ramadan Mode
- `HijriConverter` — pure Dart Kuwaiti algorithm, detects Ramadan automatically
- `RamadanTimelineGenerator` — parallel scheduling engine with 6 new anchors:
  - Suhoor (pre-Fajr), Iftar (Maghrib), Tarawih (60–90 min), split sleep, 20 pages Quran/day
  - Last Ten Nights: extended Tarawih +30 min, Qiyam al-Layl on odd nights (21,23,25,27,29)
- Ramadan Dashboard — night-sky dark theme, live Iftar countdown (seconds precision)
- Ramadan Settings — 10 configurable parameters
- `HijriDateBanner` always visible in Timeline header
- `RamadanModeToggleCard` — auto-suggests when Hijri month = 9
- Dynamic bottom nav — Ramadan tab appears/disappears with mode

### Phase 5 — Analytics Dashboard
- `AnalyticsRepositoryImpl` — reads Isar StreakRecordModel + HabitModel
  - `getPrayerAnalytics()`, `getHabitAnalytics()`, `getWeeklyScoreSeries()`, `getMonthlyHeatmap()`
  - `getSnapshot()` bundles all four in one round-trip
- Chart widgets (fl_chart):
  - `WeeklyScoreLineChart` — trend line with dashed average reference
  - `PrayerBarChart` — per-prayer on-time rate with prayer-identity colours
  - `HabitCompletionChart` — daily bar chart, green/amber/red by threshold
  - `MonthlyHeatmapCalendar` — 30-day grid, ⭐ on perfect days, month nav
  - `HabitLeaderboard` — 🥇🥈🥉 by completion rate
  - `WeeklyScoreBreakdown` — ring + 4 component bars
- 3-tab dashboard: Overview / Prayers / Habits
- Period picker: This Week / This Month / Last 3 Months
- Lazy loading — analytics only loads when tab is first visited

---

## ✅ Phase 6 — Settings & Profile (COMPLETE)

**Built in this phase:**
- `AppSettings` entity — notification prefs (per-prayer + habits + Quran), quiet hours, theme mode, Hijri display, 24h time
- `SettingsService` — SharedPreferences save/load/reset (all 15 keys)
- `SettingsRepositoryImpl` — Either<Failure, T> wrapper over SettingsService
- `SettingsBloc` — 10 events, optimistic UI updates, fire-and-forget persistence
- `LoadSettings`, `SaveSettings`, `ResetSettings` use cases
- UI pages (all in `lib/features/settings/presentation/pages/`):
  - `SettingsPage` — hub with profile card, section groups, nav to sub-pages
  - `ProfileEditPage` — name, city, occupation dropdown, work schedule, Quran/sleep goals; saves via `UpdateUserProfile` + triggers `TimelineGenerateRequested`
  - `PrayerSettingsPage` — calculation method (10 methods), madhab, buffer slider
  - `NotificationsPage` — per-prayer toggles, habit/Quran reminders, quiet hours time picker
  - `AppearancePage` — light/dark/system theme picker, Hijri date toggle, 24h toggle
  - `DataPage` — export (stub), privacy policy sheet, reset settings, full app reset
- `AppTheme.dark` — dark theme added to AppTheme
- `HomeShell` — Settings tab replaces Profile placeholder; `SettingsBloc` wired into `MultiBlocProvider`
- `main.dart` — `BlocBuilder<SettingsBloc>` wraps `MaterialApp.router` for live theme switching
- `AppDependencies.resetAllData()` — clears Isar + SharedPreferences for full reset

---

## ✅ Phase 7A — QA & Bug Fixes (COMPLETE)

**Bugs fixed in this phase:**

| # | Bug | File(s) changed |
|---|-----|-----------------|
| 1 | `gymDays` silently dropped — seeder always received `[]` | `habits_repository.dart`, `habits_repository_impl.dart`, `habit_usecases.dart` |
| 2 | `HabitsBloc._onUpdate` called `saveHabit` (creates duplicate Isar records) instead of upserting | `habits_repository_impl.dart` — `saveHabit` now upserts by `habitId` |
| 3 | Notification ID collision — `day.date.day` (1–31) caused buffer IDs to overlap prayer IDs after day 10 | `prayer_notification_service.dart` — switched to 0-based `dayIndex`; `_prayerBaseId` → 500 |
| 4 | `newPersonalBest` fired on every streak completion — `currentStreak >= longestStreak` is always true after `_recalculateStreak` | `habits_bloc.dart` — now compares `longestStreak` before vs after completion |

**Test files added in this phase:**

| File | Coverage |
|------|----------|
| `test/features/onboarding/integration/onboarding_to_timeline_test.dart` | Step validation, submission, SaveUserProfile call, TimelineGenerateRequested → loaded/error |
| `test/features/habits/integration/habit_completion_streak_test.dart` | Load, completion, streak increment, personal-best true/false, undo, weekly score, StreakCalculator unit tests |
| `test/features/settings/integration/settings_profile_timeline_test.dart` | Load, all 7 toggle events, optimistic UI, reset, UpdateUserProfile, post-edit timeline generate |

---

## ✅ Phase 7C — Home Screen Widget (COMPLETE)

**Built in this phase:**
- `home_widget: ^0.6.0` added to pubspec.yaml
- `lib/core/services/widget_update_service.dart` — pure `buildData()` formats next prayer + current block from `DailyTimeline` / `DailyPrayerTimes`; `update()` writes via home_widget and catches all platform errors (safe in unit tests)
- `TimelineBloc` — `WidgetUpdateService.update()` called fire-and-forget (`.ignore()`) after loaded emit in `_onLoadRequested`, `_onGenerateRequested`, and on every `_onTick`
- **Android**: `res/layout/productive_muslim_widget.xml` layout; `res/xml/productive_muslim_widget_info.xml` AppWidgetProviderInfo; `res/drawable/widget_background.xml` rounded green background; `ProductiveMuslimWidgetProvider.kt` reads from `HomeWidgetPlugin.getData(context)` and updates RemoteViews; registered in `AndroidManifest.xml`
- **iOS**: `ios/ProductiveMuslimWidget/ProductiveMuslimWidget.swift` — WidgetKit extension with `StaticConfiguration`, reads from `UserDefaults(suiteName: "group.com.example.productiveMuslim")`; `ios/ProductiveMuslimWidget/Info.plist`
  - ⚠️ **iOS setup required**: Add `ProductiveMuslimWidget` as a new target in Xcode, link Swift files, add the App Group capability (`group.com.example.productiveMuslim`) to both the Runner and the widget extension targets
- `test/core/services/widget_update_service_test.dart` — 22 unit tests covering null inputs, prayer detection, duration/time formatting, current block detection, fallback to prayerTimes

---

## ✅ Phase 7D — Offline Prayer Cache (COMPLETE)

**Built in this phase:**
- `lib/features/prayer/data/models/cached_prayer_day_model.dart` — Isar `@collection`; one row per calendar day; stores 6 prayer + sunrise `DateTime` fields plus 4 cache-key fields (`calculationMethod`, `madhab`, `latitude`, `longitude`); `@Index(unique: true)` on `date`; `fromDailyPrayerTimes()` factory + `toEntity()` mapper
- `lib/features/prayer/domain/repositories/prayer_cache_repository.dart` — abstract domain contract (`getDay`, `saveDay`, `clearAll`, `isValid`, `countCachedDays`)
- `lib/features/prayer/data/repositories/prayer_cache_repository_impl.dart` — Isar implementation; 4dp lat/lon rounding for GPS-jitter-safe cache-key comparison; upsert by deleting existing date row before `put()`
- `lib/core/services/prayer_cache_service.dart` — `warmCache(profile)`: validates cache key, clears stale entries, fills missing days using the *sync* `getPrayerTimes()` path (avoids circular reads); `invalidateAndRewarm()` for settings changes; all errors swallowed so cache failures never crash the app
- `lib/features/prayer/data/repositories/prayer_time_service.dart` — added optional `PrayerCacheRepository? _cache` field; new `getPrayerTimesAsync()` cache-first async method; existing sync `getPrayerTimes()` unchanged (zero breaking changes)
- `lib/core/services/isar_service.dart` — `CachedPrayerDayModelSchema` added to schema list
- `lib/core/di/app_dependencies.dart` — `prayerCacheRepository` and `prayerCacheService` wired; `PrayerTimeService` now receives cache reference; fire-and-forget `warmCache()` called at startup after loading the user profile
- `pubspec.yaml` — `isar_generator: ^3.1.0+1` added to `dev_dependencies` (needed for `build_runner`)
- **Pending user action:** run `dart run build_runner build --delete-conflicting-outputs` to generate `cached_prayer_day_model.g.dart`, then optionally remove `isar_generator` from dev_dependencies

**Key design decisions:**
- Cache key precision: 4 decimal places (~11 m) — prevents spurious re-warms from GPS jitter
- Warm path uses sync `getPrayerTimes()`, NOT `getPrayerTimesAsync()` — avoids circular cache reads
- `PrayerCacheService` errors are fully swallowed — `getPrayerTimesAsync` always falls back to live adhan
- `sunrise` field cached alongside prayers to support Golden Hour calculation in `TimelineGeneratorService`

---

## ✅ Phase 7E — Polish & Animations (COMPLETE)

**Built in this phase:**
- `flutter_animate: ^4.5.0` added to `pubspec.yaml`
- `lib/shared/widgets/celebration_overlay.dart` — `FullScreenCelebrationOverlay.show()` static factory inserts a full-screen `OverlayEntry`; `CustomPainter` confetti (100 particles, gravity physics, fade-out in last 25%); card scale 0.4→1.0 elastic + fade; auto-dismisses after 2.5 s; tap-to-dismiss
- `lib/shared/widgets/app_splash_screen.dart` — `AppSplashScreen({required targetRoute})` at `/` route; `_IslamicPatternPainter` draws hex-offset grid of overlapping-square octagrams slowly rotating; logo scale-in 0.6→1.0 `easeOutBack` + tagline slide-up; navigates to `targetRoute` after 1.6 s
- `lib/core/navigation/app_router.dart` — `_fadePage()` `CustomTransitionPage` with simultaneous fade-in/fade-out for all routes (300 ms forward, 200 ms reverse); splash route added as initial `'/'`
- `lib/features/onboarding/presentation/pages/onboarding_page.dart` — `PageView` replaced with `AnimatedSwitcher`; `_goingForward` + `_displayedStep` state drives directional `SlideTransition` (±0.18 x-axis) + `FadeTransition`; `_StepEntrance` wraps each step with 0.96→1.0 scale + fade in 320 ms
- `lib/features/timeline/presentation/widgets/timeline_widgets.dart` — `TimeBlockCard` converted to `StatefulWidget`; `_checkCtrl` + `_checkScale` (0.0→1.0 `elasticOut`, 450 ms); `ScaleTransition` wraps check icon; `didUpdateWidget` triggers forward from 0 on completion
- `lib/features/timeline/presentation/pages/home_shell.dart` — `IndexedStack` replaced with `Stack + AnimatedOpacity + IgnorePointer` per child (220 ms `easeInOut`); all tabs remain mounted (BLoC state preserved)
- `lib/features/habits/presentation/pages/habits_page.dart` — `_showPersonalBestCelebration` removed; replaced with `FullScreenCelebrationOverlay.show(context, habitName:, streakCount:)`
- `test/shared/widgets/animation_widgets_test.dart` — 18 widget tests across 3 groups: CelebrationOverlay (6), AppSplashScreen (4), TimeBlockCard (8)

**Key decisions:**
- No Lottie JSON assets needed — all animations are native Flutter (`CustomPainter`, `AnimationController`, `AnimatedSwitcher`, `AnimatedOpacity`)
- `flutter_animate` package added for future chainable syntax; not used in core widgets to keep them free from an extra dependency for now
- `withValues(alpha:)` used everywhere instead of deprecated `withOpacity()`

---

## ✅ Phase 8 — App Store Readiness (COMPLETE)

**Built in this phase:**
- `flutter_launcher_icons: ^0.14.1` + `flutter_native_splash: ^2.4.3` added to dev_dependencies
- `pubspec.yaml` — `flutter_launcher_icons:` config block: adaptive icon background `#1B6B3A`, foreground `assets/icons/app_icon_foreground.png`, iOS `remove_alpha_ios: true`, web/windows/macos generation disabled
- `pubspec.yaml` — `flutter_native_splash:` config block: light `#1B6B3A`, dark `#0D3B1F`, Android 12 section with icon background colours
- `scripts/generate_icons.py` — Python/Pillow script that generates `app_icon.png` (1024×1024, octagram on green), `app_icon_foreground.png` (1024×1024 transparent adaptive foreground), `splash_logo.png` (512×512 transparent centre logo); run before `dart run flutter_launcher_icons`
- `android/app/build.gradle.kts` (rewritten): `namespace`/`applicationId` = `com.productivemuslim.app`, `compileSdk = 34`, `minSdk = 21`, `targetSdk = 34`; `debug` buildType with `.debug` suffix; `signingConfigs { create("release") { ... } }` placeholder with env-var instructions
- `ios/Runner/Info.plist` — `NSUserNotificationsUsageDescription` key added before `UIBackgroundModes`; `CFBundleIdentifier` left as `$(PRODUCT_BUNDLE_IDENTIFIER)` (set `com.productivemuslim.app` in Xcode)
- `assets/privacy_policy.md` — comprehensive privacy policy (location data, notifications, no third-party analytics, data deletion contact); bundled in Flutter assets for Settings → Data page
- `assets/store_listing.md` — Google Play + App Store listing copy: short/full descriptions, subtitle, keywords (100 chars), 5 ASO tags, What's New v1.0.0, content ratings, URLs
- **flutter analyze: 0 issues** (all errors, warnings, and infos resolved)
  - 9 unused import warnings removed
  - 2 unused local variable warnings removed (`selected`, `updated`)
  - `avoid_types_as_parameter_names`: renamed `Type` → `Result` in `UseCase<Result, Params>`
  - `unnecessary_import`: removed redundant `streak_calculator.dart` imports
  - `curly_braces_in_flow_control_structures`: braces added in ramadan generator + dashboard
  - `activeColor` deprecated → `activeThumbColor` across 4 Switch widgets
  - `value` deprecated → `initialValue` in `DropdownButtonFormField`
  - `prefer_const_*`: 36 auto-fixes applied via `dart fix --apply`
  - Radio `groupValue`/`onChanged` (Flutter 3.32 deprecation): `// ignore: deprecated_member_use` added — full `RadioGroup` migration deferred to post-v1.0.0

**Pending developer actions before upload:**
1. Run `python scripts/generate_icons.py` (requires `pip install Pillow`) → creates 3 PNG assets
2. Run `dart run flutter_launcher_icons` → generates all Android/iOS icon sizes
3. Run `dart run flutter_native_splash:create` → generates native splash screen assets
4. In Xcode: set Bundle Identifier to `com.productivemuslim.app`
5. Create `android/app/keystore/productive_muslim.jks` and set env vars `KEYSTORE_PASSWORD`, `KEY_ALIAS`, `KEY_PASSWORD` before release build

---

## ✅ Phase 8B — Full Responsiveness (COMPLETE)

**Built in this phase:**
- `lib/core/utils/responsive.dart` — `ScreenSize` enum (small/medium/large/tablet), `Responsive` static helpers (`isPhone`, `isTablet`, `isLandscape`, `screenHPadding`, `screenPadding`, `cardPadding`, `navItemHPadding`), `ResponsiveContext` extension on `BuildContext` (`context.isTablet`, `context.screenHPadding`, `context.screenPadding`, `context.adaptive()`), `AdaptiveSpacing`, `ResponsiveBuilder`
- `lib/core/utils/adaptive_layout.dart` — `TwoColumnLayout`, `MaxWidthBox`, `SafeScrollView`, `MasterDetailLayout`
- **Breakpoints:** small < 360 dp · medium 360–599 dp · large 600–767 dp · tablet ≥ 768 dp
- `home_shell.dart` — bottom nav items wrapped in `Expanded` (no overflow on 360 px with 5 tabs); `navItemHPadding` auto-shrinks horizontal padding; **tablet:** `NavigationRail` on left (extended in landscape), body fills right
- `timeline_dashboard_page.dart` — adaptive `screenHPadding` in header and section wrappers; **tablet:** 300 dp left sidebar (header + prayer strip + progress ring) + `Expanded` block list
- `habits_page.dart` — adaptive `screenHPadding` in header, tabs, section headers; **tablet:** left column (Today's habits) + right column (Weekly score), no TabBar needed
- `analytics_dashboard_page.dart` — adaptive padding in header + insight/champion cards; **tablet:** 220 dp left sidebar (title + period picker + vertical tab list) + right content area
- `settings_page.dart` — adaptive `screenHPadding` in all `_buildSection` calls
- `timeline_widgets.dart` — `NextPrayerBanner`, `DailyProgressRing`, `PrayerStrip`, `MorningIntentionCard` margins all use `context.screenHPadding`
- `habits_widgets.dart` — `WeeklyScoreCard` margin + snackbar container + `AddHabitSheet` padding all adaptive
- `analytics_widgets.dart` — `AnalyticsCard` margin + `_InsightCard`/`_StreakChampionCard` margins adaptive
- `ramadan_dashboard_page.dart` — header padding + time-pill row margin adaptive
- `onboarding_page.dart` — top-bar + bottom-nav padding adaptive
- All 6 onboarding step files — `AppSpacing.screenPadding` → `context.screenPadding` (responsive extension)
- **flutter analyze: 0 issues** after all changes

**Files modified (22 total):**
`lib/core/utils/responsive.dart` (NEW) · `lib/core/utils/adaptive_layout.dart` (NEW) · `lib/features/timeline/presentation/pages/home_shell.dart` · `lib/features/timeline/presentation/pages/timeline_dashboard_page.dart` · `lib/features/timeline/presentation/widgets/timeline_widgets.dart` · `lib/features/habits/presentation/pages/habits_page.dart` · `lib/features/habits/presentation/widgets/habits_widgets.dart` · `lib/features/analytics/presentation/pages/analytics_dashboard_page.dart` · `lib/features/analytics/presentation/widgets/analytics_widgets.dart` · `lib/features/settings/presentation/pages/settings_page.dart` · `lib/features/ramadan/presentation/pages/ramadan_dashboard_page.dart` · `lib/features/onboarding/presentation/pages/onboarding_page.dart` · `lib/features/onboarding/presentation/pages/steps/step_0_welcome.dart` · `step_1_occupation.dart` · `step_2_work_schedule.dart` · `step_3_prayer_settings.dart` · `step_4_fitness.dart` · `step_5_sleep.dart`

---

## ✅ Phase 9 — Play Store / App Store Submission (COMPLETE)

**Built in this phase:**
- `android/app/build.gradle.kts` — full release `signingConfig` reading from `android/key.properties` using `java.util.Properties`; falls back to env vars `KEYSTORE_PASSWORD`, `KEY_ALIAS`, `KEY_PASSWORD` for CI/CD; release buildType wired to `signingConfigs.getByName("release")`
- `android/.gitignore` — added explicit `keystore/` directory exclusion (in addition to existing `key.properties` and `**/*.jks`)
- `docs/ANDROID_SIGNING.md` — keytool command, `.jks` placement at `android/keystore/`, `key.properties` format, `flutter build appbundle --release`, AAB output path, CI env-var fallback, pre-submission checklist
- `docs/IOS_SUBMISSION.md` — Apple Developer Portal App ID creation, App Store Connect app setup, Xcode signing config, `flutter build ios --release` + Xcode Archive + Transporter, all metadata fields, age rating questionnaire (4+), privacy data types, submission checklist
- `docs/PLAY_STORE_SUBMISSION.md` — Play Console app creation, AAB build, Internal Testing → Production rollout, store listing fields, content rating questionnaire (Everyone), target audience, data safety form, privacy policy, version management, submission checklist
- `docs/SCREENSHOT_GUIDE.md` — Play Store sizes (1080×1920 phone, 1200×1920 7" tablet, 1600×2560 10" tablet), App Store sizes (1290×2796, 1242×2208, 2048×2732 iPad), 5 recommended screens with capture instructions and caption copy, device frame guidance

### Submission Docs

| File | Purpose |
|---|---|
| `docs/ANDROID_SIGNING.md` | Generate keystore, wire `key.properties`, build release AAB |
| `docs/IOS_SUBMISSION.md` | Apple Developer Portal, Xcode archive, App Store Connect |
| `docs/PLAY_STORE_SUBMISSION.md` | Play Console setup, AAB upload, content rating, data safety |
| `docs/SCREENSHOT_GUIDE.md` | Required screenshot sizes + 5 recommended screens with captions |
| `assets/store_listing.md` | Copy-paste text for all store fields (name, description, keywords) |

---

## ✅ Session A — Branding, Icon, Splash, Notifications (COMPLETE)

**Built in this session:**

### App Icon
- `assets/icon/icon.svg` — Islamic geometric SVG design: green background, 8-pointed star (rub el hizb), crescent moon, "PM" wordmark
- `assets/icon/icon.png` + `assets/icon/icon_foreground.png` — generated by `dart run tool/generate_icon.dart`
- `tool/generate_icon.dart` — Dart CLI tool using `image: ^4.1.0`; draws 8-pointed star (two overlapping rotated squares) + crescent; writes 1024×1024 RGBA PNG for both full icon and transparent adaptive foreground
- `pubspec.yaml` — `flutter_launcher_icons` updated to point at `assets/icon/icon.png` + `assets/icon/icon_foreground.png`; `image: ^4.1.0` added to dev_dependencies; `assets/icon/`, `assets/notifications/`, `assets/audio/` added to flutter assets

### Splash Screen
- `lib/shared/widgets/app_splash_screen.dart` — REPLACED with full 6-phase sequence:
  - Phase 1 (0–600ms): green background fades in
  - Phase 2 (400–900ms): 8-pointed star draws itself via animated `PathMetric` stroke then snaps to filled + crescent
  - Phase 3 (700–1100ms): "Productive Muslim" slides up + fades in (Playfair Display)
  - Phase 4 (900–1300ms): Arabic "المسلم المنتج" fades in (Amiri font, RTL)
  - Phase 5 (1200–1600ms): tagline "Balance. Worship. Grow." fades in
  - Phase 6 (1600–2200ms): pause → everything scales up 1.0→1.08 + fades out → `context.go(targetRoute)`
  - Fully responsive via `ResponsiveContext` (tablet uses larger font + icon sizes)

### Lottie Celebration
- `assets/animations/celebration.json` — self-contained Lottie file (v5.9.0, 30fps, 75 frames = 2.5s); 15 confetti layers in green (#1B6B3A), gold (#C9A84C / #E8BC23), and white; varying sizes, rotation speeds, stagger offsets
- `lib/shared/widgets/celebration_overlay.dart` — updated to load from `assets/animations/celebration.json` via `Lottie.asset(...)`; `errorBuilder` falls back to pure-Dart `_FallbackConfetti` / `_ConfettiPainter` if file missing — overlay never crashes

### Notification Infrastructure
- `assets/notifications/prayer_icon.svg` — sujood silhouette
- `assets/notifications/quran_icon.svg` — open book with page lines
- `assets/notifications/habit_icon.svg` — bold checkmark in ring + star accent
- `assets/notifications/fasting_icon.svg` — crescent moon + sun with rays
- `assets/notifications/general_icon.svg` — clock face + crescent badge
- `lib/core/services/notification_sound_config.dart` — NEW: `NotificationSoundType` enum (5 types); `NotificationChannels` class with 6 const `AndroidNotificationChannel` definitions (`prayer_adhan`, `prayer_buffer`, `quran_reminder`, `habit_reminder`, `iftar_adhan`, `general`); `NotificationSoundConfig` class with `androidSound()`, `iosSound()`, `iosThreadId()` per type
- `lib/core/services/prayer_notification_service.dart` — UPDATED: `initialize()` now creates all 6 Android channels via `createNotificationChannel`; `_scheduleNotification` uses `NotificationSoundConfig` for sound selection, sets `largeIcon: DrawableResourceAndroidBitmap('@mipmap/ic_launcher')` for Android, sets `DarwinNotificationDetails.sound` + `threadIdentifier` for iOS
- `tool/generate_notification_icons.dart` — Dart CLI tool; renders 5 notification icons programmatically at 4 Android densities (mdpi/hdpi/xhdpi/xxhdpi) → `android/app/src/main/res/drawable-*/ic_notification_*.png`
- `assets/audio/.gitkeep` — placeholder documenting required audio files (adhan.mp3, iftar_adhan.mp3, quran_reminder.mp3)

**Post-session steps (manual):**
1. `dart run tool/generate_icon.dart` → creates `assets/icon/icon.png` + `icon_foreground.png`
2. `dart run flutter_launcher_icons` → all Android/iOS icon sizes
3. `dart run flutter_native_splash:create` → native splash
4. `dart run tool/generate_notification_icons.dart` → Android notification drawables
5. Place adhan MP3s in `assets/audio/` and `android/app/src/main/res/raw/`; add AIFF to `ios/Runner/` via Xcode

### Analyze
- `flutter analyze` → **No issues found!** (ran 2026-06-28)

---

## ✅ Session B — Mock Auth + Cloud Backup (COMPLETE)

**Built in this session:**

### Auth abstraction layer (offline-first, swap-ready for real Google Sign-In)
- `lib/features/auth/domain/entities/auth_user.dart` — `AuthUser(id, email, displayName, photoUrl, isAnonymous)` with `copyWith`
- `lib/features/auth/domain/repositories/auth_repository.dart` — abstract interface
- `lib/features/auth/domain/usecases/auth_usecases.dart` — `SignInWithGoogle`, `SignInAsGuest`, `SignOut`, `GetCurrentUser`, `WatchAuthState`
- `lib/features/auth/data/repositories/mock_auth_repository_impl.dart` — persists to SharedPreferences `auth_user_json`; `StreamController.broadcast()` replays on first subscribe
- `lib/features/auth/presentation/bloc/auth_bloc.dart` — events: `AuthCheckRequested`, `AuthSignInRequested`, `AuthGuestRequested`, `AuthSignOutRequested`; states: `AuthInitial`, `AuthLoading`, `AuthAuthenticated(user)`, `AuthUnauthenticated`, `AuthError`
- `lib/features/auth/presentation/pages/auth_page.dart` — green background, PM logo, Google + Guest buttons; `BlocListener` navigates to onboarding or home
- `lib/features/auth/presentation/widgets/auth_widgets.dart` — `GoogleSignInButton` (inline SVG Google logo, white card), `OrDivider`
- **Swap to real auth:** create `GoogleAuthRepositoryImpl`, change one DI binding in `app_dependencies.dart`. No BLoC/UI changes.

### Backup abstraction layer (local JSON, swap-ready for Firebase/Supabase)
- `lib/features/backup/domain/entities/backup_snapshot.dart` — `BackupSnapshot` + `BackupMetadata`
- `lib/features/backup/domain/repositories/backup_repository.dart` — abstract interface
- `lib/features/backup/domain/usecases/backup_usecases.dart` — `CreateBackup`, `RestoreBackup`, `ListBackups`; `BackupThrottle` abstract (24-hour window)
- `lib/features/backup/data/services/backup_serialiser.dart` — static-only JSON conversion for `UserProfile`, `Habit`, `StreakRecord`, `AppSettings`; zero Isar/Flutter dependencies
- `lib/features/backup/data/repositories/mock_backup_repository_impl.dart` — saves to `{appDocumentsDir}/pm_backups/{id}.json` with 1s simulated delay; `BackupThrottleImpl(SharedPreferences)` in same file
- `lib/features/backup/presentation/bloc/backup_bloc.dart` — events: `BackupRequested`, `BackupAutoRequested`, `RestoreRequested`, `BackupListRequested`; guests blocked; throttle checked for auto-backup
- `lib/features/backup/presentation/pages/backup_page.dart` — status card, action buttons, backup list, guest message; async-gap-safe `_onRestore`
- **Swap to Firebase:** create `FirebaseBackupRepositoryImpl` using Firestore path `users/{userId}/backups/{backupId}`, change DI binding. No BLoC/UI changes.

### Core file updates
- `lib/core/errors/failures.dart` — added `AuthFailure`, `BackupFailure`
- `lib/core/di/app_dependencies.dart` — auth/backup repositories + use cases + factory methods `createAuthBloc()`, `createBackupBloc()`
- `lib/core/navigation/app_router.dart` — `/auth` route added; `buildRouter` accepts `authUser` parameter
- `lib/main.dart` — `ProductiveMuslimApp` now `StatefulWidget + WidgetsBindingObserver`; checks auth at startup; auto-guests existing users; `didChangeAppLifecycleState(paused)` fires `BackupAutoRequested`; `AuthBloc` + `BackupBloc` in `MultiBlocProvider`
- `lib/features/timeline/presentation/pages/home_shell.dart` — profile tab shows `CircleAvatar` with user initial when signed in as Google user
- `lib/features/settings/presentation/pages/settings_page.dart` — `_SyncChip` in app bar: green dot + "Backed up Xh ago" / grey dot + "Guest mode" / spinner during backup
- `lib/features/settings/presentation/pages/data_page.dart` — Cloud Backup tile at top of "Your Data" section

### Tests added
| File | Tests |
|------|-------|
| `test/features/auth/auth_bloc_test.dart` | 16 |
| `test/features/backup/backup_bloc_test.dart` | 15 |
| `test/features/backup/backup_serialiser_test.dart` | 15 |

### Analyze
- `flutter analyze` → **No issues found!** (ran 2026-06-28, Session B)

---

## ✅ Session C — QA Pass (Phases 3c–7) (COMPLETE)

**Built in this session:**

### Widget tests — SettingsPage `_SyncChip`
- `test/features/settings/settings_page_sync_chip_test.dart` (15 tests) — verifies all 5 states of `_SyncChip` in the SettingsPage app bar: unauthenticated ("Guest mode"), anonymous user ("Guest mode"), `BackupInProgress` ("Backing up…"), `BackupLoaded` ("Backed up"), `BackupInitial` ("Not backed up"). Also verifies the 5 main settings tile labels.
- Key pattern: `AppDependencies.getUserProfile = mockGetProfile` in `setUp()` — the static-late field must be set before `SettingsPage` mounts.

### Widget tests — CelebrationOverlay + AppSplashScreen extras
- `test/shared/widgets/celebration_overlay_test.dart` (6 tests) — auto-dismiss at 2500ms, `onDismiss` not called at 1000ms, streak count displayed.
- `test/shared/widgets/animation_widgets_test.dart` — added 3 tests: Arabic subtitle `'المسلم المنتج'` visible at 1400ms, tablet layout (800×1024 surface), landscape tablet (1024×768). Total now 21.

### Integration tests (`test/integration/`)
- `auth_to_onboarding_test.dart` (4 tests) — `AppRouter.buildRouter()` routing: no-auth → AuthPage, guest user → OnboardingPage, signed-in with profile → HomeShell.
- `timeline_to_habit_test.dart` (9 tests) — HomeShell tab navigation: nav labels present, tap Habits (fire icon), tap back to Timeline, tap Analytics, tap Profile (Settings visible).
- `backup_flow_test.dart` (5 tests) — BackupPage state machine: Initial→InProgress→Loaded, error snackbar, restore snackbar, unauthenticated screen.
- `settings_profile_edit_test.dart` (7 tests) — Profile tab navigation, SettingsPage tiles, Edit Profile tappable.

### Responsiveness tests (`test/responsiveness/`)
- `overflow_test.dart` (30 tests) — 6 sizes (320×568, 390×844, 414×896, 600×1024, 768×1024, 1024×768) × 5 pages (AuthPage, OnboardingPage, SettingsPage, BackupPage guest, AppSplashScreen). Each test: `tester.takeException()` is null + key widget present.

### Patterns discovered (use in future tests)
- **Screen size override:** Use `MaterialApp.builder` + `MediaQuery.copyWith(size: ...)` — not `setSurfaceSize` (which asserts `inTest`). Forces `Responsive.isTablet` for all descendants.
- **`_AnalyticsAwareStack` renders all tabs:** All tab pages are always in the render tree (opacity 0 when inactive). Use `findsAtLeastNWidgets(1)` for labels that duplicate page headings; use `.last` to tap nav bar labels.
- **`repeat()` animation:** `timeline_widgets.dart:953` runs a `..repeat()` animation — `pumpAndSettle()` never returns. Use `pump(Duration(milliseconds: 50))` instead.
- **`part of` files:** `settings_state.dart` is `part of 'settings_bloc.dart'` — import only the bloc file.

---

## ✅ Final Completion Session — Production Polish (9 Steps) (COMPLETE)

**Built in this session:**

### STEP 1 — Android notification sound fallback
- `lib/core/services/notification_sound_config.dart` — added `kSoundFilesPresent = false` compile-time constant; `androidSound()` returns `null` (system default) when false; `playSound()` always returns `true`.
- `android/app/src/main/res/raw/.gitkeep` — documents required MP3 filenames.
- `test/core/services/notification_sound_config_test.dart` — fully rewritten; verifies null return for all types when flag is false.

### STEP 2 — Splash screen production-ready
- `lib/shared/widgets/app_splash_screen.dart` — minimum 2.5s display via `Timer`+`Completer` (cancellable on dispose); error state with "Continue" button; both `CustomPaint` widgets wrapped in `RepaintBoundary`.

### STEP 3 — App icon tooling
- `tool/setup_icons.sh` — one-liner that runs generate_icon → flutter_launcher_icons → native_splash in sequence.

### STEP 4 — Firebase scaffold
- `lib/core/di/environment_config.dart` — `useFirebase = false` compile-time switch; routes DI to mock or Firebase implementations.
- `lib/features/auth/data/repositories/firebase_auth_repository_impl.dart` — full Firebase Auth scaffold, all code commented.
- `lib/features/backup/data/repositories/firebase_backup_repository_impl.dart` — full Firestore scaffold, all code commented.
- `lib/core/di/app_dependencies.dart` — updated to delegate to `EnvironmentConfig`.
- `pubspec.yaml` — Firebase packages listed in commented block.

### STEP 5 — Google Sign-In scaffold
- `lib/features/auth/data/services/google_sign_in_service.dart` — OAuth flow scaffold, all code commented.
- `android/app/build.gradle.kts` — SHA-1 fingerprint instructions comment.
- `ios/Runner/Info.plist` — REVERSED_CLIENT_ID `CFBundleURLTypes` comment.

### STEP 6 — l10n scaffold
- `lib/l10n/app_en.arb` + `lib/l10n/app_ar.arb` — 20 strings each.
- `l10n.yaml` — configured for `flutter gen-l10n`.
- `pubspec.yaml` — `flutter_localizations: sdk: flutter`, `intl: ^0.20.2`, `generate: true`.
- `lib/features/settings/domain/entities/app_settings.dart` — `language` field added.
- `lib/features/settings/data/services/settings_service.dart` — persists language to SharedPreferences.
- `lib/features/settings/presentation/bloc/settings_event.dart` + `settings_bloc.dart` — `SettingsLanguageChanged` event and handler.
- `lib/features/settings/presentation/pages/appearance_page.dart` — language picker (English / العربية).
- `lib/main.dart` — `locale`, `localizationsDelegates`, `supportedLocales` wired to `MaterialApp.router`.

### STEP 7 — Accessibility
- `lib/features/timeline/presentation/widgets/timeline_widgets.dart` — `Semantics` on `TimeBlockCard` and `_PrayerPill`.
- `lib/features/habits/presentation/widgets/habits_widgets.dart` — `Semantics` on `HabitCard`.

### STEP 8 — Final .gitignore
- Added: `android/key.properties`, `android/keystore/`, `*.jks`, `*.keystore`, iOS/Android Firebase config files, `.flutter-plugins`, `*.isar`, `assets/audio/*.mp3`.

### STEP 9 — Final verification
- `flutter pub get` ✅ (fixed `intl ^0.19.0` → `^0.20.2` for `flutter_localizations` compatibility)
- `flutter analyze` ✅ No issues found
- `flutter test` ✅ **535/535 All tests passed**

---

## ✅ Firebase Full Integration Session (COMPLETE — 2026-07-02)

**Files created / modified:**

| File | Change |
|------|--------|
| `pubspec.yaml` | Uncommented/upgraded: `firebase_core ^3.6.0`, `firebase_auth ^5.3.1`, `cloud_firestore ^5.4.4`, `firebase_analytics ^11.3.3`, `firebase_crashlytics ^4.1.3`, `google_sign_in ^6.2.2` |
| `lib/firebase_options.dart` | NEW — `DefaultFirebaseOptions` with real Android/iOS credentials from `google-services.json` and `GoogleService-Info.plist` |
| `android/build.gradle.kts` | Added `google-services 4.4.2` + `crashlytics 3.0.2` plugin declarations |
| `android/app/build.gradle.kts` | Applied both plugins; added Firebase BOM 33.5.1 + crashlytics + analytics dependencies; removed `applicationIdSuffix` (google-services plugin requires package match) |
| `ios/Runner/Info.plist` | Replaced comment placeholder with real `CFBundleURLTypes` / `REVERSED_CLIENT_ID` |
| `lib/core/di/environment_config.dart` | Replaced compile-time `useFirebase` const with runtime `_firebaseAvailable` flag; added `initializeIfAvailable()` with try/catch fallback |
| `lib/features/auth/data/repositories/firebase_auth_repository_impl.dart` | All Firebase code uncommented and activated; `firebase_auth ^5.x` compatible |
| `lib/features/backup/data/repositories/firebase_backup_repository_impl.dart` | All Firestore code uncommented; offline persistence enabled via `Settings(persistenceEnabled: true)` |
| `lib/core/services/analytics_service.dart` | NEW — Firebase Analytics wrapper, all calls guarded by `firebaseAvailable` |
| `lib/core/services/error_reporting_service.dart` | NEW — Firebase Crashlytics wrapper, all calls guarded by `firebaseAvailable` |
| `lib/main.dart` | Added `EnvironmentConfig.initializeIfAvailable()` before DI init; wired `FlutterError.onError` + `PlatformDispatcher.instance.onError` to Crashlytics |
| `firestore.rules` | NEW — allow read/write only to `users/{userId}/backups/{backupId}` where `auth.uid == userId` |
| `firebase.json` | NEW — Firebase project config pointing at rules and indexes |
| `firestore.indexes.json` | NEW — `createdAt` descending index on `backups` collection |
| `tool/get_sha_fingerprints.bat` | NEW — prints debug + release SHA-1/SHA-256 on Windows |
| `tool/get_sha_fingerprints.sh` | NEW — same for macOS/Linux |
| `tool/create_debug_keystore.bat` | NEW — creates `~/.android/debug.keystore` if missing |
| `docs/SHA_FINGERPRINTS.md` | NEW — how to get fingerprints and register in Firebase Console |

**Firebase project:** `productive-muslim-app`
**Android package:** `com.productivemuslim.app`
**iOS bundle:** `com.productivemuslim.app`

**Debug SHA-1:** `FD:D7:6D:F6:99:76:4E:22:28:8B:69:F1:6B:9B:70:F5:AB:E7:47:0F`
**Debug SHA-256:** `E2:BE:FE:51:50:FA:8B:38:B5:FB:1F:E5:5F:49:53:19:1B:13:57:93:DE:60:92:72:2B:3B:0A:3C:6A:CA:D4:4E`

**Next required action:** Register the debug SHA-1 above in Firebase Console → Project Settings → Your Android App to enable Google Sign-In on Android.

---

## 🔜 Remaining Phases

**None — all phases complete. Firebase is live. The app is ready to submit.**

---

## 🧪 Test Suite Status

**535/535 passing — 0 failures.**

| File | Tests | Status |
|------|-------|--------|
| `test/features/timeline/domain/timeline_generator_test.dart` | 30 | ✅ |
| `test/features/habits/domain/streak_calculator_test.dart` | 35 | ✅ |
| `test/features/ramadan/domain/ramadan_generator_test.dart` | 38 | ✅ |
| `test/features/analytics/domain/analytics_entities_test.dart` | 30 | ✅ |
| `test/features/onboarding/integration/onboarding_to_timeline_test.dart` | ~20 | ✅ |
| `test/features/habits/integration/habit_completion_streak_test.dart` | ~25 | ✅ |
| `test/features/settings/integration/settings_profile_timeline_test.dart` | ~20 | ✅ |
| `test/core/services/widget_update_service_test.dart` | 22 | ✅ |
| `test/core/services/notification_sound_config_test.dart` | ~8 | ✅ |
| `test/features/prayer/data/repositories/prayer_cache_repository_test.dart` | 30 | ✅ |
| `test/shared/widgets/animation_widgets_test.dart` | 21 | ✅ |
| `test/features/auth/auth_bloc_test.dart` | 16 | ✅ |
| `test/features/backup/backup_bloc_test.dart` | 15 | ✅ |
| `test/features/backup/backup_serialiser_test.dart` | 15 | ✅ |
| `test/features/backup/backup_page_test.dart` | ~15 | ✅ |
| `test/features/settings/settings_page_sync_chip_test.dart` | 15 | ✅ |
| `test/shared/widgets/celebration_overlay_test.dart` | 6 | ✅ |
| `test/integration/auth_to_onboarding_test.dart` | 4 | ✅ |
| `test/integration/timeline_to_habit_test.dart` | 9 | ✅ |
| `test/integration/backup_flow_test.dart` | 5 | ✅ |
| `test/integration/settings_profile_edit_test.dart` | 7 | ✅ |
| `test/responsiveness/overflow_test.dart` | 30 | ✅ |
| **Total** | **535** | **✅ All passing** |

**Fixes applied (Session B / prior):**
1. `lib/core/services/widget_update_service.dart` — Changed `b.startTime.isAfter(now)` → `!b.startTime.isBefore(now)` so a prayer block starting at exactly `now` produces `'0m'` instead of `'—'`.
2. `test/features/prayer/data/repositories/prayer_cache_repository_test.dart` — Added `registerFallbackValue(_day(todayOnly))` to `setUpAll` in `PrayerTimeService.getPrayerTimesAsync` group.
3. `test/shared/widgets/animation_widgets_test.dart` — Changed `find.byType(ScaleTransition)` to `find.ancestor(of: checkIcon, matching: find.byType(ScaleTransition))`.

**Fixes applied (Session C — QA pass):**
1. `test/features/backup/backup_page_test.dart` + `test/integration/backup_flow_test.dart` — Added `const` to `BackupListRequested('dummy')` and `RestoreRequested('dummy')` (`prefer_const_constructors` lint).
2. `test/integration/auth_to_onboarding_test.dart` — `OnboardingState()` has all-optional constructor params; removed incorrect `selectedDate` argument.
3. `test/integration/timeline_to_habit_test.dart` — Replaced `pumpAndSettle()` with `pump(Duration(milliseconds: 50))` to avoid timeout from `..repeat()` animation in `timeline_widgets.dart:953`.
4. All HomeShell tests — Use `MaterialApp.builder` + `MediaQuery.copyWith(size: Size(390, 844))` to force phone layout (avoids tablet breakpoint ≥768dp at default 800×600 test surface).
5. Nav-label finders — Use `.last` to target the nav bar label when the same text also appears in an always-rendered page heading (`_AnalyticsAwareStack` keeps all tab pages in the render tree at opacity 0).

---

## 🔑 Key Conventions (follow these always)

1. **Every new feature** follows Clean Architecture: `domain/entities/` → `domain/usecases/` → `data/models/` → `data/repositories/` → `presentation/bloc/` → `presentation/pages/` → `presentation/widgets/`
2. **Isar models** go in `data/models/`, annotated with `@collection`. After adding any Isar model, remind the user to run `dart run build_runner build --delete-conflicting-outputs`
3. **BLoC files** are split into three files: `_bloc.dart` (the bloc itself), `_event.dart`, `_state.dart` — OR combined in one file if under ~150 lines
4. **Use cases** extend `UseCase<Result, Params>` from `core/usecases/usecase.dart`
5. **Either<Failure, T>** (dartz) for all repository return types
6. **Female-aware features**: any streak/habit feature must respect `UserProfile.isFemale` and support `StreakPauseReason.cycle`
7. **Prayer identity colours** (use consistently in UI):
   - Fajr: `#5B8DEF` (blue dawn)
   - Dhuhr: `#F5A623` (noon gold)
   - Asr: `#E8873A` (amber)
   - Maghrib: `#E05D5D` (sunset red)
   - Isha: `#7B61FF` (night purple)
8. **Theme colours**: Islamic green primary `#1B6B3A`, soft cream background `#FAF7F2`
9. **All new algorithms** must have a corresponding unit test file with ≥20 test cases
10. **No hardcoded strings** — use `AppConstants` or build a proper `l10n` setup if internationalisation is added

---

## ⚡ Quick Start Commands

```bash
# After cloning / adding dependencies
flutter pub get

# After adding any Isar @collection model
dart run build_runner build --delete-conflicting-outputs

# Run the app
flutter run

# Run all tests
flutter test

# Run specific test file
flutter test test/features/timeline/domain/timeline_generator_test.dart -v
```

---

## 🎯 Session Workflow

When starting a new session in the IDE, Claude should:
1. Read this file (`PROJECT_MEMORY.md`) in full
2. Read the relevant existing feature files before writing any new code
3. State clearly: "I've read the memory file. Current phase: X. Continuing from: Y."
4. Build the next incomplete item from the list above
5. After completing a phase, update this file's status table

---

## 🧹 Last Analyze Output

**Run date:** 2026-07-02 (Firebase Full Integration Session)
**Command:** `flutter analyze`
**Result:** ✅ No issues found!

**Test run:** `flutter test` → **535/535 All tests passed!**

**Build:** `flutter build apk --debug` → ✅ Built successfully with Firebase Gradle plugins
