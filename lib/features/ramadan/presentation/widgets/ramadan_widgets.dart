import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/theme/app_theme.dart';
import '../../../onboarding/domain/entities/user_profile.dart';
import '../../../ramadan/domain/usecases/hijri_converter.dart';
import '../../../ramadan/presentation/bloc/ramadan_bloc.dart';

// ─── HIJRI DATE BANNER ───────────────────────────────────────────────────────
/// Shows the current Hijri date and — during Ramadan — a Ramadan badge.
class HijriDateBanner extends StatelessWidget {
  const HijriDateBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final hijri = const HijriConverter().toHijri(DateTime.now());
    final isRamadan = hijri.isRamadan;

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: isRamadan
            ? const Color(0xFF0D1B2A).withValues(alpha: 0.9)
            : AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            isRamadan ? '🌙' : '📅',
            style: const TextStyle(fontSize: 14),
          ),
          const SizedBox(width: 6),
          Text(
            hijri.toString(),
            style: AppTextStyles.bodyMedium.copyWith(
              fontSize: 12,
              color: isRamadan ? Colors.white : AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (isRamadan) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.gold,
                borderRadius: BorderRadius.circular(AppRadius.full),
              ),
              child: Text(
                'Day ${hijri.ramadanDay} 🌙',
                style: AppTextStyles.labelSmall.copyWith(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ─── RAMADAN MODE TOGGLE CARD ────────────────────────────────────────────────
/// A prominent card shown at the top of the timeline when Ramadan
/// is detected or manually activated. Tapping it toggles Ramadan Mode.
class RamadanModeToggleCard extends StatelessWidget {
  final UserProfile profile;
  final bool isRamadanMode;
  final ValueChanged<bool> onToggle;

  const RamadanModeToggleCard({
    super.key,
    required this.profile,
    required this.isRamadanMode,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    if (isRamadanMode) {
      return _ActiveBanner(profile: profile, onToggle: onToggle);
    }

    // Check if we're in Ramadan (show suggestion)
    final hijri = const HijriConverter().toHijri(DateTime.now());
    if (!hijri.isRamadan) return const SizedBox.shrink();

    return _RamadanSuggestionCard(profile: profile, onToggle: onToggle);
  }
}

class _ActiveBanner extends StatelessWidget {
  final UserProfile profile;
  final ValueChanged<bool> onToggle;

  const _ActiveBanner({required this.profile, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _confirmDisable(context),
      child: Container(
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF0D1B2A), Color(0xFF1B3A5C)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(AppRadius.lg),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            const Text('🌙', style: TextStyle(fontSize: 24)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ramadan Mode Active',
                    style: AppTextStyles.titleMedium
                        .copyWith(color: Colors.white),
                  ),
                  Text(
                    'Tap the Ramadan tab for your full schedule',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: Colors.white60,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.gold.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(AppRadius.full),
                border: Border.all(
                    color: AppColors.gold.withValues(alpha: 0.4)),
              ),
              child: Text(
                'ON',
                style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.gold,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDisable(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.lg)),
        title: Text('Disable Ramadan Mode?',
            style: AppTextStyles.headlineMedium.copyWith(fontSize: 18)),
        content: Text(
          'Your timeline will switch back to the standard daily schedule.',
          style: AppTextStyles.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              onToggle(false);
            },
            child: Text(
              'Disable',
              style: AppTextStyles.bodyMedium
                  .copyWith(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}

class _RamadanSuggestionCard extends StatelessWidget {
  final UserProfile profile;
  final ValueChanged<bool> onToggle;

  const _RamadanSuggestionCard(
      {required this.profile, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0D1B2A).withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
            color: const Color(0xFF0D1B2A).withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          const Text('🌙', style: TextStyle(fontSize: 24)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Ramadan Mubarak! 🌟',
                    style: AppTextStyles.titleMedium),
                Text(
                  'Switch to Ramadan Mode for a Suhoor, Iftar & Tarawih schedule.',
                  style: AppTextStyles.bodyMedium.copyWith(fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: () => onToggle(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0D1B2A),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                  horizontal: 14, vertical: 8),
              minimumSize: Size.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.full),
              ),
            ),
            child: Text(
              'Enable',
              style: AppTextStyles.labelLarge
                  .copyWith(color: Colors.white, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── RAMADAN IFTAR MINI COUNTDOWN ────────────────────────────────────────────
/// Small countdown chip shown in the timeline header during fasting hours.
class IftarMiniCountdown extends StatelessWidget {
  const IftarMiniCountdown({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RamadanBloc, RamadanState>(
      builder: (context, state) {
        if (!state.isRamadanMode || state.dayContext == null) {
          return const SizedBox.shrink();
        }

        final times = state.dayContext!.times;
        final now = DateTime.now();

        if (!times.isFasting(now)) return const SizedBox.shrink();

        final diff = times.timeUntilIftar(now);
        final h = diff.inHours;
        final m = diff.inMinutes % 60;
        final label = h > 0 ? '${h}h ${m}m to Iftar' : '${m}m to Iftar';

        return Container(
          margin: const EdgeInsets.fromLTRB(20, 0, 20, 8),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.gold.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppRadius.full),
            border:
                Border.all(color: AppColors.gold.withValues(alpha: 0.3)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('⏳', style: TextStyle(fontSize: 12)),
              const SizedBox(width: 6),
              Text(
                label,
                style: AppTextStyles.labelLarge.copyWith(
                  color: AppColors.goldDark,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
