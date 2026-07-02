import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../shared/theme/app_theme.dart';
import '../bloc/settings_bloc.dart';

class AppearancePage extends StatelessWidget {
  const AppearancePage({super.key});

  @override
  Widget build(BuildContext context) {
    final bg = Theme.of(context).scaffoldBackgroundColor;
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        title: const Text('Appearance'),
        backgroundColor: bg,
        elevation: 0,
      ),
      body: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          if (state is SettingsLoading || state is SettingsInitial) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is! SettingsLoaded) {
            return const Center(child: Text('Unable to load settings'));
          }
          final s = state.settings;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _sectionLabel(context, 'Theme'),
              _buildCard(context, children: [
                _buildThemeOption(
                  context,
                  mode: 'light',
                  label: 'Light',
                  icon: Icons.wb_sunny_outlined,
                  subtitle: 'Classic bright interface',
                  selected: s.themeMode == 'light',
                ),
                _divider(context),
                _buildThemeOption(
                  context,
                  mode: 'dark',
                  label: 'Dark',
                  icon: Icons.nights_stay_outlined,
                  subtitle: 'Easy on the eyes at night',
                  selected: s.themeMode == 'dark',
                ),
                _divider(context),
                _buildThemeOption(
                  context,
                  mode: 'system',
                  label: 'System Default',
                  icon: Icons.brightness_auto_outlined,
                  subtitle: 'Follows your device setting',
                  selected: s.themeMode == 'system',
                ),
              ]),
              const SizedBox(height: 16),
              _sectionLabel(context, 'Date & Time'),
              _buildCard(context, children: [
                _buildToggleTile(
                  context,
                  icon: Icons.calendar_today_outlined,
                  iconColor: const Color(0xFF1B6B3A),
                  title: 'Show Hijri Date',
                  subtitle: 'Display Islamic calendar date in headers',
                  value: s.showHijriDate,
                  onChanged: (v) => context
                      .read<SettingsBloc>()
                      .add(SettingsHijriDisplayToggled(v)),
                ),
                _divider(context),
                _buildToggleTile(
                  context,
                  icon: Icons.access_time_outlined,
                  iconColor: Theme.of(context).colorScheme.primary,
                  title: '24-Hour Time',
                  subtitle: 'Use 14:30 instead of 2:30 PM',
                  value: s.show24HourTime,
                  onChanged: (v) => context
                      .read<SettingsBloc>()
                      .add(Settings24HourToggled(v)),
                ),
              ]),
              const SizedBox(height: 16),
              _sectionLabel(context, 'Language'),
              _buildCard(context, children: [
                _buildLanguageOption(
                  context,
                  code: 'en',
                  label: 'English',
                  selected: s.language == 'en',
                ),
                _divider(context),
                _buildLanguageOption(
                  context,
                  code: 'ar',
                  label: 'العربية',
                  selected: s.language == 'ar',
                ),
              ]),
              const SizedBox(height: 32),
            ],
          );
        },
      ),
    );
  }

  Widget _sectionLabel(BuildContext context, String title) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: AppTextStyles.labelSmall.copyWith(
          color: cs.onSurface.withValues(alpha: 0.5),
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, {required List<Widget> children}) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _divider(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Divider(
      height: 1,
      indent: 56,
      color: cs.outlineVariant.withValues(alpha: 0.5),
    );
  }

  Widget _buildThemeOption(
    BuildContext context, {
    required String mode,
    required String label,
    required IconData icon,
    required String subtitle,
    required bool selected,
  }) {
    final cs = Theme.of(context).colorScheme;
    return InkWell(
      onTap: () => context
          .read<SettingsBloc>()
          .add(SettingsThemeModeChanged(mode)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: selected
                    ? cs.primary.withValues(alpha: 0.12)
                    : cs.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                size: 20,
                color: selected ? cs.primary : cs.onSurfaceVariant,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: AppTextStyles.labelLarge.copyWith(
                      color: selected ? cs.primary : cs.onSurface,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: cs.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            if (selected)
              Icon(Icons.check_circle, color: cs.primary, size: 22)
            else
              Icon(Icons.radio_button_unchecked,
                  color: cs.onSurface.withValues(alpha: 0.4), size: 22),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageOption(
    BuildContext context, {
    required String code,
    required String label,
    required bool selected,
  }) {
    final cs = Theme.of(context).colorScheme;
    return InkWell(
      onTap: () => context
          .read<SettingsBloc>()
          .add(SettingsLanguageChanged(code)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: selected
                    ? cs.primary.withValues(alpha: 0.12)
                    : cs.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  code == 'ar' ? 'ع' : 'A',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: selected ? cs.primary : cs.onSurfaceVariant,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.labelLarge.copyWith(
                  color: selected ? cs.primary : cs.onSurface,
                ),
              ),
            ),
            if (selected)
              Icon(Icons.check_circle, color: cs.primary, size: 22)
            else
              Icon(Icons.radio_button_unchecked,
                  color: cs.onSurface.withValues(alpha: 0.4), size: 22),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleTile(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 20, color: iconColor),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.labelLarge.copyWith(
                    color: cs.onSurface,
                  ),
                ),
                Text(
                  subtitle,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: cs.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeTrackColor: cs.primary,
          ),
        ],
      ),
    );
  }
}
