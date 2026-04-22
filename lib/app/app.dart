import 'package:fintrack/app/theme/app_theme.dart';
import 'package:fintrack/features/auth/presentation/bloc/auth_session_bloc.dart';
import 'package:fintrack/features/auth/presentation/bloc/auth_session_event.dart';
import 'package:fintrack/features/auth/presentation/bloc/auth_session_state.dart';
import 'package:fintrack/features/auth/presentation/pages/login_page.dart';
import 'package:fintrack/features/shell/presentation/pages/shell_page.dart';
import 'package:fintrack/features/transactions/data/datasources/shared_prefs_transaction_local_data_source.dart';
import 'package:fintrack/features/transactions/data/repositories/local_transaction_repository.dart';
import 'package:fintrack/features/transactions/domain/entities/transaction.dart';
import 'package:fintrack/features/transactions/domain/entities/transaction_categories.dart';
import 'package:fintrack/features/transactions/domain/entities/transaction_type.dart';
import 'package:fintrack/features/transactions/domain/repositories/transaction_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FinTrackApp extends StatelessWidget {
  final SharedPreferences sharedPreferences;
  final List<Transaction> initialTransactions;

  const FinTrackApp({
    super.key,
    required this.sharedPreferences,
    required this.initialTransactions,
  });

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<TransactionRepository>(
      create: (_) => LocalTransactionRepository(
        localDataSource: SharedPrefsTransactionLocalDataSource(
          sharedPreferences,
        ),
        initialTransactions: initialTransactions.isNotEmpty
            ? initialTransactions
            : [
                Transaction(
                  id: '1',
                  type: TransactionType.income,
                  amount: 3500,
                  date: DateTime(2026, 4, 5),
                  description: 'Salário',
                  category: TransactionCategories.salary,
                ),
                Transaction(
                  id: '2',
                  type: TransactionType.expense,
                  amount: 82.50,
                  date: DateTime(2026, 4, 6),
                  description: 'Supermercado',
                  category: TransactionCategories.food,
                ),
                Transaction(
                  id: '3',
                  type: TransactionType.expense,
                  amount: 18.00,
                  date: DateTime(2026, 4, 7),
                  description: 'Transporte',
                  category: TransactionCategories.transport,
                ),
              ],
      ),
      child: BlocProvider<AuthSessionBloc>(
        create: (_) => AuthSessionBloc(),
        child: MaterialApp(
          title: 'FinTrack',
          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
          themeMode: ThemeMode.system,
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
