import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../../../../core/utils/responsive.dart';
import '../../../../shared/theme/app_theme.dart';
import '../../domain/entities/analytics_entities.dart';

// ─── SECTION CARD WRAPPER ─────────────────────────────────────────────────────
class AnalyticsCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget child;
  final Widget? trailing;

  const AnalyticsCard({
    super.key,
    required this.title,
    this.subtitle,
    required this.child,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      margin: EdgeInsets.fromLTRB(context.screenHPadding, 0, context.screenHPadding, 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: cs.outlineVariant, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: AppTextStyles.titleMedium.copyWith(color: cs.onSurface)),
                  if (subtitle != null)
                    Text(subtitle!,
                        style: AppTextStyles.bodyMedium
                            .copyWith(fontSize: 12, color: cs.onSurfaceVariant)),
                ],
              ),
              if (trailing != null) trailing!,
            ],
          ),
          const SizedBox(height: 20),
          child,
        ],
      ),
    );
  }
}

// ─── WEEKLY SCORE LINE CHART ──────────────────────────────────────────────────
/// Trend line of total spiritual score across multiple weeks.
class WeeklyScoreLineChart extends StatelessWidget {
  final WeeklyScoreSeries series;

  const WeeklyScoreLineChart({super.key, required this.series});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    if (series.points.isEmpty) {
      return const _EmptyChart(message: 'No score data yet');
    }

    final spots = series.points
        .asMap()
        .entries
        .map((e) => FlSpot(e.key.toDouble(), e.value.totalScore.toDouble()))
        .toList();

    final avgScore = series.averageScore;

    return Column(
      children: [
        // Summary row
        Row(
          children: [
            _ScoreSummaryChip(
              label: 'Average',
              value: '${avgScore.round()}',
              color: AppColors.primary,
            ),
            const SizedBox(width: 8),
            _ScoreSummaryChip(
              label: 'Trend',
              value: series.trendLabel,
              color: series.trend > 0
                  ? AppColors.success
                  : series.trend < 0
                      ? AppColors.error
                      : AppColors.textSecondary,
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Chart
        SizedBox(
          height: 180,
          child: LineChart(
            LineChartData(
              minX: 0,
              maxX: (series.points.length - 1).toDouble(),
              minY: 0,
              maxY: 100,
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: 25,
                getDrawingHorizontalLine: (_) => FlLine(
                  color: cs.outlineVariant.withValues(alpha: 0.5),
                  strokeWidth: 1,
                  dashArray: [4, 4],
                ),
              ),
              borderData: FlBorderData(show: false),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 32,
                    interval: 25,
                    getTitlesWidget: (v, _) => Text(
                      '${v.toInt()}',
                      style: AppTextStyles.labelSmall
                          .copyWith(fontSize: 10, color: cs.onSurfaceVariant),
                    ),
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 24,
                    getTitlesWidget: (v, _) {
                      final i = v.toInt();
                      if (i < 0 || i >= series.points.length) {
                        return const SizedBox.shrink();
                      }
                      return Text(
                        series.points[i].shortLabel,
                        style: AppTextStyles.labelSmall
                            .copyWith(fontSize: 9, color: cs.onSurfaceVariant),
                      );
                    },
                  ),
                ),
                topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false)),
                rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false)),
              ),
              lineBarsData: [
                // Total score line
                LineChartBarData(
                  spots: spots,
                  isCurved: true,
                  curveSmoothness: 0.35,
                  color: AppColors.primary,
                  barWidth: 3,
                  isStrokeCapRound: true,
                  dotData: FlDotData(
                    show: true,
                    getDotPainter: (spot, _, __, ___) => FlDotCirclePainter(
                      radius: 4,
                      color: cs.surface,
                      strokeWidth: 2.5,
                      strokeColor: AppColors.primary,
                    ),
                  ),
                  belowBarData: BarAreaData(
                    show: true,
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primary.withValues(alpha: 0.18),
                        AppColors.primary.withValues(alpha: 0.0),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
                // Average reference line
                LineChartBarData(
                  spots: [
                    FlSpot(0, avgScore),
                    FlSpot((series.points.length - 1).toDouble(), avgScore),
                  ],
                  isCurved: false,
                  color: AppColors.gold.withValues(alpha: 0.6),
                  barWidth: 1.5,
                  dashArray: [6, 4],
                  dotData: const FlDotData(show: false),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ─── PRAYER BAR CHART ─────────────────────────────────────────────────────────
/// Horizontal bars showing per-prayer on-time rate.
class PrayerBarChart extends StatelessWidget {
  final PrayerAnalytics analytics;

  const PrayerBarChart({super.key, required this.analytics});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      children: [
        // Overall summary
        Row(
          children: [
            CircularPercentIndicator(
              radius: 32,
              lineWidth: 6,
              percent: analytics.overallRate,
              center: Text(
                '${(analytics.overallRate * 100).round()}%',
                style: AppTextStyles.labelLarge
                    .copyWith(color: AppColors.primary, fontSize: 11),
              ),
              progressColor: AppColors.primary,
              backgroundColor: cs.surfaceContainerHighest,
              circularStrokeCap: CircularStrokeCap.round,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Overall Prayer Rate',
                      style: AppTextStyles.titleMedium
                          .copyWith(fontSize: 14, color: cs.onSurface)),
                  Text(
                    'Best: ${analytics.bestPrayer} · '
                    'Needs work: ${analytics.weakestPrayer}',
                    style: AppTextStyles.bodyMedium
                        .copyWith(fontSize: 12, color: cs.onSurfaceVariant),
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        // Per-prayer bars
        ...analytics.byPrayer.map((p) => _PrayerBar(stat: p)),
      ],
    );
  }
}

class _PrayerBar extends StatelessWidget {
  final PrayerStat stat;
  const _PrayerBar({required this.stat});

  Color get _color {
    switch (stat.prayerName) {
      case 'fajr':    return AppColors.fajr;
      case 'dhuhr':   return AppColors.dhuhr;
      case 'asr':     return AppColors.asr;
      case 'maghrib': return AppColors.maghrib;
      case 'isha':    return AppColors.isha;
      default:        return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Text(stat.emoji, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 8),
          SizedBox(
            width: 52,
            child: Text(stat.label,
                style: AppTextStyles.bodyMedium
                    .copyWith(fontSize: 13, color: cs.onSurface)),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.full),
                  child: LinearProgressIndicator(
                    value: stat.rate,
                    backgroundColor: cs.surfaceContainerHighest,
                    valueColor: AlwaysStoppedAnimation(_color),
                    minHeight: 10,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${stat.completedCount}/${stat.totalDays} days',
                  style: AppTextStyles.labelSmall
                      .copyWith(fontSize: 10, color: cs.onSurfaceVariant),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '${(stat.rate * 100).round()}%',
            style: AppTextStyles.labelLarge.copyWith(
              fontSize: 13,
              color: _color,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── HABIT COMPLETION BAR CHART ───────────────────────────────────────────────
class HabitCompletionChart extends StatelessWidget {
  final HabitAnalytics analytics;

  const HabitCompletionChart({super.key, required this.analytics});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    if (analytics.dailyRates.isEmpty) {
      return const _EmptyChart(message: 'No habit data yet');
    }

    return Column(
      children: [
        // Summary row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _MiniKpi(
              label: 'Overall',
              value: '${(analytics.overallRate * 100).round()}%',
              color: AppColors.success,
            ),
            _MiniKpi(
              label: 'Total streak days',
              value: analytics.totalStreakDays.toString(),
              color: AppColors.gold,
            ),
          ],
        ),
        const SizedBox(height: 16),

        SizedBox(
          height: 140,
          child: BarChart(
            BarChartData(
              maxY: 100,
              minY: 0,
              barGroups: analytics.dailyRates.asMap().entries.map((e) {
                final rate = e.value.rate;
                final color = rate >= 0.8
                    ? AppColors.success
                    : rate >= 0.5
                        ? AppColors.gold
                        : AppColors.error.withValues(alpha: 0.7);
                return BarChartGroupData(
                  x: e.key,
                  barRods: [
                    BarChartRodData(
                      toY: rate * 100,
                      color: color,
                      width: analytics.dailyRates.length > 14 ? 6 : 12,
                      borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(4)),
                    ),
                  ],
                );
              }).toList(),
              borderData: FlBorderData(show: false),
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: 50,
                getDrawingHorizontalLine: (_) => FlLine(
                  color: cs.outlineVariant.withValues(alpha: 0.4),
                  strokeWidth: 1,
                  dashArray: [4, 4],
                ),
              ),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 28,
                    interval: 50,
                    getTitlesWidget: (v, _) => Text(
                      '${v.toInt()}%',
                      style: AppTextStyles.labelSmall
                          .copyWith(fontSize: 9, color: cs.onSurfaceVariant),
                    ),
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: analytics.dailyRates.length <= 14,
                    reservedSize: 18,
                    getTitlesWidget: (v, _) {
                      final i = v.toInt();
                      if (i < 0 ||
                          i >= analytics.dailyRates.length ||
                          i % 2 != 0) {
                        return const SizedBox.shrink();
                      }
                      return Text(
                        DateFormat('d').format(analytics.dailyRates[i].date),
                        style: AppTextStyles.labelSmall
                            .copyWith(fontSize: 9, color: cs.onSurfaceVariant),
                      );
                    },
                  ),
                ),
                topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false)),
                rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false)),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ─── MONTHLY HEATMAP CALENDAR ─────────────────────────────────────────────────
class MonthlyHeatmapCalendar extends StatelessWidget {
  final MonthlyHeatmap heatmap;
  final VoidCallback onPrevMonth;
  final VoidCallback onNextMonth;

  const MonthlyHeatmapCalendar({
    super.key,
    required this.heatmap,
    required this.onPrevMonth,
    required this.onNextMonth,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      children: [
        // Month nav
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: onPrevMonth,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: cs.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
                child: Icon(Icons.chevron_left, size: 18, color: cs.onSurface),
              ),
            ),
            Column(
              children: [
                Text(heatmap.monthLabel,
                    style: AppTextStyles.titleMedium
                        .copyWith(color: cs.onSurface)),
                Text(
                  '${heatmap.perfectDays} perfect · '
                  '${heatmap.missedDays} missed',
                  style: AppTextStyles.bodyMedium
                      .copyWith(fontSize: 11, color: cs.onSurfaceVariant),
                ),
              ],
            ),
            GestureDetector(
              onTap: onNextMonth,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: cs.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
                child: Icon(Icons.chevron_right, size: 18, color: cs.onSurface),
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Day-of-week header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: ['M', 'T', 'W', 'T', 'F', 'S', 'S']
              .map((d) => SizedBox(
                    width: 36,
                    child: Center(
                      child: Text(d,
                          style: AppTextStyles.labelSmall.copyWith(
                              fontSize: 11, color: cs.onSurfaceVariant)),
                    ),
                  ))
              .toList(),
        ),

        const SizedBox(height: 8),

        // Calendar grid
        _buildCalendarGrid(heatmap),

        const SizedBox(height: 16),

        // Legend
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _LegendDot(
                color: cs.onSurface.withValues(alpha: 0.12), label: 'No data'),
            const SizedBox(width: 12),
            _LegendDot(
                color: AppColors.error.withValues(alpha: 0.4), label: 'Low'),
            const SizedBox(width: 12),
            const _LegendDot(color: AppColors.gold, label: 'Good'),
            const SizedBox(width: 12),
            const _LegendDot(color: AppColors.success, label: 'Perfect'),
          ],
        ),
      ],
    );
  }

  Widget _buildCalendarGrid(MonthlyHeatmap heatmap) {
    final firstDay = DateTime(heatmap.year, heatmap.month, 1);
    // weekday: 1=Mon … 7=Sun; offset = weekday - 1 (0-indexed from Mon)
    final offset = firstDay.weekday - 1;

    final allCells = <Widget>[
      ...List.generate(offset, (_) => const SizedBox(width: 36, height: 36)),
      ...heatmap.days.map((d) => _HeatmapCell(day: d)),
    ];

    final rows = <Widget>[];
    for (int r = 0; r < (allCells.length / 7).ceil(); r++) {
      final start = r * 7;
      final end = (start + 7).clamp(0, allCells.length);
      final rowCells = allCells.sublist(start, end);
      // Pad last row
      while (rowCells.length < 7) {
        rowCells.add(const SizedBox(width: 36, height: 36));
      }
      rows.add(Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: rowCells,
        ),
      ));
    }

    return Column(children: rows);
  }
}

class _HeatmapCell extends StatelessWidget {
  final HeatmapDay day;
  const _HeatmapCell({required this.day});

  Color _cellColor(ColorScheme cs) {
    if (!day.hasPassed) return cs.onSurface.withValues(alpha: 0.08);
    if (day.isEmpty) return AppColors.error.withValues(alpha: 0.25);
    if (day.isDim) return AppColors.gold.withValues(alpha: 0.4);
    if (day.isGood) return AppColors.success.withValues(alpha: 0.55);
    return AppColors.success; // perfect
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isToday = _isToday(day.date);

    return Tooltip(
      message: '${DateFormat('MMM d').format(day.date)}\n'
          '${day.prayersCompleted}/5 prayers · '
          '${day.habitsCompleted} habits',
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: _cellColor(cs),
          borderRadius: BorderRadius.circular(8),
          border: isToday ? Border.all(color: cs.primary, width: 2) : null,
        ),
        child: day.isPerfect && day.hasPassed
            ? const Center(
                child: Text('⭐', style: TextStyle(fontSize: 14)),
              )
            : Center(
                child: Text(
                  '${day.date.day}',
                  style: AppTextStyles.labelSmall.copyWith(
                    fontSize: 11,
                    color: day.hasPassed && !day.isEmpty
                        ? Colors.white
                        : cs.onSurface.withValues(alpha: 0.4),
                    fontWeight: isToday ? FontWeight.w700 : FontWeight.w400,
                  ),
                ),
              ),
      ),
    );
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }
}

// ─── HABIT LEADERBOARD ────────────────────────────────────────────────────────
/// Top habits ranked by completion rate for the period.
class HabitLeaderboard extends StatelessWidget {
  final HabitAnalytics analytics;
  final int maxItems;

  const HabitLeaderboard({
    super.key,
    required this.analytics,
    this.maxItems = 5,
  });

  @override
  Widget build(BuildContext context) {
    if (analytics.habitStats.isEmpty) {
      return const _EmptyChart(message: 'No habits tracked yet');
    }

    final sorted = List<HabitStat>.from(analytics.habitStats)
      ..sort((a, b) => b.completionRate.compareTo(a.completionRate));
    final top = sorted.take(maxItems).toList();

    return Column(
      children: top.asMap().entries.map((entry) {
        final rank = entry.key + 1;
        final stat = entry.value;
        return _LeaderboardRow(rank: rank, stat: stat);
      }).toList(),
    );
  }
}

class _LeaderboardRow extends StatelessWidget {
  final int rank;
  final HabitStat stat;

  const _LeaderboardRow({required this.rank, required this.stat});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final rankEmoji = rank == 1
        ? '🥇'
        : rank == 2
            ? '🥈'
            : rank == 3
                ? '🥉'
                : '$rank';

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          SizedBox(
            width: 28,
            child: Text(rankEmoji,
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center),
          ),
          const SizedBox(width: 10),
          Text(stat.emoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(stat.name,
                    style: AppTextStyles.titleMedium
                        .copyWith(fontSize: 13, color: cs.onSurface)),
                Row(
                  children: [
                    Text('${stat.currentStreak}d streak',
                        style: AppTextStyles.labelSmall
                            .copyWith(color: AppColors.gold, fontSize: 10)),
                    const SizedBox(width: 8),
                    Text('${stat.completedDays}/${stat.targetDays} days',
                        style: AppTextStyles.labelSmall.copyWith(
                            fontSize: 10, color: cs.onSurfaceVariant)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 80,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${(stat.completionRate * 100).round()}%',
                  style: AppTextStyles.titleMedium.copyWith(
                    fontSize: 14,
                    color: stat.completionRate >= 0.8
                        ? AppColors.success
                        : stat.completionRate >= 0.5
                            ? AppColors.gold
                            : AppColors.error,
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.full),
                  child: LinearProgressIndicator(
                    value: stat.completionRate,
                    backgroundColor: cs.surfaceContainerHighest,
                    valueColor: AlwaysStoppedAnimation(
                      stat.completionRate >= 0.8
                          ? AppColors.success
                          : stat.completionRate >= 0.5
                              ? AppColors.gold
                              : AppColors.error,
                    ),
                    minHeight: 4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── WEEKLY SCORE BREAKDOWN ───────────────────────────────────────────────────
/// Shows the most recent week's component scores in a compact grid.
class WeeklyScoreBreakdown extends StatelessWidget {
  final WeeklyScorePoint? latest;

  const WeeklyScoreBreakdown({super.key, this.latest});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    if (latest == null) {
      return const _EmptyChart(message: 'No score data yet');
    }

    final components = [
      ('🤲', 'Prayers', latest!.prayerScore, '50%'),
      ('📖', 'Quran', latest!.quranScore, '20%'),
      ('✅', 'Habits', latest!.habitsScore, '20%'),
      ('🏋️', 'Fitness', latest!.gymScore, '10%'),
    ];

    return Column(
      children: [
        // Total score circle
        Row(
          children: [
            CircularPercentIndicator(
              radius: 44,
              lineWidth: 8,
              percent: latest!.totalScore / 100,
              center: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${latest!.totalScore}',
                    style: AppTextStyles.dataLarge.copyWith(fontSize: 22),
                  ),
                  Text('pts',
                      style: AppTextStyles.labelSmall.copyWith(
                          fontSize: 9, color: cs.onSurfaceVariant)),
                ],
              ),
              progressColor: _scoreColor(latest!.totalScore),
              backgroundColor: cs.surfaceContainerHighest,
              circularStrokeCap: CircularStrokeCap.round,
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                children: components
                    .map((c) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            children: [
                              Text(c.$1,
                                  style: const TextStyle(fontSize: 14)),
                              const SizedBox(width: 6),
                              Text(c.$2,
                                  style: AppTextStyles.bodyMedium.copyWith(
                                      fontSize: 12, color: cs.onSurface)),
                              const Spacer(),
                              Text(c.$4,
                                  style: AppTextStyles.labelSmall.copyWith(
                                      fontSize: 9,
                                      color: cs.onSurface
                                          .withValues(alpha: 0.4))),
                              const SizedBox(width: 4),
                              SizedBox(
                                width: 60,
                                child: ClipRRect(
                                  borderRadius:
                                      BorderRadius.circular(AppRadius.full),
                                  child: LinearProgressIndicator(
                                    value: c.$3 / 100,
                                    backgroundColor: cs.surfaceContainerHighest,
                                    valueColor: AlwaysStoppedAnimation(
                                        _scoreColor(c.$3)),
                                    minHeight: 6,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 4),
                              SizedBox(
                                width: 28,
                                child: Text(
                                  '${c.$3}',
                                  style: AppTextStyles.labelLarge.copyWith(
                                      fontSize: 12,
                                      color: _scoreColor(c.$3)),
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ],
                          ),
                        ))
                    .toList(),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Color _scoreColor(int score) {
    if (score >= 80) return AppColors.success;
    if (score >= 55) return AppColors.gold;
    return AppColors.error;
  }
}

// ─── PERIOD PICKER ────────────────────────────────────────────────────────────
class PeriodPicker extends StatelessWidget {
  final AnalyticsPeriod selected;
  final ValueChanged<AnalyticsPeriod> onChanged;

  const PeriodPicker(
      {super.key, required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      children: AnalyticsPeriod.values.map((p) {
        final isSelected = selected == p;
        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: GestureDetector(
            onTap: () => onChanged(p),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              decoration: BoxDecoration(
                color: isSelected ? cs.primary : cs.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(AppRadius.full),
              ),
              child: Text(
                p.label,
                style: AppTextStyles.labelLarge.copyWith(
                  fontSize: 12,
                  color: isSelected ? cs.onPrimary : cs.onSurfaceVariant,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ─── SHARED SMALL WIDGETS ─────────────────────────────────────────────────────
class _ScoreSummaryChip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _ScoreSummaryChip(
      {required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: '$label: ',
              style: AppTextStyles.labelSmall
                  .copyWith(color: cs.onSurfaceVariant, fontSize: 11),
            ),
            TextSpan(
              text: value,
              style: AppTextStyles.labelLarge
                  .copyWith(color: color, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniKpi extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _MiniKpi(
      {required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      children: [
        Text(value,
            style: AppTextStyles.dataLarge.copyWith(color: color, fontSize: 24)),
        Text(label,
            style: AppTextStyles.bodyMedium
                .copyWith(fontSize: 12, color: cs.onSurfaceVariant)),
      ],
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;
  const _LegendDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
              color: color, borderRadius: BorderRadius.circular(3)),
        ),
        const SizedBox(width: 4),
        Text(label,
            style: AppTextStyles.labelSmall
                .copyWith(fontSize: 10, color: cs.onSurfaceVariant)),
      ],
    );
  }
}

class _EmptyChart extends StatelessWidget {
  final String message;
  const _EmptyChart({required this.message});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SizedBox(
      height: 80,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.bar_chart_outlined,
                color: cs.onSurface.withValues(alpha: 0.3), size: 28),
            const SizedBox(height: 6),
            Text(message,
                style: AppTextStyles.bodyMedium
                    .copyWith(color: cs.onSurface.withValues(alpha: 0.5))),
          ],
        ),
      ),
    );
  }
}
