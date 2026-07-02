// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'المسلم المنتج';

  @override
  String get tabHome => 'الرئيسية';

  @override
  String get tabHabits => 'العادات';

  @override
  String get tabAnalytics => 'التحليلات';

  @override
  String get tabSettings => 'الإعدادات';

  @override
  String get onboardingWelcomeTitle => 'السلام عليكم';

  @override
  String get onboardingWelcomeSubtitle => 'لنبني حياتك الإسلامية المنتجة';

  @override
  String get settingsTitle => 'الإعدادات';

  @override
  String get appearanceTitle => 'المظهر';

  @override
  String get notificationsTitle => 'الإشعارات';

  @override
  String get prayerTimesTitle => 'مواقيت الصلاة';

  @override
  String get buttonSave => 'حفظ';

  @override
  String get buttonCancel => 'إلغاء';

  @override
  String get buttonContinue => 'متابعة';

  @override
  String get buttonDone => 'تم';

  @override
  String get buttonRetry => 'إعادة المحاولة';

  @override
  String get habitCompleted => 'تم اليوم';

  @override
  String habitStreak(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count أيام متواصلة',
      two: 'يومان متواصلان',
      one: 'يوم واحد متواصل',
    );
    return '$_temp0';
  }

  @override
  String get prayerNext => 'الصلاة القادمة';

  @override
  String get splashTagline => 'توازن. عبادة. نمو.';
}
