import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/utils/responsive.dart';
import '../../../../../shared/theme/app_theme.dart';
import '../../bloc/onboarding_bloc.dart';
import '../../widgets/onboarding_widgets.dart';

class Step3PrayerSettings extends StatelessWidget {
  const Step3PrayerSettings({super.key});

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
                title: 'Prayer Times',
                subtitle:
                    'Accurate Salah times are the backbone of your daily schedule.',
                emoji: '🕌',
              ),

              const SizedBox(height: AppSpacing.xl),

              // Location section
              const SectionLabel('YOUR LOCATION'),
              if (!state.hasLocationPermission)
                _LocationRequestCard(
                  isLoading:
                      state.status == OnboardingStatus.locationLoading,
                  onRequest: () => context
                      .read<OnboardingBloc>()
                      .add(const OnboardingLocationRequested()),
                )
              else
                _LocationConfirmedCard(
                  city: state.city,
                  lat: state.latitude!,
                  lng: state.longitude!,
                  onReset: () => context
                      .read<OnboardingBloc>()
                      .add(const OnboardingLocationRequested()),
                ),

              const SizedBox(height: AppSpacing.xl),

              // Calculation method
              const SectionLabel('CALCULATION METHOD'),
              _ExpandableMethodPicker(
                selected: state.calculationMethod,
                onChanged: (m) => context
                    .read<OnboardingBloc>()
                    .add(OnboardingCalculationMethodChanged(m)),
              ),

              const SizedBox(height: AppSpacing.xl),

              // Madhab for Asr
              const SectionLabel('MADHAB (FOR ASR TIME)'),
              ...MadhabConstants.madhhabs.map((m) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: SelectionCard(
                    label: m['label']!,
                    subtitle: m['description'],
                    isSelected: state.madhab == m['id'],
                    onTap: () => context
                        .read<OnboardingBloc>()
                        .add(OnboardingMadhabChanged(m['id']!)),
                  ),
                );
              }),

              const SizedBox(height: AppSpacing.xl),

              // Prayer buffer
              const SectionLabel('PRAYER BUFFER TIME'),
              const InfoBanner(
                text:
                    'We add buffer time before each prayer so you can wrap up work, make Wudu, and pray without rushing.',
                icon: Icons.timer_outlined,
              ),
              const SizedBox(height: 12),
              _BufferSlider(
                value: state.prayerBufferMinutes,
                onChanged: (v) => context
                    .read<OnboardingBloc>()
                    .add(OnboardingPrayerBufferChanged(v)),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ─── Location Request Card ─────────────────────────────────────────────────
class _LocationRequestCard extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onRequest;

  const _LocationRequestCard(
      {required this.isLoading, required this.onRequest});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.stepInactive),
      ),
      child: Column(
        children: [
          const Text('📍', style: TextStyle(fontSize: 40)),
          const SizedBox(height: 12),
          Text(
            'Allow Location Access',
            style: AppTextStyles.titleMedium,
          ),
          const SizedBox(height: 6),
          Text(
            'We only use your location to calculate precise prayer times. It\'s stored on your device only.',
            style: AppTextStyles.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: isLoading ? null : onRequest,
              icon: isLoading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white))
                  : const Icon(Icons.my_location, size: 18),
              label: Text(isLoading ? 'Getting location…' : 'Use My Location'),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Location Confirmed Card ───────────────────────────────────────────────
class _LocationConfirmedCard extends StatelessWidget {
  final String city;
  final double lat;
  final double lng;
  final VoidCallback onReset;

  const _LocationConfirmedCard(
      {required this.city,
      required this.lat,
      required this.lng,
      required this.onReset});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.success.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.success.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.location_on,
                color: AppColors.success, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(city,
                    style: AppTextStyles.titleMedium
                        .copyWith(color: AppColors.success)),
                Text(
                  '${lat.toStringAsFixed(4)}, ${lng.toStringAsFixed(4)}',
                  style: AppTextStyles.bodyMedium,
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: onReset,
            child: Text('Change',
                style: AppTextStyles.bodyMedium
                    .copyWith(color: AppColors.primary)),
          ),
        ],
      ),
    );
  }
}

// ─── Calculation Method Picker ────────────────────────────────────────────
class _ExpandableMethodPicker extends StatefulWidget {
  final String selected;
  final ValueChanged<String> onChanged;

  const _ExpandableMethodPicker(
      {required this.selected, required this.onChanged});

  @override
  State<_ExpandableMethodPicker> createState() =>
      _ExpandableMethodPickerState();
}

class _ExpandableMethodPickerState extends State<_ExpandableMethodPicker> {
  bool _expanded = false;

  String get _selectedLabel {
    return PrayerCalculationMethods.methods
        .firstWhere((m) => m['id'] == widget.selected,
            orElse: () => PrayerCalculationMethods.methods.first)['label']!;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Current selection
        InkWell(
          onTap: () => setState(() => _expanded = !_expanded),
          borderRadius: BorderRadius.circular(AppRadius.md),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(_selectedLabel,
                      style: AppTextStyles.titleMedium),
                ),
                Icon(
                  _expanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: AppColors.textSecondary,
                ),
              ],
            ),
          ),
        ),

        if (_expanded) ...[
          const SizedBox(height: AppSpacing.sm),
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(color: AppColors.stepInactive),
            ),
            child: Column(
              children: PrayerCalculationMethods.methods.map((method) {
                final isSelected = widget.selected == method['id'];
                return InkWell(
                  onTap: () {
                    widget.onChanged(method['id']!);
                    setState(() => _expanded = false);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(method['label']!,
                                  style: AppTextStyles.titleMedium.copyWith(
                                    color: isSelected
                                        ? AppColors.primary
                                        : AppColors.textPrimary,
                                    fontSize: 14,
                                  )),
                              Text(method['region']!,
                                  style: AppTextStyles.bodyMedium
                                      .copyWith(fontSize: 12)),
                            ],
                          ),
                        ),
                        if (isSelected)
                          const Icon(Icons.check,
                              color: AppColors.primary, size: 18),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ],
    );
  }
}

// ─── Buffer Slider ────────────────────────────────────────────────────────
class _BufferSlider extends StatelessWidget {
  final int value;
  final ValueChanged<int> onChanged;

  const _BufferSlider({required this.value, required this.onChanged});

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
              Text('Buffer before prayer', style: AppTextStyles.bodyMedium),
              Text(
                '$value min',
                style: AppTextStyles.titleMedium
                    .copyWith(color: AppColors.primary),
              ),
            ],
          ),
          Slider(
            value: value.toDouble(),
            min: 0,
            max: 30,
            divisions: 6,
            activeColor: AppColors.primary,
            inactiveColor: AppColors.stepInactive,
            onChanged: (v) => onChanged(v.round()),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('None', style: AppTextStyles.bodyMedium.copyWith(fontSize: 11)),
              Text('30 min', style: AppTextStyles.bodyMedium.copyWith(fontSize: 11)),
            ],
          ),
        ],
      ),
    );
  }
}
