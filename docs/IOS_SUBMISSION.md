# iOS App Store Submission

Step-by-step guide to submit Productive Muslim to the Apple App Store.

---

## Prerequisites

- Mac running macOS 13+ with Xcode 15+
- Apple Developer account ($99/year) enrolled at [developer.apple.com](https://developer.apple.com)
- Flutter installed and `flutter doctor` reports no iOS issues

---

## 1 — Create an App ID in the Apple Developer Portal

1. Go to [developer.apple.com → Certificates, IDs & Profiles → Identifiers](https://developer.apple.com/account/resources/identifiers/list)
2. Click **+** → **App IDs** → **App**
3. Enter:
   - **Description:** `Productive Muslim`
   - **Bundle ID:** `com.productivemuslim.app` (Explicit)
   - **Capabilities:** enable **Push Notifications** if you plan to add prayer reminders later
4. Click **Continue** → **Register**

---

## 2 — Create the app in App Store Connect

1. Go to [appstoreconnect.apple.com](https://appstoreconnect.apple.com) → **Apps** → **+** → **New App**
2. Fill in:
   - **Platform:** iOS
   - **Name:** `Productive Muslim`
   - **Primary Language:** English (U.S.)
   - **Bundle ID:** `com.productivemuslim.app`
   - **SKU:** `productive-muslim-v1` (internal, not shown to users)
3. Click **Create**

---

## 3 — Configure Xcode

Open the iOS workspace (not the `.xcodeproj`):

```bash
open ios/Runner.xcworkspace
```

In Xcode:

1. Select the **Runner** target → **Signing & Capabilities** tab
2. Set **Team** to your Apple Developer account
3. Confirm **Bundle Identifier** = `com.productivemuslim.app`
4. Set **Automatically manage signing** = ✓
5. Select the **Release** scheme: Product → Scheme → Edit Scheme → Run → Build Configuration = **Release**

---

## 4 — Set version and build number

In `pubspec.yaml`:

```yaml
version: 1.0.0+1
```

The `+1` becomes the **Build Number** (CFBundleVersion). Increment the build number on every upload to TestFlight / App Store, even if the version string stays the same.

---

## 5 — Archive and upload

### Option A: Xcode Organizer (recommended)

```bash
# Build first to confirm no errors
flutter build ios --release

# Open Xcode, then:
# Product → Archive
# Xcode Organizer opens automatically when archiving completes
# Click "Distribute App" → "App Store Connect" → "Upload"
```

### Option B: `flutter build ipa` + Transporter

```bash
flutter build ipa --release --export-options-plist=ios/ExportOptions.plist
```

Create `ios/ExportOptions.plist`:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN"
  "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>method</key>
  <string>app-store</string>
  <key>teamID</key>
  <string>YOUR_TEAM_ID</string>
  <key>uploadBitcode</key>
  <false/>
  <key>signingStyle</key>
  <string>automatic</string>
</dict>
</plist>
```

Then drag the `.ipa` from `build/ios/ipa/` into [Transporter.app](https://apps.apple.com/us/app/transporter/id1450874784) to upload.

---

## 6 — Fill in App Store Connect metadata

Navigate to your app in [appstoreconnect.apple.com](https://appstoreconnect.apple.com) and complete each section. Full copy is in `assets/store_listing.md`.

### App Information
| Field | Value |
|---|---|
| Name | `Productive Muslim` |
| Subtitle | `Prayer, Habits & Daily Planner` |
| Primary Category | Health & Fitness |
| Secondary Category | Lifestyle |
| Content Rights | Does not contain third-party content |

### Version Information (1.0.0)
| Field | Value |
|---|---|
| Description | See `assets/store_listing.md` → App Store Full Description |
| Keywords | `prayer times,muslim planner,islamic app,habit tracker,quran,ramadan,salah,productivity,adhan` |
| Support URL | `https://productivemuslim.app/support` |
| Marketing URL | `https://productivemuslim.app` |
| Privacy Policy URL | `https://productivemuslim.app/privacy` |
| What's New | See `assets/store_listing.md` → What's New |

### Pricing & Availability
- **Price:** Free
- **Availability:** All countries (or your preferred regions)

---

## 7 — Screenshots

Upload screenshots for **all required device sizes**. See `docs/SCREENSHOT_GUIDE.md` for exact sizes, recommended screens, and caption text.

Required slots:
- 6.7" iPhone (iPhone 15 Pro Max / 14 Plus) — **required**
- 5.5" iPhone (iPhone 8 Plus) — required for older device support
- iPad Pro 12.9" — required if you select iPad support

---

## 8 — Age Rating questionnaire

Navigate to **App Information → Age Rating** and answer:

| Question | Answer |
|---|---|
| Cartoon or Fantasy Violence | None |
| Realistic Violence | None |
| Prolonged Graphic or Sadistic Violence | None |
| Profanity or Crude Humor | None |
| Mature/Suggestive Themes | None |
| Horror/Fear Themes for Children | None |
| Medical/Treatment Information | None |
| Alcohol, Tobacco, or Drug Use | None |
| Gambling | None |
| Sexual Content or Nudity | None |
| Contests | None |
| Social Networking | None |

**Result: 4+** (suitable for all ages)

---

## 9 — Privacy & Data collection

Navigate to **App Privacy → Data Types** and select:

- **Location** → Approximate Location → Used for prayer time calculation → Not linked to user, not used for tracking
- **No other data types** — the app stores everything locally, no analytics, no accounts

---

## 10 — Submit for review

1. Confirm the build uploaded from Step 5 is visible in App Store Connect → TestFlight
2. Under **Version Information → Build**, select the uploaded build
3. Click **Add for Review** → **Submit to App Review**
4. Expected review time: 24–72 hours for first submission

---

## Checklist before submitting

- [ ] `flutter build ios --release` completes with no errors
- [ ] Archive created in Xcode with Release scheme
- [ ] Build uploaded and visible in App Store Connect
- [ ] All metadata fields filled (name, subtitle, description, keywords, URLs)
- [ ] Screenshots uploaded for all required device sizes
- [ ] Age rating completed (should show 4+)
- [ ] Privacy data types declared (approximate location only)
- [ ] Privacy policy URL resolves (`https://productivemuslim.app/privacy`)
- [ ] Build number incremented in `pubspec.yaml`
