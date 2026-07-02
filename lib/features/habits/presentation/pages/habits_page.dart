import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/utils/responsive.dart';
import '../../../../shared/theme/app_theme.dart';
import '../../../../shared/widgets/celebration_overlay.dart';
import '../../domain/entities/habit.dart';
import '../../domain/usecases/streak_calculator.dart';
import '../bloc/habits_bloc.dart';
import '../widgets/habits_widgets.dart';

class HabitsPage extends StatefulWidget {
  const HabitsPage({super.key});

  @override
  State<HabitsPage> createState() => _HabitsPageState();
}

class _HabitsPageState extends State<HabitsPage>
    with SingleTickerProviderStateMixin {
  HabitCategory? _selectedCategory;
  late TabController _tabCtrl;
  static const _uuid = Uuid();

  final _heatMapCache = <String, List<DayStatus>>{};
  final _streakCalculator = const StreakCalculator();

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 2, vsync: this);
    _loadData();
  }

  void _loadData() {
    context.read<HabitsBloc>().add(
          HabitsLoadRequested(date: DateTime.now()),
        );
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HabitsBloc, HabitsState>(
      listenWhen: (prev, curr) =>
          prev.newPersonalBest != curr.newPersonalBest ||
          prev.lastCompletedHabitId != curr.lastCompletedHabitId,
      listener: (context, state) {
        if (state.newPersonalBest && state.lastCompletedHabitId != null) {
          final habit = state.findHabit(state.lastCompletedHabitId!);
          if (habit != null) {
            FullScreenCelebrationOverlay.show(
              context,
              habitName: habit.name,
              streakCount: habit.longestStreak,
            );
          }
        }
      },
      builder: (context, state) {
        final fab = FloatingActionButton(
          backgroundColor: AppColors.primary,
          tooltip: 'Add new habit',
          onPressed: () => _showAddHabitSheet(context),
          child: const Icon(Icons.add, color: Colors.white),
        );

        // ── Tablet two-column: Today | Score always visible ──────────────────
        if (context.isTablet) {
          return Scaffold(
            backgroundColor: AppColors.background,
            floatingActionButton: fab,
            body: SafeArea(
              child: Column(
                children: [
                  _buildHeader(context, state),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Left: Today's habits
                        Expanded(
                          flex: 3,
                          child: _buildTodayTab(context, state),
                        ),
                        const VerticalDivider(width: 1),
                        // Right: Weekly score
                        Expanded(
                          flex: 2,
                          child: _buildScoreTab(context, state),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        // ── Phone: TabBar + TabBarView ────────────────────────────────────────
        return Scaffold(
          backgroundColor: AppColors.background,
          floatingActionButton: fab,
          body: SafeArea(
            child: Column(
              children: [
                _buildHeader(context, state),
                _buildTabBar(),
                Expanded(
                  child: TabBarView(
                    controller: _tabCtrl,
                    children: [
                      _buildTodayTab(context, state),
                      _buildScoreTab(context, state),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ─── HEADER ──────────────────────────────────────────────────────────────────
  Widget _buildHeader(BuildContext context, HabitsState state) {
    final summary = state.dailySummary;
    final completed = summary?.completedCount ?? 0;
    final total = summary?.totalScheduled ?? 0;
    final allDone = total > 0 && completed == total;
    final h = context.screenHPadding;

    return Padding(
      padding: EdgeInsets.fromLTRB(h, 16, h, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DateFormat('EEEE, MMM d').format(DateTime.now()),
                      style: AppTextStyles.bodyMedium,
                    ),
                    Text(
                      'My Habits',
                      style: AppTextStyles.displayMedium,
                    ),
                  ],
                ),
              ),
              if (total > 0)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: allDone
                        ? AppColors.success
                        : AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppRadius.full),
                  ),
                  child: Text(
                    allDone ? '🎉 All done!' : '$completed / $total',
                    style: AppTextStyles.titleMedium.copyWith(
                      fontSize: 14,
                      color: allDone ? Colors.white : AppColors.primary,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 14),

          if (total > 0)
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.full),
              child: LinearProgressIndicator(
                value: total == 0 ? 0 : completed / total,
                backgroundColor: AppColors.surfaceVariant,
                valueColor: AlwaysStoppedAnimation(
                  completed == total ? AppColors.success : AppColors.primary,
                ),
                minHeight: 6,
              ),
            ),
        ],
      ),
    );
  }

  // ─── TAB BAR (phone only) ─────────────────────────────────────────────────────
  Widget _buildTabBar() {
    final h = context.screenHPadding;
    return Padding(
      padding: EdgeInsets.fromLTRB(h, 16, h, 0),
      child: TabBar(
        controller: _tabCtrl,
        labelStyle: AppTextStyles.labelLarge.copyWith(fontSize: 13),
        unselectedLabelStyle:
            AppTextStyles.bodyMedium.copyWith(fontSize: 13),
        labelColor: AppColors.primary,
        unselectedLabelColor: AppColors.textSecondary,
        indicatorColor: AppColors.primary,
        indicatorSize: TabBarIndicatorSize.label,
        dividerColor: Colors.transparent,
        tabs: const [
          Tab(text: "Today's Habits"),
          Tab(text: 'Weekly Score'),
        ],
      ),
    );
  }

  // ─── TODAY TAB ───────────────────────────────────────────────────────────────
  Widget _buildTodayTab(BuildContext context, HabitsState state) {
    if (state.status == HabitsStatus.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.status == HabitsStatus.error) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(state.errorMessage ?? 'Error',
                style: AppTextStyles.bodyMedium),
            const SizedBox(height: 16),
            ElevatedButton(
                onPressed: _loadData, child: const Text('Retry')),
          ],
        ),
      );
    }

    final allHabits = state.habits;
    if (allHabits.isEmpty) {
      return _buildEmptyState(context);
    }

    final filtered = _selectedCategory == null
        ? allHabits
        : allHabits.where((h) => h.category == _selectedCategory).toList();

    final spiritual =
        filtered.where((h) => h.category == HabitCategory.spiritual).toList();
    final others =
        filtered.where((h) => h.category != HabitCategory.spiritual).toList();

    final h = context.screenHPadding;

    return ListView(
      padding: const EdgeInsets.only(top: 12, bottom: 100),
      children: [
        CategoryFilterBar(
          selected: _selectedCategory,
          onChanged: (cat) => setState(() => _selectedCategory = cat),
        ),

        const SizedBox(height: 16),

        if (spiritual.isNotEmpty) ...[
          _SectionHeader(
            label: '🤲 Spiritual',
            completedCount:
                spiritual.where((h) => state.isCompleted(h.id)).length,
            total: spiritual.length,
            hPad: h,
          ),
          ...spiritual.map((hab) => Padding(
                padding: EdgeInsets.symmetric(horizontal: h),
                child: _buildHabitCard(context, state, hab),
              )),
          const SizedBox(height: 8),
        ],

        if (others.isNotEmpty) ...[
          _SectionHeader(
            label: '📋 Other Habits',
            completedCount:
                others.where((h) => state.isCompleted(h.id)).length,
            total: others.length,
            hPad: h,
          ),
          ...others.map((hab) => Padding(
                padding: EdgeInsets.symmetric(horizontal: h),
                child: _buildHabitCard(context, state, hab),
              )),
        ],
      ],
    );
  }

  Widget _buildHabitCard(
      BuildContext context, HabitsState state, Habit habit) {
    if (!_heatMapCache.containsKey(habit.id)) {
      _heatMapCache[habit.id] = _streakCalculator.buildRecentHeatMap(
        records: [],
        scheduledDays: habit.scheduledDays,
      );
    }

    final isCompleted = state.isCompleted(habit.id);
    final isExcused = state.isExcused(habit.id);
    final isNewBest = state.newPersonalBest &&
        state.lastCompletedHabitId == habit.id;

    return HabitCard(
      habit: habit,
      isCompleted: isCompleted,
      isExcused: isExcused,
      heatMap: _heatMapCache[habit.id]!,
      isNewPersonalBest: isNewBest && isCompleted,
      onComplete: () {
        context.read<HabitsBloc>().add(HabitCompleted(
              habitId: habit.id,
              date: DateTime.now(),
            ));
        _heatMapCache.remove(habit.id);
      },
      onUndo: () {
        context.read<HabitsBloc>().add(HabitUndone(
              habitId: habit.id,
              date: DateTime.now(),
            ));
        _heatMapCache.remove(habit.id);
      },
      onExcuse: () => _showExcuseDialog(context, habit),
      onEdit: habit.isSystemHabit
          ? null
          : () => _showAddHabitSheet(context, existing: habit),
    );
  }

  // ─── SCORE TAB ───────────────────────────────────────────────────────────────
  Widget _buildScoreTab(BuildContext context, HabitsState state) {
    final h = context.screenHPadding;
    return ListView(
      padding: const EdgeInsets.only(top: 16, bottom: 100),
      children: [
        if (state.weeklyScore != null)
          WeeklyScoreCard(score: state.weeklyScore!)
        else
          const Padding(
            padding: EdgeInsets.all(20),
            child: Center(child: CircularProgressIndicator()),
          ),

        const SizedBox(height: 20),

        if (state.habits.isNotEmpty) ...[
          Padding(
            padding: EdgeInsets.fromLTRB(h, 0, h, 12),
            child: Text('All Streaks', style: AppTextStyles.headlineMedium),
          ),
          ...state.habits.map((hab) => Padding(
                padding: EdgeInsets.fromLTRB(h, 0, h, 10),
                child: _StreakSummaryRow(habit: hab),
              )),
        ],
      ],
    );
  }

  // ─── EMPTY STATE ─────────────────────────────────────────────────────────────
  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('📿', style: TextStyle(fontSize: 56)),
            const SizedBox(height: 20),
            Text('No habits yet',
                style: AppTextStyles.headlineMedium,
                textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(
              'Tap + to add your first habit, or we\'ll seed spiritual defaults from your profile.',
              style: AppTextStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 28),
            OutlinedButton(
              onPressed: _loadData,
              child: const Text('Refresh'),
            ),
          ],
        ),
      ),
    );
  }

  // ─── DIALOGS & SHEETS ────────────────────────────────────────────────────────
  void _showAddHabitSheet(BuildContext context, {Habit? existing}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AddHabitSheet(
        existing: existing,
        onSave: (habit) {
          final withId = habit.id.isEmpty
              ? habit.copyWith(id: _uuid.v4())
              : habit;
          context.read<HabitsBloc>().add(
                existing == null
                    ? HabitAdded(withId)
                    : HabitUpdated(withId),
              );
        },
      ),
    );
  }

  void _showExcuseDialog(BuildContext context, Habit habit) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.lg)),
        title: Text('Excuse Today?',
            style: AppTextStyles.headlineMedium.copyWith(fontSize: 18)),
        content: Text(
          'Your streak for "${habit.name}" will be preserved but today won\'t count toward it.',
          style: AppTextStyles.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ...StreakPauseReason.values
              .where((r) => r != StreakPauseReason.none)
              .map((reason) => TextButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                      context.read<HabitsBloc>().add(HabitExcused(
                            habitId: habit.id,
                            date: DateTime.now(),
                            reason: reason,
                          ));
                    },
                    child: Text(
                      _reasonLabel(reason),
                      style: AppTextStyles.bodyMedium
                          .copyWith(color: AppColors.gold),
                    ),
                  )),
        ],
      ),
    );
  }

  String _reasonLabel(StreakPauseReason reason) {
    switch (reason) {
      case StreakPauseReason.illness:  return '🤒 Illness';
      case StreakPauseReason.travel:   return '✈️ Travel';
      case StreakPauseReason.cycle:    return '🌸 Cycle';
      case StreakPauseReason.ramadan:  return '🌙 Ramadan';
      case StreakPauseReason.excused:  return '✓ Other';
      case StreakPauseReason.none:     return '';
    }
  }
}

// ─── SECTION HEADER ──────────────────────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  final String label;
  final int completedCount;
  final int total;
  final double hPad;

  const _SectionHeader({
    required this.label,
    required this.completedCount,
    required this.total,
    this.hPad = 20,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(hPad, 4, hPad, 8),
      child: Row(
        children: [
          Text(
            label.toUpperCase(),
            style: AppTextStyles.labelSmall.copyWith(letterSpacing: 1.2),
          ),
          const Spacer(),
          Text(
            '$completedCount / $total',
            style: AppTextStyles.bodyMedium.copyWith(
              fontSize: 12,
              color: completedCount == total && total > 0
                  ? AppColors.success
                  : AppColors.textHint,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── STREAK SUMMARY ROW (Score Tab) ──────────────────────────────────────────
class _StreakSummaryRow extends StatelessWidget {
  final Habit habit;

  const _StreakSummaryRow({required this.habit});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.surfaceVariant, width: 1.5),
      ),
      child: Row(
        children: [
          Text(habit.emoji, style: const TextStyle(fontSize: 22)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(habit.name,
                    style: AppTextStyles.titleMedium.copyWith(fontSize: 14)),
                Text(
                  habit.weekProgressLabel(
                    habit.currentStreak.clamp(0, habit.targetFrequencyPerWeek),
                  ),
                  style: AppTextStyles.bodyMedium.copyWith(fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          StreakFlameBadge(streak: habit.currentStreak, size: 40),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${habit.longestStreak}d',
                style: AppTextStyles.titleMedium
                    .copyWith(color: AppColors.gold, fontSize: 14),
              ),
              Text('best',
                  style: AppTextStyles.labelSmall.copyWith(fontSize: 10)),
            ],
          ),
        ],
      ),
    );
  }
}
