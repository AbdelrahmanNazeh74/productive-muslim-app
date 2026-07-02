import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/di/app_dependencies.dart';
import '../../../../../core/navigation/app_router.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../../../../shared/theme/app_theme.dart';
import '../bloc/auth_bloc.dart';
import '../widgets/auth_widgets.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (ctx, state) async {
        if (state is AuthAuthenticated) {
          final result =
              await AppDependencies.getUserProfile(const NoParams());
          if (!ctx.mounted) return;
          final profile = result.fold((_) => null, (p) => p);
          if (profile?.isOnboardingComplete == true) {
            ctx.go(AppRouter.home);
          } else {
            ctx.go(AppRouter.onboarding);
          }
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.primary,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Spacer(flex: 2),
                // ── App logo ─────────────────────────────────────────────────
                const _AppLogoWidget(),
                const SizedBox(height: 32),
                // ── App name ─────────────────────────────────────────────────
                Text(
                  'Productive Muslim',
                  style: AppTextStyles.displayMedium.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 26,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Balance. Worship. Grow.',
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: Colors.white.withValues(alpha: 0.75),
                    letterSpacing: 0.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const Spacer(flex: 2),
                // ── Sign-in options ───────────────────────────────────────────
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    final isLoading = state is AuthLoading;
                    return GoogleSignInButton(
                      isLoading: isLoading,
                      onTap: () =>
                          context.read<AuthBloc>().add(const AuthSignInRequested()),
                    );
                  },
                ),
                const SizedBox(height: 16),
                const OrDivider(),
                const SizedBox(height: 16),
                // ── Guest option ─────────────────────────────────────────────
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    final isLoading = state is AuthLoading;
                    return TextButton(
                      onPressed: isLoading
                          ? null
                          : () => context
                              .read<AuthBloc>()
                              .add(const AuthGuestRequested()),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white.withValues(alpha: 0.75),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                      ),
                      child: const Text(
                        'Continue as Guest',
                        style: TextStyle(fontSize: 15, letterSpacing: 0.25),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 8),
                // ── Guest disclaimer ─────────────────────────────────────────
                Text(
                  'Guest mode: all data is local-only. Sign in later to enable cloud backup.',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: Colors.white.withValues(alpha: 0.45),
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── App logo widget ───────────────────────────────────────────────────────────

class _AppLogoWidget extends StatelessWidget {
  const _AppLogoWidget();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 88,
      height: 88,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: Center(
        child: Text(
          'PM',
          style: AppTextStyles.displayMedium.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w900,
            fontSize: 32,
            letterSpacing: -1,
          ),
        ),
      ),
    );
  }
}
