import 'package:fintrack/app/theme/app_theme.dart';
import 'package:fintrack/features/auth/presentation/bloc/auth_session_bloc.dart';
import 'package:fintrack/features/auth/presentation/bloc/auth_session_event.dart';
import 'package:fintrack/features/auth/presentation/bloc/auth_session_state.dart';
import 'package:fintrack/features/auth/presentation/pages/login_page.dart';
import 'package:fintrack/features/shell/presentation/pages/shell_page.dart';
import 'package:fintrack/features/transactions/data/repositories/in_memory_transaction_repository.dart';
import 'package:fintrack/features/transactions/domain/entities/transaction.dart';
import 'package:fintrack/features/transactions/domain/repositories/transaction_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FinTrackApp extends StatelessWidget {
  const FinTrackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<TransactionRepository>(
      create: (_) => InMemoryTransactionRepository(
        initialTransactions: [
          Transaction(
            id: '1',
            type: TransactionType.income,
            amount: 3500,
            date: DateTime(2026, 4, 5),
            description: 'Salário',
            category: 'Renda',
          ),
          Transaction(
            id: '2',
            type: TransactionType.expense,
            amount: 82.50,
            date: DateTime(2026, 4, 6),
            description: 'Supermercado',
            category: 'Alimentação',
          ),
          Transaction(
            id: '3',
            type: TransactionType.expense,
            amount: 18.00,
            date: DateTime(2026, 4, 7),
            description: 'Transporte',
            category: 'Mobilidade',
          ),
        ],
      ),
      child: BlocProvider<AuthSessionBloc>(
        create: (_) => AuthSessionBloc(),
        child: MaterialApp(
          title: 'FinTrack',
          theme: AppTheme.light(),
          home: const _AppEntryPage(),
        ),
      ),
    );
  }
}

class _AppEntryPage extends StatelessWidget {
  const _AppEntryPage();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthSessionBloc, AuthSessionState>(
      builder: (context, state) {
        if (state is AuthSessionAuthenticated) {
          return ShellPage(
            onLogout: () {
              context.read<AuthSessionBloc>().add(const AuthSessionLoggedOut());
            },
          );
        }

        return LoginPage(
          onEnterDemo: () {
            context.read<AuthSessionBloc>().add(const AuthSessionEnteredDemo());
          },
        );
      },
    );
  }
}
