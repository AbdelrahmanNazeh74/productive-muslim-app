import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../../shared/theme/app_theme.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../domain/entities/backup_snapshot.dart';
import '../bloc/backup_bloc.dart';

class BackupPage extends StatefulWidget {
  const BackupPage({super.key});

  @override
  State<BackupPage> createState() => _BackupPageState();
}

class _BackupPageState extends State<BackupPage> {
  @override
  void initState() {
    super.initState();
    _loadList();
  }

  void _loadList() {
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated && !authState.user.isAnonymous) {
      context
          .read<BackupBloc>()
          .add(BackupListRequested(authState.user.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Cloud Backup'),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, authState) {
          final isGuest =
              authState is! AuthAuthenticated || authState.user.isAnonymous;

          if (isGuest) return const _GuestMessage();

          return BlocConsumer<BackupBloc, BackupState>(
            listener: (context, state) {
              if (state is RestoreSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                        'Backup restored. Restart the app to apply changes.'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
              if (state is BackupError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: AppColors.error,
                  ),
                );
              }
            },
            builder: (context, state) {
              final isLoading = state is BackupInProgress;
              final backups = state is BackupLoaded ? state.backups : <BackupMetadata>[];
              final lastAt = state is BackupLoaded ? state.lastBackupAt : null;

              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _StatusCard(lastBackupAt: lastAt, isLoading: isLoading),
                  const SizedBox(height: 20),
                  _ActionButtons(
                    isLoading: isLoading,
                    onBackupNow: () => _onBackupNow(context, authState),
                    onRestore: backups.isEmpty
                        ? null
                        : () => _onRestore(context, backups.first),
                  ),
                  if (backups.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    _BackupList(backups: backups),
                  ],
                  const SizedBox(height: 32),
                ],
              );
            },
          );
        },
      ),
    );
  }

  void _onBackupNow(BuildContext context, AuthState authState) {
    if (authState is! AuthAuthenticated) return;
    // Build a minimal snapshot — in production, gather from Isar.
    final snapshot = BackupSnapshot(
      userId: authState.user.id,
      createdAt: DateTime.now(),
      appVersion: '1.0.0',
      userProfile: const {},
      habits: const [],
      streakRecords: const [],
      settings: const {},
    );
    context.read<BackupBloc>().add(BackupRequested(snapshot));
  }

  void _onRestore(BuildContext context, BackupMetadata metadata) {
    // Capture the bloc before the async gap to satisfy use_build_context_synchronously.
    final backupBloc = context.read<BackupBloc>();
    showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Restore Backup?', style: AppTextStyles.titleMedium),
        content: Text(
          'This will overwrite your current data with the backup from '
          '${DateFormat('MMM d, yyyy – h:mm a').format(metadata.createdAt)}.',
          style: AppTextStyles.bodyLarge,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(
              'Restore',
              style: AppTextStyles.labelLarge
                  .copyWith(color: AppColors.primary),
            ),
          ),
        ],
      ),
    ).then((confirmed) {
      if (confirmed == true && mounted) {
        backupBloc.add(RestoreRequested(metadata.id));
      }
    });
  }
}

// ── Status card ───────────────────────────────────────────────────────────────

class _StatusCard extends StatelessWidget {
  final DateTime? lastBackupAt;
  final bool isLoading;

  const _StatusCard({this.lastBackupAt, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
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
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: isLoading
                ? const Padding(
                    padding: EdgeInsets.all(10),
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Icon(
                    lastBackupAt != null
                        ? Icons.cloud_done_outlined
                        : Icons.cloud_outlined,
                    color: lastBackupAt != null
                        ? Colors.green.shade600
                        : AppColors.textHint,
                  ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isLoading
                      ? 'Backing up...'
                      : lastBackupAt != null
                          ? 'Last backed up'
                          : 'Not backed up yet',
                  style: AppTextStyles.labelLarge,
                ),
                if (lastBackupAt != null && !isLoading) ...[
                  const SizedBox(height: 2),
                  Text(
                    DateFormat('MMM d, yyyy – h:mm a').format(lastBackupAt!),
                    style: AppTextStyles.bodyMedium
                        .copyWith(color: AppColors.textSecondary),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Action buttons ────────────────────────────────────────────────────────────

class _ActionButtons extends StatelessWidget {
  final bool isLoading;
  final VoidCallback? onBackupNow;
  final VoidCallback? onRestore;

  const _ActionButtons({
    required this.isLoading,
    required this.onBackupNow,
    required this.onRestore,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: FilledButton.icon(
            onPressed: isLoading ? null : onBackupNow,
            icon: const Icon(Icons.cloud_upload_outlined, size: 18),
            label: const Text('Back Up Now'),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: isLoading ? null : onRestore,
            icon: const Icon(Icons.cloud_download_outlined, size: 18),
            label: const Text('Restore'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: const BorderSide(color: AppColors.primary),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ),
      ],
    );
  }
}

// ── Backup list ───────────────────────────────────────────────────────────────

class _BackupList extends StatelessWidget {
  final List<BackupMetadata> backups;
  const _BackupList({required this.backups});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            'RECENT BACKUPS',
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
              for (int i = 0; i < backups.length; i++) ...[
                _BackupTile(metadata: backups[i]),
                if (i < backups.length - 1)
                  const Divider(
                      height: 1,
                      indent: 56,
                      color: AppColors.surfaceVariant),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _BackupTile extends StatelessWidget {
  final BackupMetadata metadata;
  const _BackupTile({required this.metadata});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.backup_outlined,
                size: 20, color: AppColors.primary),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat('MMM d, yyyy').format(metadata.createdAt),
                  style: AppTextStyles.labelLarge,
                ),
                Text(
                  '${metadata.habitCount} habits · v${metadata.appVersion}',
                  style: AppTextStyles.bodyMedium
                      .copyWith(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          Text(
            DateFormat('h:mm a').format(metadata.createdAt),
            style: AppTextStyles.labelSmall
                .copyWith(color: AppColors.textHint),
          ),
        ],
      ),
    );
  }
}

// ── Guest mode message ────────────────────────────────────────────────────────

class _GuestMessage extends StatelessWidget {
  const _GuestMessage();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.cloud_off_outlined,
                size: 64, color: AppColors.textHint.withValues(alpha: 0.5)),
            const SizedBox(height: 20),
            Text(
              'Backup Unavailable',
              style: AppTextStyles.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'You are using Productive Muslim in guest mode. '
              'Sign in with Google to enable automatic cloud backup and '
              'restore your data across devices.',
              style: AppTextStyles.bodyLarge
                  .copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
