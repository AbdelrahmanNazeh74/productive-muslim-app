import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../shared/theme/app_theme.dart';
import '../bloc/settings_bloc.dart';

class AppearancePage extends StatelessWidget {
  const AppearancePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Appearance'),
        backgroundColor: AppColors.background,
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
              _sectionLabel('Theme'),
              _buildCard(children: [
                _buildThemeOption(
                  context,
                  mode: 'light',
                  label: 'Light',
                  icon: Icons.wb_sunny_outlined,
                  subtitle: 'Classic bright interface',
                  selected: s.themeMode == 'light',
                ),
                _divider(),
                _buildThemeOption(
                  context,
                  mode: 'dark',
                  label: 'Dark',
                  icon: Icons.nights_stay_outlined,
                  subtitle: 'Easy on the eyes at night',
                  selected: s.themeMode == 'dark',
                ),
                _divider(),
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
              _sectionLabel('Date & Time'),
              _buildCard(children: [
                _buildToggleTile(
                  icon: Icons.calendar_today_outlined,
                  iconColor: const Color(0xFF1B6B3A),
                  title: 'Show Hijri Date',
                  subtitle: 'Display Islamic calendar date in headers',
                  value: s.showHijriDate,
                  onChanged: (v) => context
                      .read<SettingsBloc>()
                      .add(SettingsHijriDisplayToggled(v)),
                ),
                _divider(),
                _buildToggleTile(
                  icon: Icons.access_time_outlined,
                  iconColor: AppColors.primary,
                  title: '24-Hour Time',
                  subtitle: 'Use 14:30 instead of 2:30 PM',
                  value: s.show24HourTime,
                  onChanged: (v) => context
                      .read<SettingsBloc>()
                      .add(Settings24HourToggled(v)),
                ),
              ]),
              const SizedBox(height: 16),
              _sectionLabel('Language'),
              _buildCard(children: [
                _buildLanguageOption(
                  context,
                  code: 'en',
                  label: 'English',
                  selected: s.language == 'en',
                ),
                _divider(),
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

  Widget _sectionLabel(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: AppTextStyles.labelSmall
            .copyWith(color: AppColors.textHint, letterSpacing: 1.2),
      ),
    );
  }

  Widget _buildCard({required List<Widget> children}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
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
      child: Column(children: children),
    );
  }

  Widget _divider() =>
      const Divider(height: 1, indent: 56, color: AppColors.surfaceVariant);

  Widget _buildThemeOption(
    BuildContext context, {
    required String mode,
    required String label,
    required IconData icon,
    required String subtitle,
    required bool selected,
  }) {
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
                    ? AppColors.primary.withValues(alpha: 0.12)
                    : AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                size: 20,
                color: selected ? AppColors.primary : AppColors.textSecondary,
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
                      color: selected
                          ? AppColors.primary
                          : AppColors.textPrimary,
                    ),
                  ),
                  Text(subtitle, style: AppTextStyles.bodyMedium),
                ],
              ),
            ),
            if (selected)
              const Icon(Icons.check_circle,
                  color: AppColors.primary, size: 22)
            else
              const Icon(Icons.radio_button_unchecked,
                  color: AppColors.textHint, size: 22),
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
                    ? AppColors.primary.withValues(alpha: 0.12)
                    : AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  code == 'ar' ? 'ع' : 'A',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: selected ? AppColors.primary : AppColors.textSecondary,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.labelLarge.copyWith(
                  color: selected ? AppColors.primary : AppColors.textPrimary,
                ),
              ),
            ),
            if (selected)
              const Icon(Icons.check_circle, color: AppColors.primary, size: 22)
            else
              const Icon(Icons.radio_button_unchecked,
                  color: AppColors.textHint, size: 22),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
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
                Text(title, style: AppTextStyles.labelLarge),
                Text(subtitle, style: AppTextStyles.bodyMedium),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeTrackColor: AppColors.primary,
          ),
        ],
      ),
    );
  }
}
