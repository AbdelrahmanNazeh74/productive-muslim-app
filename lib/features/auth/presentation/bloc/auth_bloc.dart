import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/auth_user.dart';
import '../../domain/usecases/auth_usecases.dart';

// ─── EVENTS ───────────────────────────────────────────────────────────────────

abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object?> get props => [];
}

class AuthCheckRequested extends AuthEvent {
  const AuthCheckRequested();
}

class AuthSignInRequested extends AuthEvent {
  const AuthSignInRequested();
}

class AuthGuestRequested extends AuthEvent {
  const AuthGuestRequested();
}

class AuthSignOutRequested extends AuthEvent {
  const AuthSignOutRequested();
}

// Internal — fired by the auth state stream.
class _AuthStateChanged extends AuthEvent {
  final AuthUser? user;
  const _AuthStateChanged(this.user);
  @override
  List<Object?> get props => [user];
}

// ─── STATES ───────────────────────────────────────────────────────────────────

abstract class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

// Both Google-signed and guest users end up here; check user.isAnonymous to
// distinguish. Guest users have isAnonymous == true and an empty email.
class AuthAuthenticated extends AuthState {
  final AuthUser user;
  const AuthAuthenticated(this.user);
  @override
  List<Object?> get props => [user];
}

class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);
  @override
  List<Object?> get props => [message];
}

// ─── BLoC ─────────────────────────────────────────────────────────────────────

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignInWithGoogle _signInWithGoogle;
  final SignInAsGuest _signInAsGuest;
  final SignOut _signOut;
  final GetCurrentUser _getCurrentUser;
  final WatchAuthState _watchAuthState;

  StreamSubscription<AuthUser?>? _authSub;

  AuthBloc({
    required SignInWithGoogle signInWithGoogle,
    required SignInAsGuest signInAsGuest,
    required SignOut signOut,
    required GetCurrentUser getCurrentUser,
    required WatchAuthState watchAuthState,
  })  : _signInWithGoogle = signInWithGoogle,
        _signInAsGuest = signInAsGuest,
        _signOut = signOut,
        _getCurrentUser = getCurrentUser,
        _watchAuthState = watchAuthState,
        super(const AuthInitial()) {
    on<AuthCheckRequested>(_onCheckRequested);
    on<AuthSignInRequested>(_onSignInRequested);
    on<AuthGuestRequested>(_onGuestRequested);
    on<AuthSignOutRequested>(_onSignOutRequested);
    on<_AuthStateChanged>(_onStateChanged);

    _authSub = _watchAuthState().listen((user) {
      add(_AuthStateChanged(user));
    });
  }

  @override
  Future<void> close() {
    _authSub?.cancel();
    return super.close();
  }

  Future<void> _onCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    final result = await _getCurrentUser(const NoParams());
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) =>
          emit(user != null ? AuthAuthenticated(user) : const AuthUnauthenticated()),
    );
  }

  Future<void> _onSignInRequested(
    AuthSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    final result = await _signInWithGoogle(const NoParams());
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => emit(AuthAuthenticated(user)),
    );
  }

  Future<void> _onGuestRequested(
    AuthGuestRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    final result = await _signInAsGuest(const NoParams());
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => emit(AuthAuthenticated(user)),
    );
  }

  Future<void> _onSignOutRequested(
    AuthSignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await _signOut(const NoParams());
    emit(const AuthUnauthenticated());
  }

  void _onStateChanged(
    _AuthStateChanged event,
    Emitter<AuthState> emit,
  ) {
    // Don't interrupt an in-flight sign-in/out operation.
    if (state is AuthLoading) return;
    emit(event.user != null
        ? AuthAuthenticated(event.user!)
        : const AuthUnauthenticated());
  }
}
