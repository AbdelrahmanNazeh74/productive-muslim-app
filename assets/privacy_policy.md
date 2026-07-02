# Privacy Policy — Productive Muslim

**Last updated: June 2026**

---

## 1. Introduction

Productive Muslim ("we", "our", or "the app") is built for Muslim individuals who want to balance their spiritual obligations, health, and daily productivity. We take your privacy seriously. This policy explains what data the app collects, how it is used, and what rights you have.

---

## 2. Data We Collect

### 2.1 Location Data

- **What**: Your GPS coordinates or city-level location.
- **Why**: To calculate accurate daily prayer times (Fajr, Dhuhr, Asr, Maghrib, Isha) using the built-in `adhan` prayer-time library. No prayer times are fetched from a remote server.
- **When**: Only when you grant permission. You may instead enter your city manually.
- **Storage**: Coordinates are stored only on your device (in the local Isar database). They are never transmitted to any external server.

### 2.2 Usage Data

- **Habit completions and streaks**: Stored locally on your device. Never synced to a server.
- **Prayer time records**: Stored locally.
- **Daily timeline**: Stored locally.
- **App settings and preferences**: Stored locally via SharedPreferences.
- **Profile information** (name, occupation, prayer settings, gender, fitness days): Stored locally.

---

## 3. Data We Do NOT Collect

- We do not collect analytics or crash telemetry.
- We do not track your usage behaviour or send events to third-party analytics services (e.g. Firebase Analytics, Mixpanel, Amplitude).
- We do not use advertising SDKs.
- We do not sell, rent, or share any data with third parties.
- We do not create accounts, and no data ever leaves your device.

---

## 4. Third-Party Services

| Service | Purpose | Data sent |
|---------|---------|-----------|
| `geocoding` (device OS) | Convert GPS coordinates to a city name | Coordinates sent to device OS geocoding API only; subject to your device's privacy settings |
| `google_fonts` | Typography | Font files downloaded once at build time; no user data is sent |

No other third-party SDKs or services receive any user data.

---

## 5. Notifications

The app sends local notifications for:
- Prayer time reminders (Adhan alerts)
- Daily habit check-in reminders
- Quran reading reminders

All notifications are scheduled locally on your device using the `flutter_local_notifications` package. No notification data is sent to a remote server. You can disable any notification category in **Settings → Notifications**.

---

## 6. Data Retention & Deletion

- All your data is stored exclusively on your device.
- You can delete all app data at any time via **Settings → Data → Reset All Data**, which permanently wipes the local Isar database and all SharedPreferences.
- Uninstalling the app removes all associated data from your device.

---

## 7. Children's Privacy

Productive Muslim is not directed at children under the age of 13. We do not knowingly collect personal information from children.

---

## 8. Changes to This Policy

We may update this policy occasionally. When we do, we will update the "Last updated" date at the top of this document and include a summary of changes in the app update release notes.

---

## 9. Contact

If you have questions or concerns about this privacy policy, please contact:

**Email**: privacy@productivemuslim.app *(replace with your actual support email)*

---

*Productive Muslim is a locally-first app. Your data belongs to you — it never leaves your device.*
