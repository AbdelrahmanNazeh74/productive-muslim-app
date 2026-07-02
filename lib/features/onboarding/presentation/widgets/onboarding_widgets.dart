import 'package:flutter/material.dart';
import '../../../../shared/theme/app_theme.dart';

// â”€â”€â”€ STEP HEADER â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
class OnboardingStepHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? emoji;

  const OnboardingStepHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.emoji,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (emoji != null) ...[
          Text(emoji!, style: const TextStyle(fontSize: 44)),
          const SizedBox(height: AppSpacing.md),
        ],
        Text(title, style: AppTextStyles.displayMedium),
        const SizedBox(height: AppSpacing.sm),
        Text(subtitle, style: AppTextStyles.bodyMedium),
      ],
    );
  }
}

// â”€â”€â”€ SELECTION CARD â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
class SelectionCard extends StatelessWidget {
  final String label;
  final String? emoji;
  final String? subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  const SelectionCard({
    super.key,
    required this.label,
    this.emoji,
    this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        color: isSelected
            ? AppColors.primary.withValues(alpha: 0.08)
            : AppColors.surface,
        border: Border.all(
          color: isSelected ? AppColors.primary : AppColors.stepInactive,
          width: isSelected ? 2 : 1.5,
        ),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              if (emoji != null) ...[
                Text(emoji!, style: const TextStyle(fontSize: 24)),
                const SizedBox(width: 12),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label,
                        style: AppTextStyles.titleMedium.copyWith(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.textPrimary,
                        )),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(subtitle!, style: AppTextStyles.bodyMedium),
                    ],
                  ],
                ),
              ),
              if (isSelected)
                Container(
                  width: 22,
                  height: 22,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check, color: Colors.white, size: 14),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// â”€â”€â”€ DAY CHIP â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
class DayChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const DayChip({
    super.key,
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
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surfaceVariant,
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.transparent,
            width: 2,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: AppTextStyles.labelLarge.copyWith(
              color: isSelected ? Colors.white : AppColors.textSecondary,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }
}

// â”€â”€â”€ TIME PICKER TILE â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
class TimePickerTile extends StatelessWidget {
  final String label;
  final int hour;
  final int minute;
  final VoidCallback onTap;

  const TimePickerTile({
    super.key,
    required this.label,
    required this.hour,
    required this.minute,
    required this.onTap,
  });

  String get _formatted {
    final period = hour < 12 ? 'AM' : 'PM';
    final h = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
    final m = minute.toString().padLeft(2, '0');
    return '$h:$m $period';
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: AppTextStyles.bodyMedium),
            Row(
              children: [
                Text(_formatted,
                    style: AppTextStyles.titleMedium.copyWith(
                      color: AppColors.primary,
                    )),
                const SizedBox(width: 6),
                const Icon(Icons.access_time,
                    size: 18, color: AppColors.primary),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// â”€â”€â”€ SECTION LABEL â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
class SectionLabel extends StatelessWidget {
  final String text;
  final EdgeInsets? padding;

  const SectionLabel(this.text, {super.key, this.padding});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.only(bottom: 12),
      child: Text(
        text.toUpperCase(),
        style: AppTextStyles.labelSmall.copyWith(
          color: AppColors.textHint,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

// â”€â”€â”€ GENDER TOGGLE â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
class GenderSelector extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onChanged;

  const GenderSelector({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _GenderOption(
            label: 'Male',
            emoji: 'ðŸ‘¨',
            value: 'male',
            selected: selected == 'male',
            onTap: () => onChanged('male'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _GenderOption(
            label: 'Female',
            emoji: 'ðŸ‘©',
            value: 'female',
            selected: selected == 'female',
            onTap: () => onChanged('female'),
          ),
        ),
      ],
    );
  }
}

class _GenderOption extends StatelessWidget {
  final String label;
  final String emoji;
  final String value;
  final bool selected;
  final VoidCallback onTap;

  const _GenderOption({
    required this.label,
    required this.emoji,
    required this.value,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary.withValues(alpha: 0.08)
              : AppColors.surface,
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.stepInactive,
            width: selected ? 2 : 1.5,
          ),
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 30)),
            const SizedBox(height: 8),
            Text(
              label,
              style: AppTextStyles.titleMedium.copyWith(
                color: selected ? AppColors.primary : AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// â”€â”€â”€ STEP PROGRESS BAR â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
class OnboardingProgressBar extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const OnboardingProgressBar({
    super.key,
    required this.currentStep,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(totalSteps, (i) {
        final isCompleted = i < currentStep;
        final isCurrent = i == currentStep;
        return Expanded(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: 3,
            margin: EdgeInsets.only(right: i < totalSteps - 1 ? 4 : 0),
            decoration: BoxDecoration(
              color: isCompleted
                  ? AppColors.gold
                  : isCurrent
                      ? AppColors.primary
                      : AppColors.stepInactive,
              borderRadius: BorderRadius.circular(AppRadius.full),
            ),
          ),
        );
      }),
    );
  }
}

// â”€â”€â”€ INFO BANNER â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
class InfoBanner extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color? color;

  const InfoBanner({
    super.key,
    required this.text,
    required this.icon,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final c = color ?? AppColors.primary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: c.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: c.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: c),
          const SizedBox(width: 10),
          Expanded(
            child: Text(text,
                style:
                    AppTextStyles.bodyMedium.copyWith(color: c, fontSize: 13)),
          ),
        ],
      ),
    );
  }
}
