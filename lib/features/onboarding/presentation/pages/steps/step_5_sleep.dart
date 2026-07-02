import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/utils/responsive.dart';
import '../../../../../shared/theme/app_theme.dart';
import '../../bloc/onboarding_bloc.dart';
import '../../widgets/onboarding_widgets.dart';

class Step5Sleep extends StatelessWidget {
  const Step5Sleep({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingBloc, OnboardingState>(
      builder: (context, state) {
        return SingleChildScrollView(
          padding: context.screenPadding.copyWith(top: 24, bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const OnboardingStepHeader(
                title: 'Sleep & Quran',
                subtitle:
                    'Good sleep fuels your ibadah and your work. Let\'s set a plan that honors both.',
                emoji: '🌙',
              ),

              const SizedBox(height: AppSpacing.xl),

              // Sleep hours target
              const SectionLabel('TARGET SLEEP HOURS'),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: SleepConstants.targetHours.map((h) {
                  final isSelected = state.targetSleepHours == h['id'];
                  return _SleepChip(
                    label: h['label'] as String,
                    isSelected: isSelected,
                    onTap: () => context
                        .read<OnboardingBloc>()
                        .add(OnboardingTargetSleepHoursChanged(h['id'] as int)),
                  );
                }).toList(),
              ),

              const SizedBox(height: AppSpacing.xl),

              // Wake up relative to Fajr
              const SectionLabel('WAKE UP TIME'),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.fajr.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  border: Border.all(color: AppColors.fajr.withValues(alpha: 0.15)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text('🌅', style: TextStyle(fontSize: 20)),
                        const SizedBox(width: 8),
                        Text(
                          'Relative to Fajr',
                          style: AppTextStyles.titleMedium
                              .copyWith(color: AppColors.fajr),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ...SleepConstants.fajrOffsets.map((offset) {
                      final isSelected =
                          state.wakeUpOffsetFromFajrMinutes == offset['id'];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: InkWell(
                          onTap: () => context
                              .read<OnboardingBloc>()
                              .add(OnboardingFajrOffsetChanged(
                                  offset['id'] as int)),
                          borderRadius:
                              BorderRadius.circular(AppRadius.sm),
                          child: Row(
                            children: [
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 180),
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isSelected
                                      ? AppColors.fajr
                                      : Colors.transparent,
                                  border: Border.all(
                                    color: isSelected
                                        ? AppColors.fajr
                                        : AppColors.stepInactive,
                                    width: 2,
                                  ),
                                ),
                                child: isSelected
                                    ? const Icon(Icons.check,
                                        color: Colors.white, size: 12)
                                    : null,
                              ),
                              const SizedBox(width: 10),
                              Text(offset['label'] as String,
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: isSelected
                                        ? AppColors.fajr
                                        : AppColors.textPrimary,
                                    fontWeight: isSelected
                                        ? FontWeight.w600
                                        : FontWeight.w400,
                                  )),
                            ],
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.xl),

              // Quran daily goal
              const SectionLabel('DAILY QURAN GOAL'),
              const InfoBanner(
                text:
                    'A consistent small amount is better than an inconsistent large one. We\'ll suggest a reading slot after Fajr.',
                icon: Icons.auto_stories_outlined,
                color: AppColors.gold,
              ),
              const SizedBox(height: 12),
              _QuranGoalSlider(
                value: state.dailyQuranPagesGoal,
                onChanged: (v) => context
                    .read<OnboardingBloc>()
                    .add(OnboardingQuranGoalChanged(v)),
              ),

              const SizedBox(height: AppSpacing.xl),

              // Cycle-aware streaks (female only)
              if (state.gender == 'female') ...[
                const SectionLabel('STREAK SETTINGS'),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.maghrib.withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    border: Border.all(
                        color: AppColors.maghrib.withValues(alpha: 0.15)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Cycle-Aware Streaks',
                              style: AppTextStyles.titleMedium,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'During your cycle, prayer and Quran streaks will be paused — not broken.',
                              style: AppTextStyles.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                      Switch(
                        value: state.cycleAwareStreaks,
                        onChanged: (v) => context
                            .read<OnboardingBloc>()
                            .add(OnboardingCycleAwareToggled(v)),
                        activeThumbColor: AppColors.maghrib,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
              ],

              // Final encouragement
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, AppColors.primaryLight],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                ),
                child: Column(
                  children: [
                    const Text('🤲', style: TextStyle(fontSize: 36)),
                    const SizedBox(height: 12),
                    Text(
                      'You\'re almost there!',
                      style: AppTextStyles.titleMedium
                          .copyWith(color: Colors.white),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Tap "Start My Journey" and we\'ll generate your first personalized day.',
                      style: AppTextStyles.bodyMedium
                          .copyWith(color: Colors.white70),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SleepChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _SleepChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(AppRadius.full),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.transparent,
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.labelLarge.copyWith(
            color: isSelected ? Colors.white : AppColors.textPrimary,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}

class _QuranGoalSlider extends StatelessWidget {
  final int value;
  final ValueChanged<int> onChanged;

  const _QuranGoalSlider({required this.value, required this.onChanged});

  String get _label {
    if (value == 0) return 'No goal yet';
    if (value == 1) return '1 page';
    return '$value pages';
  }

  String get _context {
    if (value == 0) return '';
    final daysToKhatm = (604 / value).ceil();
    return '≈ $daysToKhatm days to complete the Quran';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Daily pages', style: AppTextStyles.bodyMedium),
              Text(
                _label,
                style:
                    AppTextStyles.titleMedium.copyWith(color: AppColors.gold),
              ),
            ],
          ),
          Slider(
            value: value.toDouble(),
            min: 0,
            max: 20,
            divisions: 20,
            activeColor: AppColors.gold,
            inactiveColor: AppColors.stepInactive,
            onChanged: (v) => onChanged(v.round()),
          ),
          if (_context.isNotEmpty)
            Text(
              _context,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.gold,
                fontSize: 12,
              ),
            ),
        ],
      ),
    );
  }
}
