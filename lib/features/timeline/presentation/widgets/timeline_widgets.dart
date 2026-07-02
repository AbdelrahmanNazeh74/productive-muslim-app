import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:intl/intl.dart';

import '../../../../core/utils/responsive.dart';
import '../../../../shared/theme/app_theme.dart';
import '../../domain/entities/time_block.dart';
import '../bloc/timeline_bloc.dart';
import '../../../prayer/domain/entities/prayer_times.dart';

// ─── PRAYER COUNTDOWN BANNER ─────────────────────────────────────────────────
class NextPrayerBanner extends StatefulWidget {
  final TimeBlock prayerBlock;
  final DailyPrayerTimes prayerTimes;

  const NextPrayerBanner({
    super.key,
    required this.prayerBlock,
    required this.prayerTimes,
  });

  @override
  State<NextPrayerBanner> createState() => _NextPrayerBannerState();
}

class _NextPrayerBannerState extends State<NextPrayerBanner> {
  late PrayerName _prayerName;
  Color _bgColor = AppColors.primary;

  @override
  void initState() {
    super.initState();
    _prayerName = widget.prayerBlock.linkedPrayer ?? PrayerName.fajr;
    _bgColor = _prayerColor(_prayerName);
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final diff = widget.prayerBlock.startTime.difference(now);
    final isBuffer =
        widget.prayerBlock.type == TimeBlockType.prayerBuffer;

    final String countdownLabel;
    if (diff.isNegative) {
      countdownLabel = 'Now';
    } else if (diff.inMinutes < 60) {
      countdownLabel = 'in ${diff.inMinutes}m';
    } else {
      final h = diff.inHours;
      final m = diff.inMinutes % 60;
      countdownLabel = m > 0 ? 'in ${h}h ${m}m' : 'in ${h}h';
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: context.screenHPadding, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [_bgColor, _bgColor.withValues(alpha: 0.75)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: [
          BoxShadow(
            color: _bgColor.withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Text(
            _prayerName.emoji,
            style: const TextStyle(fontSize: 28),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isBuffer
                      ? 'Prepare for ${_prayerName.label}'
                      : '${_prayerName.label} Prayer',
                  style: AppTextStyles.titleMedium
                      .copyWith(color: Colors.white),
                ),
                Text(
                  isBuffer
                      ? 'Make Wudu · Wrap up your task'
                      : _formattedTime(widget.prayerBlock.startTime),
                  style: AppTextStyles.bodyMedium
                      .copyWith(color: Colors.white70),
                ),
              ],
            ),
          ),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(AppRadius.full),
            ),
            child: Text(
              countdownLabel,
              style: AppTextStyles.labelLarge.copyWith(
                color: Colors.white,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _prayerColor(PrayerName name) {
    switch (name) {
      case PrayerName.fajr:    return AppColors.fajr;
      case PrayerName.dhuhr:   return AppColors.dhuhr;
      case PrayerName.asr:     return AppColors.asr;
      case PrayerName.maghrib: return AppColors.maghrib;
      case PrayerName.isha:    return AppColors.isha;
    }
  }

  String _formattedTime(DateTime dt) {
    return DateFormat('h:mm a').format(dt);
  }
}

// ─── DAILY PROGRESS RING ─────────────────────────────────────────────────────
class DailyProgressRing extends StatelessWidget {
  final DailyTimeline timeline;

  const DailyProgressRing({super.key, required this.timeline});

  @override
  Widget build(BuildContext context) {
    final ratio = timeline.completionRatio;
    final prayers = timeline.prayersCompletedCount;

    return Container(
      margin: EdgeInsets.fromLTRB(context.screenHPadding, 0, context.screenHPadding, 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.surfaceVariant, width: 1.5),
      ),
      child: Row(
        children: [
          // Progress ring
          CircularPercentIndicator(
            radius: 38,
            lineWidth: 7,
            percent: ratio.clamp(0.0, 1.0),
            center: Text(
              '${(ratio * 100).toInt()}%',
              style: AppTextStyles.titleMedium.copyWith(
                color: AppColors.primary,
                fontSize: 13,
              ),
            ),
            progressColor: AppColors.gold,
            backgroundColor: AppColors.surfaceVariant,
            circularStrokeCap: CircularStrokeCap.round,
          ),

          const SizedBox(width: 20),

          // Stats column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Today's Progress",
                    style: AppTextStyles.titleMedium),
                const SizedBox(height: 10),
                _StatRow(
                  emoji: '🤲',
                  label: 'Prayers',
                  value: '$prayers / 5',
                  valueColor: prayers == 5
                      ? AppColors.success
                      : AppColors.textPrimary,
                ),
                const SizedBox(height: 6),
                _StatRow(
                  emoji: '✅',
                  label: 'Blocks done',
                  value:
                      '${timeline.completedCount} / ${timeline.totalActionable}',
                ),
                const SizedBox(height: 6),
                _StatRow(
                  emoji: '🌿',
                  label: 'Free time',
                  value: '${timeline.freeMinutes ~/ 60}h ${timeline.freeMinutes % 60}m',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final String emoji;
  final String label;
  final String value;
  final Color? valueColor;

  const _StatRow({
    required this.emoji,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 13)),
        const SizedBox(width: 6),
        Text(label, style: AppTextStyles.bodyMedium.copyWith(fontSize: 13)),
        const Spacer(),
        Text(
          value,
          style: AppTextStyles.labelLarge.copyWith(
            fontSize: 13,
            color: valueColor ?? AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

// ─── PRAYER STRIP ────────────────────────────────────────────────────────────
class PrayerStrip extends StatelessWidget {
  final DailyPrayerTimes prayerTimes;
  final List<TimeBlock> prayerBlocks;

  const PrayerStrip({
    super.key,
    required this.prayerTimes,
    required this.prayerBlocks,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(context.screenHPadding, 0, context.screenHPadding, 4),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.surfaceVariant, width: 1.5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: prayerTimes.ordered.map((prayer) {
          final block = prayerBlocks.firstWhere(
            (b) => b.linkedPrayer == prayer.name,
            orElse: () => TimeBlock(
              id: '',
              type: TimeBlockType.prayer,
              startTime: prayer.time,
              endTime: prayer.prayerEnd(),
              title: prayer.name.label,
              priority: BlockPriority.fixed,
              linkedPrayer: prayer.name,
            ),
          );
          return _PrayerPill(prayer: prayer, block: block);
        }).toList(),
      ),
    );
  }
}

class _PrayerPill extends StatelessWidget {
  final PrayerTime prayer;
  final TimeBlock block;

  const _PrayerPill({required this.prayer, required this.block});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final isPast = prayer.time.isBefore(now);
    final isCurrent = prayer.time.isBefore(now) &&
        prayer.prayerEnd().isAfter(now);
    final isDone = block.isCompleted;

    return BlocBuilder<TimelineBloc, TimelineState>(
      builder: (context, state) {
        return Semantics(
          label: '${prayer.name.label} at ${DateFormat('h:mm a').format(prayer.time)}, '
              '${isDone ? 'completed' : isCurrent ? 'current prayer' : 'upcoming'}',
          button: block.id.isNotEmpty,
          child: GestureDetector(
          onTap: block.id.isNotEmpty
              ? () => context
                  .read<TimelineBloc>()
                  .add(TimelineBlockCompleted(block.id))
              : null,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Dot indicator
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDone
                      ? AppColors.success
                      : isCurrent
                          ? _prayerColor(prayer.name)
                          : isPast
                              ? AppColors.error.withValues(alpha: 0.15)
                              : AppColors.surfaceVariant,
                  border: Border.all(
                    color: isCurrent
                        ? _prayerColor(prayer.name)
                        : Colors.transparent,
                    width: 2,
                  ),
                  boxShadow: isCurrent
                      ? [
                          BoxShadow(
                            color: _prayerColor(prayer.name).withValues(alpha: 0.4),
                            blurRadius: 8,
                          )
                        ]
                      : null,
                ),
                child: Center(
                  child: isDone
                      ? const Icon(Icons.check, color: Colors.white, size: 16)
                      : Text(
                          prayer.name.emoji,
                          style: const TextStyle(fontSize: 16),
                        ),
                ),
              ),

              const SizedBox(height: 5),

              // Prayer name
              Text(
                prayer.name.label,
                style: AppTextStyles.labelSmall.copyWith(
                  color: isCurrent
                      ? _prayerColor(prayer.name)
                      : AppColors.textSecondary,
                  fontWeight:
                      isCurrent ? FontWeight.w700 : FontWeight.w500,
                ),
              ),

              // Time
              Text(
                DateFormat('h:mm').format(prayer.time),
                style: AppTextStyles.labelSmall.copyWith(
                  fontSize: 10,
                  color: AppColors.textHint,
                ),
              ),
            ],
          ),
          ), // GestureDetector
        ); // Semantics
      },
    );
  }

  Color _prayerColor(PrayerName name) {
    switch (name) {
      case PrayerName.fajr:    return AppColors.fajr;
      case PrayerName.dhuhr:   return AppColors.dhuhr;
      case PrayerName.asr:     return AppColors.asr;
      case PrayerName.maghrib: return AppColors.maghrib;
      case PrayerName.isha:    return AppColors.isha;
    }
  }
}

// ─── TIME BLOCK CARD ─────────────────────────────────────────────────────────
class TimeBlockCard extends StatefulWidget {
  final TimeBlock block;
  final bool isCurrentBlock;
  final VoidCallback? onComplete;
  final VoidCallback? onSkip;

  const TimeBlockCard({
    super.key,
    required this.block,
    this.isCurrentBlock = false,
    this.onComplete,
    this.onSkip,
  });

  @override
  State<TimeBlockCard> createState() => _TimeBlockCardState();
}

class _TimeBlockCardState extends State<TimeBlockCard>
    with SingleTickerProviderStateMixin {
  // Drives the checkmark scale-bounce on completion
  late AnimationController _checkCtrl;
  late Animation<double> _checkScale;

  @override
  void initState() {
    super.initState();
    _checkCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
    _checkScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _checkCtrl, curve: Curves.elasticOut),
    );
    // Already completed when the card first renders — show without animation
    if (widget.block.isCompleted) _checkCtrl.value = 1.0;
  }

  @override
  void didUpdateWidget(TimeBlockCard old) {
    super.didUpdateWidget(old);
    if (!old.block.isCompleted && widget.block.isCompleted) {
      _checkCtrl.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _checkCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDone = widget.block.isCompleted;
    final isSkipped = widget.block.isSkipped;
    final isPrayer = widget.block.type == TimeBlockType.prayer;
    final isFixed = widget.block.priority == BlockPriority.fixed;

    final blockColor = _blockColor(widget.block.type, widget.block.linkedPrayer);

    return Semantics(
      label: '${widget.block.title}, ${widget.block.type.label}, '
          '${_fmt(widget.block.startTime)} to ${_fmt(widget.block.endTime)}, '
          '${isDone ? 'completed' : isSkipped ? 'skipped' : 'not completed'}',
      child: AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isDone
            ? AppColors.success.withValues(alpha: 0.05)
            : isSkipped
                ? AppColors.surfaceVariant.withValues(alpha: 0.5)
                : widget.isCurrentBlock
                    ? blockColor.withValues(alpha: 0.08)
                    : AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: widget.isCurrentBlock
              ? blockColor
              : isDone
                  ? AppColors.success.withValues(alpha: 0.3)
                  : AppColors.surfaceVariant,
          width: widget.isCurrentBlock ? 2 : 1.5,
        ),
        boxShadow: widget.isCurrentBlock
            ? [
                BoxShadow(
                  color: blockColor.withValues(alpha: 0.15),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Row(
          children: [
            // Left color bar
            Container(
              width: 4,
              height: 72,
              color: isDone
                  ? AppColors.success
                  : isSkipped
                      ? AppColors.textHint
                      : blockColor,
            ),

            const SizedBox(width: 14),

            // Time column
            SizedBox(
              width: 52,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _fmt(widget.block.startTime),
                    style: AppTextStyles.labelLarge.copyWith(
                      fontSize: 12,
                      color: isDone || isSkipped
                          ? AppColors.textHint
                          : AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    _fmt(widget.block.endTime),
                    style: AppTextStyles.bodyMedium.copyWith(fontSize: 11),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${widget.block.durationMinutes}m',
                    style: AppTextStyles.labelSmall.copyWith(fontSize: 10),
                  ),
                ],
              ),
            ),

            // Type icon circle
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: isDone
                    ? AppColors.success.withValues(alpha: 0.1)
                    : blockColor.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: isDone
                    ? ScaleTransition(
                        scale: _checkScale,
                        child: const Icon(Icons.check_circle,
                            color: AppColors.success, size: 18),
                      )
                    : Text(
                        widget.block.type.emoji,
                        style: const TextStyle(fontSize: 17),
                      ),
              ),
            ),

            const SizedBox(width: 12),

            // Title + subtitle
            Expanded(
              child: Opacity(
                opacity: isSkipped ? 0.45 : 1.0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.block.title,
                            style: AppTextStyles.titleMedium.copyWith(
                              fontSize: 14,
                              decoration: isSkipped
                                  ? TextDecoration.lineThrough
                                  : null,
                              color: isDone
                                  ? AppColors.textSecondary
                                  : AppColors.textPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (widget.isCurrentBlock)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 7, vertical: 2),
                            decoration: BoxDecoration(
                              color: blockColor,
                              borderRadius:
                                  BorderRadius.circular(AppRadius.full),
                            ),
                            child: Text(
                              'NOW',
                              style: AppTextStyles.labelSmall.copyWith(
                                color: Colors.white,
                                fontSize: 9,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                      ],
                    ),
                    if (widget.block.subtitle != null) ...[
                      const SizedBox(height: 3),
                      Text(
                        widget.block.subtitle!,
                        style:
                            AppTextStyles.bodyMedium.copyWith(fontSize: 12),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
            ),

            // Action button
            if (!isDone && !isSkipped && !isFixed)
              _ActionMenu(onComplete: widget.onComplete, onSkip: widget.onSkip)
            else if (!isDone && !isSkipped && isPrayer)
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: GestureDetector(
                  onTap: widget.onComplete,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: blockColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(AppRadius.full),
                    ),
                    child: Text(
                      'Prayed ✓',
                      style: AppTextStyles.labelLarge.copyWith(
                        fontSize: 11,
                        color: blockColor,
                      ),
                    ),
                  ),
                ),
              )
            else
              const SizedBox(width: 12),
          ],
        ),
      ),
      ), // AnimatedContainer
    ); // Semantics
  }

  Color _blockColor(TimeBlockType type, PrayerName? prayer) {
    if (prayer != null) {
      switch (prayer) {
        case PrayerName.fajr:    return AppColors.fajr;
        case PrayerName.dhuhr:   return AppColors.dhuhr;
        case PrayerName.asr:     return AppColors.asr;
        case PrayerName.maghrib: return AppColors.maghrib;
        case PrayerName.isha:    return AppColors.isha;
      }
    }
    switch (type) {
      case TimeBlockType.sleep:          return AppColors.isha;
      case TimeBlockType.goldenHour:     return AppColors.gold;
      case TimeBlockType.deepWork:       return AppColors.primary;
      case TimeBlockType.work:           return AppColors.primaryLight;
      case TimeBlockType.gym:            return const Color(0xFF2D7D46);
      case TimeBlockType.quran:          return AppColors.gold;
      case TimeBlockType.dhikr:          return AppColors.goldDark;
      case TimeBlockType.qaylula:        return AppColors.dhuhr;
      case TimeBlockType.meal:           return const Color(0xFFD4851A);
      case TimeBlockType.morningRoutine: return AppColors.fajr;
      case TimeBlockType.eveningRoutine: return AppColors.maghrib;
      case TimeBlockType.freeTime:       return const Color(0xFF5D8A6E);
      case TimeBlockType.break_:         return AppColors.textHint;
      default:                           return AppColors.primary;
    }
  }

  String _fmt(DateTime dt) => DateFormat('h:mm a').format(dt);
}

class _ActionMenu extends StatelessWidget {
  final VoidCallback? onComplete;
  final VoidCallback? onSkip;

  const _ActionMenu({this.onComplete, this.onSkip});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 4),
      child: PopupMenuButton<String>(
        icon: const Icon(Icons.more_vert,
            size: 18, color: AppColors.textHint),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        onSelected: (value) {
          if (value == 'complete') onComplete?.call();
          if (value == 'skip') onSkip?.call();
        },
        itemBuilder: (context) => [
          PopupMenuItem(
            value: 'complete',
            child: Row(children: [
              const Icon(Icons.check_circle_outline,
                  size: 18, color: AppColors.success),
              const SizedBox(width: 10),
              Text('Mark done',
                  style:
                      AppTextStyles.bodyMedium.copyWith(color: AppColors.success)),
            ]),
          ),
          PopupMenuItem(
            value: 'skip',
            child: Row(children: [
              const Icon(Icons.skip_next_outlined,
                  size: 18, color: AppColors.textHint),
              const SizedBox(width: 10),
              Text('Skip',
                  style: AppTextStyles.bodyMedium),
            ]),
          ),
        ],
      ),
    );
  }
}

// ─── SECTION HEADER ──────────────────────────────────────────────────────────
class TimelineSectionHeader extends StatelessWidget {
  final String label;
  final String? time;

  const TimelineSectionHeader({super.key, required this.label, this.time});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 16, 4, 8),
      child: Row(
        children: [
          Text(
            label.toUpperCase(),
            style: AppTextStyles.labelSmall.copyWith(letterSpacing: 1.4),
          ),
          if (time != null) ...[
            const Spacer(),
            Text(time!, style: AppTextStyles.bodyMedium.copyWith(fontSize: 11)),
          ],
        ],
      ),
    );
  }
}

// ─── MORNING INTENTION CARD ───────────────────────────────────────────────────
class MorningIntentionCard extends StatefulWidget {
  final String? existing;
  final ValueChanged<String> onSave;

  const MorningIntentionCard({
    super.key,
    this.existing,
    required this.onSave,
  });

  @override
  State<MorningIntentionCard> createState() => _MorningIntentionCardState();
}

class _MorningIntentionCardState extends State<MorningIntentionCard> {
  late final TextEditingController _ctrl;
  bool _editing = false;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(text: widget.existing ?? '');
    _editing = widget.existing == null || widget.existing!.isEmpty;
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(context.screenHPadding, 0, context.screenHPadding, 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1B4F72), Color(0xFF2E86C1)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('🤲', style: TextStyle(fontSize: 18)),
              const SizedBox(width: 8),
              Text(
                "Today's Niyyah",
                style: AppTextStyles.titleMedium.copyWith(color: Colors.white),
              ),
              const Spacer(),
              if (!_editing && widget.existing != null)
                GestureDetector(
                  onTap: () => setState(() => _editing = true),
                  child: Text(
                    'Edit',
                    style: AppTextStyles.bodyMedium
                        .copyWith(color: Colors.white60, fontSize: 12),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          if (_editing)
            Column(
              children: [
                TextField(
                  controller: _ctrl,
                  style: AppTextStyles.bodyLarge
                      .copyWith(color: Colors.white, fontSize: 14),
                  decoration: InputDecoration(
                    hintText:
                        'e.g. "Today I intend to be patient and productive for Allah\'s sake"',
                    hintStyle:
                        AppTextStyles.bodyMedium.copyWith(color: Colors.white38, fontSize: 13),
                    filled: true,
                    fillColor: Colors.white.withValues(alpha: 0.1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 12),
                  ),
                  maxLines: 2,
                  textCapitalization: TextCapitalization.sentences,
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_ctrl.text.trim().isNotEmpty) {
                        widget.onSave(_ctrl.text.trim());
                        setState(() => _editing = false);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.gold,
                      minimumSize: const Size(80, 36),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.full),
                      ),
                    ),
                    child: Text(
                      'Set Intention',
                      style: AppTextStyles.labelLarge.copyWith(
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            )
          else
            Text(
              widget.existing ?? '',
              style: AppTextStyles.bodyMedium
                  .copyWith(color: Colors.white, fontSize: 14, height: 1.4),
            ),
        ],
      ),
    );
  }
}

// ─── EMPTY STATE ─────────────────────────────────────────────────────────────
class TimelineEmptyState extends StatelessWidget {
  final VoidCallback onGenerate;

  const TimelineEmptyState({super.key, required this.onGenerate});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🌙', style: TextStyle(fontSize: 56)),
            const SizedBox(height: 20),
            Text(
              'No timeline yet',
              style: AppTextStyles.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Tap below to generate your personalized day around your prayers.',
              style: AppTextStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: 200,
              child: ElevatedButton(
                onPressed: onGenerate,
                child: const Text('Generate Today'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── LOADING SHIMMER ─────────────────────────────────────────────────────────
class TimelineLoadingShimmer extends StatefulWidget {
  const TimelineLoadingShimmer({super.key});

  @override
  State<TimelineLoadingShimmer> createState() => _TimelineLoadingShimmerState();
}

class _TimelineLoadingShimmerState extends State<TimelineLoadingShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _anim = Tween(begin: 0.4, end: 0.9).animate(_ctrl);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) => Opacity(
        opacity: _anim.value,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: List.generate(
              7,
              (i) => Container(
                height: 72,
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
