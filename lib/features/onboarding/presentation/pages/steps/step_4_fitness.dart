import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/utils/responsive.dart';
import '../../../../../shared/theme/app_theme.dart';
import '../../bloc/onboarding_bloc.dart';
import '../../widgets/onboarding_widgets.dart';

class Step4Fitness extends StatelessWidget {
  const Step4Fitness({super.key});

  static const List<String> _dayLabels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingBloc, OnboardingState>(
      builder: (context, state) {
        final hasActivity = state.fitnessActivityIds.isNotEmpty &&
            !state.fitnessActivityIds.contains('none');

        return SingleChildScrollView(
          padding: context.screenPadding.copyWith(top: 24, bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const OnboardingStepHeader(
                title: 'Fitness Goals',
                subtitle:
                    'We\'ll build workout blocks around your prayers â€” no more skipping gym for Asr.',
                emoji: 'ðŸ‹ï¸',
              ),

              const SizedBox(height: AppSpacing.xl),

              // Activity types
              const SectionLabel('ACTIVITIES (SELECT ALL THAT APPLY)'),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: FitnessConstants.activities.map((activity) {
                  final isSelected =
                      state.fitnessActivityIds.contains(activity['id']);
                  return _ActivityChip(
                    label: activity['label']!,
                    emoji: activity['emoji']!,
                    isSelected: isSelected,
                    onTap: () => context
                        .read<OnboardingBloc>()
                        .add(OnboardingFitnessActivityToggled(activity['id']!)),
                  );
                }).toList(),
              ),

              if (hasActivity) ...[
                const SizedBox(height: AppSpacing.xl),

                // Gym days
                const SectionLabel('WORKOUT DAYS'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(7, (i) {
                    return DayChip(
                      label: _dayLabels[i],
                      isSelected: state.gymDays.contains(i),
                      onTap: () => context
                          .read<OnboardingBloc>()
                          .add(OnboardingGymDayToggled(i)),
                    );
                  }),
                ),

                const SizedBox(height: AppSpacing.xl),

                // Duration
                const SectionLabel('SESSION DURATION'),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: FitnessConstants.durations.map((d) {
                    final isSelected =
                        state.gymDurationMinutes == d['id'];
                    return _DurationChip(
                      label: d['label'] as String,
                      isSelected: isSelected,
                      onTap: () => context
                          .read<OnboardingBloc>()
                          .add(OnboardingGymDurationChanged(d['id'] as int)),
                    );
                  }).toList(),
                ),

                const SizedBox(height: AppSpacing.xl),

                // Preferred time
                const SectionLabel('PREFERRED TIME'),
                ...FitnessConstants.preferredTimes.map((t) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: SelectionCard(
                      label: t['label']!,
                      emoji: t['emoji'],
                      isSelected: state.preferredGymTime == t['id'],
                      onTap: () => context
                          .read<OnboardingBloc>()
                          .add(OnboardingPreferredGymTimeChanged(t['id']!)),
                    ),
                  );
                }),

                const SizedBox(height: AppSpacing.md),

                const InfoBanner(
                  text:
                      'Workout slots will be auto-scheduled around prayers, never overlapping with Salah time.',
                  icon: Icons.schedule_outlined,
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

// â”€â”€â”€ Activity Chip â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
class _ActivityChip extends StatelessWidget {
  final String label;
  final String emoji;
  final bool isSelected;
  final VoidCallback onTap;

  const _ActivityChip({
    required this.label,
    required this.emoji,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.1)
              : AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(AppRadius.full),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 16)),
            const SizedBox(width: 6),
            Text(
              label,
              style: AppTextStyles.bodyMedium.copyWith(
                color: isSelected ? AppColors.primary : AppColors.textPrimary,
                fontWeight:
                    isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// â”€â”€â”€ Duration Chip â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
class _DurationChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _DurationChip({
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
        padding:
            const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(AppRadius.full),
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
