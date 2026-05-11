import 'package:cloud_firestore/cloud_firestore.dart' hide Transaction;
import 'package:fintrack/app/theme/app_theme.dart';
import 'package:fintrack/features/auth/presentation/bloc/auth_session_bloc.dart';
import 'package:fintrack/features/auth/presentation/bloc/auth_session_event.dart';
import 'package:fintrack/features/auth/presentation/bloc/auth_session_state.dart';
import 'package:fintrack/features/auth/presentation/pages/login_page.dart';
import 'package:fintrack/features/shell/presentation/pages/shell_page.dart';
import 'package:fintrack/features/transactions/data/datasources/firestore_transaction_remote_data_source.dart';
import 'package:fintrack/features/transactions/data/datasources/firestore_transaction_category_remote_data_source.dart';
import 'package:fintrack/features/transactions/data/datasources/shared_prefs_transaction_local_data_source.dart';
import 'package:fintrack/features/transactions/data/datasources/transaction_category_remote_data_source.dart';
import 'package:fintrack/features/transactions/data/datasources/transaction_local_data_source.dart';
import 'package:fintrack/features/transactions/data/datasources/transaction_remote_data_source.dart';
import 'package:fintrack/features/transactions/data/repositories/firebase_transaction_category_repository.dart';
import 'package:fintrack/features/transactions/data/repositories/firebase_transaction_repository.dart';
import 'package:fintrack/features/transactions/data/repositories/local_transaction_category_repository.dart';
import 'package:fintrack/features/transactions/data/services/remote_transaction_category_catalog_service.dart';
import 'package:fintrack/features/transactions/data/repositories/local_transaction_repository.dart';
import 'package:fintrack/features/transactions/data/services/local_transaction_migration_service.dart';
import 'package:fintrack/features/transactions/domain/entities/transaction.dart';
import 'package:fintrack/features/transactions/domain/entities/transaction_categories.dart';
import 'package:fintrack/features/transactions/domain/repositories/transaction_category_repository.dart';
import 'package:fintrack/features/transactions/presentation/cubit/transaction_category_catalog_cubit.dart';
import 'package:fintrack/features/transactions/domain/entities/transaction_type.dart';
import 'package:fintrack/features/transactions/domain/repositories/transaction_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fintrack/features/auth/data/repositories/firebase_auth_repository.dart';
import 'package:fintrack/features/auth/domain/repositories/auth_repository.dart';

class FinTrackApp extends StatelessWidget {
  final SharedPreferences sharedPreferences;
  final List<Transaction> initialTransactions;
  final AuthRepository? authRepository;
  final TransactionRemoteDataSource? remoteDataSource;
  final TransactionCategoryRemoteDataSource? categoryRemoteDataSource;

  const FinTrackApp({
    super.key,
    required this.sharedPreferences,
    required this.initialTransactions,
    this.authRepository,
    this.remoteDataSource,
    this.categoryRemoteDataSource,
  });

  @override
  Widget build(BuildContext context) {
    final localDataSource = SharedPrefsTransactionLocalDataSource(
      sharedPreferences,
    );

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>(
          create: (_) =>
              authRepository ?? FirebaseAuthRepository(FirebaseAuth.instance),
        ),
        RepositoryProvider<TransactionLocalDataSource>.value(
          value: localDataSource,
        ),
        RepositoryProvider<TransactionRepository>(
          create: (_) => LocalTransactionRepository(
            localDataSource: localDataSource,
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
        ),
            RepositoryProvider<TransactionCategoryRepository>(
              create: (_) => const LocalTransactionCategoryRepository(),
            ),
      ],
          child: MultiBlocProvider(
            providers: [
              BlocProvider<AuthSessionBloc>(
                create: (context) =>
                    AuthSessionBloc(context.read<AuthRepository>())
                      ..add(const AuthSessionStarted()),
          ),
              BlocProvider<TransactionCategoryCatalogCubit>(
                create: (context) =>
                    TransactionCategoryCatalogCubit(
                      repository: context.read<TransactionCategoryRepository>(),
                      canManage: false,
                    )
                      ..load(),
              ),
            ],
            child: MaterialApp(
              title: 'FinTrack',
              theme: AppTheme.light(),
              darkTheme: AppTheme.dark(),
              themeMode: ThemeMode.system,
              home: _AppEntryPage(
                remoteDataSource: remoteDataSource,
                categoryRemoteDataSource: categoryRemoteDataSource,
              ),
        ),
      ),
    );
  }
}

class _AppEntryPage extends StatelessWidget {
  const _AppEntryPage({this.remoteDataSource, this.categoryRemoteDataSource});

  final TransactionRemoteDataSource? remoteDataSource;
  final TransactionCategoryRemoteDataSource? categoryRemoteDataSource;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthSessionBloc, AuthSessionState>(
      builder: (context, state) {
        if (state is AuthSessionAuthenticated) {
          return _AuthenticatedShell(
            state: state,
            remoteDataSource: remoteDataSource,
            categoryRemoteDataSource: categoryRemoteDataSource,
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

class _AuthenticatedShell extends StatelessWidget {
  const _AuthenticatedShell({
    required this.state,
    this.remoteDataSource,
    this.categoryRemoteDataSource,
  });

  final AuthSessionAuthenticated state;
  final TransactionRemoteDataSource? remoteDataSource;
  final TransactionCategoryRemoteDataSource? categoryRemoteDataSource;

  @override
  Widget build(BuildContext context) {
    final shellPage = ShellPage(
      onLogout: () {
        context.read<AuthSessionBloc>().add(const AuthSessionLoggedOut());
      },
    );

    final user = state.user;
    if (state.isDemo || user == null) {
      return shellPage;
    }

    return _RemoteTransactionsScope(
      userId: user.id,
      remoteDataSource:
          remoteDataSource ??
          FirestoreTransactionRemoteDataSource(FirebaseFirestore.instance),
      categoryRemoteDataSource:
          categoryRemoteDataSource ??
          FirestoreTransactionCategoryRemoteDataSource(FirebaseFirestore.instance),
      child: shellPage,
    );
  }
}

class _RemoteTransactionsScope extends StatefulWidget {
  const _RemoteTransactionsScope({
    required this.userId,
    required this.remoteDataSource,
    required this.categoryRemoteDataSource,
    required this.child,
  });

  final String userId;
  final TransactionRemoteDataSource remoteDataSource;
  final TransactionCategoryRemoteDataSource categoryRemoteDataSource;
  final Widget child;

  @override
  State<_RemoteTransactionsScope> createState() =>
      _RemoteTransactionsScopeState();
}

class _RemoteTransactionsScopeState extends State<_RemoteTransactionsScope> {
  late Future<void> _migrationFuture;

  @override
  void initState() {
    super.initState();
    _migrationFuture = _migrate();
  }

  @override
  void didUpdateWidget(covariant _RemoteTransactionsScope oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.userId != widget.userId ||
        oldWidget.remoteDataSource != widget.remoteDataSource) {
      _migrationFuture = _migrate();
    }
  }

  Future<void> _migrate() async {
    await LocalTransactionMigrationService(
      localDataSource: context.read<TransactionLocalDataSource>(),
      remoteDataSource: widget.remoteDataSource,
    ).migrate(userId: widget.userId);

    await RemoteTransactionCategoryCatalogService(
      remoteDataSource: widget.categoryRemoteDataSource,
    ).syncAndLoad(userId: widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _migrationFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        return MultiRepositoryProvider(
          providers: [
            RepositoryProvider<TransactionRepository>(
              create: (_) => FirebaseTransactionRepository(
                remoteDataSource: widget.remoteDataSource,
                userId: widget.userId,
              ),
            ),
            RepositoryProvider<TransactionCategoryRepository>(
              create: (_) => FirebaseTransactionCategoryRepository(
                remoteDataSource: widget.categoryRemoteDataSource,
                userId: widget.userId,
              ),
            ),
          ],
          child: BlocProvider<TransactionCategoryCatalogCubit>(
            create: (context) =>
                TransactionCategoryCatalogCubit(
                  repository: context.read<TransactionCategoryRepository>(),
                  canManage: true,
                )
                  ..load(),
            child: widget.child,
          ),
        );
      },
    );
  }
}
