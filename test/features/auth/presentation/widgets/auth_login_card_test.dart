import 'package:fintrack/features/auth/domain/entities/auth_user.dart';
import 'package:fintrack/features/auth/domain/repositories/auth_repository.dart';
import 'package:fintrack/features/auth/presentation/bloc/auth_form_bloc.dart';
import 'package:fintrack/features/auth/presentation/widgets/auth_login_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renderiza campos de auth e botao demo', (tester) async {
    await tester.pumpWidget(_buildTestApp());

    expect(find.text('Bem-vindo'), findsOneWidget);
    expect(find.text('E-mail'), findsOneWidget);
    expect(find.text('Senha'), findsOneWidget);
    expect(find.text('Entrar'), findsOneWidget);
    expect(find.text('Criar conta'), findsOneWidget);
    expect(find.text('Entrar no modo demo'), findsOneWidget);
  });

  testWidgets('valida campos obrigatorios', (tester) async {
    await tester.pumpWidget(_buildTestApp());

    await tester.tap(find.text('Entrar'));
    await tester.pumpAndSettle();

    expect(find.text('Informe o e-mail.'), findsOneWidget);
    expect(find.text('Informe a senha.'), findsOneWidget);
  });

  testWidgets('entra com email e senha ao tocar em Entrar', (tester) async {
    final authRepository = _FakeAuthRepository();

    await tester.pumpWidget(_buildTestApp(authRepository: authRepository));

    await tester.enterText(find.byType(TextFormField).at(0), 'user@email.com');
    await tester.enterText(find.byType(TextFormField).at(1), 'password123');
    await tester.tap(find.text('Entrar'));
    await tester.pumpAndSettle();

    expect(authRepository.signInEmail, 'user@email.com');
    expect(authRepository.signInPassword, 'password123');
    expect(authRepository.signUpEmail, isNull);
  });

  testWidgets('cria conta com um toque em Criar conta', (tester) async {
    final authRepository = _FakeAuthRepository();

    await tester.pumpWidget(_buildTestApp(authRepository: authRepository));

    await tester.enterText(find.byType(TextFormField).at(0), 'new@email.com');
    await tester.enterText(find.byType(TextFormField).at(1), 'password123');
    await tester.tap(find.text('Criar conta'));
    await tester.pumpAndSettle();

    expect(authRepository.signUpEmail, 'new@email.com');
    expect(authRepository.signUpPassword, 'password123');
    expect(authRepository.signInEmail, isNull);
  });
}

Widget _buildTestApp({_FakeAuthRepository? authRepository}) {
  return MaterialApp(
    home: Scaffold(
      body: BlocProvider<AuthFormBloc>(
        create: (_) => AuthFormBloc(
          authRepository: authRepository ?? _FakeAuthRepository(),
        ),
        child: const AuthLoginCard(),
      ),
    ),
  );
}

class _FakeAuthRepository implements AuthRepository {
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

    return AuthUser(id: 'user-id', email: email);
  }

  @override
  Future<AuthUser> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    signUpEmail = email;
    signUpPassword = password;

    return AuthUser(id: 'user-id', email: email);
  }

  @override
  Future<void> signOut() async {}
}
