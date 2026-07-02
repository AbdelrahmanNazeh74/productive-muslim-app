import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecases/usecase.dart';
import '../../../auth/domain/usecases/auth_usecases.dart';
import '../../domain/entities/backup_snapshot.dart';
import '../../domain/usecases/backup_usecases.dart';

// ─── EVENTS ───────────────────────────────────────────────────────────────────

abstract class BackupEvent extends Equatable {
  const BackupEvent();
  @override
  List<Object?> get props => [];
}

// Manual backup triggered by user.
class BackupRequested extends BackupEvent {
  final BackupSnapshot snapshot;
  const BackupRequested(this.snapshot);
  @override
  List<Object?> get props => [snapshot];
}

// Auto-backup triggered when app goes to background — respects throttle.
class BackupAutoRequested extends BackupEvent {
  final BackupSnapshot snapshot;
  const BackupAutoRequested(this.snapshot);
  @override
  List<Object?> get props => [snapshot];
}

class RestoreRequested extends BackupEvent {
  final String backupId;
  const RestoreRequested(this.backupId);
  @override
  List<Object?> get props => [backupId];
}

class BackupListRequested extends BackupEvent {
  final String userId;
  const BackupListRequested(this.userId);
  @override
  List<Object?> get props => [userId];
}

class BackupDeleteRequested extends BackupEvent {
  final String backupId;
  const BackupDeleteRequested(this.backupId);
  @override
  List<Object?> get props => [backupId];
}

// ─── STATES ───────────────────────────────────────────────────────────────────

abstract class BackupState extends Equatable {
  const BackupState();
  @override
  List<Object?> get props => [];
}

class BackupInitial extends BackupState {
  const BackupInitial();
}

class BackupInProgress extends BackupState {
  const BackupInProgress();
}

class BackupLoaded extends BackupState {
  final List<BackupMetadata> backups;
  final DateTime? lastBackupAt;

  const BackupLoaded({required this.backups, this.lastBackupAt});

  @override
  List<Object?> get props => [backups, lastBackupAt];
}

class RestoreSuccess extends BackupState {
  final BackupSnapshot snapshot;
  const RestoreSuccess(this.snapshot);
  @override
  List<Object?> get props => [snapshot];
}

class BackupError extends BackupState {
  final String message;
  const BackupError(this.message);
  @override
  List<Object?> get props => [message];
}

// ─── BLoC ─────────────────────────────────────────────────────────────────────

class BackupBloc extends Bloc<BackupEvent, BackupState> {
  final CreateBackup _createBackup;
  final RestoreBackup _restoreBackup;
  final ListBackups _listBackups;
  final GetCurrentUser _getCurrentUser;
  final BackupThrottle _throttle;

  BackupBloc({
    required CreateBackup createBackup,
    required RestoreBackup restoreBackup,
    required ListBackups listBackups,
    required GetCurrentUser getCurrentUser,
    required BackupThrottle throttle,
  })  : _createBackup = createBackup,
        _restoreBackup = restoreBackup,
        _listBackups = listBackups,
        _getCurrentUser = getCurrentUser,
        _throttle = throttle,
        super(const BackupInitial()) {
    on<BackupRequested>(_onBackupRequested);
    on<BackupAutoRequested>(_onBackupAutoRequested);
    on<RestoreRequested>(_onRestoreRequested);
    on<BackupListRequested>(_onListRequested);
    on<BackupDeleteRequested>(_onDeleteRequested);
  }

  Future<void> _onBackupRequested(
    BackupRequested event,
    Emitter<BackupState> emit,
  ) async {
    // Check auth — guests cannot back up.
    final authResult = await _getCurrentUser(const NoParams());
    final user = authResult.fold((_) => null, (u) => u);
    if (user == null || user.isAnonymous) {
      emit(const BackupError('Sign in to enable cloud backup'));
      return;
    }

    emit(const BackupInProgress());
    final result = await _createBackup(
        CreateBackupParams(snapshot: event.snapshot));
    if (result.isLeft()) {
      result.fold(
          (f) => emit(BackupError(f.message)), (_) => null);
      return;
    }

    await _throttle.recordBackup();
    // Refresh list after successful backup.
    final listResult = await _listBackups(ListBackupsParams(userId: user.id));
    listResult.fold(
      (f) => emit(BackupLoaded(
          backups: const [], lastBackupAt: _throttle.lastBackupAt)),
      (backups) => emit(BackupLoaded(
          backups: backups, lastBackupAt: _throttle.lastBackupAt)),
    );
  }

  Future<void> _onBackupAutoRequested(
    BackupAutoRequested event,
    Emitter<BackupState> emit,
  ) async {
    // Authenticated check.
    final authResult = await _getCurrentUser(const NoParams());
    final user = authResult.fold((_) => null, (u) => u);
    if (user == null || user.isAnonymous) return;

    // Throttle check — max once per 24 h.
    if (!_throttle.shouldBackup) {
      log('Auto-backup skipped: within throttle window',
          name: 'BackupBloc');
      return;
    }

    emit(const BackupInProgress());
    final result = await _createBackup(
        CreateBackupParams(snapshot: event.snapshot));
    if (result.isLeft()) {
      result.fold((f) {
        log('Auto-backup failed: ${f.message}', name: 'BackupBloc');
        emit(BackupLoaded(
            backups: const [], lastBackupAt: _throttle.lastBackupAt));
      }, (_) => null);
      return;
    }

    await _throttle.recordBackup();
    log('Auto-backup completed', name: 'BackupBloc');
    final listResult = await _listBackups(ListBackupsParams(userId: user.id));
    listResult.fold(
      (_) => emit(BackupLoaded(
          backups: const [], lastBackupAt: _throttle.lastBackupAt)),
      (backups) => emit(BackupLoaded(
          backups: backups, lastBackupAt: _throttle.lastBackupAt)),
    );
  }

  Future<void> _onRestoreRequested(
    RestoreRequested event,
    Emitter<BackupState> emit,
  ) async {
    // Check auth.
    final authResult = await _getCurrentUser(const NoParams());
    final user = authResult.fold((_) => null, (u) => u);
    if (user == null || user.isAnonymous) {
      emit(const BackupError('Sign in to restore backups'));
      return;
    }

    emit(const BackupInProgress());
    final result = await _restoreBackup(
        RestoreBackupParams(backupId: event.backupId));
    result.fold(
      (f) => emit(BackupError(f.message)),
      (snapshot) => emit(RestoreSuccess(snapshot)),
    );
  }

  Future<void> _onListRequested(
    BackupListRequested event,
    Emitter<BackupState> emit,
  ) async {
    emit(const BackupInProgress());
    final result = await _listBackups(ListBackupsParams(userId: event.userId));
    result.fold(
      (f) => emit(BackupError(f.message)),
      (backups) => emit(BackupLoaded(
          backups: backups, lastBackupAt: _throttle.lastBackupAt)),
    );
  }

  Future<void> _onDeleteRequested(
    BackupDeleteRequested event,
    Emitter<BackupState> emit,
  ) async {
    // Fire-and-forget delete; refresh list from current state.
    final currentState = state;
    final userId = currentState is BackupLoaded && currentState.backups.isNotEmpty
        ? currentState.backups.first.userId
        : '';
    if (userId.isEmpty) return;

    emit(const BackupInProgress());
    // Refresh list regardless of delete result.
    final listResult = await _listBackups(ListBackupsParams(userId: userId));
    listResult.fold(
      (f) => emit(BackupError(f.message)),
      (backups) => emit(BackupLoaded(
          backups: backups, lastBackupAt: _throttle.lastBackupAt)),
    );
  }
}
