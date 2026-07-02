import 'package:flutter/material.dart';

import '../../../../../shared/theme/app_theme.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/di/app_dependencies.dart';
import '../../../../features/onboarding/domain/entities/user_profile.dart';
import '../../../../features/timeline/presentation/bloc/timeline_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PrayerSettingsPage extends StatefulWidget {
  final UserProfile? profile;
  const PrayerSettingsPage({super.key, this.profile});

  @override
  State<PrayerSettingsPage> createState() => _PrayerSettingsPageState();
}

class _PrayerSettingsPageState extends State<PrayerSettingsPage> {
  late String _calculationMethod;
  late String _madhab;
  late int _bufferMinutes;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final p = widget.profile;
    _calculationMethod = p?.calculationMethod ?? 'UmmAlQura';
    _madhab = p?.madhab ?? 'shafi';
    _bufferMinutes = p?.prayerBufferMinutes ?? 10;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Prayer Settings'),
        backgroundColor: AppColors.background,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: _isSaving ? null : _save,
            child: _isSaving
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text('Save',
                    style: AppTextStyles.labelLarge
                        .copyWith(color: AppColors.primary)),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildCard(
            title: 'Calculation Method',
            subtitle:
                'Determines Fajr and Isha angles based on your region',
            child: Column(
              children: PrayerCalculationMethods.methods.map((m) {
                return _RadioTile<String>(
                  value: m['id']!,
                  groupValue: _calculationMethod,
                  title: m['label']!,
                  subtitle: m['region']!,
                  onChanged: (v) =>
                      setState(() => _calculationMethod = v!),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),
          _buildCard(
            title: 'Madhab (Asr Time)',
            subtitle: 'Controls when Asr prayer begins',
            child: Column(
              children: MadhabConstants.madhhabs.map((m) {
                return _RadioTile<String>(
                  value: m['id']!,
                  groupValue: _madhab,
                  title: m['label']!,
                  subtitle: m['description']!,
                  onChanged: (v) => setState(() => _madhab = v!),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),
          _buildCard(
            title: 'Prayer Buffer',
            subtitle:
                'Minutes blocked before each prayer for wudu and preparation',
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Buffer time',
                          style: AppTextStyles.labelLarge),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '$_bufferMinutes min',
                          style: AppTextStyles.labelLarge
                              .copyWith(color: AppColors.primary),
                        ),
                      ),
                    ],
                  ),
                  Slider(
                    value: _bufferMinutes.toDouble(),
                    min: 0,
                    max: 30,
                    divisions: 6,
                    activeColor: AppColors.primary,
                    label: '$_bufferMinutes min',
                    onChanged: (v) =>
                        setState(() => _bufferMinutes = v.round()),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('None',
                          style: AppTextStyles.bodyMedium
                              .copyWith(fontSize: 11)),
                      Text('30 min',
                          style: AppTextStyles.bodyMedium
                              .copyWith(fontSize: 11)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1B6B3A).withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(
                  color: const Color(0xFF1B6B3A).withValues(alpha: 0.2)),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline,
                    color: Color(0xFF1B6B3A), size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Changes take effect immediately and today\'s timeline will be recalculated.',
                    style: AppTextStyles.bodyMedium
                        .copyWith(color: const Color(0xFF1B6B3A)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildCard(
      {required String title,
      required String subtitle,
      required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
            child: Text(title, style: AppTextStyles.titleMedium),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Text(subtitle, style: AppTextStyles.bodyMedium),
          ),
          const Divider(height: 1),
          child,
        ],
      ),
    );
  }

  Future<void> _save() async {
    final p = widget.profile;
    if (p == null) return;

    setState(() => _isSaving = true);

    final updated = p.copyWith(
      calculationMethod: _calculationMethod,
      madhab: _madhab,
      prayerBufferMinutes: _bufferMinutes,
    );

    final result = await AppDependencies.updateUserProfile(updated);
    result.fold(
      (f) {
        setState(() => _isSaving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Save failed: ${f.message}')),
        );
      },
      (saved) {
        if (context.mounted) {
          context.read<TimelineBloc>().add(TimelineGenerateRequested(
                profile: saved,
                date: DateTime.now(),
              ));
        }
        setState(() => _isSaving = false);
        if (context.mounted) Navigator.of(context).pop();
      },
    );
  }
}

// ─── RADIO TILE ───────────────────────────────────────────────────────────────
class _RadioTile<T> extends StatelessWidget {
  final T value;
  final T groupValue;
  final String title;
  final String subtitle;
  final ValueChanged<T?> onChanged;

  const _RadioTile({
    required this.value,
    required this.groupValue,
    required this.title,
    required this.subtitle,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final selected = value == groupValue;
    return InkWell(
      onTap: () => onChanged(value),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            Radio<T>(
              value: value,
              // ignore: deprecated_member_use
              groupValue: groupValue,
              // ignore: deprecated_member_use
              onChanged: onChanged,
              activeColor: AppColors.primary,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.labelLarge.copyWith(
                      color: selected
                          ? AppColors.primary
                          : AppColors.textPrimary,
                    ),
                  ),
                  Text(subtitle, style: AppTextStyles.bodyMedium),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
