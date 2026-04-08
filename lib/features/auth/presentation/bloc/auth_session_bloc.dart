import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_session_event.dart';
import 'auth_session_state.dart';

class AuthSessionBloc extends Bloc<AuthSessionEvent, AuthSessionState> {
  AuthSessionBloc() : super(const AuthSessionUnauthenticated()) {
    on<AuthSessionEnteredDemo>((event, emit) {
      emit(const AuthSessionAuthenticated());
    });

    on<AuthSessionLoggedOut>((event, emit) {
      emit(const AuthSessionUnauthenticated());
    });
  }
}
