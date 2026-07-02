import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../../core/utils/responsive.dart';
import '../../../../../shared/theme/app_theme.dart';
import '../../../../core/di/app_dependencies.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../../../features/backup/presentation/bloc/backup_bloc.dart';
import '../../../../features/onboarding/domain/entities/user_profile.dart';
import '../../../../features/ramadan/presentation/pages/ramadan_settings_page.dart';
import '../bloc/settings_bloc.dart';
import 'appearance_page.dart';
import 'data_page.dart';
import 'notifications_page.dart';
import 'prayer_settings_page.dart';
import 'profile_edit_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  UserProfile? _profile;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final result =
        await AppDependencies.getUserProfile(const NoParams());
    result.fold((_) {}, (p) {
      if (mounted) setState(() => _profile = p);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          _buildAppBar(),
          SliverToBoxAdapter(
            child: Column(
              children: [
                _ProfileCard(profile: _profile),
                const SizedBox(height: 8),
                _buildSection(
                  ctx: context,
                  title: 'Personal',
                  items: [
                    _SettingsTile(
                      icon: Icons.person_outline,
                      iconColor: AppColors.primary,
                      title: 'Edit Profile',
                      subtitle: 'Name, occupation, work schedule',
                      onTap: () => _push(ProfileEditPage(profile: _profile)),
                    ),
                  ],
                ),
                _buildSection(
                  ctx: context,
                  title: 'Prayer',
                  items: [
                    _SettingsTile(
                      icon: Icons.mosque_outlined,
                      iconColor: const Color(0xFF1B6B3A),
                      title: 'Prayer Settings',
                      subtitle: 'Calculation method, madhab, buffer',
                      onTap: () =>
                          _push(PrayerSettingsPage(profile: _profile)),
                    ),
                    _SettingsTile(
                      icon: Icons.nights_stay_outlined,
                      iconColor: const Color(0xFF7B61FF),
                      title: 'Ramadan Settings',
                      subtitle: 'Suhoor, Iftar, Tarawih preferences',
                      onTap: () {
                        if (_profile != null) {
                          _push(RamadanSettingsPage(profile: _profile!));
                        }
                      },
                    ),
                  ],
                ),
                _buildSection(
                  ctx: context,
                  title: 'App',
                  items: [
                    _SettingsTile(
                      icon: Icons.notifications_outlined,
                      iconColor: const Color(0xFFF5A623),
                      title: 'Notifications',
                      subtitle: 'Prayer alerts, reminders, quiet hours',
                      onTap: () => _push(const NotificationsPage()),
                    ),
                    _SettingsTile(
                      icon: Icons.palette_outlined,
                      iconColor: const Color(0xFF2E86C1),
                      title: 'Appearance',
                      subtitle: 'Theme, Hijri date, time format',
                      onTap: () => _push(const AppearancePage()),
                    ),
                  ],
                ),
                _buildSection(
                  ctx: context,
                  title: 'Data & About',
                  items: [
                    _SettingsTile(
                      icon: Icons.storage_outlined,
                      iconColor: AppColors.textSecondary,
                      title: 'Data & Privacy',
                      subtitle: 'Export data, reset app, about',
                      onTap: () => _push(const DataPage()),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                _buildVersion(),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      backgroundColor: AppColors.background,
      floating: true,
      snap: true,
      elevation: 0,
      title: Text('Settings', style: AppTextStyles.headlineMedium),
      centerTitle: false,
      actions: const [_SyncChip(), SizedBox(width: 8)],
    );
  }

  Widget _buildSection(
      {required String title,
      required List<Widget> items,
      required BuildContext ctx}) {
    final h = ctx.screenHPadding;
    return Padding(
      padding: EdgeInsets.fromLTRB(h, 8, h, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 6),
            child: Text(
              title.toUpperCase(),
              style: AppTextStyles.labelSmall.copyWith(
                color: AppColors.textHint,
                letterSpacing: 1.2,
              ),
            ),
          ),
          Container(
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
              children: [
                for (int i = 0; i < items.length; i++) ...[
                  items[i],
                  if (i < items.length - 1)
                    const Divider(
                      height: 1,
                      indent: 56,
                      color: AppColors.surfaceVariant,
                    ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildVersion() {
    return Text(
      'Productive Muslim · v1.0.0',
      style: AppTextStyles.labelSmall.copyWith(color: AppColors.textHint),
    );
  }

  Future<void> _push(Widget page) async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => page),
    );
    await _loadProfile();
  }
}

// ─── PROFILE CARD ─────────────────────────────────────────────────────────────
class _ProfileCard extends StatelessWidget {
  final UserProfile? profile;
  const _ProfileCard({this.profile});

  @override
  Widget build(BuildContext context) {
    final name = profile?.name ?? 'Your Name';
    final city = profile?.city ?? '';
    final occupation = profile?.occupationLabel ?? '';

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF1B4F72), Color(0xFF2E86C1)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(AppRadius.xl),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.3),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.white.withValues(alpha: 0.2),
              child: Text(
                name.isNotEmpty ? name[0].toUpperCase() : '?',
                style: AppTextStyles.displayMedium.copyWith(
                  color: Colors.white,
                  fontSize: 28,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: AppTextStyles.titleMedium.copyWith(
                        color: Colors.white, fontWeight: FontWeight.w700),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (occupation.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      occupation,
                      style: AppTextStyles.bodyMedium
                          .copyWith(color: Colors.white70),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  if (city.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined,
                            size: 12, color: Colors.white60),
                        const SizedBox(width: 2),
                        Text(
                          city,
                          style: AppTextStyles.labelSmall
                              .copyWith(color: Colors.white60),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            BlocBuilder<SettingsBloc, SettingsState>(
              builder: (context, state) {
                final themeLabel = state is SettingsLoaded
                    ? _themeModeLabel(state.settings.themeMode)
                    : '';
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Icon(Icons.wb_sunny_outlined,
                        size: 18, color: Colors.white60),
                    if (themeLabel.isNotEmpty)
                      Text(themeLabel,
                          style: AppTextStyles.labelSmall
                              .copyWith(color: Colors.white60)),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  String _themeModeLabel(String mode) {
    switch (mode) {
      case 'light':
        return 'Light';
      case 'dark':
        return 'Dark';
      default:
        return 'Auto';
    }
  }
}

// ─── SETTINGS TILE ────────────────────────────────────────────────────────────
class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _SettingsTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
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
                  Text(title, style: AppTextStyles.labelLarge),
                  const SizedBox(height: 2),
                  Text(subtitle, style: AppTextStyles.bodyMedium),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.textHint, size: 20),
          ],
        ),
      ),
    );
  }
}

// ─── SYNC STATUS CHIP ────────────────────────────────────────────────────────
class _SyncChip extends StatelessWidget {
  const _SyncChip();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        final isGuest = authState is! AuthAuthenticated ||
            authState.user.isAnonymous;

        if (isGuest) {
          return _chip(
            dot: _greyDot,
            label: 'Guest mode',
          );
        }

        return BlocBuilder<BackupBloc, BackupState>(
          builder: (context, backupState) {
            if (backupState is BackupInProgress) {
              return _chip(
                dot: const SizedBox(
                  width: 8,
                  height: 8,
                  child: CircularProgressIndicator(strokeWidth: 1.5),
                ),
                label: 'Backing up…',
              );
            }
            if (backupState is BackupLoaded &&
                backupState.lastBackupAt != null) {
              final ago = _formatAgo(backupState.lastBackupAt!);
              return _chip(dot: _greenDot, label: 'Backed up $ago');
            }
            return _chip(dot: _greyDot, label: 'Not backed up');
          },
        );
      },
    );
  }

  Widget _chip({required Widget dot, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.surfaceVariant),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          dot,
          const SizedBox(width: 5),
          Text(label,
              style: AppTextStyles.labelSmall
                  .copyWith(color: AppColors.textSecondary)),
        ],
      ),
    );
  }

  static const _greenDot = _Dot(color: Color(0xFF34A853));
  static const _greyDot = _Dot(color: AppColors.textHint);

  String _formatAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 1) return 'just now';
    if (diff.inHours < 1) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return DateFormat('MMM d').format(dt);
  }
}

class _Dot extends StatelessWidget {
  final Color color;
  const _Dot({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
