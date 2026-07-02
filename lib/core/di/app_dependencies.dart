import 'package:isar/isar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/auth/domain/repositories/auth_repository.dart';
import 'environment_config.dart';
import '../../features/auth/domain/usecases/auth_usecases.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/backup/data/repositories/mock_backup_repository_impl.dart';
import '../../features/backup/domain/repositories/backup_repository.dart';
import '../../features/backup/domain/usecases/backup_usecases.dart';
import '../../features/backup/presentation/bloc/backup_bloc.dart';
import '../../features/habits/data/repositories/habits_repository_impl.dart';
import '../../features/habits/domain/repositories/habits_repository.dart';
import '../../features/habits/domain/usecases/habit_usecases.dart';
import '../../features/habits/domain/usecases/streak_calculator.dart';
import '../../features/habits/presentation/bloc/habits_bloc.dart';
import '../../features/onboarding/data/repositories/onboarding_repository_impl.dart';
import '../../features/onboarding/domain/repositories/onboarding_repository.dart';
import '../../features/onboarding/domain/usecases/onboarding_usecases.dart';
import '../../features/onboarding/presentation/bloc/onboarding_bloc.dart';
import '../../features/prayer/data/repositories/prayer_cache_repository_impl.dart';
import '../../features/prayer/data/repositories/prayer_time_service.dart';
import '../../features/prayer/domain/repositories/prayer_cache_repository.dart';
import '../../features/ramadan/domain/usecases/hijri_converter.dart';
import '../usecases/usecase.dart';
import '../services/prayer_cache_service.dart';
import '../../features/ramadan/domain/usecases/ramadan_timeline_generator.dart';
import '../../features/analytics/data/repositories/analytics_repository_impl.dart';
import '../../features/analytics/domain/repositories/analytics_repository.dart';
import '../../features/analytics/domain/usecases/analytics_usecases.dart';
import '../../features/analytics/presentation/bloc/analytics_bloc.dart';
import '../../features/ramadan/presentation/bloc/ramadan_bloc.dart';
import '../../features/settings/data/repositories/settings_repository_impl.dart';
import '../../features/settings/data/services/settings_service.dart';
import '../../features/settings/domain/repositories/settings_repository.dart';
import '../../features/settings/domain/usecases/settings_usecases.dart';
import '../../features/settings/presentation/bloc/settings_bloc.dart';
import '../../features/timeline/data/repositories/timeline_repository_impl.dart';
import '../../features/timeline/domain/repositories/timeline_repository.dart';
import '../../features/timeline/domain/usecases/timeline_generator_service.dart';
import '../../features/timeline/domain/usecases/timeline_usecases.dart';
import '../../features/timeline/presentation/bloc/timeline_bloc.dart';

class AppDependencies {
  AppDependencies._();

  static late Isar _isar;

  // ── Auth ──────────────────────────────────────────────────────────────────────
  static late AuthRepository authRepository;
  static late SignInWithGoogle signInWithGoogle;
  static late SignInAsGuest signInAsGuest;
  static late SignOut signOut;
  static late GetCurrentUser getCurrentAuthUser;
  static late WatchAuthState watchAuthState;

  // ── Backup ────────────────────────────────────────────────────────────────────
  static late BackupRepository backupRepository;
  static late BackupThrottle backupThrottle;
  static late CreateBackup createBackup;
  static late RestoreBackup restoreBackup;
  static late ListBackups listBackups;

  // ── Repositories ─────────────────────────────────────────────────────────────
  static late OnboardingRepository onboardingRepository;
  static late TimelineRepository timelineRepository;
  static late HabitsRepository habitsRepository;

  // ── Prayer cache ──────────────────────────────────────────────────────────────
  static late PrayerCacheRepository prayerCacheRepository;
  static late PrayerCacheService prayerCacheService;

  // ── Services ─────────────────────────────────────────────────────────────────
  static late PrayerTimeService prayerTimeService;
  static late TimelineGeneratorService timelineGeneratorService;
  static late StreakCalculator streakCalculator;
  static late HijriConverter hijriConverter;
  static late RamadanTimelineGenerator ramadanTimelineGenerator;

  // ── Analytics ────────────────────────────────────────────────────────────────
  static late AnalyticsRepository analyticsRepository;
  static late GetAnalyticsSnapshot getAnalyticsSnapshot;
  static late GetWeeklyScoreSeries getWeeklyScoreSeries;
  static late GetMonthlyHeatmap getMonthlyHeatmap;

  // ── Use Cases — Onboarding ───────────────────────────────────────────────────
  static late SaveUserProfile saveUserProfile;
  static late GetUserProfile getUserProfile;
  static late UpdateUserProfile updateUserProfile;

  // ── Use Cases — Timeline ─────────────────────────────────────────────────────
  static late GenerateAndSaveTimeline generateAndSaveTimeline;
  static late GetTimeline getTimeline;
  static late CompleteBlock completeBlock;
  static late SkipBlock skipBlock;
  static late SetMorningIntention setMorningIntention;
  static late SetEveningReflection setEveningReflection;

  // ── Settings ─────────────────────────────────────────────────────────────────
  static late SettingsRepository settingsRepository;
  static late LoadSettings loadSettings;
  static late SaveSettings saveSettings;
  static late ResetSettings resetSettings;

  // ── Use Cases — Habits ───────────────────────────────────────────────────────
  static late GetAllHabits getAllHabits;
  static late SaveHabit saveHabit;
  static late DeleteHabit deleteHabit;
  static late ArchiveHabit archiveHabit;
  static late CompleteHabit completeHabit;
  static late ExcuseHabit excuseHabit;
  static late UndoHabitCompletion undoHabitCompletion;
  static late GetDailyHabitSummary getDailyHabitSummary;
  static late GetWeeklySpiritualScore getWeeklySpiritualScore;
  static late SeedDefaultHabits seedDefaultHabits;

  static Future<void> init(Isar isar) async {
    _isar = isar;

    final prefs = await SharedPreferences.getInstance();

    // Auth — EnvironmentConfig.authRepository() returns MockAuthRepositoryImpl
    // by default; returns FirebaseAuthRepositoryImpl when useFirebase = true.
    authRepository = EnvironmentConfig.authRepository(prefs);
    signInWithGoogle = SignInWithGoogle(authRepository);
    signInAsGuest = SignInAsGuest(authRepository);
    signOut = SignOut(authRepository);
    getCurrentAuthUser = GetCurrentUser(authRepository);
    watchAuthState = WatchAuthState(authRepository);

    // Backup — EnvironmentConfig.backupRepository() returns MockBackupRepositoryImpl
    // by default; returns FirebaseBackupRepositoryImpl when useFirebase = true.
    backupThrottle = BackupThrottleImpl(prefs);
    backupRepository = EnvironmentConfig.backupRepository();
    createBackup = CreateBackup(backupRepository);
    restoreBackup = RestoreBackup(backupRepository);
    listBackups = ListBackups(backupRepository);

    // Prayer cache — must be created before PrayerTimeService so the service
    // can receive the cache reference for getPrayerTimesAsync.
    prayerCacheRepository = PrayerCacheRepositoryImpl(isar: _isar);
    prayerTimeService = PrayerTimeService(cache: prayerCacheRepository);
    prayerCacheService = PrayerCacheService(
      repository: prayerCacheRepository,
      prayerTimeService: prayerTimeService,
    );

    timelineGeneratorService = TimelineGeneratorService();
    streakCalculator = const StreakCalculator();
    hijriConverter = const HijriConverter();
    ramadanTimelineGenerator =
        RamadanTimelineGenerator(hijri: hijriConverter);

    // Repositories
    onboardingRepository = OnboardingRepositoryImpl(isar: _isar);
    timelineRepository = TimelineRepositoryImpl(isar: _isar);
    habitsRepository = HabitsRepositoryImpl(
      isar: _isar,
      streakCalculator: streakCalculator,
    );

    // Analytics repository
    analyticsRepository = AnalyticsRepositoryImpl(
      isar: _isar,
      streakCalculator: streakCalculator,
    );
    getAnalyticsSnapshot = GetAnalyticsSnapshot(analyticsRepository);
    getWeeklyScoreSeries = GetWeeklyScoreSeries(analyticsRepository);
    getMonthlyHeatmap = GetMonthlyHeatmap(analyticsRepository);

    // Onboarding use cases
    saveUserProfile = SaveUserProfile(onboardingRepository);
    getUserProfile = GetUserProfile(onboardingRepository);
    updateUserProfile = UpdateUserProfile(onboardingRepository);

    // Timeline use cases
    generateAndSaveTimeline = GenerateAndSaveTimeline(
      repository: timelineRepository,
      prayerTimeService: prayerTimeService,
      generatorService: timelineGeneratorService,
    );
    getTimeline = GetTimeline(timelineRepository);
    completeBlock = CompleteBlock(timelineRepository);
    skipBlock = SkipBlock(timelineRepository);
    setMorningIntention = SetMorningIntention(timelineRepository);
    setEveningReflection = SetEveningReflection(timelineRepository);

    // Settings
    final settingsService = SettingsService();
    settingsRepository = SettingsRepositoryImpl(settingsService);
    loadSettings = LoadSettings(settingsRepository);
    saveSettings = SaveSettings(settingsRepository);
    resetSettings = ResetSettings(settingsRepository);

    // Warm the prayer cache in the background — does not block app startup.
    // If no profile exists yet (fresh install) this is a no-op; warmCache will
    // be called again after onboarding completes via invalidateAndRewarm().
    getUserProfile(const NoParams()).then((result) {
      result.fold(
        (_) => null,
        (profile) {
          if (profile != null) prayerCacheService.warmCache(profile).ignore();
        },
      );
    });

    // Habits use cases
    getAllHabits = GetAllHabits(habitsRepository);
    saveHabit = SaveHabit(habitsRepository);
    deleteHabit = DeleteHabit(habitsRepository);
    archiveHabit = ArchiveHabit(habitsRepository);
    completeHabit = CompleteHabit(habitsRepository);
    excuseHabit = ExcuseHabit(habitsRepository);
    undoHabitCompletion = UndoHabitCompletion(habitsRepository);
    getDailyHabitSummary = GetDailyHabitSummary(habitsRepository);
    getWeeklySpiritualScore = GetWeeklySpiritualScore(habitsRepository);
    seedDefaultHabits = SeedDefaultHabits(habitsRepository);
  }

  // ── BLoC Factories ───────────────────────────────────────────────────────────
  static AuthBloc createAuthBloc() => AuthBloc(
        signInWithGoogle: signInWithGoogle,
        signInAsGuest: signInAsGuest,
        signOut: signOut,
        getCurrentUser: getCurrentAuthUser,
        watchAuthState: watchAuthState,
      );

  static BackupBloc createBackupBloc() => BackupBloc(
        createBackup: createBackup,
        restoreBackup: restoreBackup,
        listBackups: listBackups,
        getCurrentUser: getCurrentAuthUser,
        throttle: backupThrottle,
      );

  static OnboardingBloc createOnboardingBloc() => OnboardingBloc(
        saveUserProfile: saveUserProfile,
        getUserProfile: getUserProfile,
      );

  static TimelineBloc createTimelineBloc() => TimelineBloc(
        generateAndSaveTimeline: generateAndSaveTimeline,
        getTimeline: getTimeline,
        completeBlock: completeBlock,
        skipBlock: skipBlock,
        setMorningIntention: setMorningIntention,
        setEveningReflection: setEveningReflection,
        prayerTimeService: prayerTimeService,
      );

  static HabitsBloc createHabitsBloc() => HabitsBloc(
        getAllHabits: getAllHabits,
        saveHabit: saveHabit,
        deleteHabit: deleteHabit,
        archiveHabit: archiveHabit,
        completeHabit: completeHabit,
        excuseHabit: excuseHabit,
        undoHabitCompletion: undoHabitCompletion,
        getDailyHabitSummary: getDailyHabitSummary,
        getWeeklySpiritualScore: getWeeklySpiritualScore,
        seedDefaultHabits: seedDefaultHabits,
      );

  static RamadanBloc createRamadanBloc() => RamadanBloc(
        isar: _isar,
        prayerTimeService: prayerTimeService,
        generator: ramadanTimelineGenerator,
        hijriConverter: hijriConverter,
      );

  static AnalyticsBloc createAnalyticsBloc() => AnalyticsBloc(
        getSnapshot: getAnalyticsSnapshot,
        getWeeklyScoreSeries: getWeeklyScoreSeries,
        getMonthlyHeatmap: getMonthlyHeatmap,
      );

  static SettingsBloc createSettingsBloc() => SettingsBloc(
        loadSettings: loadSettings,
        saveSettings: saveSettings,
        resetSettings: resetSettings,
      );

  // Clears Isar + SharedPreferences — used by DataPage full reset
  static Future<void> resetAllData() async {
    await _isar.writeTxn(() => _isar.clear());
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}

