import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/analytics_entities.dart';
import '../../domain/usecases/analytics_usecases.dart';

// ─── EVENTS ───────────────────────────────────────────────────────────────────
abstract class AnalyticsEvent extends Equatable {
  const AnalyticsEvent();
  @override
  List<Object?> get props => [];
}

class AnalyticsLoadRequested extends AnalyticsEvent {
  final AnalyticsPeriod period;
  const AnalyticsLoadRequested(this.period);
  @override
  List<Object?> get props => [period];
}

class AnalyticsPeriodChanged extends AnalyticsEvent {
  final AnalyticsPeriod period;
  const AnalyticsPeriodChanged(this.period);
  @override
  List<Object?> get props => [period];
}

class AnalyticsHeatmapMonthChanged extends AnalyticsEvent {
  final int year;
  final int month;
  const AnalyticsHeatmapMonthChanged(
      {required this.year, required this.month});
  @override
  List<Object?> get props => [year, month];
}

class AnalyticsRefreshRequested extends AnalyticsEvent {
  const AnalyticsRefreshRequested();
}

// ─── STATE ────────────────────────────────────────────────────────────────────
enum AnalyticsStatus { initial, loading, loaded, error }

class AnalyticsState extends Equatable {
  final AnalyticsStatus status;
  final AnalyticsPeriod period;
  final AnalyticsSnapshot? snapshot;
  final MonthlyHeatmap? currentHeatmap;
  final int heatmapYear;
  final int heatmapMonth;
  final String? errorMessage;

  AnalyticsState({
    this.status = AnalyticsStatus.initial,
    this.period = AnalyticsPeriod.week,
    this.snapshot,
    this.currentHeatmap,
    int? heatmapYear,
    int? heatmapMonth,
    this.errorMessage,
  })  : heatmapYear = heatmapYear ?? DateTime.now().year,
        heatmapMonth = heatmapMonth ?? DateTime.now().month;

  bool get hasData => snapshot != null;

  AnalyticsState copyWith({
    AnalyticsStatus? status,
    AnalyticsPeriod? period,
    AnalyticsSnapshot? snapshot,
    MonthlyHeatmap? currentHeatmap,
    int? heatmapYear,
    int? heatmapMonth,
    String? errorMessage,
  }) {
    return AnalyticsState(
      status: status ?? this.status,
      period: period ?? this.period,
      snapshot: snapshot ?? this.snapshot,
      currentHeatmap: currentHeatmap ?? this.currentHeatmap,
      heatmapYear: heatmapYear ?? this.heatmapYear,
      heatmapMonth: heatmapMonth ?? this.heatmapMonth,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status, period, snapshot,
        currentHeatmap, heatmapYear, heatmapMonth, errorMessage,
      ];
}

// ─── BLOC ─────────────────────────────────────────────────────────────────────
class AnalyticsBloc extends Bloc<AnalyticsEvent, AnalyticsState> {
  final GetAnalyticsSnapshot getSnapshot;
  final GetWeeklyScoreSeries getWeeklyScoreSeries;
  final GetMonthlyHeatmap getMonthlyHeatmap;

  AnalyticsBloc({
    required this.getSnapshot,
    required this.getWeeklyScoreSeries,
    required this.getMonthlyHeatmap,
  }) : super(AnalyticsState()) {
    on<AnalyticsLoadRequested>(_onLoad);
    on<AnalyticsPeriodChanged>(_onPeriodChanged);
    on<AnalyticsHeatmapMonthChanged>(_onHeatmapMonthChanged);
    on<AnalyticsRefreshRequested>(_onRefresh);
  }

  Future<void> _onLoad(
      AnalyticsLoadRequested event, Emitter<AnalyticsState> emit) async {
    emit(state.copyWith(
        status: AnalyticsStatus.loading, period: event.period));

    final result = await getSnapshot(event.period);
    result.fold(
      (f) => emit(state.copyWith(
          status: AnalyticsStatus.error, errorMessage: f.message)),
      (snapshot) => emit(state.copyWith(
        status: AnalyticsStatus.loaded,
        snapshot: snapshot,
        currentHeatmap: snapshot.heatmap,
      )),
    );
  }

  Future<void> _onPeriodChanged(
      AnalyticsPeriodChanged event, Emitter<AnalyticsState> emit) async {
    add(AnalyticsLoadRequested(event.period));
  }

  Future<void> _onHeatmapMonthChanged(
      AnalyticsHeatmapMonthChanged event,
      Emitter<AnalyticsState> emit) async {
    emit(state.copyWith(
      heatmapYear: event.year,
      heatmapMonth: event.month,
      status: AnalyticsStatus.loading,
    ));

    final result = await getMonthlyHeatmap(
      MonthlyHeatmapParams(year: event.year, month: event.month),
    );
    result.fold(
      (f) => emit(
          state.copyWith(status: AnalyticsStatus.loaded, errorMessage: f.message)),
      (heatmap) => emit(state.copyWith(
        status: AnalyticsStatus.loaded,
        currentHeatmap: heatmap,
        heatmapYear: event.year,
        heatmapMonth: event.month,
      )),
    );
  }

  Future<void> _onRefresh(
      AnalyticsRefreshRequested event, Emitter<AnalyticsState> emit) async {
    add(AnalyticsLoadRequested(state.period));
  }
}
