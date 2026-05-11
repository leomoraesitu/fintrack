import 'package:fintrack/features/auth/domain/entities/auth_user.dart';
import 'package:fintrack/features/auth/domain/repositories/auth_repository.dart';
import 'package:fintrack/features/auth/presentation/bloc/auth_form_bloc.dart';
import 'package:fintrack/features/auth/presentation/bloc/auth_form_event.dart';
import 'package:fintrack/features/auth/presentation/bloc/auth_form_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AuthFormBloc', () {
    test('deve autenticar com email e senha com sucesso', () async {
      final authRepository = _FakeAuthRepository();
      final bloc = AuthFormBloc(authRepository: authRepository);

      bloc.add(
        const AuthFormSignInSubmitted(
          email: 'user@email.com',
          password: 'password123',
        ),
      );

      await expectLater(
        bloc.stream,
        emitsInOrder([
          isA<AuthFormSubmitting>(),
          isA<AuthFormSuccess>(),
        ]),
      );

      expect(authRepository.signInEmail, 'user@email.com');
      expect(authRepository.signInPassword, 'password123');

      await bloc.close();
    });

    test('deve emitir erro quando login falhar', () async {
      final authRepository = _FakeAuthRepository(signInError: Exception('erro'));
      final bloc = AuthFormBloc(authRepository: authRepository);

      bloc.add(
        const AuthFormSignInSubmitted(
          email: 'user@email.com',
          password: 'password123',
        ),
      );

      await expectLater(
        bloc.stream,
        emitsInOrder([
          isA<AuthFormSubmitting>(),
          isA<AuthFormError>().having(
            (state) => state.message,
            'message',
            contains('erro'),
          ),
        ]),
      );

      await bloc.close();
    });

    test('deve criar conta com email e senha com sucesso', () async {
      final authRepository = _FakeAuthRepository();
      final bloc = AuthFormBloc(authRepository: authRepository);

      bloc.add(
        const AuthFormSignUpSubmitted(
          email: 'new@email.com',
          password: 'password123',
        ),
      );

      await expectLater(
        bloc.stream,
        emitsInOrder([
          isA<AuthFormSubmitting>(),
          isA<AuthFormSuccess>(),
        ]),
      );

      expect(authRepository.signUpEmail, 'new@email.com');
      expect(authRepository.signUpPassword, 'password123');

      await bloc.close();
    });

    test('deve emitir erro quando cadastro falhar', () async {
      final authRepository = _FakeAuthRepository(signUpError: Exception('erro'));
      final bloc = AuthFormBloc(authRepository: authRepository);

      bloc.add(
        const AuthFormSignUpSubmitted(
          email: 'new@email.com',
          password: 'password123',
        ),
      );

      await expectLater(
        bloc.stream,
        emitsInOrder([
          isA<AuthFormSubmitting>(),
          isA<AuthFormError>().having(
            (state) => state.message,
            'message',
            contains('erro'),
          ),
        ]),
      );

      await bloc.close();
    });
  });
}

class _FakeAuthRepository implements AuthRepository {
  _FakeAuthRepository({this.signInError, this.signUpError});

  final Object? signInError;
  final Object? signUpError;

  String? signInEmail;
  String? signInPassword;
  String? signUpEmail;
  String? signUpPassword;

  @override
  Stream<AuthUser?> authStateChanges() {
    return const Stream<AuthUser?>.empty();
  }

  @override
  Future<AuthUser> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    signInEmail = email;
    signInPassword = password;

    final error = signInError;
    if (error != null) {
      throw error;
    }

    return AuthUser(id: 'user-id', email: email);
  }

  @override
  Future<AuthUser> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    signUpEmail = email;
    signUpPassword = password;

    final error = signUpError;
    if (error != null) {
      throw error;
    }

    return AuthUser(id: 'user-id', email: email);
  }

  @override
  Future<void> signOut() async {}
}
