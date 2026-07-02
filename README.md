# Productive Muslim

**A Flutter productivity app for Muslims who want to build a structured daily life anchored around the five daily prayers.**

![Tests](https://img.shields.io/badge/tests-535%20passing-brightgreen)
![Analyze](https://img.shields.io/badge/flutter%20analyze-0%20issues-brightgreen)
![Flutter](https://img.shields.io/badge/Flutter-3.22%2B-blue)
![Firebase](https://img.shields.io/badge/Firebase-active-orange)
![Platform](https://img.shields.io/badge/platform-Android%20%7C%20iOS-lightgrey)
![License](https://img.shields.io/badge/license-MIT-green)

---

## Features

- **Prayer-anchored scheduling** — generates a complete daily timeline with Deep Work blocks, Quran time, and meals scheduled around the five prayers using offline adhan calculation (no API key required)
- **Habit streaks** — 12–15 personalised habits seeded from your profile; streak counting with excused-day support (travel, illness, menstrual cycle) and personal-best celebrations
- **Weekly Spiritual Score** — weighted composite of prayer rate (50%), Quran (20%), general habits (20%), and fitness (10%)
- **Ramadan mode** — separate scheduling engine with Suhoor, Iftar, Tarawih, and extended Qiyam al-Layl on the Last Ten Nights; activates automatically when the Hijri month is Ramadan
- **Analytics dashboard** — weekly score line chart, per-prayer bar chart, habit completion bars, monthly heatmap calendar, habit leaderboard; periods: this week / this month / last 3 months
- **Home screen widget** — next prayer name, countdown, and current block title on Android (AppWidget) and iOS (WidgetKit)
- **Prayer notifications** — configurable lead time per prayer, quiet hours window, powered by `flutter_local_notifications`
- **Full settings suite** — prayer calculation method (10 options), Hanafi/Shafi madhab, work schedule, sleep goals, Quran pages target, notification config, light/dark/system theme
- **Responsive layout** — two-column tablet layout at ≥768dp; four breakpoints (small / medium / large / tablet)
- **Google Sign-In + Cloud Backup** — Firebase Auth (Google + anonymous) and Firestore backup with offline persistence; gracefully falls back to local-only mode if Firebase is unavailable
- **Fully offline-first** — all features work without internet; prayer times computed on-device, data stored in local Isar database

---

## Tech Stack

| Concern | Library |
|---|---|
| State management | `flutter_bloc ^8.1.5` |
| Local database | `isar ^3.1.0+1` |
| Navigation | `go_router ^14.2.0` |
| Prayer times | `adhan ^1.1.0` |
| Notifications | `flutter_local_notifications ^17.2.2` |
| Home screen widget | `home_widget ^0.6.0` |
| Charts | `fl_chart ^0.68.0` |
| Location | `geolocator` + `geocoding` |
| Functional | `dartz ^0.10.1` |
| Auth / Backup | `firebase_auth ^5.3.1` + `cloud_firestore ^5.4.4` |
| Crash / Analytics | `firebase_crashlytics ^4.1.3` + `firebase_analytics ^11.3.3` |
| Google Sign-In | `google_sign_in ^6.2.2` |
| Testing | `bloc_test ^9.1.7` + `mocktail ^1.0.4` |

---

## Quick Start

```bash
# Prerequisites: Flutter 3.22+ on stable channel
flutter --version

# Install dependencies
flutter pub get

# Run on a connected device / emulator
flutter run

# Run the full test suite
flutter test
# → 535 tests passed

# Static analysis
flutter analyze
# → No issues found!
```

> The generated Isar schema files (`*.g.dart`) are committed. You do **not** need to run `build_runner` to get started.

---

## Building for Release

**Android (App Bundle):**
```bash
# 1. Create android/key.properties (see docs/ANDROID_SIGNING.md)
# 2. Build
flutter build appbundle --release
# Output: build/app/outputs/bundle/release/app-release.aab
```

**iOS (Archive):**
```bash
flutter build ios --release
# Then: Xcode → Product → Archive → Distribute App → App Store Connect
```

Full submission checklists:
- [docs/ANDROID_SIGNING.md](docs/ANDROID_SIGNING.md)
- [docs/IOS_SUBMISSION.md](docs/IOS_SUBMISSION.md)
- [docs/PLAY_STORE_SUBMISSION.md](docs/PLAY_STORE_SUBMISSION.md)
- [docs/SCREENSHOT_GUIDE.md](docs/SCREENSHOT_GUIDE.md)

---

## Developer Handover

If you are picking up this codebase, read **[HANDOVER.md](HANDOVER.md)** first. It covers:

- What is fully built and working (with entry point file paths and test coverage)
- What needs manual configuration before release (signing, iOS App Group, icons, splash)
- What is missing / not yet built (adhan audio, localisation, backend sync, Quran text)
- Annotated project structure reference
- Key architectural decisions explained in prose
- Known issues and technical debt

---

## Project Structure

```
lib/
├── core/           — DI, navigation, services, responsive utils
├── features/
│   ├── onboarding/ — 6-step first-launch flow
│   ├── prayer/     — adhan wrapper + 30-day cache
│   ├── timeline/   — scheduling engine + dashboard UI
│   ├── habits/     — streak calculator + seeder
│   ├── ramadan/    — Hijri converter + Ramadan generator
│   ├── analytics/  — charts + heatmap dashboard
│   └── settings/   — SharedPreferences + 6 sub-pages
└── shared/         — theme, splash screen, celebration overlay
```

---

## License

MIT — see LICENSE for details.

---

*Package ID: `com.productivemuslim.app` · Version: 1.0.0+1 · Flutter 3.22+ / Dart 3.x*
