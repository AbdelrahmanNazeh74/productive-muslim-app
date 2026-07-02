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
  String get tabTimeline => 'الجدول اليومي';

  @override
  String get tabRamadan => 'رمضان';

  @override
  String get tabProfile => 'الملف الشخصي';

  @override
  String get onboardingWelcomeTitle => 'السلام عليكم';

  @override
  String get onboardingWelcomeSubtitle => 'لنبني حياتك الإسلامية المنتجة';

  @override
  String get onboardingGetStarted => 'ابدأ الآن';

  @override
  String get onboardingOccupation => 'المهنة';

  @override
  String get onboardingWorkSchedule => 'جدول العمل';

  @override
  String get onboardingPrayerSettings => 'مواقيت الصلاة';

  @override
  String get onboardingFitnessGoals => 'أهداف اللياقة';

  @override
  String get onboardingSleepQuran => 'النوم والقرآن';

  @override
  String get settingsTitle => 'الإعدادات';

  @override
  String get appearanceTitle => 'المظهر';

  @override
  String get notificationsTitle => 'الإشعارات';

  @override
  String get prayerTimesTitle => 'مواقيت الصلاة';

  @override
  String get profileTitle => 'تعديل الملف الشخصي';

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
  String get buttonBack => 'رجوع';

  @override
  String get buttonSkip => 'تخطي';

  @override
  String get buttonSignOut => 'تسجيل الخروج';

  @override
  String get prayerFajr => 'الفجر';

  @override
  String get prayerDhuhr => 'الظهر';

  @override
  String get prayerAsr => 'العصر';

  @override
  String get prayerMaghrib => 'المغرب';

  @override
  String get prayerIsha => 'العشاء';

  @override
  String get prayerNext => 'الصلاة القادمة';

  @override
  String get todaySchedule => 'جدول اليوم';

  @override
  String get goodMorning => 'صباح الخير';

  @override
  String get goodEvening => 'مساء الخير';

  @override
  String get markComplete => 'تمييز كمكتمل';

  @override
  String get timeRemaining => 'الوقت المتبقي';

  @override
  String get myHabits => 'عاداتي';

  @override
  String get weeklyScore => 'النتيجة الأسبوعية';

  @override
  String get habitCompleted => 'تم اليوم';

  @override
  String get habitMissed => 'فائت';

  @override
  String get habitExcellent => 'ممتاز';

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
  String get ramadanMode => 'وضع رمضان';

  @override
  String get suhoor => 'السحور';

  @override
  String get iftar => 'الإفطار';

  @override
  String get tarawih => 'التراويح';

  @override
  String get timeToIftar => 'الوقت حتى الإفطار';

  @override
  String get language => 'اللغة';

  @override
  String get darkMode => 'الوضع الداكن';

  @override
  String get lightMode => 'الوضع الفاتح';

  @override
  String get systemDefault => 'إعداد الجهاز';

  @override
  String get signInWithGoogle => 'المتابعة مع Google';

  @override
  String get continueAsGuest => 'المتابعة كضيف';

  @override
  String get cloudBackup => 'النسخ الاحتياطي';

  @override
  String get backUpNow => 'نسخ احتياطي الآن';

  @override
  String get lastBackup => 'آخر نسخة احتياطية';

  @override
  String get analyticsOverview => 'نظرة عامة';

  @override
  String get analyticsPrayers => 'الصلوات';

  @override
  String get analyticsHabits => 'العادات';

  @override
  String get thisWeek => 'هذا الأسبوع';

  @override
  String get thisMonth => 'هذا الشهر';

  @override
  String get last3Months => 'آخر 3 أشهر';

  @override
  String get loading => 'جارٍ التحميل...';

  @override
  String get errorGeneric => 'حدث خطأ ما';

  @override
  String get locationNotSet => 'الموقع غير مُحدَّد — يرجى تحديثه من الإعدادات.';

  @override
  String get minutes => 'د';

  @override
  String get hours => 'س';

  @override
  String get splashTagline => 'توازن. عبادة. نمو.';
}
