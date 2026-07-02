import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isar/isar.dart';

import '../../../../features/onboarding/domain/entities/user_profile.dart';
import '../../../../features/prayer/data/repositories/prayer_time_service.dart';
import '../../../../features/prayer/domain/entities/prayer_times.dart';
import '../../../../features/timeline/domain/entities/time_block.dart';
import '../../data/models/ramadan_profile_model.dart';
import '../../domain/entities/ramadan_entities.dart';
import '../../domain/usecases/hijri_converter.dart';
import '../../domain/usecases/ramadan_timeline_generator.dart';

// ─── EVENTS ───────────────────────────────────────────────────────────────────
abstract class RamadanEvent extends Equatable {
  const RamadanEvent();
  @override
  List<Object?> get props => [];
}

class RamadanInitialised extends RamadanEvent {
  final UserProfile userProfile;
  const RamadanInitialised(this.userProfile);
  @override
  List<Object?> get props => [userProfile.id];
}

class RamadanModeToggled extends RamadanEvent {
  final bool enabled;
  final UserProfile userProfile;
  const RamadanModeToggled({required this.enabled, required this.userProfile});
  @override
  List<Object?> get props => [enabled];
}

class RamadanProfileUpdated extends RamadanEvent {
  final RamadanProfile profile;
  const RamadanProfileUpdated(this.profile);
  @override
  List<Object?> get props => [profile];
}

class RamadanDateChanged extends RamadanEvent {
  final DateTime date;
  final UserProfile userProfile;
  const RamadanDateChanged({required this.date, required this.userProfile});
  @override
  List<Object?> get props => [date];
}

class RamadanTimelineRequested extends RamadanEvent {
  final DateTime date;
  final UserProfile userProfile;
  const RamadanTimelineRequested(
      {required this.date, required this.userProfile});
  @override
  List<Object?> get props => [date];
}

// ─── STATE ────────────────────────────────────────────────────────────────────
enum RamadanStatus { initial, loading, active, inactive, error }

class RamadanState extends Equatable {
  final RamadanStatus status;
  final bool isRamadanMode;
  final DateTime selectedDate;
  final RamadanProfile? ramadanProfile;
  final RamadanDayContext? dayContext;
  final DailyTimeline? timeline;
  final DailyPrayerTimes? prayerTimes;
  final HijriDate? todayHijri;
  final String? errorMessage;

  const RamadanState({
    this.status = RamadanStatus.initial,
    this.isRamadanMode = false,
    required this.selectedDate,
    this.ramadanProfile,
    this.dayContext,
    this.timeline,
    this.prayerTimes,
    this.todayHijri,
    this.errorMessage,
  });

  bool get isCurrentlyFasting {
    if (dayContext == null) return false;
    return dayContext!.times.isFasting(DateTime.now());
  }

  Duration get timeUntilIftar {
    if (dayContext == null) return Duration.zero;
    return dayContext!.times.timeUntilIftar(DateTime.now());
  }

  bool get isLastTenNights => dayContext?.isLastTenNights ?? false;

  RamadanState copyWith({
    RamadanStatus? status,
    bool? isRamadanMode,
    DateTime? selectedDate,
    RamadanProfile? ramadanProfile,
    RamadanDayContext? dayContext,
    DailyTimeline? timeline,
    DailyPrayerTimes? prayerTimes,
    HijriDate? todayHijri,
    String? errorMessage,
  }) {
    return RamadanState(
      status: status ?? this.status,
      isRamadanMode: isRamadanMode ?? this.isRamadanMode,
      selectedDate: selectedDate ?? this.selectedDate,
      ramadanProfile: ramadanProfile ?? this.ramadanProfile,
      dayContext: dayContext ?? this.dayContext,
      timeline: timeline ?? this.timeline,
      prayerTimes: prayerTimes ?? this.prayerTimes,
      todayHijri: todayHijri ?? this.todayHijri,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status, isRamadanMode, selectedDate,
        ramadanProfile, dayContext, timeline, errorMessage,
      ];
}

// ─── BLOC ─────────────────────────────────────────────────────────────────────
class RamadanBloc extends Bloc<RamadanEvent, RamadanState> {
  final Isar isar;
  final PrayerTimeService prayerTimeService;
  final RamadanTimelineGenerator generator;
  final HijriConverter hijriConverter;

  RamadanBloc({
    required this.isar,
    required this.prayerTimeService,
    required this.generator,
    required this.hijriConverter,
  }) : super(RamadanState(selectedDate: DateTime.now())) {
    on<RamadanInitialised>(_onInitialised);
    on<RamadanModeToggled>(_onModeToggled);
    on<RamadanProfileUpdated>(_onProfileUpdated);
    on<RamadanDateChanged>(_onDateChanged);
    on<RamadanTimelineRequested>(_onTimelineRequested);
  }

  // ── INIT ──────────────────────────────────────────────────────────────────
  Future<void> _onInitialised(
      RamadanInitialised event, Emitter<RamadanState> emit) async {
    emit(state.copyWith(status: RamadanStatus.loading));

    final profile = await _loadOrCreateProfile();
    final todayHijri = hijriConverter.toHijri(DateTime.now());
    final isActive = event.userProfile.isRamadanMode;

    emit(state.copyWith(
      status: isActive ? RamadanStatus.active : RamadanStatus.inactive,
      isRamadanMode: isActive,
      ramadanProfile: profile,
      todayHijri: todayHijri,
    ));

    if (isActive) {
      add(RamadanTimelineRequested(
        date: state.selectedDate,
        userProfile: event.userProfile,
      ));
    }
  }

  // ── TOGGLE ────────────────────────────────────────────────────────────────
  Future<void> _onModeToggled(
      RamadanModeToggled event, Emitter<RamadanState> emit) async {
    emit(state.copyWith(
      isRamadanMode: event.enabled,
      status: event.enabled ? RamadanStatus.active : RamadanStatus.inactive,
    ));

    if (event.enabled) {
      add(RamadanTimelineRequested(
        date: state.selectedDate,
        userProfile: event.userProfile,
      ));
    }
  }

  // ── PROFILE UPDATE ────────────────────────────────────────────────────────
  Future<void> _onProfileUpdated(
      RamadanProfileUpdated event, Emitter<RamadanState> emit) async {
    try {
      final model = RamadanProfileModel.fromEntity(event.profile);
      await isar.writeTxn(() => isar.ramadanProfileModels.put(model));
      emit(state.copyWith(
        ramadanProfile: model.toEntity(),
        status: RamadanStatus.active,
      ));
    } catch (e) {
      emit(state.copyWith(errorMessage: 'Failed to save Ramadan settings: $e'));
    }
  }

  // ── DATE CHANGE ───────────────────────────────────────────────────────────
  Future<void> _onDateChanged(
      RamadanDateChanged event, Emitter<RamadanState> emit) async {
    emit(state.copyWith(selectedDate: event.date));
    add(RamadanTimelineRequested(
      date: event.date,
      userProfile: event.userProfile,
    ));
  }

  // ── TIMELINE ──────────────────────────────────────────────────────────────
  Future<void> _onTimelineRequested(
      RamadanTimelineRequested event, Emitter<RamadanState> emit) async {
    emit(state.copyWith(status: RamadanStatus.loading));

    try {
      final profile =
          state.ramadanProfile ?? await _loadOrCreateProfile();

      // Get prayer times
      final prayerResult = prayerTimeService.getPrayerTimes(
        profile: event.userProfile,
        date: event.date,
      );

      late DailyPrayerTimes prayerTimes;
      prayerResult.fold(
        (f) => throw Exception(f.message),
        (p) => prayerTimes = p,
      );

      // Build Ramadan context
      final ctx = generator.buildContext(
        date: event.date,
        prayerTimes: prayerTimes,
        ramadanProfile: profile,
      );

      // Generate restructured timeline
      final timeline = generator.generate(
        date: event.date,
        userProfile: event.userProfile,
        prayerTimes: prayerTimes,
        ramadanProfile: profile,
      );

      emit(state.copyWith(
        status: RamadanStatus.active,
        ramadanProfile: profile,
        dayContext: ctx,
        timeline: timeline,
        prayerTimes: prayerTimes,
        todayHijri: hijriConverter.toHijri(event.date),
      ));
    } catch (e) {
      emit(state.copyWith(
        status: RamadanStatus.error,
        errorMessage: 'Failed to generate Ramadan timeline: $e',
      ));
    }
  }

  // ── HELPERS ───────────────────────────────────────────────────────────────
  Future<RamadanProfile> _loadOrCreateProfile() async {
    final existing =
        await isar.ramadanProfileModels.where().findFirst();
    if (existing != null) return existing.toEntity();

    // Create default profile
    final now = DateTime.now();
    final defaultProfile = RamadanProfile(
      id: 0,
      createdAt: now,
      updatedAt: now,
    );
    final model = RamadanProfileModel.fromEntity(defaultProfile);
    await isar.writeTxn(() => isar.ramadanProfileModels.put(model));
    return model.toEntity();
  }
}
