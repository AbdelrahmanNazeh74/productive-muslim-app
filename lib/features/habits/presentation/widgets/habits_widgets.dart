import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../../../../core/utils/responsive.dart';
import '../../../../shared/theme/app_theme.dart';
import '../../domain/entities/habit.dart';
import '../../domain/usecases/streak_calculator.dart';

// â”€â”€â”€ STREAK FLAME BADGE â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
/// The visual centrepiece â€” a flame that grows with the streak count.
class StreakFlameBadge extends StatefulWidget {
  final int streak;
  final double size;
  final bool animate;

  const StreakFlameBadge({
    super.key,
    required this.streak,
    this.size = 48,
    this.animate = false,
  });

  @override
  State<StreakFlameBadge> createState() => _StreakFlameBadgeState();
}

class _StreakFlameBadgeState extends State<StreakFlameBadge>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;
  late Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _scale = Tween(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut),
    );
    _opacity = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeIn),
    );

    if (widget.animate) {
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted) _ctrl.forward();
      });
    } else {
      _ctrl.value = 1.0;
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = _flameColor(widget.streak);
    final emoji = _flameEmoji(widget.streak);

    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) => Opacity(
        opacity: _opacity.value,
        child: Transform.scale(
          scale: _scale.value,
          child: SizedBox(
            width: widget.size,
            height: widget.size,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Glow ring
                if (widget.streak >= 7)
                  Container(
                    width: widget.size,
                    height: widget.size,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(colors: [
                        color.withValues(alpha: 0.25),
                        Colors.transparent,
                      ]),
                    ),
                  ),
                // Flame emoji
                Text(
                  emoji,
                  style: TextStyle(fontSize: widget.size * 0.55),
                ),
                // Streak number
                Positioned(
                  bottom: 2,
                  right: 2,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 4, vertical: 1),
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(AppRadius.full),
                      border: Border.all(color: Colors.white, width: 1),
                    ),
                    child: Text(
                      widget.streak > 999
                          ? '999+'
                          : widget.streak.toString(),
                      style: AppTextStyles.labelSmall.copyWith(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _flameColor(int streak) {
    if (streak >= 100) return const Color(0xFF9B59B6); // legendary purple
    if (streak >= 30) return AppColors.gold;
    if (streak >= 14) return const Color(0xFFE67E22); // orange
    if (streak >= 7) return AppColors.error;
    return AppColors.asr; // amber
  }

  String _flameEmoji(int streak) {
    if (streak == 0) return 'â—‹';
    if (streak >= 100) return 'ðŸ’œ';
    if (streak >= 30) return 'ðŸŒŸ';
    if (streak >= 14) return 'ðŸ”¥';
    if (streak >= 7) return 'ðŸ”¥';
    return 'ðŸ”¥';
  }
}

// â”€â”€â”€ 7-DAY HEAT MAP â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
class HeatMapRow extends StatelessWidget {
  final List<DayStatus> days;

  const HeatMapRow({super.key, required this.days});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: days.map((d) => _HeatDot(day: d)).toList(),
    );
  }
}

class _HeatDot extends StatelessWidget {
  final DayStatus day;
  const _HeatDot({required this.day});

  @override
  Widget build(BuildContext context) {
    final isToday = _isToday(day.date);

    Color dotColor;
    switch (day.status) {
      case DayStatusType.completed:
        dotColor = AppColors.success;
        break;
      case DayStatusType.missed:
        dotColor = AppColors.error.withValues(alpha: 0.35);
        break;
      case DayStatusType.excused:
        dotColor = AppColors.gold.withValues(alpha: 0.5);
        break;
      case DayStatusType.pending:
        dotColor = AppColors.primary.withValues(alpha: 0.2);
        break;
      case DayStatusType.notScheduled:
        dotColor = AppColors.surfaceVariant;
        break;
    }

    return Column(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: dotColor,
            shape: BoxShape.circle,
            border: isToday
                ? Border.all(color: AppColors.primary, width: 2)
                : null,
          ),
          child: day.status == DayStatusType.completed
              ? const Icon(Icons.check, color: Colors.white, size: 14)
              : day.status == DayStatusType.excused
                  ? const Center(
                      child: Text('~',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold)))
                  : null,
        ),
        const SizedBox(height: 4),
        Text(
          DateFormat('E').format(day.date)[0], // M T W T F S S
          style: AppTextStyles.labelSmall.copyWith(
            fontSize: 10,
            color: isToday ? AppColors.primary : AppColors.textHint,
            fontWeight: isToday ? FontWeight.w700 : FontWeight.w400,
          ),
        ),
      ],
    );
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }
}

// â”€â”€â”€ HABIT CARD â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
class HabitCard extends StatefulWidget {
  final Habit habit;
  final bool isCompleted;
  final bool isExcused;
  final List<DayStatus> heatMap;
  final VoidCallback onComplete;
  final VoidCallback onUndo;
  final VoidCallback onExcuse;
  final VoidCallback? onEdit;
  final bool isNewPersonalBest;

  const HabitCard({
    super.key,
    required this.habit,
    required this.isCompleted,
    required this.isExcused,
    required this.heatMap,
    required this.onComplete,
    required this.onUndo,
    required this.onExcuse,
    this.onEdit,
    this.isNewPersonalBest = false,
  });

  @override
  State<HabitCard> createState() => _HabitCardState();
}

class _HabitCardState extends State<HabitCard>
    with SingleTickerProviderStateMixin {
  bool _expanded = false;
  late AnimationController _celebCtrl;
  late Animation<double> _celebScale;

  @override
  void initState() {
    super.initState();
    _celebCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _celebScale = Tween(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _celebCtrl, curve: Curves.easeOut),
    );
  }

  @override
  void didUpdateWidget(HabitCard old) {
    super.didUpdateWidget(old);
    if (!old.isCompleted && widget.isCompleted) {
      _playCompletionAnimation();
    }
  }

  void _playCompletionAnimation() {
    HapticFeedback.mediumImpact();
    _celebCtrl.forward().then((_) => _celebCtrl.reverse());
  }

  @override
  void dispose() {
    _celebCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final catColor = _categoryColor(widget.habit.category);
    final isDone = widget.isCompleted;
    final isExcused = widget.isExcused;

    return Semantics(
      label: '${widget.habit.name}, streak ${widget.habit.currentStreak} days, '
          '${isDone ? 'done today' : isExcused ? 'excused today' : 'tap to complete'}',
      child: ScaleTransition(
      scale: _celebScale,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 280),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: isDone
              ? AppColors.success.withValues(alpha: 0.06)
              : isExcused
                  ? AppColors.gold.withValues(alpha: 0.06)
                  : AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(
            color: isDone
                ? AppColors.success.withValues(alpha: 0.4)
                : isExcused
                    ? AppColors.gold.withValues(alpha: 0.4)
                    : AppColors.surfaceVariant,
            width: 1.5,
          ),
          boxShadow: widget.isNewPersonalBest && isDone
              ? [
                  BoxShadow(
                    color: AppColors.gold.withValues(alpha: 0.3),
                    blurRadius: 16,
                    spreadRadius: 2,
                  )
                ]
              : null,
        ),
        child: Column(
          children: [
            // â”€â”€ Main row â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
            InkWell(
              onTap: () => setState(() => _expanded = !_expanded),
              borderRadius: BorderRadius.circular(AppRadius.lg),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    // Category color bar
                    Container(
                      width: 4,
                      height: 52,
                      decoration: BoxDecoration(
                        color: isDone
                            ? AppColors.success
                            : isExcused
                                ? AppColors.gold
                                : catColor,
                        borderRadius:
                            BorderRadius.circular(AppRadius.full),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Emoji + streak flame
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: catColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              widget.habit.emoji,
                              style: const TextStyle(fontSize: 22),
                            ),
                          ),
                        ),
                        if (widget.habit.currentStreak > 0)
                          Positioned(
                            top: -6,
                            right: -6,
                            child: StreakFlameBadge(
                              streak: widget.habit.currentStreak,
                              size: 26,
                              animate: !isDone &&
                                  widget.isNewPersonalBest,
                            ),
                          ),
                      ],
                    ),

                    const SizedBox(width: 12),

                    // Text
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  widget.habit.name,
                                  style: AppTextStyles.titleMedium
                                      .copyWith(
                                    fontSize: 14,
                                    color: isDone
                                        ? AppColors.textSecondary
                                        : AppColors.textPrimary,
                                    decoration: isDone
                                        ? TextDecoration.lineThrough
                                        : null,
                                    decorationColor:
                                        AppColors.textSecondary,
                                  ),
                                ),
                              ),
                              if (widget.isNewPersonalBest && isDone)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AppColors.gold,
                                    borderRadius: BorderRadius.circular(
                                        AppRadius.full),
                                  ),
                                  child: Text(
                                    'ðŸ† Best!',
                                    style: AppTextStyles.labelSmall
                                        .copyWith(
                                      color: Colors.white,
                                      fontSize: 9,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 3),
                          Text(
                            isDone
                                ? 'âœ“ Done Â· ${widget.habit.currentStreak} day streak'
                                : isExcused
                                    ? '~ Excused Â· streak preserved'
                                    : widget.habit.description ??
                                        widget.habit.category.label,
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontSize: 12,
                              color: isDone
                                  ? AppColors.success
                                  : isExcused
                                      ? AppColors.gold
                                      : AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Check button
                    const SizedBox(width: 8),
                    _CheckButton(
                      isDone: isDone,
                      isExcused: isExcused,
                      catColor: catColor,
                      onComplete: widget.onComplete,
                      onUndo: widget.onUndo,
                    ),
                  ],
                ),
              ),
            ),

            // â”€â”€ Expanded detail â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
            if (_expanded)
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Divider(height: 1),
                    const SizedBox(height: 12),

                    // Heat map
                    HeatMapRow(days: widget.heatMap),

                    const SizedBox(height: 14),

                    // Stats row
                    Row(
                      children: [
                        _MiniStat(
                          label: 'Current',
                          value: '${widget.habit.currentStreak}d',
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 12),
                        _MiniStat(
                          label: 'Best',
                          value: '${widget.habit.longestStreak}d',
                          color: AppColors.gold,
                        ),
                        const SizedBox(width: 12),
                        _MiniStat(
                          label: 'Target',
                          value: '${widget.habit.targetFrequencyPerWeek}Ã—/wk',
                          color: AppColors.textSecondary,
                        ),
                        const Spacer(),

                        // Excuse + edit actions
                        if (!isDone && !isExcused)
                          TextButton(
                            onPressed: widget.onExcuse,
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              minimumSize: Size.zero,
                            ),
                            child: Text(
                              'Excuse',
                              style: AppTextStyles.bodyMedium.copyWith(
                                fontSize: 12,
                                color: AppColors.gold,
                              ),
                            ),
                          ),
                        if (widget.onEdit != null && !widget.habit.isSystemHabit)
                          IconButton(
                            onPressed: widget.onEdit,
                            icon: const Icon(Icons.edit_outlined,
                                size: 16, color: AppColors.textHint),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(
                                minWidth: 28, minHeight: 28),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
      ), // ScaleTransition
    ); // Semantics
  }

  Color _categoryColor(HabitCategory cat) {
    switch (cat) {
      case HabitCategory.spiritual: return AppColors.fajr;
      case HabitCategory.fitness:   return AppColors.success;
      case HabitCategory.health:    return AppColors.dhuhr;
      case HabitCategory.work:      return AppColors.primary;
      case HabitCategory.personal:  return AppColors.gold;
    }
  }
}

// â”€â”€â”€ CHECK BUTTON â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
class _CheckButton extends StatelessWidget {
  final bool isDone;
  final bool isExcused;
  final Color catColor;
  final VoidCallback onComplete;
  final VoidCallback onUndo;

  const _CheckButton({
    required this.isDone,
    required this.isExcused,
    required this.catColor,
    required this.onComplete,
    required this.onUndo,
  });

  @override
  Widget build(BuildContext context) {
    if (isDone) {
      return GestureDetector(
        onTap: onUndo,
        child: Container(
          width: 36,
          height: 36,
          decoration: const BoxDecoration(
            color: AppColors.success,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.check, color: Colors.white, size: 18),
        ),
      );
    }

    if (isExcused) {
      return Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: AppColors.gold.withValues(alpha: 0.15),
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.gold, width: 1.5),
        ),
        child: const Center(
          child: Text('~',
              style: TextStyle(
                  color: AppColors.gold,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
        ),
      );
    }

    return GestureDetector(
      onTap: onComplete,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: Colors.transparent,
          shape: BoxShape.circle,
          border: Border.all(color: catColor.withValues(alpha: 0.5), width: 2),
        ),
        child: Center(
          child: Icon(Icons.circle_outlined, color: catColor, size: 18),
        ),
      ),
    );
  }
}

// â”€â”€â”€ MINI STAT â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
class _MiniStat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _MiniStat(
      {required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value,
            style:
                AppTextStyles.titleMedium.copyWith(color: color, fontSize: 15)),
        Text(label,
            style: AppTextStyles.labelSmall.copyWith(fontSize: 10)),
      ],
    );
  }
}

// â”€â”€â”€ WEEKLY SPIRITUAL SCORE CARD â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
class WeeklyScoreCard extends StatelessWidget {
  final WeeklySpiritualScore score;

  const WeeklyScoreCard({super.key, required this.score});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(context.screenHPadding, 0, context.screenHPadding, 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            AppColors.primaryDark,
            AppColors.primary,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              const Text('ðŸ“Š', style: TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Text(
                'Weekly Spiritual Score',
                style: AppTextStyles.titleMedium
                    .copyWith(color: Colors.white),
              ),
              const Spacer(),
              Text(
                _weekLabel(),
                style: AppTextStyles.bodyMedium
                    .copyWith(color: Colors.white60, fontSize: 12),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Main score ring + grade
          Row(
            children: [
              CircularPercentIndicator(
                radius: 44,
                lineWidth: 8,
                percent: score.totalScore / 100,
                center: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${score.totalScore}',
                      style: AppTextStyles.dataLarge.copyWith(
                        color: Colors.white,
                        fontSize: 22,
                      ),
                    ),
                    Text(
                      'pts',
                      style: AppTextStyles.labelSmall
                          .copyWith(color: Colors.white60, fontSize: 9),
                    ),
                  ],
                ),
                progressColor: AppColors.gold,
                backgroundColor: Colors.white.withValues(alpha: 0.15),
                circularStrokeCap: CircularStrokeCap.round,
              ),

              const SizedBox(width: 20),

              // Grade + breakdown
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      score.grade,
                      style: AppTextStyles.headlineMedium.copyWith(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _ScoreBar(
                      label: 'ðŸ¤² Prayers',
                      score: score.prayerScore,
                      weight: '50%',
                    ),
                    const SizedBox(height: 6),
                    _ScoreBar(
                      label: 'ðŸ“– Quran',
                      score: score.quranScore,
                      weight: '20%',
                    ),
                    const SizedBox(height: 6),
                    _ScoreBar(
                      label: 'âœ… Habits',
                      score: score.habitsScore,
                      weight: '20%',
                    ),
                    const SizedBox(height: 6),
                    _ScoreBar(
                      label: 'ðŸ‹ï¸ Fitness',
                      score: score.gymScore,
                      weight: '10%',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _weekLabel() {
    final end = score.weekStart.add(const Duration(days: 6));
    return '${DateFormat('MMM d').format(score.weekStart)} â€“ '
        '${DateFormat('d').format(end)}';
  }
}

class _ScoreBar extends StatelessWidget {
  final String label;
  final int score;
  final String weight;

  const _ScoreBar(
      {required this.label, required this.score, required this.weight});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 80,
          child: Text(label,
              style: AppTextStyles.labelSmall
                  .copyWith(color: Colors.white70, fontSize: 10)),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.full),
            child: LinearProgressIndicator(
              value: score / 100,
              backgroundColor: Colors.white.withValues(alpha: 0.15),
              valueColor: AlwaysStoppedAnimation(
                score >= 80
                    ? AppColors.success
                    : score >= 50
                        ? AppColors.gold
                        : AppColors.error,
              ),
              minHeight: 6,
            ),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          '$score',
          style: AppTextStyles.labelSmall.copyWith(
            color: Colors.white,
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

// â”€â”€â”€ CELEBRATION OVERLAY â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
/// Shown briefly when a new personal best streak is achieved.
class PersonalBestCelebration extends StatefulWidget {
  final Habit habit;
  final VoidCallback onDismiss;

  const PersonalBestCelebration({
    super.key,
    required this.habit,
    required this.onDismiss,
  });

  @override
  State<PersonalBestCelebration> createState() =>
      _PersonalBestCelebrationState();
}

class _PersonalBestCelebrationState extends State<PersonalBestCelebration>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _slide;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _slide = Tween(begin: 60.0, end: 0.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOut),
    );
    _fade = Tween(begin: 0.0, end: 1.0).animate(_ctrl);
    _ctrl.forward();

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        _ctrl.reverse().then((_) => widget.onDismiss());
      }
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) => Opacity(
        opacity: _fade.value,
        child: Transform.translate(
          offset: Offset(0, _slide.value),
          child: GestureDetector(
            onTap: widget.onDismiss,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: context.screenHPadding),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.goldDark, AppColors.gold],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(AppRadius.lg),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.gold.withValues(alpha: 0.4),
                    blurRadius: 20,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Text('ðŸ†', style: TextStyle(fontSize: 32)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'New Personal Best!',
                          style: AppTextStyles.titleMedium
                              .copyWith(color: Colors.white),
                        ),
                        Text(
                          '${widget.habit.name} Â· '
                          '${widget.habit.longestStreak} day streak ðŸ”¥',
                          style: AppTextStyles.bodyMedium
                              .copyWith(color: Colors.white.withValues(alpha: 0.8), fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// â”€â”€â”€ CATEGORY FILTER BAR â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
class CategoryFilterBar extends StatelessWidget {
  final HabitCategory? selected;
  final ValueChanged<HabitCategory?> onChanged;

  const CategoryFilterBar({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        children: [
          // All categories
          _FilterChip(
            label: 'All',
            isSelected: selected == null,
            onTap: () => onChanged(null),
          ),
          const SizedBox(width: 8),
          ...HabitCategory.values.map((cat) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: _FilterChip(
                  label: '${cat.emoji} ${cat.label}',
                  isSelected: selected == cat,
                  onTap: () =>
                      onChanged(selected == cat ? null : cat),
                ),
              )),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip(
      {required this.label,
      required this.isSelected,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color:
              isSelected ? AppColors.primary : AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(AppRadius.full),
        ),
        child: Text(
          label,
          style: AppTextStyles.labelLarge.copyWith(
            fontSize: 12,
            color: isSelected ? Colors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

// â”€â”€â”€ ADD HABIT BOTTOM SHEET â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
class AddHabitSheet extends StatefulWidget {
  final Habit? existing; // null = create, non-null = edit
  final ValueChanged<Habit> onSave;

  const AddHabitSheet({super.key, this.existing, required this.onSave});

  @override
  State<AddHabitSheet> createState() => _AddHabitSheetState();
}

class _AddHabitSheetState extends State<AddHabitSheet> {
  late final TextEditingController _nameCtrl;
  late HabitCategory _category;
  late String _emoji;
  late int _frequency;
  late String _timeAnchor;
  final _emojis = ['ðŸ¤²', 'ðŸ“–', 'ðŸ“¿', 'ðŸ‹ï¸', 'ðŸƒ', 'ðŸ’§', 'ðŸ¥—', 'ðŸ“š', 'âœï¸', 'ðŸŒ±', 'ðŸ’¤', 'â˜•'];

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.existing?.name ?? '');
    _category = widget.existing?.category ?? HabitCategory.personal;
    _emoji = widget.existing?.emoji ?? 'ðŸŒ±';
    _frequency = widget.existing?.targetFrequencyPerWeek ?? 7;
    _timeAnchor = widget.existing?.timeAnchor ?? 'anytime';
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: EdgeInsets.fromLTRB(context.screenHPadding, 12, context.screenHPadding, 32),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(
              top: Radius.circular(AppRadius.xl)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.stepInactive,
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
              ),
            ),
            const SizedBox(height: 20),

            Text(
              widget.existing == null ? 'New Habit' : 'Edit Habit',
              style: AppTextStyles.headlineMedium,
            ),
            const SizedBox(height: 20),

            // Emoji picker
            Text('EMOJI', style: AppTextStyles.labelSmall),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _emojis.map((e) {
                return GestureDetector(
                  onTap: () => setState(() => _emoji = e),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: _emoji == e
                          ? AppColors.primary.withValues(alpha: 0.12)
                          : AppColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(10),
                      border: _emoji == e
                          ? Border.all(
                              color: AppColors.primary, width: 2)
                          : null,
                    ),
                    child: Center(
                      child: Text(e,
                          style: const TextStyle(fontSize: 20)),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            // Name
            Text('HABIT NAME', style: AppTextStyles.labelSmall),
            const SizedBox(height: 8),
            TextField(
              controller: _nameCtrl,
              style: AppTextStyles.bodyLarge,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                hintText: 'e.g. Read 10 pages',
              ),
            ),
            const SizedBox(height: 20),

            // Category
            Text('CATEGORY', style: AppTextStyles.labelSmall),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: HabitCategory.values.map((cat) {
                final sel = _category == cat;
                return GestureDetector(
                  onTap: () => setState(() => _category = cat),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: sel
                          ? AppColors.primary.withValues(alpha: 0.1)
                          : AppColors.surfaceVariant,
                      borderRadius:
                          BorderRadius.circular(AppRadius.full),
                      border: sel
                          ? Border.all(
                              color: AppColors.primary, width: 1.5)
                          : null,
                    ),
                    child: Text(
                      '${cat.emoji} ${cat.label}',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: sel
                            ? AppColors.primary
                            : AppColors.textPrimary,
                        fontWeight: sel
                            ? FontWeight.w600
                            : FontWeight.w400,
                        fontSize: 13,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            // Frequency
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('FREQUENCY PER WEEK',
                    style: AppTextStyles.labelSmall),
                Text(
                  '$_frequencyÃ— / week',
                  style: AppTextStyles.titleMedium
                      .copyWith(color: AppColors.primary, fontSize: 14),
                ),
              ],
            ),
            Slider(
              value: _frequency.toDouble(),
              min: 1,
              max: 7,
              divisions: 6,
              activeColor: AppColors.primary,
              inactiveColor: AppColors.stepInactive,
              onChanged: (v) => setState(() => _frequency = v.round()),
            ),
            const SizedBox(height: 24),

            // Save button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  if (_nameCtrl.text.trim().isEmpty) return;
                  final habit = (widget.existing ??
                          Habit(
                            id: '',
                            name: '',
                            emoji: '',
                            category: _category,
                            createdAt: DateTime.now(),
                          ))
                      .copyWith(
                    name: _nameCtrl.text.trim(),
                    emoji: _emoji,
                    category: _category,
                    targetFrequencyPerWeek: _frequency,
                    timeAnchor: _timeAnchor,
                  );
                  widget.onSave(habit);
                  Navigator.of(context).pop();
                },
                child: Text(
                  widget.existing == null ? 'Add Habit' : 'Save Changes',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
