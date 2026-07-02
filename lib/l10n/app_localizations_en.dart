// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Productive Muslim';

  @override
  String get tabHome => 'Home';

  @override
  String get tabHabits => 'Habits';

  @override
  String get tabAnalytics => 'Analytics';

  @override
  String get tabSettings => 'Settings';

  @override
  String get tabTimeline => 'Timeline';

  @override
  String get tabRamadan => 'Ramadan';

  @override
  String get tabProfile => 'Profile';

  @override
  String get onboardingWelcomeTitle => 'Assalamu Alaikum';

  @override
  String get onboardingWelcomeSubtitle =>
      'Let\'s build your productive Muslim life';

  @override
  String get onboardingGetStarted => 'Get Started';

  @override
  String get onboardingOccupation => 'Occupation';

  @override
  String get onboardingWorkSchedule => 'Work Schedule';

  @override
  String get onboardingPrayerSettings => 'Prayer Times';

  @override
  String get onboardingFitnessGoals => 'Fitness Goals';

  @override
  String get onboardingSleepQuran => 'Sleep & Quran';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get appearanceTitle => 'Appearance';

  @override
  String get notificationsTitle => 'Notifications';

  @override
  String get prayerTimesTitle => 'Prayer Times';

  @override
  String get profileTitle => 'Edit Profile';

  @override
  String get buttonSave => 'Save';

  @override
  String get buttonCancel => 'Cancel';

  @override
  String get buttonContinue => 'Continue';

  @override
  String get buttonDone => 'Done';

  @override
  String get buttonRetry => 'Retry';

  @override
  String get buttonBack => 'Back';

  @override
  String get buttonSkip => 'Skip';

  @override
  String get buttonSignOut => 'Sign Out';

  @override
  String get prayerFajr => 'Fajr';

  @override
  String get prayerDhuhr => 'Dhuhr';

  @override
  String get prayerAsr => 'Asr';

  @override
  String get prayerMaghrib => 'Maghrib';

  @override
  String get prayerIsha => 'Isha';

  @override
  String get prayerNext => 'Next prayer';

  @override
  String get todaySchedule => 'Today\'s Schedule';

  @override
  String get goodMorning => 'Good Morning';

  @override
  String get goodEvening => 'Good Evening';

  @override
  String get markComplete => 'Mark Complete';

  @override
  String get timeRemaining => 'Time Remaining';

  @override
  String get myHabits => 'My Habits';

  @override
  String get weeklyScore => 'Weekly Score';

  @override
  String get habitCompleted => 'Done today';

  @override
  String get habitMissed => 'Missed';

  @override
  String get habitExcellent => 'Excellent';

  @override
  String habitStreak(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count day streak',
      one: '1 day streak',
    );
    return '$_temp0';
  }

  @override
  String get ramadanMode => 'Ramadan Mode';

  @override
  String get suhoor => 'Suhoor';

  @override
  String get iftar => 'Iftar';

  @override
  String get tarawih => 'Tarawih';

  @override
  String get timeToIftar => 'Time to Iftar';

  @override
  String get language => 'Language';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get lightMode => 'Light Mode';

  @override
  String get systemDefault => 'System Default';

  @override
  String get signInWithGoogle => 'Continue with Google';

  @override
  String get continueAsGuest => 'Continue as Guest';

  @override
  String get cloudBackup => 'Cloud Backup';

  @override
  String get backUpNow => 'Back Up Now';

  @override
  String get lastBackup => 'Last backup';

  @override
  String get analyticsOverview => 'Overview';

  @override
  String get analyticsPrayers => 'Prayers';

  @override
  String get analyticsHabits => 'Habits';

  @override
  String get thisWeek => 'This Week';

  @override
  String get thisMonth => 'This Month';

  @override
  String get last3Months => 'Last 3 Months';

  @override
  String get loading => 'Loading...';

  @override
  String get errorGeneric => 'Something went wrong';

  @override
  String get locationNotSet =>
      'Location not set — please update your location in Settings.';

  @override
  String get minutes => 'min';

  @override
  String get hours => 'h';

  @override
  String get splashTagline => 'Balance. Worship. Grow.';
}
