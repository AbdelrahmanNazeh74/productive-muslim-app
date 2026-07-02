import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utils/responsive.dart';
import '../../../../../shared/theme/app_theme.dart';
import '../../bloc/onboarding_bloc.dart';
import '../../widgets/onboarding_widgets.dart';

class Step2WorkSchedule extends StatelessWidget {
  const Step2WorkSchedule({super.key});

  static const List<String> _dayLabels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingBloc, OnboardingState>(
      builder: (context, state) {
        final isStudent = state.occupationType == 'student';
        final isHomemaker = state.occupationType == 'home';

        return SingleChildScrollView(
          padding: context.screenPadding.copyWith(top: 24, bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              OnboardingStepHeader(
                title: isStudent ? 'Your Study Hours' : 'Your Work Hours',
                subtitle: isHomemaker
                    ? 'Set the hours you\'d like to focus on home tasks.'
                    : 'Tell us when your ${isStudent ? 'classes or study sessions' : 'shift'} typically run.',
                emoji: isStudent ? '📖' : '⏰',
              ),

              const SizedBox(height: AppSpacing.xl),

              // Time pickers
              const SectionLabel('SHIFT TIMES'),
              TimePickerTile(
                label: isStudent ? 'Classes start' : 'Work starts',
                hour: state.workStartHour,
                minute: state.workStartMinute,
                onTap: () async {
                  final picked = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay(
                      hour: state.workStartHour,
                      minute: state.workStartMinute,
                    ),
                    builder: (ctx, child) => _timePickerTheme(ctx, child),
                  );
                  if (picked != null && context.mounted) {
                    context.read<OnboardingBloc>().add(
                          OnboardingWorkStartTimeChanged(
                              picked.hour, picked.minute),
                        );
                  }
                },
              ),

              const SizedBox(height: AppSpacing.sm),

              TimePickerTile(
                label: isStudent ? 'Classes end' : 'Work ends',
                hour: state.workEndHour,
                minute: state.workEndMinute,
                onTap: () async {
                  final picked = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay(
                      hour: state.workEndHour,
                      minute: state.workEndMinute,
                    ),
                    builder: (ctx, child) => _timePickerTheme(ctx, child),
                  );
                  if (picked != null && context.mounted) {
                    context.read<OnboardingBloc>().add(
                          OnboardingWorkEndTimeChanged(
                              picked.hour, picked.minute),
                        );
                  }
                },
              ),

              if ((state.workEndHour * 60 + state.workEndMinute) <=
                  (state.workStartHour * 60 + state.workStartMinute))
                const Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: InfoBanner(
                    text: 'End time must be after start time.',
                    icon: Icons.warning_amber_outlined,
                    color: AppColors.error,
                  ),
                ),

              const SizedBox(height: AppSpacing.xl),

              // Duration summary
              if ((state.workEndHour * 60 + state.workEndMinute) >
                  (state.workStartHour * 60 + state.workStartMinute))
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.bolt,
                          color: AppColors.gold, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        '${_durationHours(state)} hours of focused ${isStudent ? 'study' : 'work'} time',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: AppSpacing.xl),

              // Work days
              const SectionLabel('ACTIVE DAYS'),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(7, (i) {
                  return DayChip(
                    label: _dayLabels[i],
                    isSelected: state.workDays.contains(i),
                    onTap: () => context
                        .read<OnboardingBloc>()
                        .add(OnboardingWorkDayToggled(i)),
                  );
                }),
              ),

              const SizedBox(height: 12),

              // Quick-select presets
              Row(
                children: [
                  _PresetChip(
                    label: 'Mon–Fri',
                    onTap: () {
                      for (int i = 0; i < 7; i++) {
                        final shouldBeActive = i < 5;
                        final isActive = state.workDays.contains(i);
                        if (shouldBeActive != isActive) {
                          context
                              .read<OnboardingBloc>()
                              .add(OnboardingWorkDayToggled(i));
                        }
                      }
                    },
                  ),
                  const SizedBox(width: 8),
                  _PresetChip(
                    label: 'Sun–Thu',
                    onTap: () {
                      // Sun=6, Mon=0, Tue=1, Wed=2, Thu=3
                      final sunThu = [0, 1, 2, 3, 6];
                      for (int i = 0; i < 7; i++) {
                        final shouldBeActive = sunThu.contains(i);
                        final isActive = state.workDays.contains(i);
                        if (shouldBeActive != isActive) {
                          context
                              .read<OnboardingBloc>()
                              .add(OnboardingWorkDayToggled(i));
                        }
                      }
                    },
                  ),
                ],
              ),

              const SizedBox(height: AppSpacing.lg),

              const InfoBanner(
                text:
                    'Prayer times will never conflict with your work blocks — we always build in buffer time.',
                icon: Icons.mosque_outlined,
                color: AppColors.primary,
              ),
            ],
          ),
        );
      },
    );
  }

  int _durationHours(OnboardingState state) {
    return ((state.workEndHour * 60 + state.workEndMinute) -
            (state.workStartHour * 60 + state.workStartMinute)) ~/
        60;
  }

  Widget _timePickerTheme(BuildContext context, Widget? child) {
    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme: const ColorScheme.light(
          primary: AppColors.primary,
          onPrimary: Colors.white,
          surface: AppColors.surface,
        ),
      ),
      child: child!,
    );
  }
}

class _PresetChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _PresetChip({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(AppRadius.full),
        ),
        child: Text(label, style: AppTextStyles.labelLarge.copyWith(
          fontSize: 13,
          color: AppColors.primary,
        )),
      ),
    );
  }
}
