import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/app_dependencies.dart';
import '../../../../core/navigation/app_router.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../shared/theme/app_theme.dart';
import '../bloc/onboarding_bloc.dart';
import '../widgets/onboarding_widgets.dart';
import 'steps/step_0_welcome.dart';
import 'steps/step_1_occupation.dart';
import 'steps/step_2_work_schedule.dart';
import 'steps/step_3_prayer_settings.dart';
import 'steps/step_4_fitness.dart';
import 'steps/step_5_sleep.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  // Step direction drives the AnimatedSwitcher slide direction
  bool _goingForward = true;
  int _displayedStep = 0;

  final List<Widget> _steps = const [
    Step0Welcome(),
    Step1Occupation(),
    Step2WorkSchedule(),
    Step3PrayerSettings(),
    Step4Fitness(),
    Step5Sleep(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OnboardingBloc, OnboardingState>(
      listenWhen: (prev, curr) =>
          prev.currentStep != curr.currentStep ||
          prev.status != curr.status,
      listener: (context, state) {
        // Track direction for slide animation
        if (state.currentStep != _displayedStep) {
          setState(() {
            _goingForward = state.currentStep > _displayedStep;
            _displayedStep = state.currentStep;
          });
        }

        // Show validation errors
        if (state.status == OnboardingStatus.stepInvalid &&
            state.errorMessage != null) {
          _showSnackBar(context, state.errorMessage!, isError: true);
        }

        // Navigate on success — load saved profile and pass it to HomeShell
        if (state.status == OnboardingStatus.success) {
          AppDependencies.getUserProfile(const NoParams()).then((result) {
            if (!context.mounted) return;
            final profile = result.fold((_) => null, (p) => p);
            context.go(AppRouter.home, extra: profile);
          });
        }

        // Show generic errors
        if (state.status == OnboardingStatus.failure &&
            state.errorMessage != null) {
          _showSnackBar(context, state.errorMessage!, isError: true);
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: SafeArea(
            child: Column(
              children: [
                // ── Top bar ─────────────────────────────────────────────────
                _buildTopBar(context, state),

                // ── Step content with directional slide+fade transition ──────
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 380),
                    reverseDuration: const Duration(milliseconds: 250),
                    transitionBuilder: _stepTransition,
                    child: KeyedSubtree(
                      key: ValueKey<int>(_displayedStep),
                      child: _StepEntrance(
                        child: _steps[_displayedStep],
                      ),
                    ),
                  ),
                ),

                // ── Bottom navigation ────────────────────────────────────────
                _buildBottomNav(context, state),
              ],
            ),
          ),
        );
      },
    );
  }

  // ── Transition builder ──────────────────────────────────────────────────────
  Widget _stepTransition(Widget child, Animation<double> animation) {
    // Incoming child: slides in from the correct side + fades in
    // Outgoing child: gets the reverse animation (0→1 reversed = 1→0) so it
    //   slides out to the opposite side + fades out automatically.
    final direction = _goingForward ? 1.0 : -1.0;
    final offset = Tween<Offset>(
      begin: Offset(direction * 0.18, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic));

    return FadeTransition(
      opacity: CurvedAnimation(parent: animation, curve: Curves.easeIn),
      child: SlideTransition(position: offset, child: child),
    );
  }

  // ── Top bar ─────────────────────────────────────────────────────────────────
  Widget _buildTopBar(BuildContext context, OnboardingState state) {
    return Padding(
      padding: EdgeInsets.fromLTRB(context.screenHPadding, 16, context.screenHPadding, 12),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Back button
              if (state.currentStep > 0)
                GestureDetector(
                  onTap: () => context
                      .read<OnboardingBloc>()
                      .add(const OnboardingPreviousStep()),
                  child: Builder(
                    builder: (ctx) {
                      final cs = Theme.of(ctx).colorScheme;
                      final isRtl =
                          Localizations.localeOf(ctx).languageCode == 'ar';
                      return Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: cs.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          isRtl
                              ? Icons.arrow_forward_ios
                              : Icons.arrow_back_ios_new,
                          size: 16,
                          color: cs.onSurface,
                        ),
                      );
                    },
                  ),
                )
              else
                const SizedBox(width: 40),

              // Step counter
              Text(
                'Step ${state.currentStep + 1} of ${OnboardingBloc.totalSteps}',
                style: AppTextStyles.labelSmall,
              ),

              // Skip button (only for optional steps 4 & 5)
              if (state.currentStep >= 4)
                GestureDetector(
                  onTap: () => context
                      .read<OnboardingBloc>()
                      .add(const OnboardingNextStep()),
                  child: Text(
                    'Skip',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )
              else
                const SizedBox(width: 40),
            ],
          ),
          const SizedBox(height: 14),
          OnboardingProgressBar(
            currentStep: state.currentStep,
            totalSteps: OnboardingBloc.totalSteps,
          ),
        ],
      ),
    );
  }

  // ── Bottom nav ──────────────────────────────────────────────────────────────
  Widget _buildBottomNav(BuildContext context, OnboardingState state) {
    final isLastStep = state.currentStep == OnboardingBloc.totalSteps - 1;
    final isLoading = state.status == OnboardingStatus.submitting ||
        state.status == OnboardingStatus.locationLoading;

    return Padding(
      padding: EdgeInsets.fromLTRB(context.screenHPadding, 12, context.screenHPadding, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (state.status == OnboardingStatus.stepInvalid &&
              state.errorMessage != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: InfoBanner(
                text: state.errorMessage!,
                icon: Icons.info_outline,
                color: AppColors.error,
              ),
            ),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: isLoading
                  ? null
                  : () => context
                      .read<OnboardingBloc>()
                      .add(const OnboardingNextStep()),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    isLastStep ? AppColors.gold : AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
              ),
              child: isLoading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      isLastStep ? 'Start My Journey ✨' : 'Continue',
                      style: AppTextStyles.labelLarge.copyWith(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message,
      {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message,
            style: AppTextStyles.bodyMedium.copyWith(color: Colors.white)),
        backgroundColor: isError ? AppColors.error : AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}

// ── Step entrance animation ───────────────────────────────────────────────────
/// Wraps each step's content in a subtle scale + fade entrance animation that
/// plays once when the step first appears (driven by the AnimatedSwitcher
/// transition, but adds the card-level pop-in feel).
class _StepEntrance extends StatefulWidget {
  final Widget child;
  const _StepEntrance({required this.child});

  @override
  State<_StepEntrance> createState() => _StepEntranceState();
}

class _StepEntranceState extends State<_StepEntrance>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
    );
    _scale = Tween<double>(begin: 0.96, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOut),
    );
    _fade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeIn),
    );
    // Delay slightly so the slide transition leads
    Future.microtask(() {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, child) => Opacity(
        opacity: _fade.value,
        child: Transform.scale(scale: _scale.value, child: child),
      ),
      child: widget.child,
    );
  }
}
