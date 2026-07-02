# Google Play Store Submission

Step-by-step guide to submit Productive Muslim to the Google Play Store.

---

## Prerequisites

- Google account with access to [Google Play Console](https://play.google.com/console)
- One-time developer registration fee ($25 USD)
- Release signing keystore set up — see `docs/ANDROID_SIGNING.md`
- Privacy policy hosted at a live URL

---

## 1 — Create the app in Play Console

1. Go to [play.google.com/console](https://play.google.com/console) → **Create app**
2. Fill in:
   - **App name:** `Productive Muslim`
   - **Default language:** English (United States)
   - **App or game:** App
   - **Free or paid:** Free
3. Accept the Declarations → **Create app**

---

## 2 — Build the release App Bundle

```bash
# Ensure key.properties and keystore are in place — see docs/ANDROID_SIGNING.md
flutter build appbundle --release
```

Output:
```
build/app/outputs/bundle/release/app-release.aab
```

---

## 3 — Set up the release track

Play Store uses tracks to control rollout. For a first submission, use **Internal Testing** to verify everything works, then promote to Production.

### Internal Testing (recommended first step)
1. Play Console → your app → **Testing → Internal testing → Create new release**
2. Upload `app-release.aab`
3. Add release notes (see `assets/store_listing.md` → What's New)
4. **Save** → **Review release** → **Start rollout to Internal testing**

### Production release (after internal testing passes)
1. Play Console → **Production → Create new release**
2. Upload the same AAB (or promote the internal testing release)
3. Set **Rollout percentage** to 20% for a staged rollout (recommended for first launch)

---

## 4 — Store listing

Navigate to **Grow → Store presence → Main store listing**.

Full copy for every field is in `assets/store_listing.md`. Summary:

| Field | Value |
|---|---|
| App name | `Productive Muslim` |
| Short description | `Prayer times, habit streaks & daily scheduling for Muslim productivity.` |
| Full description | See `assets/store_listing.md` → Google Play Full Description |

### Graphics
- **App icon:** 512×512 px PNG, no alpha (submit the same icon used in the app)
- **Feature graphic:** 1024×500 px JPG/PNG (shown at top of store listing)
- **Phone screenshots:** at least 2, maximum 8 — see `docs/SCREENSHOT_GUIDE.md`
- **Tablet screenshots (7"):** optional but increases discoverability on tablets
- **Tablet screenshots (10"):** optional

---

## 5 — Category

Navigate to **App content → App category**:

| Field | Value |
|---|---|
| Application type | Apps |
| Category | Health & Fitness |

---

## 6 — Content rating questionnaire

Navigate to **Policy → App content → Content rating → Start questionnaire**.

- **Category:** Utility, productivity, communication, or other
- Answer all violence / sexual content / gambling questions as **No**
- **Result:** Everyone (ESRB), G (PEGI), 4+ (App Store equivalent)

---

## 7 — Target audience

Navigate to **Policy → App content → Target audience and content**:

- **Target age group:** 13 and over (or 18 and over — either works; this app is appropriate for all Muslim users 13+)
- **Primarily child-directed:** No

---

## 8 — Privacy policy

A privacy policy URL is **required** before you can publish.

- URL: `https://productivemuslim.app/privacy`
- The policy should state:
  - No personal data is collected or transmitted
  - Location is used only to calculate prayer times and is never stored or shared
  - All app data remains on the user's device
  - No third-party analytics or advertising SDKs

Navigate to **Policy → App content → Privacy policy** → enter the URL.

---

## 9 — Ads declaration

Navigate to **Policy → App content → Ads**:

- **Does your app contain ads?** No

---

## 10 — Data safety form

Navigate to **Policy → App content → Data safety**:

| Question | Answer |
|---|---|
| Does your app collect or share any of the required user data types? | No |
| Is all of the user data collected by your app encrypted in transit? | Yes (nothing is transmitted) |
| Do you provide a way for users to request that their data is deleted? | Yes — Settings → Reset All Data |

No data types need to be declared since nothing leaves the device.

---

## 11 — App access

Navigate to **Policy → App content → App access**:

- Select **All or most functionality is accessible without special access** (no login required)

---

## 12 — Review and publish

1. Complete all required sections (each shows a green tick in the sidebar)
2. Play Console → **Production → Review release**
3. Address any policy warnings (there should be none for this app)
4. **Start rollout to Production** (or your chosen rollout percentage)
5. Expected review time: 1–3 business days for first-time submission

---

## Version management

- Increment `versionCode` in `pubspec.yaml` for every upload (Play Store rejects a duplicate version code)
- Increment `versionName` for user-visible releases

```yaml
# pubspec.yaml
version: 1.0.0+1   # versionName: 1.0.0 | versionCode: 1
```

Next upload: `1.0.0+2`, `1.0.1+3`, etc.

---

## Checklist before publishing

- [ ] `flutter build appbundle --release` succeeds
- [ ] AAB signed with the release keystore (not debug key)
- [ ] Internal testing track tested on at least one physical device
- [ ] All store listing fields completed (name, short desc, full desc)
- [ ] Feature graphic uploaded (1024×500 px)
- [ ] At least 2 phone screenshots uploaded
- [ ] App icon uploaded (512×512 px)
- [ ] Content rating questionnaire completed (result: Everyone)
- [ ] Privacy policy URL live and accessible
- [ ] Data safety form completed
- [ ] `versionCode` in `pubspec.yaml` is incremented
