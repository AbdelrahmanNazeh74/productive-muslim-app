import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../shared/theme/app_theme.dart';
import '../bloc/settings_bloc.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Notifications'),
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
              _buildSectionHeader('Prayer Notifications'),
              _buildCard(children: [
                _buildPrayerToggle(
                  context,
                  prayer: 'fajr',
                  label: 'Fajr',
                  emoji: '🌅',
                  color: const Color(0xFF4A235A),
                  enabled: s.fajrNotification,
                ),
                _divider(),
                _buildPrayerToggle(
                  context,
                  prayer: 'dhuhr',
                  label: 'Dhuhr',
                  emoji: '☀️',
                  color: const Color(0xFF1A5276),
                  enabled: s.dhuhrNotification,
                ),
                _divider(),
                _buildPrayerToggle(
                  context,
                  prayer: 'asr',
                  label: 'Asr',
                  emoji: '🌤',
                  color: const Color(0xFF7E5109),
                  enabled: s.asrNotification,
                ),
                _divider(),
                _buildPrayerToggle(
                  context,
                  prayer: 'maghrib',
                  label: 'Maghrib',
                  emoji: '🌇',
                  color: const Color(0xFF922B21),
                  enabled: s.maghribNotification,
                ),
                _divider(),
                _buildPrayerToggle(
                  context,
                  prayer: 'isha',
                  label: 'Isha',
                  emoji: '🌙',
                  color: const Color(0xFF1B2631),
                  enabled: s.ishaNotification,
                ),
              ]),
              const SizedBox(height: 16),
              _buildSectionHeader('Daily Reminders'),
              _buildCard(children: [
                _buildToggleTile(
                  icon: Icons.local_fire_department_outlined,
                  iconColor: const Color(0xFFE05D5D),
                  title: 'Habit Reminders',
                  subtitle: 'Daily nudge to complete your habits',
                  value: s.habitReminders,
                  onChanged: (v) => context
                      .read<SettingsBloc>()
                      .add(SettingsHabitReminderToggled(v)),
                ),
                _divider(),
                _buildToggleTile(
                  icon: Icons.menu_book_outlined,
                  iconColor: const Color(0xFF1B6B3A),
                  title: 'Quran Reminder',
                  subtitle: 'Gentle reminder for your daily Quran goal',
                  value: s.quranReminder,
                  onChanged: (v) => context
                      .read<SettingsBloc>()
                      .add(SettingsQuranReminderToggled(v)),
                ),
              ]),
              const SizedBox(height: 16),
              _buildSectionHeader('Quiet Hours'),
              _buildCard(children: [
                _buildToggleTile(
                  icon: Icons.do_not_disturb_on_outlined,
                  iconColor: AppColors.textSecondary,
                  title: 'Enable Quiet Hours',
                  subtitle: 'Silence all notifications during this window',
                  value: s.quietHoursEnabled,
                  onChanged: (v) => context
                      .read<SettingsBloc>()
                      .add(SettingsQuietHoursToggled(v)),
                ),
                if (s.quietHoursEnabled) ...[
                  _divider(),
                  _buildQuietHoursPicker(context, s),
                ],
              ]),
              const SizedBox(height: 16),
              _buildInfoBanner(
                'Two notifications are sent per prayer: at call time and at the buffer start.',
              ),
              const SizedBox(height: 32),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
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

  Widget _buildPrayerToggle(
    BuildContext context, {
    required String prayer,
    required String label,
    required String emoji,
    required Color color,
    required bool enabled,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: Text(emoji, style: const TextStyle(fontSize: 18)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppTextStyles.labelLarge),
                Text('Adhan + buffer alert',
                    style: AppTextStyles.bodyMedium),
              ],
            ),
          ),
          Switch(
            value: enabled,
            onChanged: (v) => context.read<SettingsBloc>().add(
                  SettingsPrayerNotificationToggled(
                      prayer: prayer, enabled: v),
                ),
            activeThumbColor: AppColors.primary,
          ),
        ],
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
            activeThumbColor: AppColors.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildQuietHoursPicker(BuildContext context, dynamic s) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Row(
        children: [
          const Icon(Icons.schedule_outlined,
              size: 20, color: AppColors.textSecondary),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Time Window', style: AppTextStyles.labelLarge),
                Text(s.quietHoursLabel,
                    style: AppTextStyles.bodyMedium
                        .copyWith(color: AppColors.primary)),
              ],
            ),
          ),
          TextButton(
            onPressed: () => _pickQuietHours(context, s),
            child: const Text('Edit'),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBanner(String text) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline,
              color: AppColors.primary, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(text,
                style: AppTextStyles.bodyMedium
                    .copyWith(color: AppColors.primary)),
          ),
        ],
      ),
    );
  }

  Future<void> _pickQuietHours(BuildContext context, dynamic s) async {
    final start = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(
          hour: s.quietHoursStartHour, minute: s.quietHoursStartMinute),
      helpText: 'Quiet hours START',
    );
    if (start == null || !context.mounted) return;

    final end = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(
          hour: s.quietHoursEndHour, minute: s.quietHoursEndMinute),
      helpText: 'Quiet hours END',
    );
    if (end == null || !context.mounted) return;

    context.read<SettingsBloc>().add(SettingsQuietHoursChanged(
          startHour: start.hour,
          startMinute: start.minute,
          endHour: end.hour,
          endMinute: end.minute,
        ));
  }
}
