import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../shared/theme/app_theme.dart';
import '../../../../core/di/app_dependencies.dart';
import '../../../backup/presentation/pages/backup_page.dart';
import '../bloc/settings_bloc.dart';

class DataPage extends StatelessWidget {
  const DataPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Data & Privacy'),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _sectionLabel('Your Data'),
          _buildCard(children: [
            _buildActionTile(
              icon: Icons.cloud_outlined,
              iconColor: AppColors.primary,
              title: 'Cloud Backup',
              subtitle: 'Back up and restore your data',
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const BackupPage()),
              ),
            ),
            _divider(),
            _buildActionTile(
              icon: Icons.download_outlined,
              iconColor: AppColors.primary,
              title: 'Export Data',
              subtitle: 'Download your profile and habits as JSON',
              onTap: () => _onExport(context),
            ),
          ]),
          const SizedBox(height: 16),
          _sectionLabel('About'),
          _buildCard(children: [
            _buildInfoTile(
              icon: Icons.info_outline,
              iconColor: AppColors.primary,
              title: 'Version',
              value: '1.0.0 (build 1)',
            ),
            _divider(),
            _buildInfoTile(
              icon: Icons.mosque_outlined,
              iconColor: const Color(0xFF1B6B3A),
              title: 'Built with',
              value: 'Flutter · Isar · adhan-dart',
            ),
            _divider(),
            _buildActionTile(
              icon: Icons.privacy_tip_outlined,
              iconColor: AppColors.textSecondary,
              title: 'Privacy Policy',
              subtitle: 'All data stored locally on your device',
              onTap: () => _showPrivacySheet(context),
            ),
          ]),
          const SizedBox(height: 24),
          _sectionLabel('Danger Zone'),
          _buildDangerCard(context),
          const SizedBox(height: 32),
        ],
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

  Widget _buildDangerCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
            color: AppColors.error.withValues(alpha: 0.3), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildActionTile(
            icon: Icons.restart_alt_outlined,
            iconColor: AppColors.warning,
            title: 'Reset Settings',
            subtitle: 'Restore all app settings to defaults',
            onTap: () => _confirmResetSettings(context),
          ),
          _divider(),
          _buildActionTile(
            icon: Icons.delete_forever_outlined,
            iconColor: AppColors.error,
            title: 'Reset App',
            subtitle: 'Erase all data and restart onboarding',
            onTap: () => _confirmFullReset(context),
            titleColor: AppColors.error,
          ),
        ],
      ),
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color? titleColor,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
                        color: titleColor ?? AppColors.textPrimary),
                  ),
                  Text(subtitle, style: AppTextStyles.bodyMedium),
                ],
              ),
            ),
            const Icon(Icons.chevron_right,
                color: AppColors.textHint, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
          Expanded(child: Text(title, style: AppTextStyles.labelLarge)),
          Text(value,
              style: AppTextStyles.bodyMedium
                  .copyWith(color: AppColors.textSecondary)),
        ],
      ),
    );
  }

  void _onExport(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Data export coming in a future update'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showPrivacySheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Privacy Policy', style: AppTextStyles.headlineMedium),
            const SizedBox(height: 12),
            Text(
              'Productive Muslim stores all your data locally on your device using Isar database and SharedPreferences. '
              'No data is ever transmitted to external servers. '
              'Location is used only to calculate prayer times and is never stored beyond your profile.',
              style: AppTextStyles.bodyLarge,
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmResetSettings(BuildContext context) async {
    final confirmed = await _showConfirmDialog(
      context,
      title: 'Reset Settings?',
      message: 'All notification and appearance settings will be restored to defaults.',
      confirmLabel: 'Reset',
      confirmColor: AppColors.warning,
    );
    if (confirmed == true && context.mounted) {
      context.read<SettingsBloc>().add(const SettingsResetRequested());
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Settings reset to defaults'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _confirmFullReset(BuildContext context) async {
    final confirmed = await _showConfirmDialog(
      context,
      title: 'Reset Entire App?',
      message:
          'This will permanently delete all your data including profile, habits, and timeline history. This cannot be undone.',
      confirmLabel: 'Delete Everything',
      confirmColor: AppColors.error,
    );
    if (confirmed == true && context.mounted) {
      await AppDependencies.resetAllData();
      if (context.mounted) context.go('/onboarding');
    }
  }

  Future<bool?> _showConfirmDialog(
    BuildContext context, {
    required String title,
    required String message,
    required String confirmLabel,
    required Color confirmColor,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title, style: AppTextStyles.titleMedium),
        content: Text(message, style: AppTextStyles.bodyLarge),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(
              confirmLabel,
              style: AppTextStyles.labelLarge.copyWith(color: confirmColor),
            ),
          ),
        ],
      ),
    );
  }
}
