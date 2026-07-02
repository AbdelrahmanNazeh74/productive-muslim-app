import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/theme/app_theme.dart';
import '../../../../features/onboarding/domain/entities/user_profile.dart';
import '../../../../features/onboarding/presentation/widgets/onboarding_widgets.dart';
import '../../domain/entities/ramadan_entities.dart';
import '../bloc/ramadan_bloc.dart';

class RamadanSettingsPage extends StatefulWidget {
  final UserProfile profile;
  const RamadanSettingsPage({super.key, required this.profile});

  @override
  State<RamadanSettingsPage> createState() => _RamadanSettingsPageState();
}

class _RamadanSettingsPageState extends State<RamadanSettingsPage> {
  late RamadanProfile _draft;

  @override
  void initState() {
    super.initState();
    final existing =
        context.read<RamadanBloc>().state.ramadanProfile;
    _draft = existing ??
        RamadanProfile(
          id: 0,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
  }

  void _save() {
    context.read<RamadanBloc>().add(
          RamadanProfileUpdated(
              _draft.copyWith(updatedAt: DateTime.now())),
        );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Ramadan Settings'),
        actions: [
          TextButton(
            onPressed: _save,
            child: Text(
              'Save',
              style: AppTextStyles.labelLarge
                  .copyWith(color: AppColors.primary),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
        children: [
          // ── Suhoor ─────────────────────────────────────────────────────────
          _Section(
            emoji: '🌙',
            title: 'Suhoor',
            child: Column(
              children: [
                _SliderRow(
                  label: 'Wake up before Fajr',
                  value: _draft.suhoorWakeMinutesBeforeFajr.toDouble(),
                  min: 20,
                  max: 90,
                  divisions: 14,
                  format: (v) => '${v.round()} min',
                  color: AppColors.fajr,
                  onChanged: (v) => setState(() => _draft =
                      _draft.copyWith(
                          suhoorWakeMinutesBeforeFajr: v.round())),
                ),
                const SizedBox(height: 12),
                _SliderRow(
                  label: 'Suhoor meal duration',
                  value: _draft.suhoorDurationMinutes.toDouble(),
                  min: 15,
                  max: 45,
                  divisions: 6,
                  format: (v) => '${v.round()} min',
                  color: AppColors.fajr,
                  onChanged: (v) => setState(() => _draft =
                      _draft.copyWith(
                          suhoorDurationMinutes: v.round())),
                ),
              ],
            ),
          ),

          // ── Iftar ──────────────────────────────────────────────────────────
          _Section(
            emoji: '🌅',
            title: 'Iftar',
            child: Column(
              children: [
                _ToggleRow(
                  label: 'Iftar with family/community',
                  subtitle: 'Extends Iftar block to 45 min',
                  value: _draft.hasIftarGathering,
                  onChanged: (v) => setState(() =>
                      _draft = _draft.copyWith(hasIftarGathering: v)),
                ),
                const SizedBox(height: 12),
                _SliderRow(
                  label: 'Iftar duration',
                  value: _draft.iftarDurationMinutes.toDouble(),
                  min: 20,
                  max: 90,
                  divisions: 14,
                  format: (v) => '${v.round()} min',
                  color: AppColors.maghrib,
                  onChanged: (v) => setState(() => _draft =
                      _draft.copyWith(iftarDurationMinutes: v.round())),
                ),
              ],
            ),
          ),

          // ── Tarawih ────────────────────────────────────────────────────────
          _Section(
            emoji: '🌙',
            title: 'Tarawih',
            child: Column(
              children: [
                _ToggleRow(
                  label: 'Pray Tarawih',
                  value: _draft.praysTarawih,
                  onChanged: (v) => setState(
                      () => _draft = _draft.copyWith(praysTarawih: v)),
                ),
                if (_draft.praysTarawih) ...[
                  const SizedBox(height: 12),
                  _SliderRow(
                    label: 'Tarawih duration',
                    value: _draft.tarawihDurationMinutes.toDouble(),
                    min: 30,
                    max: 120,
                    divisions: 9,
                    format: (v) => '${v.round()} min',
                    color: AppColors.isha,
                    onChanged: (v) => setState(() => _draft =
                        _draft.copyWith(
                            tarawihDurationMinutes: v.round())),
                  ),
                  const SizedBox(height: 12),
                  _ToggleRow(
                    label: 'Include Witr',
                    value: _draft.praysWitr,
                    onChanged: (v) => setState(
                        () => _draft = _draft.copyWith(praysWitr: v)),
                  ),
                ],
                const SizedBox(height: 12),
                _ToggleRow(
                  label: 'Laylat al-Qadr mode (last 10 nights)',
                  subtitle:
                      'Extends Tarawih + adds Qiyam al-Layl on odd nights',
                  value: _draft.hasLaylatAlQadrMode,
                  onChanged: (v) => setState(() =>
                      _draft = _draft.copyWith(hasLaylatAlQadrMode: v)),
                ),
              ],
            ),
          ),

          // ── Work hours ─────────────────────────────────────────────────────
          _Section(
            emoji: '💼',
            title: 'Work Hours',
            child: Column(
              children: [
                _ToggleRow(
                  label: 'Reduced work hours in Ramadan',
                  subtitle: 'Adjust end time for fasting energy levels',
                  value: _draft.hasReducedWorkHours,
                  onChanged: (v) => setState(() => _draft =
                      _draft.copyWith(hasReducedWorkHours: v)),
                ),
                if (_draft.hasReducedWorkHours) ...[
                  const SizedBox(height: 12),
                  TimePickerTile(
                    label: 'Work ends at',
                    hour: _draft.reducedWorkEndHour,
                    minute: _draft.reducedWorkEndMinute,
                    onTap: () async {
                      final picked = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay(
                          hour: _draft.reducedWorkEndHour,
                          minute: _draft.reducedWorkEndMinute,
                        ),
                      );
                      if (picked != null) {
                        setState(() => _draft = _draft.copyWith(
                              reducedWorkEndHour: picked.hour,
                              reducedWorkEndMinute: picked.minute,
                            ));
                      }
                    },
                  ),
                ],
              ],
            ),
          ),

          // ── Sleep ──────────────────────────────────────────────────────────
          _Section(
            emoji: '😴',
            title: 'Ramadan Sleep',
            child: Column(
              children: [
                const InfoBanner(
                  text:
                      'Ramadan sleep splits into night (after Tarawih) and day (Qaylula). These settings tune both windows.',
                  icon: Icons.info_outline,
                ),
                const SizedBox(height: 12),
                _SliderRow(
                  label: 'Night sleep',
                  value: _draft.nightSleepHours.toDouble(),
                  min: 2,
                  max: 6,
                  divisions: 4,
                  format: (v) => '${v.round()}h',
                  color: AppColors.isha,
                  onChanged: (v) => setState(() => _draft =
                      _draft.copyWith(nightSleepHours: v.round())),
                ),
                const SizedBox(height: 12),
                _SliderRow(
                  label: 'Qaylula (day nap)',
                  value: _draft.daySleepMinutes.toDouble(),
                  min: 30,
                  max: 120,
                  divisions: 9,
                  format: (v) => '${v.round()} min',
                  color: AppColors.dhuhr,
                  onChanged: (v) => setState(() => _draft =
                      _draft.copyWith(daySleepMinutes: v.round())),
                ),
              ],
            ),
          ),

          // ── Quran ──────────────────────────────────────────────────────────
          _Section(
            emoji: '📖',
            title: 'Quran Goal',
            child: Column(
              children: [
                _SliderRow(
                  label: 'Pages per day',
                  value: _draft.ramadanQuranPagesGoal.toDouble(),
                  min: 5,
                  max: 60,
                  divisions: 11,
                  format: (v) {
                    final pages = v.round();
                    final days = (604 / pages).ceil();
                    return '$pages pages (Khatm in $days days)';
                  },
                  color: AppColors.gold,
                  onChanged: (v) => setState(() => _draft =
                      _draft.copyWith(ramadanQuranPagesGoal: v.round())),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: _save,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.gold,
              ),
              child: Text(
                'Save Ramadan Settings',
                style: AppTextStyles.labelLarge.copyWith(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── REUSABLE SETTING WIDGETS ────────────────────────────────────────────────
class _Section extends StatelessWidget {
  final String emoji;
  final String title;
  final Widget child;

  const _Section(
      {required this.emoji, required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
            color: Theme.of(context).colorScheme.outlineVariant, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Text(title,
                  style: AppTextStyles.titleMedium.copyWith(
                      color: Theme.of(context).colorScheme.onSurface)),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

class _SliderRow extends StatelessWidget {
  final String label;
  final double value;
  final double min;
  final double max;
  final int divisions;
  final String Function(double) format;
  final Color color;
  final ValueChanged<double> onChanged;

  const _SliderRow({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.divisions,
    required this.format,
    required this.color,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: AppTextStyles.bodyMedium),
            Text(
              format(value),
              style: AppTextStyles.labelLarge
                  .copyWith(color: color, fontSize: 13),
            ),
          ],
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: divisions,
          activeColor: color,
          inactiveColor: Theme.of(context).colorScheme.outlineVariant,
          onChanged: onChanged,
        ),
      ],
    );
  }
}

class _ToggleRow extends StatelessWidget {
  final String label;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ToggleRow({
    required this.label,
    this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: AppTextStyles.bodyMedium
                  .copyWith(color: Theme.of(context).colorScheme.onSurface)),
              if (subtitle != null)
                Text(subtitle!,
                    style: AppTextStyles.bodyMedium
                        .copyWith(fontSize: 12)),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeThumbColor: AppColors.primary,
        ),
      ],
    );
  }
}
