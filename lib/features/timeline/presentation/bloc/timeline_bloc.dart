import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../onboarding/domain/entities/user_profile.dart';
import '../../domain/entities/time_block.dart';
import '../../domain/usecases/timeline_usecases.dart';
import '../../../prayer/data/repositories/prayer_time_service.dart';
import '../../../prayer/domain/entities/prayer_times.dart';
import '../../../../core/services/widget_update_service.dart';

// ─── EVENTS ───────────────────────────────────────────────────────────────────
abstract class TimelineEvent extends Equatable {
  const TimelineEvent();
  @override
  List<Object?> get props => [];
}

class TimelineLoadRequested extends TimelineEvent {
  final UserProfile profile;
  final DateTime date;
  const TimelineLoadRequested({required this.profile, required this.date});
  @override
  List<Object?> get props => [date];
}

class TimelineGenerateRequested extends TimelineEvent {
  final UserProfile profile;
  final DateTime date;
  const TimelineGenerateRequested({required this.profile, required this.date});
  @override
  List<Object?> get props => [date];
}

class TimelineBlockCompleted extends TimelineEvent {
  final String blockId;
  const TimelineBlockCompleted(this.blockId);
  @override
  List<Object?> get props => [blockId];
}

class TimelineBlockSkipped extends TimelineEvent {
  final String blockId;
  const TimelineBlockSkipped(this.blockId);
  @override
  List<Object?> get props => [blockId];
}

class TimelineMorningIntentionSet extends TimelineEvent {
  final String text;
  const TimelineMorningIntentionSet(this.text);
  @override
  List<Object?> get props => [text];
}

class TimelineEveningReflectionSet extends TimelineEvent {
  final String text;
  const TimelineEveningReflectionSet(this.text);
  @override
  List<Object?> get props => [text];
}

class TimelineDateChanged extends TimelineEvent {
  final DateTime date;
  final UserProfile profile;
  const TimelineDateChanged({required this.date, required this.profile});
  @override
  List<Object?> get props => [date];
}

class TimelineTick extends TimelineEvent {
  const TimelineTick();
}

// ─── STATES ───────────────────────────────────────────────────────────────────
enum TimelineStatus { initial, loading, generating, loaded, error }

class TimelineState extends Equatable {
  final TimelineStatus status;
  final DateTime selectedDate;
  final DailyTimeline? timeline;
  final DailyPrayerTimes? prayerTimes;
  final String? errorMessage;
  final DateTime? lastRefreshed;

  const TimelineState({
    this.status = TimelineStatus.initial,
    required this.selectedDate,
    this.timeline,
    this.prayerTimes,
    this.errorMessage,
    this.lastRefreshed,
  });

  TimeBlock? get currentBlock => timeline?.currentBlock;
  TimeBlock? get nextPrayer => timeline?.nextPrayer;

  bool get hasTimeline => timeline != null;
  bool get isToday {
    final now = DateTime.now();
    return selectedDate.year == now.year &&
        selectedDate.month == now.month &&
        selectedDate.day == now.day;
  }

  TimelineState copyWith({
    TimelineStatus? status,
    DateTime? selectedDate,
    DailyTimeline? timeline,
    DailyPrayerTimes? prayerTimes,
    String? errorMessage,
    DateTime? lastRefreshed,
  }) {
    return TimelineState(
      status: status ?? this.status,
      selectedDate: selectedDate ?? this.selectedDate,
      timeline: timeline ?? this.timeline,
      prayerTimes: prayerTimes ?? this.prayerTimes,
      errorMessage: errorMessage,
      lastRefreshed: lastRefreshed ?? this.lastRefreshed,
    );
  }

  @override
  List<Object?> get props =>
      [status, selectedDate, timeline, prayerTimes, errorMessage];
}

// ─── BLOC ─────────────────────────────────────────────────────────────────────
class TimelineBloc extends Bloc<TimelineEvent, TimelineState> {
  final GenerateAndSaveTimeline generateAndSaveTimeline;
  final GetTimeline getTimeline;
  final CompleteBlock completeBlock;
  final SkipBlock skipBlock;
  final SetMorningIntention setMorningIntention;
  final SetEveningReflection setEveningReflection;
  final PrayerTimeService prayerTimeService;

  Timer? _tickTimer;

  TimelineBloc({
    required this.generateAndSaveTimeline,
    required this.getTimeline,
    required this.completeBlock,
    required this.skipBlock,
    required this.setMorningIntention,
    required this.setEveningReflection,
    required this.prayerTimeService,
  }) : super(TimelineState(selectedDate: DateTime.now())) {
    on<TimelineLoadRequested>(_onLoadRequested);
    on<TimelineGenerateRequested>(_onGenerateRequested);
    on<TimelineBlockCompleted>(_onBlockCompleted);
    on<TimelineBlockSkipped>(_onBlockSkipped);
    on<TimelineMorningIntentionSet>(_onMorningIntentionSet);
    on<TimelineEveningReflectionSet>(_onEveningReflectionSet);
    on<TimelineDateChanged>(_onDateChanged);
    on<TimelineTick>(_onTick);

    // Auto-tick every minute to keep "current block" in sync
    _tickTimer = Timer.periodic(
      const Duration(minutes: 1),
      (_) => add(const TimelineTick()),
    );
  }

  // ── LOAD ─────────────────────────────────────────────────────────────────────
  Future<void> _onLoadRequested(
      TimelineLoadRequested event, Emitter<TimelineState> emit) async {
    emit(state.copyWith(
      status: TimelineStatus.loading,
      selectedDate: event.date,
    ));

    // Always compute fresh prayer times (cheap, synchronous)
    final prayerResult = prayerTimeService.getPrayerTimes(
      profile: event.profile,
      date: event.date,
    );

    DailyPrayerTimes? prayers;
    prayerResult.fold((f) => null, (p) => prayers = p);

    // Try to load cached timeline from Isar
    final result = await getTimeline(event.date);

    result.fold(
      (failure) => emit(state.copyWith(
        status: TimelineStatus.error,
        errorMessage: failure.message,
        prayerTimes: prayers,
      )),
      (timeline) {
        if (timeline == null) {
          // No cached timeline — auto-generate
          add(TimelineGenerateRequested(
              profile: event.profile, date: event.date));
        } else {
          emit(state.copyWith(
            status: TimelineStatus.loaded,
            timeline: timeline,
            prayerTimes: prayers,
            lastRefreshed: DateTime.now(),
          ));
          WidgetUpdateService.update(
            timeline: timeline,
            prayerTimes: prayers,
            now: DateTime.now(),
          ).ignore();
        }
      },
    );
  }

  // ── GENERATE ─────────────────────────────────────────────────────────────────
  Future<void> _onGenerateRequested(
      TimelineGenerateRequested event, Emitter<TimelineState> emit) async {
    emit(state.copyWith(status: TimelineStatus.generating));

    final result = await generateAndSaveTimeline(
      GenerateTimelineParams(profile: event.profile, date: event.date),
    );

    result.fold(
      (failure) => emit(state.copyWith(
        status: TimelineStatus.error,
        errorMessage: failure.message,
      )),
      (timeline) {
        final prayerResult = prayerTimeService.getPrayerTimes(
          profile: event.profile,
          date: event.date,
        );
        DailyPrayerTimes? prayers;
        prayerResult.fold((f) => null, (p) => prayers = p);

        emit(state.copyWith(
          status: TimelineStatus.loaded,
          timeline: timeline,
          prayerTimes: prayers,
          lastRefreshed: DateTime.now(),
        ));
        WidgetUpdateService.update(
          timeline: timeline,
          prayerTimes: prayers,
          now: DateTime.now(),
        ).ignore();
      },
    );
  }

  // ── COMPLETE BLOCK ────────────────────────────────────────────────────────────
  Future<void> _onBlockCompleted(
      TimelineBlockCompleted event, Emitter<TimelineState> emit) async {
    final result = await completeBlock(
      CompleteBlockParams(blockId: event.blockId, date: state.selectedDate),
    );

    result.fold(
      (f) => emit(state.copyWith(errorMessage: f.message)),
      (updatedBlock) {
        if (state.timeline == null) return;
        final updatedBlocks = state.timeline!.blocks.map((b) {
          return b.id == event.blockId ? updatedBlock : b;
        }).toList();
        emit(state.copyWith(
          timeline: state.timeline!.copyWith(blocks: updatedBlocks),
        ));
      },
    );
  }

  // ── SKIP BLOCK ───────────────────────────────────────────────────────────────
  Future<void> _onBlockSkipped(
      TimelineBlockSkipped event, Emitter<TimelineState> emit) async {
    final result = await skipBlock(
      CompleteBlockParams(blockId: event.blockId, date: state.selectedDate),
    );

    result.fold(
      (f) => emit(state.copyWith(errorMessage: f.message)),
      (updatedBlock) {
        if (state.timeline == null) return;
        final updatedBlocks = state.timeline!.blocks.map((b) {
          return b.id == event.blockId ? updatedBlock : b;
        }).toList();
        emit(state.copyWith(
          timeline: state.timeline!.copyWith(blocks: updatedBlocks),
        ));
      },
    );
  }

  // ── INTENTION / REFLECTION ───────────────────────────────────────────────────
  Future<void> _onMorningIntentionSet(
      TimelineMorningIntentionSet event, Emitter<TimelineState> emit) async {
    final result = await setMorningIntention(
      SetIntentionParams(date: state.selectedDate, text: event.text),
    );
    result.fold(
      (f) => emit(state.copyWith(errorMessage: f.message)),
      (timeline) => emit(state.copyWith(timeline: timeline)),
    );
  }

  Future<void> _onEveningReflectionSet(
      TimelineEveningReflectionSet event, Emitter<TimelineState> emit) async {
    final result = await setEveningReflection(
      SetIntentionParams(date: state.selectedDate, text: event.text),
    );
    result.fold(
      (f) => emit(state.copyWith(errorMessage: f.message)),
      (timeline) => emit(state.copyWith(timeline: timeline)),
    );
  }

  // ── DATE CHANGE ──────────────────────────────────────────────────────────────
  Future<void> _onDateChanged(
      TimelineDateChanged event, Emitter<TimelineState> emit) async {
    add(TimelineLoadRequested(profile: event.profile, date: event.date));
  }

  // ── TICK ─────────────────────────────────────────────────────────────────────
  void _onTick(TimelineTick event, Emitter<TimelineState> emit) {
    // Rebuild state so currentBlock / nextPrayer getters re-evaluate
    if (state.timeline != null) {
      emit(state.copyWith(timeline: state.timeline));
      WidgetUpdateService.update(
        timeline: state.timeline,
        prayerTimes: state.prayerTimes,
        now: DateTime.now(),
      ).ignore();
    }
  }

  @override
  Future<void> close() {
    _tickTimer?.cancel();
    return super.close();
  }
}
