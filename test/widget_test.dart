import 'dart:async';
import 'dart:convert';

import 'package:fintrack/features/auth/domain/entities/auth_user.dart';
import 'package:fintrack/features/auth/domain/repositories/auth_repository.dart';
import 'package:fintrack/features/transactions/data/datasources/transaction_remote_data_source.dart';
import 'package:fintrack/features/transactions/data/datasources/transaction_category_remote_data_source.dart';
import 'package:fintrack/features/transactions/domain/entities/transaction.dart';
import 'package:fintrack/features/transactions/domain/entities/transaction_categories.dart';
import 'package:fintrack/features/transactions/domain/entities/transaction_category.dart';
import 'package:fintrack/features/transactions/domain/entities/transaction_category_catalog.dart';
import 'package:fintrack/features/transactions/domain/entities/transaction_type.dart';
import 'package:fintrack/features/transactions/domain/repositories/transaction_category_repository.dart';
import 'package:fintrack/features/transactions/domain/repositories/transaction_repository.dart';
import 'package:fintrack/features/transactions/presentation/cubit/transaction_category_catalog_cubit.dart';
import 'package:fintrack/features/transactions/presentation/bloc/transaction_list_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:fintrack/app/app.dart';
import 'package:fintrack/features/transactions/presentation/bloc/transaction_list_bloc.dart';
import 'package:fintrack/features/transactions/presentation/pages/transactions_page.dart';
import 'package:fintrack/features/transactions/data/datasources/shared_prefs_transaction_local_data_source.dart';
import 'package:fintrack/features/transactions/data/models/transaction_storage_mapper.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<FinTrackApp> _buildTestApp({
  Map<String, Object> mockInitialValues = const {},
  AuthRepository? authRepository,
  TransactionRemoteDataSource? remoteDataSource,
  TransactionCategoryRemoteDataSource? categoryRemoteDataSource,
}) async {
  SharedPreferences.setMockInitialValues(mockInitialValues);
  final sharedPreferences = await SharedPreferences.getInstance();
  final localDataSource = SharedPrefsTransactionLocalDataSource(
    sharedPreferences,
  );
  final storedTransactions = await localDataSource.loadTransactions();
  final initialTransactions = storedTransactions
      .map(TransactionStorageMapper.fromMap)
      .toList();

  return FinTrackApp(
    sharedPreferences: sharedPreferences,
    initialTransactions: initialTransactions,
    authRepository: authRepository ?? FakeAuthRepository(),
    remoteDataSource: remoteDataSource,
    categoryRemoteDataSource: categoryRemoteDataSource,
  );
}

class FakeAuthRepository implements AuthRepository {
  @override
  Stream<AuthUser?> authStateChanges() {
    return const Stream<AuthUser?>.empty();
  }

  @override
  Future<AuthUser> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    return AuthUser(id: 'user-id', email: email);
  }

  @override
  Future<AuthUser> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    return AuthUser(id: 'user-id', email: email);
  }

  @override
  Future<void> signOut() async {}
}

class StreamAuthRepository implements AuthRepository {
  const StreamAuthRepository(this._authStateChanges);

  final Stream<AuthUser?> _authStateChanges;

  @override
  Stream<AuthUser?> authStateChanges() {
    return _authStateChanges;
  }

  @override
  Future<AuthUser> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    return AuthUser(id: 'user-id', email: email);
  }

  @override
  Future<AuthUser> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    return AuthUser(id: 'user-id', email: email);
  }

  @override
  Future<void> signOut() async {}
}

class DummyTransactionRepository implements TransactionRepository {
  @override
  Future<List<Transaction>> getTransactions() async => [];

  @override
  Stream<List<Transaction>> watchTransactions() {
    return Stream.value([]);
  }

  @override
  Future<void> addTransaction(Transaction transaction) async {}

  @override
  Future<void> updateTransaction(Transaction transaction) async {}

  @override
  Future<void> deleteTransaction(String id) async {}
}

class FakeBloc extends TransactionListBloc {
  FakeBloc() : super(repository: DummyTransactionRepository());
}

class InMemoryTransactionCategoryRepository
    implements TransactionCategoryRepository {
  final List<TransactionCategory> _categories = [
    TransactionCategories.food,
    TransactionCategories.salary,
  ];

  @override
  Future<TransactionCategoryCatalog> getCategoryCatalog() async {
    return TransactionCategoryCatalog(List.unmodifiable(_categories));
  }

  @override
  Future<TransactionCategory> addCategory({
    required String label,
    required TransactionType type,
  }) async {
    final category = TransactionCategory(
      id: label.toLowerCase(),
      label: label,
      type: type,
    );
    _categories.add(category);
    return category;
  }
}

class FakeTransactionRemoteDataSource implements TransactionRemoteDataSource {
  final List<SavedTransaction> savedTransactions = [];

  @override
  Future<List<TransactionRemoteDocument>> loadTransactions({
    required String userId,
  }) async {
    return [];
  }

  @override
  Stream<List<TransactionRemoteDocument>> watchTransactions({
    required String userId,
  }) {
    return Stream.value([]);
  }

  @override
  Future<void> saveTransaction({
    required String userId,
    required String transactionId,
    required Map<String, dynamic> data,
    DateTime? expectedUpdatedAt,
  }) async {
    savedTransactions.add(
      SavedTransaction(
        userId: userId,
        transactionId: transactionId,
        data: data,
      ),
    );
  }

  @override
  Future<void> deleteTransaction({
    required String userId,
    required String transactionId,
  }) async {}
}

class FakeTransactionCategoryRemoteDataSource
    implements TransactionCategoryRemoteDataSource {
  final List<SavedCategory> savedCategories = [];
  final List<TransactionCategoryRemoteDocument> documents;

  FakeTransactionCategoryRemoteDataSource({this.documents = const []});

  @override
  Future<List<TransactionCategoryRemoteDocument>> loadCategories({
    required String userId,
  }) async {
    return documents;
  }

  @override
  Future<void> saveCategory({
    required String userId,
    required String categoryId,
    required Map<String, dynamic> data,
  }) async {
    savedCategories.add(
      SavedCategory(userId: userId, categoryId: categoryId, data: data),
    );
  }
}

class SavedCategory {
  const SavedCategory({
    required this.userId,
    required this.categoryId,
    required this.data,
  });

  final String userId;
  final String categoryId;
  final Map<String, dynamic> data;
}

class SavedTransaction {
  const SavedTransaction({
    required this.userId,
    required this.transactionId,
    required this.data,
  });

  final String userId;
  final String transactionId;
  final Map<String, dynamic> data;
}

Transaction _transaction({required String id, required String description}) {
  return Transaction(
    id: id,
    type: TransactionType.expense,
    amount: 120,
    date: DateTime(2026, 4, 8),
    description: description,
    category: TransactionCategories.health,
  );
}

Future<void> _enterDemoMode(WidgetTester tester, {bool settle = true}) async {
  await tester.ensureVisible(find.text('Entrar no modo demo'));
  await tester.tap(find.text('Entrar no modo demo'));

  if (settle) {
    await tester.pumpAndSettle();
  }
}

Future<void> _openFilters(WidgetTester tester) async {
  await tester.ensureVisible(find.text('Filtros'));
  await tester.tap(find.text('Filtros'));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets(
    'migra transacoes locais para Firestore quando usuario real autentica',
    (WidgetTester tester) async {
      final localTransaction = _transaction(
        id: 'local-transaction',
        description: 'Consulta',
      );
      final remoteDataSource = FakeTransactionRemoteDataSource();
      final categoryRemoteDataSource = FakeTransactionCategoryRemoteDataSource();

      await tester.pumpWidget(
        await _buildTestApp(
          mockInitialValues: {
            'transactions': jsonEncode([
              TransactionStorageMapper.toMap(localTransaction),
            ]),
          },
          authRepository: StreamAuthRepository(
            Stream.value(const AuthUser(id: 'user-1', email: 'user@test.com')),
          ),
          remoteDataSource: remoteDataSource,
          categoryRemoteDataSource: categoryRemoteDataSource,
        ),
      );
      await tester.pump();
      await tester.pump();

      expect(remoteDataSource.savedTransactions, hasLength(1));
      expect(
        categoryRemoteDataSource.savedCategories,
        hasLength(TransactionCategoryCatalog.fallback.all.length),
      );
      expect(
        remoteDataSource.savedTransactions.single.transactionId,
        'local-transaction',
      );
      expect(remoteDataSource.savedTransactions.single.userId, 'user-1');
    },
  );

  testWidgets(
    'deve iniciar na login page, criar uma transacao no modo demo e voltar para a login page ao sair',
    (WidgetTester tester) async {
      await tester.pumpWidget(await _buildTestApp());

      expect(find.text('Bem-vindo'), findsOneWidget);
      expect(find.text('Entrar no modo demo'), findsOneWidget);
      expect(find.textContaining('Ambiente de demonstra'), findsOneWidget);

      await _enterDemoMode(tester);

      expect(find.text('FinTrack'), findsOneWidget);
      expect(find.text('Início'), findsOneWidget);
      expect(find.text('Extrato'), findsOneWidget);
      expect(find.text('SALDO TOTAL'), findsOneWidget);
      expect(find.text('RECEITAS'), findsOneWidget);
      expect(find.text('DESPESAS'), findsOneWidget);

      expect(find.text('R\$ 3.399,50'), findsOneWidget);
      expect(find.text('+ R\$ 3.500,00'), findsWidgets);
      expect(find.text('- R\$ 100,50'), findsOneWidget);

      expect(find.text('Transações recentes'), findsOneWidget);

      expect(find.text('- R\$ 18,00'), findsOneWidget);
      expect(find.text('Supermercado'), findsOneWidget);
      expect(find.text('+ R\$ 3.500,00'), findsWidgets);
      expect(find.byIcon(Icons.add), findsOneWidget);
      expect(find.byIcon(Icons.logout), findsOneWidget);

      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      expect(find.text('Nova transação'), findsOneWidget);

      await tester.enterText(find.byType(TextField).at(0), '45,90');
      await tester.enterText(find.byType(TextFormField).at(0), 'Farmacia');

      await tester.ensureVisible(find.text('Saúde').last);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Saúde').last);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Salvar transação'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Extrato'));
      await tester.pumpAndSettle();

      expect(find.text('Farmacia'), findsOneWidget);
      expect(find.textContaining('Saúde •'), findsOneWidget);

      await tester.scrollUntilVisible(
        find.text('+ R\$ 3.500,00'),
        200,
        scrollable: find.byType(Scrollable).last,
      );
      await tester.pumpAndSettle();

      expect(find.text('+ R\$ 3.500,00'), findsOneWidget);
      expect(find.text('Supermercado'), findsOneWidget);
      expect(find.text('- R\$ 18,00'), findsOneWidget);

      await tester.tap(find.byTooltip('Sair'));
      await tester.pumpAndSettle();

      expect(find.text('Bem-vindo'), findsOneWidget);
      expect(find.text('Entrar no modo demo'), findsOneWidget);
    },
  );

  testWidgets('deve editar e excluir uma transacao existente no modo demo', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(await _buildTestApp());

    expect(find.text('Bem-vindo'), findsOneWidget);
    expect(find.text('Entrar no modo demo'), findsOneWidget);

    await _enterDemoMode(tester);

    await tester.tap(find.text('Extrato'));
    await tester.pumpAndSettle();

    expect(find.text('Supermercado'), findsOneWidget);

    await tester.tap(find.text('Supermercado'));
    await tester.pumpAndSettle();

    expect(find.text('Editar transação'), findsOneWidget);
    expect(find.text('Salvar alterações'), findsOneWidget);

    expect(find.text('Alimentação'), findsOneWidget);

    await tester.enterText(
      find.byType(TextFormField).at(0),
      'Mercado do bairro',
    );
    await tester.ensureVisible(find.text('Salvar alterações'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Salvar alterações'));
    for (var i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }

    expect(find.text('Mercado do bairro'), findsOneWidget);
    expect(find.text('Supermercado'), findsNothing);

    await tester.tap(find.text('Mercado do bairro'));
    await tester.pumpAndSettle();

    expect(find.text('Editar transação'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.delete));
    await tester.pumpAndSettle();

    expect(find.text('Excluir transação?'), findsOneWidget);

    await tester.tap(find.text('Excluir'));
    await tester.pumpAndSettle();

    expect(find.text('Mercado do bairro'), findsNothing);
    expect(find.text('+ R\$ 3.500,00'), findsOneWidget);
    expect(find.text('- R\$ 18,00'), findsOneWidget);
  });

  testWidgets(
    'deve limpar categoria incompatível ao trocar o tipo da transação',
    (WidgetTester tester) async {
      await tester.pumpWidget(await _buildTestApp());

      await _enterDemoMode(tester);

      await tester.tap(find.text('Extrato'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Supermercado'));
      await tester.pumpAndSettle();

      expect(find.text('Editar transação'), findsOneWidget);
      expect(find.text('Alimentação'), findsOneWidget);

      await tester.tap(find.text('Receita'));
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.text('Salvar alterações'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Salvar alterações'));
      await tester.pumpAndSettle();

      expect(find.text('Selecione a categoria.'), findsOneWidget);
      expect(find.text('Editar transação'), findsOneWidget);
    },
  );

  testWidgets(
    'deve editar a categoria de uma transacao existente e refletir a alteracao na lista',
    (WidgetTester tester) async {
      await tester.pumpWidget(await _buildTestApp());

      await _enterDemoMode(tester);

      await tester.tap(find.text('Extrato'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Supermercado'));
      await tester.pumpAndSettle();

      expect(find.text('Editar transação'), findsOneWidget);
      expect(find.text('Alimentação'), findsOneWidget);

      await tester.tap(find.text('Alimentação'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Saúde').last);
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.text('Salvar alterações'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Salvar alterações'));
      await tester.pumpAndSettle();

      expect(find.text('Supermercado'), findsOneWidget);
      expect(find.textContaining('Saúde •'), findsOneWidget);
    },
  );

  testWidgets('deve abrir a aba de extrato pela navegacao inferior', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(await _buildTestApp());

    await _enterDemoMode(tester);

    expect(find.text('SALDO TOTAL'), findsOneWidget);
    expect(find.text('Extrato'), findsOneWidget);

    await tester.tap(find.text('Extrato'));
    await tester.pumpAndSettle();

    expect(find.text('Extrato'), findsOneWidget);
    expect(find.text('+ R\$ 3.500,00'), findsOneWidget);
    expect(find.text('Supermercado'), findsOneWidget);
    expect(find.text('- R\$ 18,00'), findsOneWidget);
  });

  testWidgets(
    'deve manter uma transacao criada ao reiniciar o app com o mesmo storage',
    (WidgetTester tester) async {
      await tester.pumpWidget(await _buildTestApp());

      await _enterDemoMode(tester);

      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField).at(0), '120,00');
      await tester.enterText(find.byType(TextFormField).at(0), 'Consulta');

      await tester.ensureVisible(find.text('Saúde').last);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Saúde').last);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Salvar transação'));
      await tester.pumpAndSettle();

      expect(find.text('Consulta'), findsOneWidget);

      final savedTransactions = (await SharedPreferences.getInstance())
          .getString('transactions');

      expect(savedTransactions, isNotNull);

      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpAndSettle();

      await tester.pumpWidget(
        await _buildTestApp(
          mockInitialValues: {'transactions': savedTransactions!},
        ),
      );
      await tester.pumpAndSettle();

      await _enterDemoMode(tester);

      await tester.tap(find.text('Extrato'));
      await tester.pumpAndSettle();

      expect(find.text('Consulta'), findsOneWidget);
      expect(find.textContaining('Saúde •'), findsOneWidget);
    },
  );

  testWidgets('deve filtrar a lista de transações por tipo', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(await _buildTestApp());

    await _enterDemoMode(tester);

    await tester.tap(find.text('Extrato'));
    await tester.pumpAndSettle();

    expect(find.text('+ R\$ 3.500,00'), findsOneWidget);
    expect(find.text('Supermercado'), findsOneWidget);
    expect(find.text('- R\$ 18,00'), findsOneWidget);

    // Abrir o bottom sheet de filtros
    await _openFilters(tester);

    // Selecionar Receitas
    await tester.tap(find.text('Receitas'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Aplicar filtros'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Aplicar filtros'));
    await tester.pumpAndSettle();

    expect(find.text('+ R\$ 3.500,00'), findsOneWidget);
    expect(find.text('Supermercado'), findsNothing);
    expect(find.text('- R\$ 18,00'), findsNothing);

    // Abrir o bottom sheet de filtros novamente
    await _openFilters(tester);

    // Selecionar Despesas
    await tester.tap(find.text('Despesas'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Aplicar filtros'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Aplicar filtros'));
    await tester.pumpAndSettle();

    expect(find.text('+ R\$ 3.500,00'), findsNothing);
    expect(find.text('Supermercado'), findsOneWidget);
    expect(find.text('- R\$ 18,00'), findsOneWidget);

    // Abrir o bottom sheet de filtros novamente
    await _openFilters(tester);

    // Selecionar Todas
    await tester.tap(find.text('Todas'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Aplicar filtros'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Aplicar filtros'));
    await tester.pumpAndSettle();

    expect(find.text('+ R\$ 3.500,00'), findsOneWidget);
    expect(find.text('Supermercado'), findsOneWidget);
    expect(find.text('- R\$ 18,00'), findsOneWidget);
  });

  testWidgets(
    'deve filtrar por categoria e limpar categoria incompatível ao trocar o tipo',
    (WidgetTester tester) async {
      await tester.pumpWidget(await _buildTestApp());

      await _enterDemoMode(tester);

      await tester.tap(find.text('Extrato'));
      await tester.pumpAndSettle();

      // Abrir o bottom sheet de filtros
      await _openFilters(tester);

      // Selecionar categoria "Alimentação"
      await tester.tap(find.text('Alimentação'));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('Aplicar filtros'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Aplicar filtros'));
      await tester.pumpAndSettle();

      expect(find.text('Supermercado'), findsOneWidget);
      expect(find.text('+ R\$ 3.500,00'), findsNothing);
      expect(find.text('- R\$ 18,00'), findsNothing);

      // Abrir o bottom sheet de filtros novamente
      await _openFilters(tester);

      // Selecionar Receitas (tipo incompatível com categoria Alimentação)
      await tester.tap(find.text('Receitas'));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('Aplicar filtros'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Aplicar filtros'));
      await tester.pumpAndSettle();

      expect(find.text('+ R\$ 3.500,00'), findsOneWidget);
      expect(find.text('Supermercado'), findsNothing);
      expect(find.text('- R\$ 18,00'), findsNothing);

      // Categoria deve ser limpa
      await _openFilters(tester);
      expect(find.text('Todas as categorias'), findsOneWidget);
    },
  );

  testWidgets('deve filtrar a lista por período', (WidgetTester tester) async {
    await tester.pumpWidget(await _buildTestApp());

    await _enterDemoMode(tester);

    await tester.tap(find.text('Extrato'));
    await tester.pumpAndSettle();

    expect(find.text('+ R\$ 3.500,00'), findsOneWidget);
    expect(find.text('Supermercado'), findsOneWidget);
    expect(find.text('- R\$ 18,00'), findsOneWidget);

    // Abrir o bottom sheet de filtros
    await _openFilters(tester);

    // Selecionar "Todo o período"
    await tester.ensureVisible(find.text('Todo o período'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Todo o período'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Aplicar filtros'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Aplicar filtros'));
    await tester.pumpAndSettle();

    expect(find.text('+ R\$ 3.500,00'), findsOneWidget);
    expect(find.text('Supermercado'), findsOneWidget);
    expect(find.text('- R\$ 18,00'), findsOneWidget);
  });

  testWidgets(
    'deve abrir o bottom sheet de filtros e aplicar filtro por tipo',
    (WidgetTester tester) async {
      await tester.pumpWidget(await _buildTestApp());

      await _enterDemoMode(tester);

      await tester.tap(find.text('Extrato'));
      await tester.pumpAndSettle();

      expect(find.text('+ R\$ 3.500,00'), findsOneWidget);
      expect(find.text('Supermercado'), findsOneWidget);
      expect(find.text('- R\$ 18,00'), findsOneWidget);

      await _openFilters(tester);

      expect(find.text('Aplicar filtros'), findsOneWidget);
      expect(find.text('TIPO'), findsOneWidget);
      expect(find.text('CATEGORIA'), findsOneWidget);
      expect(find.text('PERÍODO'), findsOneWidget);

      await tester.tap(find.text('Receitas'));
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.text('Aplicar filtros'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Aplicar filtros'));
      await tester.pumpAndSettle();

      expect(find.text('+ R\$ 3.500,00'), findsOneWidget);
      expect(find.text('Supermercado'), findsNothing);
      expect(find.text('- R\$ 18,00'), findsNothing);
    },
  );

  testWidgets('deve limpar os filtros no bottom sheet antes de aplicar', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(await _buildTestApp());

    await _enterDemoMode(tester);

    await tester.tap(find.text('Extrato'));
    await tester.pumpAndSettle();

    await _openFilters(tester);

    await tester.tap(find.text('Receitas'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Este mês'));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Limpar'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Limpar'));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Aplicar filtros'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Aplicar filtros'));
    await tester.pumpAndSettle();

    expect(find.text('+ R\$ 3.500,00'), findsOneWidget);
    expect(find.text('Supermercado'), findsOneWidget);
    expect(find.text('- R\$ 18,00'), findsOneWidget);
  });

  testWidgets('deve alterar a ordenação da lista para mais antigas primeiro', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(await _buildTestApp());

    await _enterDemoMode(tester);

    await tester.tap(find.text('Extrato'));
    await tester.pumpAndSettle();

    final transporteAntes = tester.getTopLeft(find.text('Transporte')).dy;
    final salarioAntes = tester.getTopLeft(find.text('Salário')).dy;

    expect(transporteAntes, lessThan(salarioAntes));

    await tester.tap(find.text('Mais recentes'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Mais antigas').last);
    await tester.pumpAndSettle();

    final transporteDepois = tester.getTopLeft(find.text('Transporte')).dy;
    final salarioDepois = tester.getTopLeft(find.text('Salário')).dy;

    expect(salarioDepois, lessThan(transporteDepois));
    expect(find.text('Mais antigas'), findsOneWidget);
  });

  testWidgets(
    'mantem filtros, categorias e ordenacao na mesma linha em largura estreita',
    (WidgetTester tester) async {
      final bloc = FakeBloc();
      final categoryRepository = InMemoryTransactionCategoryRepository();

      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.binding.setSurfaceSize(const Size(360, 800));

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MultiBlocProvider(
              providers: [
                BlocProvider<TransactionListBloc>.value(value: bloc),
                BlocProvider(
                  create: (_) =>
                      TransactionCategoryCatalogCubit(
                        repository: categoryRepository,
                        canManage: true,
                      )
                        ..load(),
                ),
              ],
              child: const TransactionsView(),
            ),
          ),
        ),
      );
      bloc.emit(
        TransactionListSuccess(
          transactions: [_transaction(id: 'tx-1', description: 'Consulta')],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Filtros'), findsOneWidget);
      expect(find.text('Categorias'), findsOneWidget);
      expect(find.text('Recentes'), findsOneWidget);

      final filtrosY =
          tester.getCenter(find.byIcon(Icons.filter_alt_outlined)).dy;
      final categoriasY =
          tester.getCenter(find.byIcon(Icons.category_outlined)).dy;
      final ordenacaoY = tester.getCenter(find.byIcon(Icons.swap_vert)).dy;

      expect(categoriasY, closeTo(filtrosY, 1));
      expect(ordenacaoY, closeTo(filtrosY, 1));
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'exibe estado vazio na TransactionsPage quando não há transações',
    (WidgetTester tester) async {
      await tester.pumpWidget(await _buildTestApp());
      await _enterDemoMode(tester);

      await tester.tap(find.text('Extrato'));
      await tester.pumpAndSettle();

      await _openFilters(tester);

      await tester.ensureVisible(find.text('Outras despesas'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Outras despesas'));
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.text('Aplicar filtros'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Aplicar filtros'));
      await tester.pumpAndSettle();

      expect(find.text('Nenhuma transação encontrada'), findsOneWidget);
      expect(find.byIcon(Icons.inbox_outlined), findsOneWidget);
    },
  );

  testWidgets('exibe loading ao abrir TransactionsPage', (tester) async {
    await tester.pumpWidget(await _buildTestApp());
    await _enterDemoMode(tester, settle: false);
    await tester.pump();

    await tester.tap(find.text('Extrato'));
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsWidgets);
  });

  testWidgets('TransactionsPage exibe estado de erro isolado', (tester) async {
    final bloc = FakeBloc();

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<TransactionListBloc>.value(
          value: bloc,
          child: const TransactionsView(),
        ),
      ),
    );

    bloc.emit(
      const TransactionListError(message: 'Erro ao carregar transações'),
    );
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.error_outline), findsOneWidget);
    expect(find.text('Erro ao carregar transações'), findsOneWidget);
    expect(find.text('Tentar novamente'), findsOneWidget);
  });
}
