# 🧠 Session Starter Prompt — Productive Muslim
# Paste this at the beginning of every new Claude session in your IDE.
# Replace [TASK] with what you want to do that session.

---

## PASTE THIS INTO CLAUDE:

Act as a Senior Flutter Developer and Senior QA Engineer working on a production-ready Flutter app.

Before you write a single line of code, read the following file completely:
`PROJECT_MEMORY.md` (in the root of this project)

After reading it, confirm:
- Which phase is complete
- Where Phase 6 is currently at (what files exist, what's missing)
- What you'll build this session

Then proceed with: [TASK]

Follow all conventions listed in the memory file. After completing work, update the status section in PROJECT_MEMORY.md to reflect what's now done.

---

## EXAMPLE [TASK] VALUES:

### To continue Phase 6 (Settings):
"Complete Phase 6 — Settings & Profile. Read the existing partial files first (AppSettings entity, SettingsService, SettingsBloc), then finish them and build the full settings UI: ProfileEditPage, PrayerSettingsPage, NotificationsPage, AppearancePage, DataPage. Wire the Settings tab into HomeShell."

### To do QA testing:
"Act as a Senior QA Engineer. Write a comprehensive QA test plan for this Flutter app covering: onboarding flow edge cases, timeline generation with edge-case prayer times (midnight Fajr in Nordic countries), habit streak logic, Ramadan mode toggle, analytics data accuracy, and navigation guards. Then implement widget tests and integration tests for the highest-risk flows."

### To fix a specific bug:
"There is a bug in [describe bug]. Read the relevant files, diagnose the root cause, and fix it. Explain the fix."

### To build Phase 7 (Home Screen Widget):
"Build Phase 7B — Home Screen Widget. Create a native Android Glance widget and iOS WidgetKit extension that shows: next prayer name + countdown timer, current or next timeline block title. Wire it to read from Isar prayer cache."

### To prepare for App Store:
"Build Phase 8 — App Store Readiness. Generate app icons (1024×1024 base), splash screens, privacy policy text, and update android/app/build.gradle and ios/Runner/Info.plist with correct bundle IDs, permissions descriptions, and signing config placeholders."

---

## IMPORTANT RULES FOR CLAUDE IN THIS PROJECT:

1. ALWAYS read PROJECT_MEMORY.md before writing any code
2. ALWAYS read existing relevant files before modifying them  
3. NEVER use localStorage or sessionStorage (not Flutter — use Isar or SharedPreferences)
4. ALWAYS run `dart run build_runner build --delete-conflicting-outputs` after adding Isar models
5. ALWAYS add unit tests for new algorithms (minimum 20 test cases)
6. ALWAYS follow Clean Architecture: domain → data → presentation
7. NEVER break female-aware streak logic (cycle-pause support must be preserved)
8. Use prayer identity colours consistently (see memory file)
