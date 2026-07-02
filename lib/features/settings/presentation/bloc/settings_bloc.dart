import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/app_settings.dart';
import '../../domain/usecases/settings_usecases.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final LoadSettings _load;
  final SaveSettings _save;
  final ResetSettings _reset;

  SettingsBloc({
    required LoadSettings loadSettings,
    required SaveSettings saveSettings,
    required ResetSettings resetSettings,
  })  : _load = loadSettings,
        _save = saveSettings,
        _reset = resetSettings,
        super(const SettingsInitial()) {
    on<SettingsLoadRequested>(_onLoad);
    on<SettingsPrayerNotificationToggled>(_onPrayerToggled);
    on<SettingsHabitReminderToggled>(_onHabitToggled);
    on<SettingsQuranReminderToggled>(_onQuranToggled);
    on<SettingsQuietHoursToggled>(_onQuietToggled);
    on<SettingsQuietHoursChanged>(_onQuietHoursChanged);
    on<SettingsThemeModeChanged>(_onThemeChanged);
    on<SettingsHijriDisplayToggled>(_onHijriToggled);
    on<Settings24HourToggled>(_on24HourToggled);
    on<SettingsLanguageChanged>(_onLanguageChanged);
    on<SettingsResetRequested>(_onReset);
  }

  // ── Helpers ──────────────────────────────────────────────────────────────────

  AppSettings? get _current {
    final s = state;
    return s is SettingsLoaded ? s.settings : null;
  }

  Future<void> _applyAndSave(
      AppSettings updated, Emitter<SettingsState> emit) async {
    emit(SettingsLoaded(updated));
    // Fire-and-forget: SharedPreferences writes are fast; errors are non-critical
    await _save(SaveSettingsParams(updated));
  }

  // ── Handlers ─────────────────────────────────────────────────────────────────

  Future<void> _onLoad(
      SettingsLoadRequested event, Emitter<SettingsState> emit) async {
    emit(const SettingsLoading());
    final result = await _load(const NoParams());
    result.fold(
      (f) => emit(SettingsError(f.message)),
      (settings) => emit(SettingsLoaded(settings)),
    );
  }

  Future<void> _onPrayerToggled(SettingsPrayerNotificationToggled event,
      Emitter<SettingsState> emit) async {
    final current = _current;
    if (current == null) return;

    AppSettings updated;
    switch (event.prayer) {
      case 'fajr':
        updated = current.copyWith(fajrNotification: event.enabled);
        break;
      case 'dhuhr':
        updated = current.copyWith(dhuhrNotification: event.enabled);
        break;
      case 'asr':
        updated = current.copyWith(asrNotification: event.enabled);
        break;
      case 'maghrib':
        updated = current.copyWith(maghribNotification: event.enabled);
        break;
      case 'isha':
        updated = current.copyWith(ishaNotification: event.enabled);
        break;
      default:
        return;
    }
    await _applyAndSave(updated, emit);
  }

  Future<void> _onHabitToggled(
      SettingsHabitReminderToggled event, Emitter<SettingsState> emit) async {
    final c = _current;
    if (c == null) return;
    await _applyAndSave(c.copyWith(habitReminders: event.enabled), emit);
  }

  Future<void> _onQuranToggled(
      SettingsQuranReminderToggled event, Emitter<SettingsState> emit) async {
    final c = _current;
    if (c == null) return;
    await _applyAndSave(c.copyWith(quranReminder: event.enabled), emit);
  }

  Future<void> _onQuietToggled(
      SettingsQuietHoursToggled event, Emitter<SettingsState> emit) async {
    final c = _current;
    if (c == null) return;
    await _applyAndSave(c.copyWith(quietHoursEnabled: event.enabled), emit);
  }

  Future<void> _onQuietHoursChanged(
      SettingsQuietHoursChanged event, Emitter<SettingsState> emit) async {
    final c = _current;
    if (c == null) return;
    await _applyAndSave(
      c.copyWith(
        quietHoursStartHour: event.startHour,
        quietHoursStartMinute: event.startMinute,
        quietHoursEndHour: event.endHour,
        quietHoursEndMinute: event.endMinute,
      ),
      emit,
    );
  }

  Future<void> _onThemeChanged(
      SettingsThemeModeChanged event, Emitter<SettingsState> emit) async {
    final c = _current;
    if (c == null) return;
    await _applyAndSave(c.copyWith(themeMode: event.themeMode), emit);
  }

  Future<void> _onHijriToggled(
      SettingsHijriDisplayToggled event, Emitter<SettingsState> emit) async {
    final c = _current;
    if (c == null) return;
    await _applyAndSave(c.copyWith(showHijriDate: event.enabled), emit);
  }

  Future<void> _on24HourToggled(
      Settings24HourToggled event, Emitter<SettingsState> emit) async {
    final c = _current;
    if (c == null) return;
    await _applyAndSave(c.copyWith(show24HourTime: event.enabled), emit);
  }

  Future<void> _onLanguageChanged(
      SettingsLanguageChanged event, Emitter<SettingsState> emit) async {
    final c = _current;
    if (c == null) return;
    await _applyAndSave(c.copyWith(language: event.languageCode), emit);
  }

  Future<void> _onReset(
      SettingsResetRequested event, Emitter<SettingsState> emit) async {
    final result = await _reset(const NoParams());
    result.fold(
      (f) => emit(SettingsError(f.message)),
      (_) => emit(const SettingsLoaded(AppSettings.defaults)),
    );
  }
}
