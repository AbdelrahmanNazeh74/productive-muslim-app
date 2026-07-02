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
  String get onboardingWelcomeTitle => 'Assalamu Alaikum';

  @override
  String get onboardingWelcomeSubtitle =>
      'Let\'s build your productive Muslim life';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get appearanceTitle => 'Appearance';

  @override
  String get notificationsTitle => 'Notifications';

  @override
  String get prayerTimesTitle => 'Prayer Times';

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
  String get habitCompleted => 'Done today';

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
  String get prayerNext => 'Next prayer';

  @override
  String get splashTagline => 'Balance. Worship. Grow.';
}
