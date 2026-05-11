import 'package:fintrack/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'auth_form_event.dart';
import 'auth_form_state.dart';

class AuthFormBloc extends Bloc<AuthFormEvent, AuthFormState> {
  AuthFormBloc({required AuthRepository authRepository})
    : _authRepository = authRepository,
      super(const AuthFormInitial()) {
    on<AuthFormSignInSubmitted>(_onSignInSubmitted);
    on<AuthFormSignUpSubmitted>(_onSignUpSubmitted);
  }

  final AuthRepository _authRepository;

  Future<void> _onSignInSubmitted(
    AuthFormSignInSubmitted event,
    Emitter<AuthFormState> emit,
  ) async {
    emit(const AuthFormSubmitting());

    try {
      await _authRepository.signInWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );
      emit(const AuthFormSuccess());
    } catch (error) {
      emit(AuthFormError(message: error.toString()));
    }
  }

  Future<void> _onSignUpSubmitted(
    AuthFormSignUpSubmitted event,
    Emitter<AuthFormState> emit,
  ) async {
    emit(const AuthFormSubmitting());

    try {
      await _authRepository.createUserWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );
      emit(const AuthFormSuccess());
    } catch (error) {
      emit(AuthFormError(message: error.toString()));
    }
  }
}
