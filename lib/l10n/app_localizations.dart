import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en')
  ];

  /// App name shown in the title bar
  ///
  /// In en, this message translates to:
  /// **'Productive Muslim'**
  String get appTitle;

  /// Bottom nav: Home / Timeline tab
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get tabHome;

  /// Bottom nav: Habits tab
  ///
  /// In en, this message translates to:
  /// **'Habits'**
  String get tabHabits;

  /// Bottom nav: Analytics tab
  ///
  /// In en, this message translates to:
  /// **'Analytics'**
  String get tabAnalytics;

  /// Bottom nav: Settings tab
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get tabSettings;

  /// Bottom nav label: timeline
  ///
  /// In en, this message translates to:
  /// **'Timeline'**
  String get tabTimeline;

  /// Bottom nav label: Ramadan tab
  ///
  /// In en, this message translates to:
  /// **'Ramadan'**
  String get tabRamadan;

  /// Bottom nav label: profile/settings
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get tabProfile;

  /// First onboarding step title
  ///
  /// In en, this message translates to:
  /// **'Assalamu Alaikum'**
  String get onboardingWelcomeTitle;

  /// First onboarding step subtitle
  ///
  /// In en, this message translates to:
  /// **'Let\'s build your productive Muslim life'**
  String get onboardingWelcomeSubtitle;

  /// Onboarding CTA button
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get onboardingGetStarted;

  /// Onboarding step 2 title
  ///
  /// In en, this message translates to:
  /// **'Occupation'**
  String get onboardingOccupation;

  /// Onboarding step 3 label
  ///
  /// In en, this message translates to:
  /// **'Work Schedule'**
  String get onboardingWorkSchedule;

  /// Onboarding step 4 title
  ///
  /// In en, this message translates to:
  /// **'Prayer Times'**
  String get onboardingPrayerSettings;

  /// Onboarding step 5 title
  ///
  /// In en, this message translates to:
  /// **'Fitness Goals'**
  String get onboardingFitnessGoals;

  /// Onboarding step 6 title
  ///
  /// In en, this message translates to:
  /// **'Sleep & Quran'**
  String get onboardingSleepQuran;

  /// Settings page title
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// Appearance sub-page title
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearanceTitle;

  /// Notifications sub-page title
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationsTitle;

  /// Prayer times sub-page title
  ///
  /// In en, this message translates to:
  /// **'Prayer Times'**
  String get prayerTimesTitle;

  /// Profile edit page title
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get profileTitle;

  /// Generic save button
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get buttonSave;

  /// Generic cancel button
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get buttonCancel;

  /// Generic continue / next button
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get buttonContinue;

  /// Generic done / finish button
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get buttonDone;

  /// Retry after an error
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get buttonRetry;

  /// Back navigation button
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get buttonBack;

  /// Skip optional step
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get buttonSkip;

  /// Sign out button
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get buttonSignOut;

  /// Fajr prayer name
  ///
  /// In en, this message translates to:
  /// **'Fajr'**
  String get prayerFajr;

  /// Dhuhr prayer name
  ///
  /// In en, this message translates to:
  /// **'Dhuhr'**
  String get prayerDhuhr;

  /// Asr prayer name
  ///
  /// In en, this message translates to:
  /// **'Asr'**
  String get prayerAsr;

  /// Maghrib prayer name
  ///
  /// In en, this message translates to:
  /// **'Maghrib'**
  String get prayerMaghrib;

  /// Isha prayer name
  ///
  /// In en, this message translates to:
  /// **'Isha'**
  String get prayerIsha;

  /// Label above the next prayer countdown
  ///
  /// In en, this message translates to:
  /// **'Next prayer'**
  String get prayerNext;

  /// Timeline page header
  ///
  /// In en, this message translates to:
  /// **'Today\'s Schedule'**
  String get todaySchedule;

  /// Morning greeting
  ///
  /// In en, this message translates to:
  /// **'Good Morning'**
  String get goodMorning;

  /// Evening greeting
  ///
  /// In en, this message translates to:
  /// **'Good Evening'**
  String get goodEvening;

  /// Button to mark a block as complete
  ///
  /// In en, this message translates to:
  /// **'Mark Complete'**
  String get markComplete;

  /// Countdown label
  ///
  /// In en, this message translates to:
  /// **'Time Remaining'**
  String get timeRemaining;

  /// Habits page title
  ///
  /// In en, this message translates to:
  /// **'My Habits'**
  String get myHabits;

  /// Habits score tab label
  ///
  /// In en, this message translates to:
  /// **'Weekly Score'**
  String get weeklyScore;

  /// Habit completion status label
  ///
  /// In en, this message translates to:
  /// **'Done today'**
  String get habitCompleted;

  /// Habit missed status label
  ///
  /// In en, this message translates to:
  /// **'Missed'**
  String get habitMissed;

  /// Habit excellent rating label
  ///
  /// In en, this message translates to:
  /// **'Excellent'**
  String get habitExcellent;

  /// Streak count label on habit cards
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 day streak} other{{count} day streak}}'**
  String habitStreak(int count);

  /// Ramadan mode toggle label
  ///
  /// In en, this message translates to:
  /// **'Ramadan Mode'**
  String get ramadanMode;

  /// Suhoor meal label
  ///
  /// In en, this message translates to:
  /// **'Suhoor'**
  String get suhoor;

  /// Iftar meal label
  ///
  /// In en, this message translates to:
  /// **'Iftar'**
  String get iftar;

  /// Tarawih prayer label
  ///
  /// In en, this message translates to:
  /// **'Tarawih'**
  String get tarawih;

  /// Countdown to iftar label
  ///
  /// In en, this message translates to:
  /// **'Time to Iftar'**
  String get timeToIftar;

  /// Language setting label
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// Dark mode theme option label
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// Light mode theme option label
  ///
  /// In en, this message translates to:
  /// **'Light Mode'**
  String get lightMode;

  /// Follow system theme label
  ///
  /// In en, this message translates to:
  /// **'System Default'**
  String get systemDefault;

  /// Google sign-in button label
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get signInWithGoogle;

  /// Guest sign-in button label
  ///
  /// In en, this message translates to:
  /// **'Continue as Guest'**
  String get continueAsGuest;

  /// Cloud backup section title
  ///
  /// In en, this message translates to:
  /// **'Cloud Backup'**
  String get cloudBackup;

  /// Trigger backup button
  ///
  /// In en, this message translates to:
  /// **'Back Up Now'**
  String get backUpNow;

  /// Last backup timestamp label
  ///
  /// In en, this message translates to:
  /// **'Last backup'**
  String get lastBackup;

  /// Analytics tab: overview
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get analyticsOverview;

  /// Analytics tab: prayers
  ///
  /// In en, this message translates to:
  /// **'Prayers'**
  String get analyticsPrayers;

  /// Analytics tab: habits
  ///
  /// In en, this message translates to:
  /// **'Habits'**
  String get analyticsHabits;

  /// Period selector: this week
  ///
  /// In en, this message translates to:
  /// **'This Week'**
  String get thisWeek;

  /// Period selector: this month
  ///
  /// In en, this message translates to:
  /// **'This Month'**
  String get thisMonth;

  /// Period selector: last 3 months
  ///
  /// In en, this message translates to:
  /// **'Last 3 Months'**
  String get last3Months;

  /// Generic loading label
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// Generic error message
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get errorGeneric;

  /// Error shown when prayer times cannot be calculated
  ///
  /// In en, this message translates to:
  /// **'Location not set — please update your location in Settings.'**
  String get locationNotSet;

  /// Minutes abbreviation
  ///
  /// In en, this message translates to:
  /// **'min'**
  String get minutes;

  /// Hours abbreviation
  ///
  /// In en, this message translates to:
  /// **'h'**
  String get hours;

  /// Tagline shown on the splash screen
  ///
  /// In en, this message translates to:
  /// **'Balance. Worship. Grow.'**
  String get splashTagline;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
