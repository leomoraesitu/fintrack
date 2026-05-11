import 'dart:async';

import 'package:fintrack/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'auth_session_event.dart';
import 'auth_session_state.dart';

class AuthSessionBloc extends Bloc<AuthSessionEvent, AuthSessionState> {
  final AuthRepository _authRepository;
  StreamSubscription? _authSubscription;

  AuthSessionBloc(this._authRepository)
    : super(const AuthSessionUnauthenticated()) {
    on<AuthSessionEnteredDemo>((event, emit) {
      emit(const AuthSessionAuthenticated.demo());
    });

    on<AuthSessionLoggedOut>((event, emit) async {
      await _authRepository.signOut();
      emit(const AuthSessionUnauthenticated());
    });

    on<AuthSessionStarted>((event, emit) {
      _authSubscription?.cancel();
      _authSubscription = _authRepository.authStateChanges().listen((user) {
        add(AuthSessionUserChanged(user));
      });
    });

    on<AuthSessionUserChanged>((event, emit) {
      if (event.user == null) {
        emit(const AuthSessionUnauthenticated());
        return;
      }

      emit(AuthSessionAuthenticated(user: event.user));
    });
  }

  @override
  Future<void> close() {
    _authSubscription?.cancel();
    return super.close();
  }
}
