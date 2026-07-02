import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/responsive.dart';
import '../../../../shared/theme/app_theme.dart';
import '../../domain/entities/analytics_entities.dart';
import '../bloc/analytics_bloc.dart';
import '../widgets/analytics_widgets.dart';

class AnalyticsDashboardPage extends StatefulWidget {
  const AnalyticsDashboardPage({super.key});

  @override
  State<AnalyticsDashboardPage> createState() =>
      _AnalyticsDashboardPageState();
}

class _AnalyticsDashboardPageState extends State<AnalyticsDashboardPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 3, vsync: this);
    _load();
  }

  void _load([AnalyticsPeriod period = AnalyticsPeriod.week]) {
    context.read<AnalyticsBloc>().add(AnalyticsLoadRequested(period));
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AnalyticsBloc, AnalyticsState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: context.isTablet
                ? _buildTabletLayout(context, state)
                : _buildPhoneLayout(context, state),
          ),
        );
      },
    );
  }

  // ─── TABLET: left tab nav + right content ────────────────────────────────────
  Widget _buildTabletLayout(
      BuildContext context, AnalyticsState state) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left sidebar: title + period picker + vertical tabs
        SizedBox(
          width: 220,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                child: Row(
                  children: [
                    Expanded(
                      child: Text('Analytics',
                          style: AppTextStyles.displayMedium),
                    ),
                    IconButton(
                      icon: const Icon(Icons.refresh_outlined,
                          color: AppColors.textSecondary, size: 22),
                      tooltip: 'Refresh',
                      onPressed: () => context
                          .read<AnalyticsBloc>()
                          .add(const AnalyticsRefreshRequested()),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: PeriodPicker(
                    selected: state.period,
                    onChanged: (p) => context
                        .read<AnalyticsBloc>()
                        .add(AnalyticsPeriodChanged(p)),
                  ),
                ),
              ),
              // Vertical tab list
              _buildTabletTabList(),
            ],
          ),
        ),
        const VerticalDivider(width: 1),
        // Right content
        Expanded(
          child: _buildBody(context, state),
        ),
      ],
    );
  }

  Widget _buildTabletTabList() {
    final labels = ['Overview', 'Prayers', 'Habits'];
    return AnimatedBuilder(
      animation: _tabCtrl,
      builder: (context, _) {
        return Column(
          children: List.generate(labels.length, (i) {
            final active = _tabCtrl.index == i;
            return InkWell(
              onTap: () => setState(() => _tabCtrl.index = i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.fromLTRB(12, 2, 12, 2),
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: active
                      ? AppColors.primary.withValues(alpha: 0.08)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Row(
                  children: [
                    Icon(
                      [
                        Icons.bar_chart_outlined,
                        Icons.mosque_outlined,
                        Icons.local_fire_department_outlined,
                      ][i],
                      color: active
                          ? AppColors.primary
                          : AppColors.textHint,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      labels[i],
                      style: AppTextStyles.labelLarge.copyWith(
                        color: active
                            ? AppColors.primary
                            : AppColors.textSecondary,
                        fontWeight: active
                            ? FontWeight.w700
                            : FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        );
      },
    );
  }

  // ─── PHONE: header + tabs above content ──────────────────────────────────────
  Widget _buildPhoneLayout(BuildContext context, AnalyticsState state) {
    return Column(
      children: [
        _buildHeader(context, state),
        _buildTabBar(context),
        Expanded(child: _buildBody(context, state)),
      ],
    );
  }

  // ─── HEADER ────────────────────────────────────────────────────────────────
  Widget _buildHeader(BuildContext context, AnalyticsState state) {
    final h = context.screenHPadding;
    return Padding(
      padding: EdgeInsets.fromLTRB(h, 16, h, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Analytics', style: AppTextStyles.displayMedium),
              IconButton(
                icon: const Icon(Icons.refresh_outlined,
                    color: AppColors.textSecondary, size: 22),
                tooltip: 'Refresh',
                onPressed: () => context
                    .read<AnalyticsBloc>()
                    .add(const AnalyticsRefreshRequested()),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: PeriodPicker(
              selected: state.period,
              onChanged: (p) => context
                  .read<AnalyticsBloc>()
                  .add(AnalyticsPeriodChanged(p)),
            ),
          ),
        ],
      ),
    );
  }

  // ─── TAB BAR (phone) ───────────────────────────────────────────────────────
  Widget _buildTabBar(BuildContext context) {
    final h = context.screenHPadding;
    return Padding(
      padding: EdgeInsets.fromLTRB(h, 12, h, 0),
      child: TabBar(
        controller: _tabCtrl,
        labelStyle: AppTextStyles.labelLarge.copyWith(fontSize: 12),
        unselectedLabelStyle:
            AppTextStyles.bodyMedium.copyWith(fontSize: 12),
        labelColor: AppColors.primary,
        unselectedLabelColor: AppColors.textSecondary,
        indicatorColor: AppColors.primary,
        indicatorSize: TabBarIndicatorSize.label,
        dividerColor: Colors.transparent,
        tabs: const [
          Tab(text: 'Overview'),
          Tab(text: 'Prayers'),
          Tab(text: 'Habits'),
        ],
      ),
    );
  }

  // ─── BODY ──────────────────────────────────────────────────────────────────
  Widget _buildBody(BuildContext context, AnalyticsState state) {
    if (state.status == AnalyticsStatus.loading) {
      return const _LoadingView();
    }

    if (state.status == AnalyticsStatus.error) {
      return _ErrorView(
        message: state.errorMessage ?? 'Failed to load analytics',
        onRetry: _load,
      );
    }

    if (!state.hasData) {
      return const _EmptyView();
    }

    return TabBarView(
      controller: _tabCtrl,
      children: [
        _buildOverviewTab(context, state),
        _buildPrayersTab(context, state),
        _buildHabitsTab(context, state),
      ],
    );
  }

  // ─── OVERVIEW TAB ──────────────────────────────────────────────────────────
  Widget _buildOverviewTab(
      BuildContext context, AnalyticsState state) {
    final snapshot = state.snapshot!;
    final latestWeek = snapshot.weeklyScores.points.isNotEmpty
        ? snapshot.weeklyScores.points.last
        : null;

    return ListView(
      padding: const EdgeInsets.only(top: 16, bottom: 100),
      children: [
        AnalyticsCard(
          title: 'This Week\'s Score',
          subtitle: latestWeek != null
              ? 'Week of ${latestWeek.shortLabel}'
              : null,
          child: WeeklyScoreBreakdown(latest: latestWeek),
        ),

        if (snapshot.weeklyScores.points.length > 1)
          AnalyticsCard(
            title: 'Score Trend',
            subtitle: snapshot.weeklyScores.trendLabel,
            child: WeeklyScoreLineChart(
                series: snapshot.weeklyScores),
          ),

        AnalyticsCard(
          title: 'Monthly Heatmap',
          subtitle: 'Daily completion — green = great day',
          child: MonthlyHeatmapCalendar(
            heatmap: state.currentHeatmap ?? snapshot.heatmap,
            onPrevMonth: () {
              final cur = DateTime(
                  state.heatmapYear, state.heatmapMonth, 1);
              final prev = DateTime(cur.year, cur.month - 1, 1);
              context.read<AnalyticsBloc>().add(
                    AnalyticsHeatmapMonthChanged(
                      year: prev.year,
                      month: prev.month,
                    ),
                  );
            },
            onNextMonth: () {
              final cur = DateTime(
                  state.heatmapYear, state.heatmapMonth, 1);
              final next = DateTime(cur.year, cur.month + 1, 1);
              if (!next.isAfter(DateTime.now())) {
                context.read<AnalyticsBloc>().add(
                      AnalyticsHeatmapMonthChanged(
                        year: next.year,
                        month: next.month,
                      ),
                    );
              }
            },
          ),
        ),

        AnalyticsCard(
          title: 'Top Habits',
          subtitle:
              '${snapshot.period.label.toLowerCase()} · by completion rate',
          child: HabitLeaderboard(analytics: snapshot.habits),
        ),
      ],
    );
  }

  // ─── PRAYERS TAB ───────────────────────────────────────────────────────────
  Widget _buildPrayersTab(
      BuildContext context, AnalyticsState state) {
    final prayers = state.snapshot!.prayers;

    return ListView(
      padding: const EdgeInsets.only(top: 16, bottom: 100),
      children: [
        AnalyticsCard(
          title: 'Prayer Consistency',
          subtitle:
              '${prayers.periodStart.day}/${prayers.periodStart.month} – '
              '${prayers.periodEnd.day}/${prayers.periodEnd.month}',
          child: PrayerBarChart(analytics: prayers),
        ),

        AnalyticsCard(
          title: 'Daily Prayer Rate',
          subtitle: 'Prayers completed per day (out of 5)',
          child: _DailyPrayerRateChart(rates: prayers.dailyRates),
        ),

        _InsightCard(
          title: 'Your Strongest Prayer',
          body: '${prayers.bestPrayer} is your most consistent prayer. '
              'Keep it up!',
          emoji: '💪',
          color: AppColors.success,
        ),
        _InsightCard(
          title: 'Focus Area',
          body:
              '${prayers.weakestPrayer} needs attention. Try setting a '
              'reminder ${prayers.weakestPrayer == 'Fajr' ? '15 minutes before Fajr' : 'as a buffer before prayer time'}.',
          emoji: '🎯',
          color: AppColors.gold,
        ),
      ],
    );
  }

  // ─── HABITS TAB ────────────────────────────────────────────────────────────
  Widget _buildHabitsTab(
      BuildContext context, AnalyticsState state) {
    final habits = state.snapshot!.habits;

    return ListView(
      padding: const EdgeInsets.only(top: 16, bottom: 100),
      children: [
        AnalyticsCard(
          title: 'Habit Completion',
          subtitle: 'Daily completion rate across all habits',
          child: HabitCompletionChart(analytics: habits),
        ),

        AnalyticsCard(
          title: 'All Habits',
          subtitle:
              '${(habits.overallRate * 100).round()}% overall · '
              '${habits.totalStreakDays} total streak days',
          child: HabitLeaderboard(
            analytics: habits,
            maxItems: habits.habitStats.length,
          ),
        ),

        if (habits.habitStats.isNotEmpty)
          _StreakChampionCard(
            habit: (List.of(habits.habitStats)
                  ..sort((a, b) =>
                      b.currentStreak.compareTo(a.currentStreak)))
                .first,
          ),
      ],
    );
  }
}

// ─── DAILY PRAYER RATE MINI CHART ────────────────────────────────────────────
class _DailyPrayerRateChart extends StatelessWidget {
  final List<DailyPrayerRate> rates;
  const _DailyPrayerRateChart({required this.rates});

  @override
  Widget build(BuildContext context) {
    if (rates.isEmpty) {
      return const SizedBox(
        height: 60,
        child: Center(
          child: Text('No data yet',
              style: TextStyle(color: AppColors.textHint)),
        ),
      );
    }

    return SizedBox(
      height: 80,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: rates.map((r) {
          final color = r.completedCount == 5
              ? AppColors.success
              : r.completedCount >= 3
                  ? AppColors.gold
                  : AppColors.error.withValues(alpha: 0.6);
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 1.5),
              child: Tooltip(
                message:
                    '${r.date.day}/${r.date.month}: ${r.completedCount}/5',
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Flexible(
                      child: FractionallySizedBox(
                        heightFactor: r.rate.clamp(0.05, 1.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(3)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ─── INSIGHT CARD ────────────────────────────────────────────────────────────
class _InsightCard extends StatelessWidget {
  final String title;
  final String body;
  final String emoji;
  final Color color;

  const _InsightCard({
    required this.title,
    required this.body,
    required this.emoji,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final h = context.screenHPadding;
    return Container(
      margin: EdgeInsets.fromLTRB(h, 0, h, 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: AppTextStyles.titleMedium
                        .copyWith(color: color, fontSize: 14)),
                const SizedBox(height: 4),
                Text(body,
                    style: AppTextStyles.bodyMedium
                        .copyWith(fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── STREAK CHAMPION CARD ─────────────────────────────────────────────────────
class _StreakChampionCard extends StatelessWidget {
  final HabitStat habit;
  const _StreakChampionCard({required this.habit});

  @override
  Widget build(BuildContext context) {
    final h = context.screenHPadding;
    return Container(
      margin: EdgeInsets.fromLTRB(h, 0, h, 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.goldDark, AppColors.gold],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: [
          BoxShadow(
            color: AppColors.gold.withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Text(habit.emoji, style: const TextStyle(fontSize: 36)),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Streak Champion 🏆',
                  style: AppTextStyles.bodyMedium.copyWith(
                      color: Colors.white70, fontSize: 12),
                ),
                Text(
                  habit.name,
                  style: AppTextStyles.headlineMedium.copyWith(
                      color: Colors.white, fontSize: 18),
                ),
                Text(
                  '${habit.currentStreak}-day streak · '
                  '${habit.longestStreak}d personal best',
                  style: AppTextStyles.bodyMedium
                      .copyWith(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
          const Text('🔥', style: TextStyle(fontSize: 32)),
        ],
      ),
    );
  }
}

// ─── UTILITY VIEWS ───────────────────────────────────────────────────────────
class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    final h = context.screenHPadding;
    return ListView(
      padding: EdgeInsets.all(h),
      children: List.generate(
        4,
        (i) => Container(
          height: 140,
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.bar_chart_outlined,
                size: 48, color: AppColors.textHint),
            const SizedBox(height: 16),
            Text('Could not load analytics',
                style: AppTextStyles.headlineMedium),
            const SizedBox(height: 8),
            Text(message,
                style: AppTextStyles.bodyMedium,
                textAlign: TextAlign.center),
            const SizedBox(height: 24),
            ElevatedButton(
                onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('📊', style: TextStyle(fontSize: 56)),
            const SizedBox(height: 20),
            Text('No data yet',
                style: AppTextStyles.headlineMedium,
                textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(
              'Complete some prayers and habits — '
              'your analytics will appear here after your first day.',
              style: AppTextStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
