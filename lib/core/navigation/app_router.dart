import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/domain/entities/auth_user.dart';
import '../../features/auth/presentation/pages/auth_page.dart';
import '../../features/onboarding/domain/entities/user_profile.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../../features/timeline/presentation/pages/home_shell.dart';
import '../../shared/widgets/app_splash_screen.dart';

class AppRouter {
  AppRouter._();

  static const String splash = '/';
  static const String auth = '/auth';
  static const String onboarding = '/onboarding';
  static const String home = '/home';

  static GoRouter buildRouter({
    UserProfile? existingProfile,
    AuthUser? authUser,
  }) {
    String targetRoute;
    if (existingProfile != null && existingProfile.isOnboardingComplete) {
      targetRoute = home;
    } else if (authUser != null) {
      targetRoute = onboarding;
    } else {
      targetRoute = auth;
    }

    return GoRouter(
      initialLocation: splash,
      routes: [
        // ── Splash (always the initial screen, navigates away after 1.6 s) ──
        GoRoute(
          path: splash,
          pageBuilder: (context, state) => _fadePage(
            key: state.pageKey,
            child: AppSplashScreen(targetRoute: targetRoute),
          ),
        ),

        // ── Auth ─────────────────────────────────────────────────────────────
        GoRoute(
          path: auth,
          pageBuilder: (context, state) => _fadePage(
            key: state.pageKey,
            child: const AuthPage(),
          ),
        ),

        // ── Onboarding ───────────────────────────────────────────────────────
        GoRoute(
          path: onboarding,
          pageBuilder: (context, state) => _fadePage(
            key: state.pageKey,
            child: const OnboardingPage(),
          ),
        ),

        // ── Home shell (main app) ────────────────────────────────────────────
        GoRoute(
          path: home,
          pageBuilder: (context, state) => _fadePage(
            key: state.pageKey,
            child: HomeShell(
              profile: state.extra as UserProfile? ?? existingProfile,
            ),
          ),
        ),
      ],
    );
  }

  // ── Helper: fade-through page transition ──────────────────────────────────

  static CustomTransitionPage<void> _fadePage({
    required LocalKey key,
    required Widget child,
  }) {
    return CustomTransitionPage<void>(
      key: key,
      child: child,
      transitionDuration: const Duration(milliseconds: 300),
      reverseTransitionDuration: const Duration(milliseconds: 200),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        // Primary route fades in; secondary route fades out simultaneously
        final fadeIn = CurvedAnimation(
          parent: animation,
          curve: Curves.easeIn,
        );
        final fadeOut = CurvedAnimation(
          parent: secondaryAnimation,
          curve: Curves.easeOut,
        );
        return FadeTransition(
          opacity: Tween<double>(begin: 0.0, end: 1.0).animate(fadeIn),
          child: FadeTransition(
            opacity: Tween<double>(begin: 1.0, end: 0.0).animate(fadeOut),
            child: child,
          ),
        );
      },
    );
  }
}
