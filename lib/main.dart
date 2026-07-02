import 'dart:ui' show PlatformDispatcher;

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/di/app_dependencies.dart';
import 'core/di/environment_config.dart';
import 'l10n/app_localizations.dart';
import 'core/navigation/app_router.dart';
import 'core/services/isar_service.dart';
import 'core/services/prayer_notification_service.dart';
import 'core/usecases/usecase.dart';
import 'features/auth/domain/entities/auth_user.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/backup/domain/entities/backup_snapshot.dart';
import 'features/backup/presentation/bloc/backup_bloc.dart';
import 'features/habits/domain/usecases/habit_usecases.dart';
import 'features/onboarding/domain/entities/user_profile.dart';
import 'features/settings/presentation/bloc/settings_bloc.dart';
import 'shared/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await EnvironmentConfig.initializeIfAvailable();

  if (EnvironmentConfig.firebaseAvailable) {
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  }

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));

  final isar = await IsarService.instance;
  await AppDependencies.init(isar);
  await PrayerNotificationService.initialize();

  // Check onboarding + seed habits
  final profileResult =
      await AppDependencies.getUserProfile(const NoParams());
  final existingProfile =
      profileResult.fold((_) => null, (p) => p);

  if (existingProfile != null && existingProfile.isOnboardingComplete) {
    await AppDependencies.seedDefaultHabits(
      SeedDefaultHabitsParams(
        gender: existingProfile.gender,
        hasFitness: existingProfile.fitnessActivityIds.isNotEmpty &&
            !existingProfile.fitnessActivityIds.contains('none'),
        quranPagesGoal: existingProfile.dailyQuranPagesGoal,
        cycleAware: existingProfile.cycleAwareStreaks,
        gymDays: existingProfile.gymDays,
      ),
    );
  }

  // Check auth state — auto-guest existing users who have no auth stored
  final authResult =
      await AppDependencies.getCurrentAuthUser(const NoParams());
  AuthUser? authUser = authResult.fold((_) => null, (u) => u);

  if (existingProfile != null &&
      existingProfile.isOnboardingComplete &&
      authUser == null) {
    final guestResult =
        await AppDependencies.signInAsGuest(const NoParams());
    authUser = guestResult.fold((_) => null, (u) => u);
  }

  // Pre-load settings so the first frame uses the correct theme/locale
  // instead of the ThemeMode.system flash.
  final settingsResult =
      await AppDependencies.loadSettings(const NoParams());
  String initialThemeMode = 'system';
  String initialLanguage = 'en';
  settingsResult.fold((_) {}, (s) {
    initialThemeMode = s.themeMode;
    initialLanguage = s.language;
  });

  runApp(ProductiveMuslimApp(
    existingProfile: existingProfile,
    authUser: authUser,
    initialThemeMode: initialThemeMode,
    initialLanguage: initialLanguage,
  ));
}

ThemeMode _parseThemeMode(String mode) {
  switch (mode) {
    case 'light':
      return ThemeMode.light;
    case 'dark':
      return ThemeMode.dark;
    default:
      return ThemeMode.system;
  }
}

class ProductiveMuslimApp extends StatefulWidget {
  final UserProfile? existingProfile;
  final AuthUser? authUser;
  final String initialThemeMode;
  final String initialLanguage;

  const ProductiveMuslimApp({
    super.key,
    this.existingProfile,
    this.authUser,
    this.initialThemeMode = 'system',
    this.initialLanguage = 'en',
  });

  @override
  State<ProductiveMuslimApp> createState() => _ProductiveMuslimAppState();
}

class _ProductiveMuslimAppState extends State<ProductiveMuslimApp>
    with WidgetsBindingObserver {
  late final AuthBloc _authBloc;
  late final BackupBloc _backupBloc;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _authBloc = AppDependencies.createAuthBloc()
      ..add(const AuthCheckRequested());
    _backupBloc = AppDependencies.createBackupBloc();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _authBloc.close();
    _backupBloc.close();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      final authState = _authBloc.state;
      if (authState is AuthAuthenticated && !authState.user.isAnonymous) {
        _backupBloc.add(BackupAutoRequested(BackupSnapshot(
          userId: authState.user.id,
          createdAt: DateTime.now(),
          appVersion: '1.0.0',
          userProfile: const {},
          habits: const [],
          streakRecords: const [],
          settings: const {},
        )));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final router = AppRouter.buildRouter(
      existingProfile: widget.existingProfile,
      authUser: widget.authUser,
    );

    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _authBloc),
        BlocProvider.value(value: _backupBloc),
        BlocProvider(create: (_) => AppDependencies.createOnboardingBloc()),
        BlocProvider(create: (_) => AppDependencies.createTimelineBloc()),
        BlocProvider(create: (_) => AppDependencies.createHabitsBloc()),
        BlocProvider(create: (_) => AppDependencies.createRamadanBloc()),
        BlocProvider(create: (_) => AppDependencies.createAnalyticsBloc()),
        BlocProvider(
          create: (_) => AppDependencies.createSettingsBloc()
            ..add(const SettingsLoadRequested()),
        ),
      ],
      child: BlocBuilder<SettingsBloc, SettingsState>(
        buildWhen: (prev, curr) {
          if (prev is SettingsLoaded && curr is SettingsLoaded) {
            return prev.settings.themeMode != curr.settings.themeMode ||
                prev.settings.language != curr.settings.language;
          }
          return curr is SettingsLoaded;
        },
        builder: (context, settingsState) {
          final themeMode = settingsState is SettingsLoaded
              ? _parseThemeMode(settingsState.settings.themeMode)
              : _parseThemeMode(widget.initialThemeMode);
          final locale = settingsState is SettingsLoaded
              ? Locale(settingsState.settings.language)
              : Locale(widget.initialLanguage);
          return MaterialApp.router(
            title: 'Productive Muslim',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: themeMode,
            locale: locale,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: const [
              Locale('en'),
              Locale('ar'),
            ],
            routerConfig: router,
          );
        },
      ),
    );
  }
}
