import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/utils/responsive.dart';
import '../../../../shared/theme/app_theme.dart';
import '../../../../features/onboarding/domain/entities/user_profile.dart';
import '../../../../features/timeline/presentation/widgets/timeline_widgets.dart';
import '../../../../features/timeline/domain/entities/time_block.dart';
import '../../domain/entities/ramadan_entities.dart';
import '../bloc/ramadan_bloc.dart';
import 'ramadan_settings_page.dart';

class RamadanDashboardPage extends StatefulWidget {
  final UserProfile profile;

  const RamadanDashboardPage({super.key, required this.profile});

  @override
  State<RamadanDashboardPage> createState() => _RamadanDashboardPageState();
}

class _RamadanDashboardPageState extends State<RamadanDashboardPage> {
  Timer? _countdownTimer;

  @override
  void initState() {
    super.initState();
    context
        .read<RamadanBloc>()
        .add(RamadanInitialised(widget.profile));

    // Refresh countdown every second
    _countdownTimer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => setState(() {}),
    );
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RamadanBloc, RamadanState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: const Color(0xFF0D1B2A), // deep night
          body: SafeArea(
            child: Column(
              children: [
                _buildHeader(context, state),
                Expanded(
                  child: _buildBody(context, state),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // â”€â”€â”€ HEADER â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  Widget _buildHeader(BuildContext context, RamadanState state) {
    final ctx = state.dayContext;
    final hijri = state.todayHijri;

    return Container(
      padding: EdgeInsets.fromLTRB(context.screenHPadding, 16, context.screenHPadding, 20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0D1B2A), Color(0xFF1B3A5C)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        children: [
          // Top row: Hijri date + settings
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (hijri != null)
                    Text(
                      hijri.toString(),
                      style: AppTextStyles.bodyMedium
                          .copyWith(color: Colors.white60, fontSize: 12),
                    ),
                  Text(
                    ctx?.dayLabel ?? 'Ramadan Mubarak',
                    style: AppTextStyles.displayMedium
                        .copyWith(color: Colors.white),
                  ),
                ],
              ),
              Row(
                children: [
                  if (ctx?.specialLabel.isNotEmpty ?? false)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.gold.withValues(alpha: 0.2),
                        borderRadius:
                            BorderRadius.circular(AppRadius.full),
                        border: Border.all(
                            color: AppColors.gold.withValues(alpha: 0.5)),
                      ),
                      child: Text(
                        ctx!.specialLabel,
                        style: AppTextStyles.labelSmall
                            .copyWith(color: AppColors.gold, fontSize: 10),
                      ),
                    ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.tune,
                        color: Colors.white60, size: 22),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BlocProvider.value(
                          value: context.read<RamadanBloc>(),
                          child: RamadanSettingsPage(
                              profile: widget.profile),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Iftar countdown â€” the centrepiece
          if (state.dayContext != null)
            _IftarCountdown(
              times: state.dayContext!.times,
              now: DateTime.now(),
            ),
        ],
      ),
    );
  }

  // â”€â”€â”€ BODY â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  Widget _buildBody(BuildContext context, RamadanState state) {
    if (state.status == RamadanStatus.loading) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: AppColors.gold),
            SizedBox(height: 16),
            Text('Building your Ramadan scheduleâ€¦ ðŸŒ™',
                style: TextStyle(color: Colors.white60)),
          ],
        ),
      );
    }

    if (state.status == RamadanStatus.error) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.warning_amber_rounded,
                  color: AppColors.error, size: 48),
              const SizedBox(height: 16),
              Text(state.errorMessage ?? 'Something went wrong',
                  style: const TextStyle(color: Colors.white70),
                  textAlign: TextAlign.center),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => context
                    .read<RamadanBloc>()
                    .add(RamadanInitialised(widget.profile)),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (state.timeline == null) {
      return const Center(
        child: Text('No timeline yet',
            style: TextStyle(color: Colors.white60)),
      );
    }

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: ClipRRect(
        borderRadius:
            const BorderRadius.vertical(top: Radius.circular(24)),
        child: ListView(
          padding: const EdgeInsets.only(top: 20, bottom: 100),
          children: [
            // Prayer strip
            if (state.prayerTimes != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: PrayerStrip(
                  prayerTimes: state.prayerTimes!,
                  prayerBlocks: state.timeline!.prayerBlocks,
                ),
              ),

            // Ramadan key times strip
            if (state.dayContext != null)
              _RamadanTimesStrip(times: state.dayContext!.times),

            const SizedBox(height: 8),

            // Timeline sections (Ramadan-aware)
            ..._buildSections(context, state),
          ],
        ),
      ),
    );
  }

  // â”€â”€â”€ RAMADAN SECTIONS â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  List<Widget> _buildSections(BuildContext context, RamadanState state) {
    final timeline = state.timeline!;
    final blocks = timeline.blocks;

    final sections = <_RSection>[
      const _RSection('Pre-Dawn & Suhoor', [
        TimeBlockType.sleep,
        TimeBlockType.prayer,
        TimeBlockType.prayerBuffer,
        TimeBlockType.meal,
        TimeBlockType.dhikr,
      ], beforeHour: 6),
      const _RSection('Morning Worship', [
        TimeBlockType.prayer,
        TimeBlockType.prayerBuffer,
        TimeBlockType.goldenHour,
        TimeBlockType.quran,
        TimeBlockType.dhikr,
      ], afterHour: 5, beforeHour: 12),
      const _RSection('Fasting Hours â€” Work & Study', [
        TimeBlockType.work,
        TimeBlockType.deepWork,
        TimeBlockType.break_,
        TimeBlockType.freeTime,
      ], afterHour: 8, beforeHour: 15),
      const _RSection('Midday Rest (Qaylula)', [
        TimeBlockType.qaylula,
        TimeBlockType.prayer,
        TimeBlockType.prayerBuffer,
        TimeBlockType.dhikr,
      ], afterHour: 12, beforeHour: 16),
      const _RSection('Pre-Iftar & Asr', [
        TimeBlockType.prayer,
        TimeBlockType.prayerBuffer,
        TimeBlockType.dhikr,
        TimeBlockType.quran,
      ], afterHour: 15, beforeHour: 19),
      const _RSection('Iftar & Maghrib', [
        TimeBlockType.meal,
        TimeBlockType.prayer,
        TimeBlockType.prayerBuffer,
        TimeBlockType.dhikr,
      ], afterHour: 18, beforeHour: 21),
      const _RSection('Isha & Tarawih', [
        TimeBlockType.prayer,
        TimeBlockType.prayerBuffer,
        TimeBlockType.dhikr,
        TimeBlockType.quran,
      ], afterHour: 20, beforeHour: 24),
      const _RSection('Night & Qiyam', [
        TimeBlockType.sleep,
        TimeBlockType.prayer,
        TimeBlockType.quran,
        TimeBlockType.freeTime,
      ], afterHour: 22),
    ];

    final widgets = <Widget>[];
    for (final section in sections) {
      final sectionBlocks = blocks.where((b) {
        if (!section.types.contains(b.type)) return false;
        if (section.afterHour != null &&
            b.startTime.hour < section.afterHour!) { return false; }
        if (section.beforeHour != null &&
            b.startTime.hour >= section.beforeHour!) { return false; }
        return true;
      }).toList();

      if (sectionBlocks.isEmpty) continue;

      widgets.add(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TimelineSectionHeader(label: section.name),
              ...sectionBlocks.map((b) => TimeBlockCard(
                    block: b,
                    isCurrentBlock:
                        timeline.currentBlock?.id == b.id,
                  )),
            ],
          ),
        ),
      );
    }
    return widgets;
  }
}

// â”€â”€â”€ IFTAR COUNTDOWN â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
class _IftarCountdown extends StatelessWidget {
  final RamadanTimes times;
  final DateTime now;

  const _IftarCountdown({required this.times, required this.now});

  @override
  Widget build(BuildContext context) {
    final isFasting = times.isFasting(now);
    final diff = times.iftarTime.difference(now);
    final alreadyBroke = diff.isNegative;

    if (alreadyBroke) {
      return _CountdownCard(
        emoji: 'ðŸŒ…',
        label: 'Fast broken Â· Alhamdulillah',
        value: 'Iftar at ${DateFormat('h:mm a').format(times.iftarTime)}',
        color: AppColors.success,
        sublabel: 'Fasting window: ${times.fastingHoursLabel}',
      );
    }

    if (!isFasting) {
      return _CountdownCard(
        emoji: 'ðŸŒ™',
        label: 'Suhoor ends',
        value: DateFormat('h:mm a').format(times.suhoorEnd),
        color: AppColors.fajr,
        sublabel:
            'Wake up at ${DateFormat('h:mm a').format(times.sehriWakeUp)}',
      );
    }

    final hours = diff.inHours;
    final minutes = diff.inMinutes % 60;
    final seconds = diff.inSeconds % 60;

    return _CountdownCard(
      emoji: 'â³',
      label: 'Iftar in',
      value: hours > 0
          ? '${hours}h ${minutes}m ${seconds}s'
          : '${minutes}m ${seconds}s',
      color: AppColors.gold,
      sublabel: 'Break fast at ${DateFormat('h:mm a').format(times.iftarTime)}'
          ' Â· ${times.fastingHoursLabel}',
    );
  }
}

class _CountdownCard extends StatelessWidget {
  final String emoji;
  final String label;
  final String value;
  final Color color;
  final String sublabel;

  const _CountdownCard({
    required this.emoji,
    required this.label,
    required this.value,
    required this.color,
    required this.sublabel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 36)),
          const SizedBox(height: 8),
          Text(label,
              style: AppTextStyles.bodyMedium
                  .copyWith(color: Colors.white60)),
          const SizedBox(height: 4),
          Text(
            value,
            style: AppTextStyles.dataLarge.copyWith(
              color: color,
              fontSize: 30,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(sublabel,
              style: AppTextStyles.bodyMedium
                  .copyWith(color: Colors.white54, fontSize: 12)),
        ],
      ),
    );
  }
}

// â”€â”€â”€ RAMADAN TIMES STRIP â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
class _RamadanTimesStrip extends StatelessWidget {
  final RamadanTimes times;
  const _RamadanTimesStrip({required this.times});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(context.screenHPadding, 0, context.screenHPadding, 4),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.surfaceVariant, width: 1.5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _TimePill('ðŸŒ™', 'Suhoor', DateFormat('h:mm a').format(times.suhoorEnd)),
          _TimePill('ðŸŒ…', 'Iftar', DateFormat('h:mm a').format(times.iftarTime)),
          _TimePill('ðŸŒ™', 'Tarawih', DateFormat('h:mm a').format(times.tarawihStart)),
        ],
      ),
    );
  }
}

class _TimePill extends StatelessWidget {
  final String emoji;
  final String label;
  final String time;
  const _TimePill(this.emoji, this.label, this.time);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 18)),
        const SizedBox(height: 4),
        Text(label,
            style: AppTextStyles.labelSmall.copyWith(fontSize: 10)),
        Text(time,
            style: AppTextStyles.titleMedium.copyWith(
                fontSize: 13, color: AppColors.primary)),
      ],
    );
  }
}

class _RSection {
  final String name;
  final List<TimeBlockType> types;
  final int? afterHour;
  final int? beforeHour;
  const _RSection(this.name, this.types, {this.afterHour, this.beforeHour});
}
