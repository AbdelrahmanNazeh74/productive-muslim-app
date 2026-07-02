import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/utils/responsive.dart';
import '../../../../shared/theme/app_theme.dart';
import '../../../onboarding/domain/entities/user_profile.dart';
import '../../../ramadan/presentation/bloc/ramadan_bloc.dart';
import '../../../ramadan/presentation/widgets/ramadan_widgets.dart';
import '../../../prayer/domain/entities/prayer_times.dart';
import '../../domain/entities/time_block.dart';
import '../bloc/timeline_bloc.dart';
import '../widgets/timeline_widgets.dart';

class TimelineDashboardPage extends StatefulWidget {
  final UserProfile? profile;

  const TimelineDashboardPage({super.key, this.profile});

  @override
  State<TimelineDashboardPage> createState() => _TimelineDashboardPageState();
}

class _TimelineDashboardPageState extends State<TimelineDashboardPage> {
  late UserProfile _profile;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _profile = widget.profile ?? _placeholderProfile();
    _loadTimeline();
  }

  void _loadTimeline() {
    context.read<TimelineBloc>().add(
          TimelineLoadRequested(profile: _profile, date: _selectedDate),
        );
  }

  void _goToDate(DateTime date) {
    setState(() => _selectedDate = date);
    context.read<TimelineBloc>().add(
          TimelineDateChanged(profile: _profile, date: date),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimelineBloc, TimelineState>(
      builder: (context, state) {
        final fab = state.hasTimeline
            ? FloatingActionButton.small(
                backgroundColor: AppColors.primary,
                tooltip: 'Regenerate timeline',
                onPressed: () => context.read<TimelineBloc>().add(
                      TimelineGenerateRequested(
                          profile: _profile, date: _selectedDate),
                    ),
                child: const Icon(Icons.refresh, color: Colors.white),
              )
            : null;

        // ── Tablet two-column layout ─────────────────────────────────────────
        if (context.isTablet) {
          return Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            floatingActionButton: fab,
            body: SafeArea(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left panel: header + prayer info
                  SizedBox(
                    width: 300,
                    child: _buildLeftPanel(context, state),
                  ),
                  const VerticalDivider(width: 1),
                  // Right panel: block list + reflection
                  Expanded(
                    child: _buildBody(
                      context,
                      state,
                      sidebarExtracted: true,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        // ── Phone single-column layout ───────────────────────────────────────
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          floatingActionButton: fab,
          body: SafeArea(
            child: Column(
              children: [
                _buildHeader(context, state),
                if (state.timeline?.nextPrayer != null &&
                    state.prayerTimes != null)
                  NextPrayerBanner(
                    prayerBlock: state.timeline!.nextPrayer!,
                    prayerTimes: state.prayerTimes!,
                  ),
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

  // ─── LEFT PANEL (tablet only) ─────────────────────────────────────────────
  Widget _buildLeftPanel(BuildContext context, TimelineState state) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context, state),
          if (state.timeline?.nextPrayer != null &&
              state.prayerTimes != null)
            NextPrayerBanner(
              prayerBlock: state.timeline!.nextPrayer!,
              prayerTimes: state.prayerTimes!,
            ),
          if (state.status == TimelineStatus.loaded) ...[
            DailyProgressRing(timeline: state.timeline!),
            if (state.prayerTimes != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: PrayerStrip(
                  prayerTimes: state.prayerTimes!,
                  prayerBlocks: state.timeline!.prayerBlocks,
                ),
              ),
          ],
        ],
      ),
    );
  }

  // ─── HEADER ──────────────────────────────────────────────────────────────────
  Widget _buildHeader(BuildContext context, TimelineState state) {
    final isToday = _isToday(_selectedDate);
    final h = context.screenHPadding;

    return Padding(
      padding: EdgeInsets.fromLTRB(h, 16, h, 12),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _greeting(),
                      style: AppTextStyles.bodyMedium,
                    ),
                    Text(
                      _profile.name,
                      style: AppTextStyles.displayMedium,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    _profile.name.isNotEmpty
                        ? _profile.name[0].toUpperCase()
                        : '?',
                    style: AppTextStyles.headlineMedium
                        .copyWith(color: AppColors.primary),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          _DateNavigator(
            selectedDate: _selectedDate,
            onPrev: () => _goToDate(
                _selectedDate.subtract(const Duration(days: 1))),
            onNext: () =>
                _goToDate(_selectedDate.add(const Duration(days: 1))),
            onToday: isToday ? null : () => _goToDate(DateTime.now()),
          ),
        ],
      ),
    );
  }

  // ─── BODY ─────────────────────────────────────────────────────────────────────
  /// [sidebarExtracted] — when true (tablet left panel), skip ProgressRing
  /// and PrayerStrip since they are already shown in the sidebar.
  Widget _buildBody(
    BuildContext context,
    TimelineState state, {
    bool sidebarExtracted = false,
  }) {
    final ramadanHeader = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: Row(children: [HijriDateBanner()]),
        ),
        RamadanModeToggleCard(
          profile: _profile,
          isRamadanMode: _profile.isRamadanMode,
          onToggle: (enabled) {
            context.read<RamadanBloc>().add(
                  RamadanModeToggled(
                    enabled: enabled,
                    userProfile: _profile,
                  ),
                );
          },
        ),
        const IftarMiniCountdown(),
      ],
    );

    switch (state.status) {
      case TimelineStatus.loading:
      case TimelineStatus.generating:
        return Column(
          children: [
            ramadanHeader,
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                state.status == TimelineStatus.generating
                    ? 'Building your personalized day… 🧠'
                    : 'Loading your schedule…',
                style: AppTextStyles.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ),
            const Expanded(child: TimelineLoadingShimmer()),
          ],
        );

      case TimelineStatus.error:
        return Column(
          children: [
            ramadanHeader,
            Expanded(
              child: _ErrorView(
                message: state.errorMessage ?? 'Something went wrong.',
                onRetry: _loadTimeline,
              ),
            ),
          ],
        );

      case TimelineStatus.loaded:
        final timeline = state.timeline!;
        final h = context.screenHPadding;
        return ListView(
          padding: const EdgeInsets.only(bottom: 100),
          children: [
            ramadanHeader,

            MorningIntentionCard(
              existing: timeline.morningIntention,
              onSave: (text) => context
                  .read<TimelineBloc>()
                  .add(TimelineMorningIntentionSet(text)),
            ),

            // On phone: show ProgressRing + PrayerStrip here.
            // On tablet: these are in the left panel — skip them.
            if (!sidebarExtracted) ...[
              DailyProgressRing(timeline: timeline),
              if (state.prayerTimes != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: PrayerStrip(
                    prayerTimes: state.prayerTimes!,
                    prayerBlocks: timeline.prayerBlocks,
                  ),
                ),
            ],

            ..._buildTimelineSections(context, state, timeline, h),

            if (_isPastMaghrib(state))
              _EveningReflectionCard(
                existing: timeline.eveningReflection,
                onSave: (text) => context
                    .read<TimelineBloc>()
                    .add(TimelineEveningReflectionSet(text)),
                hPad: h,
              ),
          ],
        );

      default:
        return Column(
          children: [
            ramadanHeader,
            Expanded(
              child: TimelineEmptyState(
                onGenerate: () => context.read<TimelineBloc>().add(
                      TimelineGenerateRequested(
                          profile: _profile, date: _selectedDate),
                    ),
              ),
            ),
          ],
        );
    }
  }

  // ─── TIMELINE SECTIONS ────────────────────────────────────────────────────────
  List<Widget> _buildTimelineSections(
    BuildContext context,
    TimelineState state,
    DailyTimeline timeline,
    double h,
  ) {
    const sections = <_Section>[
      _Section('Pre-Dawn',  [TimeBlockType.sleep, TimeBlockType.morningRoutine]),
      _Section('Fajr & Morning', [
        TimeBlockType.prayer, TimeBlockType.prayerBuffer,
        TimeBlockType.goldenHour, TimeBlockType.quran,
        TimeBlockType.dhikr, TimeBlockType.meal,
      ], prayerFilter: PrayerName.fajr),
      _Section('Morning Work', [
        TimeBlockType.deepWork, TimeBlockType.work, TimeBlockType.break_,
      ], beforePrayer: PrayerName.dhuhr),
      _Section('Dhuhr & Midday', [
        TimeBlockType.prayer, TimeBlockType.prayerBuffer,
        TimeBlockType.meal, TimeBlockType.qaylula, TimeBlockType.dhikr,
      ], prayerFilter: PrayerName.dhuhr),
      _Section('Afternoon Work', [
        TimeBlockType.deepWork, TimeBlockType.work, TimeBlockType.break_,
      ], afterPrayer: PrayerName.dhuhr, beforePrayer: PrayerName.asr),
      _Section('Asr & Evening', [
        TimeBlockType.prayer, TimeBlockType.prayerBuffer,
        TimeBlockType.gym, TimeBlockType.dhikr, TimeBlockType.freeTime,
      ], afterPrayer: PrayerName.asr, beforePrayer: PrayerName.maghrib),
      _Section('Maghrib & Dinner', [
        TimeBlockType.prayer, TimeBlockType.prayerBuffer,
        TimeBlockType.meal, TimeBlockType.eveningRoutine, TimeBlockType.dhikr,
      ], prayerFilter: PrayerName.maghrib),
      _Section('Isha & Night', [
        TimeBlockType.prayer, TimeBlockType.prayerBuffer,
        TimeBlockType.dhikr, TimeBlockType.freeTime, TimeBlockType.sleep,
      ], afterPrayer: PrayerName.maghrib),
    ];

    final widgets = <Widget>[];

    for (final section in sections) {
      final sectionBlocks =
          _blocksForSection(timeline.blocks, section, state);

      if (sectionBlocks.isEmpty) continue;

      widgets.add(
        Padding(
          padding: EdgeInsets.symmetric(horizontal: h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TimelineSectionHeader(label: section.name),
              ...sectionBlocks.map((block) => TimeBlockCard(
                    block: block,
                    isCurrentBlock: state.currentBlock?.id == block.id,
                    onComplete: () => context
                        .read<TimelineBloc>()
                        .add(TimelineBlockCompleted(block.id)),
                    onSkip: () => context
                        .read<TimelineBloc>()
                        .add(TimelineBlockSkipped(block.id)),
                  )),
            ],
          ),
        ),
      );
    }

    return widgets;
  }

  List<TimeBlock> _blocksForSection(
    List<TimeBlock> all,
    _Section section,
    TimelineState state,
  ) {
    return all.where((b) {
      if (!section.types.contains(b.type)) return false;

      if (section.prayerFilter != null &&
          b.linkedPrayer != null &&
          b.linkedPrayer != section.prayerFilter) {
        return false;
      }

      if (state.prayerTimes != null) {
        if (section.afterPrayer != null) {
          final after =
              state.prayerTimes!.byName(section.afterPrayer!).time;
          if (b.startTime.isBefore(after)) return false;
        }
        if (section.beforePrayer != null) {
          final before =
              state.prayerTimes!.byName(section.beforePrayer!).time;
          if (b.startTime.isAfter(before)) return false;
        }
      }

      return true;
    }).toList();
  }

  // ─── UTILITIES ───────────────────────────────────────────────────────────────
  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  bool _isPastMaghrib(TimelineState state) {
    if (state.prayerTimes == null) return false;
    return DateTime.now().isAfter(state.prayerTimes!.maghrib.prayerEnd());
  }

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 5)  return 'Good night 🌙';
    if (hour < 12) return 'Good morning ☀️';
    if (hour < 17) return 'Good afternoon 🌤';
    if (hour < 20) return 'Good evening 🌆';
    return 'Good night 🌙';
  }

  UserProfile _placeholderProfile() {
    return UserProfile(
      name: 'Friend',
      gender: 'male',
      occupationId: 'other',
      occupationLabel: 'Other',
      occupationType: 'office',
      workStartHour: 9,
      workStartMinute: 0,
      workEndHour: 17,
      workEndMinute: 0,
      workDays: const [0, 1, 2, 3, 4],
      latitude: 51.5074,
      longitude: -0.1278,
      city: 'London',
      timezone: 'Europe/London',
      calculationMethod: 'MuslimWorldLeague',
      madhab: 'shafi',
      prayerBufferMinutes: 10,
      fitnessActivityIds: const [],
      gymDays: const [],
      gymDurationMinutes: 60,
      preferredGymTime: 'evening',
      targetSleepHours: 7,
      wakeUpOffsetFromFajrMinutes: -30,
      dailyQuranPagesGoal: 2,
      isRamadanMode: false,
      cycleAwareStreaks: false,
      createdAt: DateTime.now(),
      isOnboardingComplete: true,
    );
  }
}

// ─── DATE NAVIGATOR ───────────────────────────────────────────────────────────
class _DateNavigator extends StatelessWidget {
  final DateTime selectedDate;
  final VoidCallback onPrev;
  final VoidCallback onNext;
  final VoidCallback? onToday;

  const _DateNavigator({
    required this.selectedDate,
    required this.onPrev,
    required this.onNext,
    this.onToday,
  });

  @override
  Widget build(BuildContext context) {
    final isToday = _checkIsToday(selectedDate);
    final cs = Theme.of(context).colorScheme;
    final isRtl =
        Localizations.localeOf(context).languageCode == 'ar';

    return Row(
      children: [
        _NavButton(
            icon: isRtl ? Icons.chevron_right : Icons.chevron_left,
            onTap: onPrev),
        const SizedBox(width: 8),
        Expanded(
          child: GestureDetector(
            onTap: onToday,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: cs.surface,
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: Border.all(
                  color: isToday ? cs.primary : cs.outlineVariant,
                  width: isToday ? 2 : 1.5,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (isToday) ...[
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: cs.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                  ],
                  Flexible(
                    child: Text(
                      isToday
                          ? 'Today — ${DateFormat('EEEE, MMM d').format(selectedDate)}'
                          : DateFormat('EEEE, MMM d').format(selectedDate),
                      style: AppTextStyles.titleMedium.copyWith(
                        fontSize: 14,
                        color: isToday ? cs.primary : cs.onSurface,
                      ),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        _NavButton(
            icon: isRtl ? Icons.chevron_left : Icons.chevron_right,
            onTap: onNext),
      ],
    );
  }

  bool _checkIsToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }
}

class _NavButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _NavButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: cs.outlineVariant, width: 1.5),
        ),
        child: Icon(icon, size: 20, color: cs.onSurface),
      ),
    );
  }
}

// ─── SECTION MODEL ────────────────────────────────────────────────────────────
class _Section {
  final String name;
  final List<TimeBlockType> types;
  final PrayerName? prayerFilter;
  final PrayerName? afterPrayer;
  final PrayerName? beforePrayer;

  const _Section(
    this.name,
    this.types, {
    this.prayerFilter,
    this.afterPrayer,
    this.beforePrayer,
  });
}

// ─── EVENING REFLECTION CARD ─────────────────────────────────────────────────
class _EveningReflectionCard extends StatefulWidget {
  final String? existing;
  final ValueChanged<String> onSave;
  final double hPad;

  const _EveningReflectionCard({
    this.existing,
    required this.onSave,
    this.hPad = 20,
  });

  @override
  State<_EveningReflectionCard> createState() =>
      _EveningReflectionCardState();
}

class _EveningReflectionCardState extends State<_EveningReflectionCard> {
  final _ctrl = TextEditingController();
  bool _editing = false;

  @override
  void initState() {
    super.initState();
    _ctrl.text = widget.existing ?? '';
    _editing = widget.existing == null || widget.existing!.isEmpty;
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  static const _prompts = [
    'What did I accomplish today?',
    'What am I grateful for?',
    'What will I improve tomorrow?',
  ];

  @override
  Widget build(BuildContext context) {
    final h = widget.hPad;
    return Container(
      margin: EdgeInsets.fromLTRB(h, 8, h, 20),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.isha.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('🌛', style: TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Text(
                'Evening Reflection',
                style: AppTextStyles.titleMedium.copyWith(color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 12),

          if (_editing) ...[
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: _prompts
                  .map(
                    (p) => GestureDetector(
                      onTap: () {
                        _ctrl.text =
                            '${_ctrl.text.isEmpty ? '' : '${_ctrl.text}\n'}$p ';
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.12),
                          borderRadius:
                              BorderRadius.circular(AppRadius.full),
                        ),
                        child: Text(
                          p,
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontSize: 11,
                            color: Colors.white70,
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _ctrl,
              maxLines: 4,
              style: AppTextStyles.bodyMedium
                  .copyWith(color: Colors.white, fontSize: 14),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white.withValues(alpha: 0.1),
                hintText: 'Write freely…',
                hintStyle: AppTextStyles.bodyMedium
                    .copyWith(color: Colors.white38, fontSize: 13),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 12),
              ),
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 10),
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
                  'Save Reflection',
                  style: AppTextStyles.labelLarge
                      .copyWith(fontSize: 12, color: Colors.white),
                ),
              ),
            ),
          ] else ...[
            Text(
              widget.existing ?? '',
              style: AppTextStyles.bodyMedium.copyWith(
                color: Colors.white70,
                fontSize: 13,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => setState(() => _editing = true),
              child: Text(
                'Edit reflection',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: Colors.white38,
                  fontSize: 11,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ─── ERROR VIEW ───────────────────────────────────────────────────────────────
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
            const Icon(Icons.warning_amber_rounded,
                size: 48, color: AppColors.error),
            const SizedBox(height: 16),
            Text('Something went wrong',
                style: AppTextStyles.headlineMedium),
            const SizedBox(height: 8),
            Text(message,
                style: AppTextStyles.bodyMedium,
                textAlign: TextAlign.center),
            const SizedBox(height: 24),
            SizedBox(
              width: 160,
              child: ElevatedButton(
                onPressed: onRetry,
                child: const Text('Retry'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
