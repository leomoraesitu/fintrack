import 'package:fintrack/features/transactions/domain/entities/transaction.dart';
import 'package:fintrack/features/transactions/domain/entities/transaction_categories.dart';
import 'package:fintrack/features/transactions/domain/entities/transaction_category.dart';
import 'package:fintrack/features/transactions/domain/entities/transaction_category_catalog.dart';
import 'package:fintrack/features/transactions/domain/entities/transaction_type.dart';
import 'package:fintrack/features/transactions/domain/exceptions/transaction_conflict_exception.dart';
import 'package:fintrack/features/transactions/domain/repositories/transaction_category_repository.dart';
import 'package:fintrack/features/transactions/domain/repositories/transaction_repository.dart';
import 'package:fintrack/features/transactions/presentation/cubit/transaction_category_catalog_cubit.dart';
import 'package:fintrack/features/transactions/presentation/pages/transaction_form_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('recarrega a versao remota da transacao apos conflito', (
    tester,
  ) async {
    final staleTransaction = _transaction(
      id: 'tx-1',
      description: 'Mercado antigo',
      amount: 82.5,
      updatedAt: DateTime(2026, 4, 8, 10),
    );
    final latestTransaction = _transaction(
      id: 'tx-1',
      description: 'Mercado atualizado',
      amount: 91.3,
      updatedAt: DateTime(2026, 4, 8, 11),
    );
    final repository = _ConflictThenReloadRepository(latestTransaction);

    await tester.pumpWidget(
      MaterialApp(
        home: RepositoryProvider<TransactionRepository>.value(
          value: repository,
          child: TransactionFormPage(transaction: staleTransaction),
        ),
      ),
    );

    await tester.ensureVisible(find.text('Salvar alterações'));
    await tester.enterText(find.byType(TextFormField).first, 'Minha edição local');
    await tester.tap(find.text('Salvar alterações'));
    await tester.pumpAndSettle();

    expect(find.text('Conflito detectado'), findsOneWidget);
    expect(find.text('Recarregar dados'), findsOneWidget);

    await tester.ensureVisible(find.text('Recarregar dados'));
    await tester.tap(find.text('Recarregar dados'));
    await tester.pumpAndSettle();

    expect(find.text('Versão mais recente carregada. Revise os dados antes de salvar novamente.'), findsOneWidget);
    expect(find.text('Versão remota'), findsNWidgets(2));
    expect(find.text('Descrição:'), findsOneWidget);
    expect(find.text('Mercado atualizado'), findsNWidgets(2));
    expect(find.text('Valor:'), findsOneWidget);
    expect(find.text('91,30'), findsNWidgets(2));
    expect(find.text('Reaplicar minha edição'), findsOneWidget);

    await tester.tap(find.text('Reaplicar minha edição'));
    await tester.pumpAndSettle();

    expect(find.text('Sua edição local foi reaplicada sobre a versão mais recente. Revise os dados antes de salvar.'), findsOneWidget);
    expect(find.text('Local reaplicado'), findsNWidgets(2));
    expect(find.text('Versão remota'), findsNothing);
    expect(find.text('Minha edição local'), findsNWidgets(2));

    await tester.ensureVisible(find.text('Salvar alterações'));
    await tester.tap(find.text('Salvar alterações'));
    await tester.pumpAndSettle();

    expect(repository.receivedUpdatedAts, [
      DateTime(2026, 4, 8, 10),
      DateTime(2026, 4, 8, 11),
    ]);
    expect(repository.receivedDescriptions, [
      'Minha edição local',
      'Minha edição local',
    ]);
  });

  testWidgets('oferece fechar tela quando a transacao nao existe mais no backend', (
    tester,
  ) async {
    final staleTransaction = _transaction(
      id: 'tx-1',
      description: 'Mercado antigo',
      amount: 82.5,
      updatedAt: DateTime(2026, 4, 8, 10),
    );
    final repository = _ConflictThenDeleteRepository();

    await tester.pumpWidget(
      MaterialApp(
        home: _TransactionFormTestHost(
          repository: repository,
          transaction: staleTransaction,
        ),
      ),
    );

    await tester.tap(find.text('Abrir formulario'));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Salvar alterações'));
    await tester.tap(find.text('Salvar alterações'));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Recarregar dados'));
    await tester.tap(find.text('Recarregar dados'));
    await tester.pumpAndSettle();

    expect(find.text('Fechar tela'), findsOneWidget);

    await tester.tap(find.text('Fechar tela'));
    await tester.pumpAndSettle();

    expect(find.text('Abrir formulario'), findsOneWidget);
    expect(find.text('Editar transação'), findsNothing);
  });

  testWidgets('permite criar categoria inline e seleciona-la no formulario', (
    tester,
  ) async {
    final categoryRepository = _InMemoryTransactionCategoryRepository();

    await tester.pumpWidget(
      MaterialApp(
        home: RepositoryProvider<TransactionRepository>.value(
          value: _NoopTransactionRepository(),
          child: BlocProvider(
            create: (_) =>
                TransactionCategoryCatalogCubit(
                  repository: categoryRepository,
                  canManage: true,
                )
                  ..load(),
            child: const TransactionFormPage(),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Nova categoria de despesa'), findsOneWidget);

    await tester.ensureVisible(find.text('Nova categoria de despesa'));
    await tester.tap(find.text('Nova categoria de despesa'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).last, 'Viagem');
    await tester.tap(find.text('Salvar'));
    await tester.pumpAndSettle();

    expect(find.text('Viagem'), findsOneWidget);
    expect(categoryRepository.addedLabels, ['Viagem']);
  });
}

Transaction _transaction({
  required String id,
  required String description,
  required double amount,
  required DateTime updatedAt,
}) {
  return Transaction(
    id: id,
    type: TransactionType.expense,
    amount: amount,
    date: DateTime(2026, 4, 6),
    description: description,
    category: TransactionCategories.food,
    updatedAt: updatedAt,
  );
}

class _ConflictThenReloadRepository implements TransactionRepository {
  _ConflictThenReloadRepository(this.latestTransaction);

  final Transaction latestTransaction;
  final List<DateTime?> receivedUpdatedAts = [];
  final List<String> receivedDescriptions = [];
  var _shouldConflict = true;

  @override
  Future<void> addTransaction(Transaction transaction) async {}

  @override
  Future<void> deleteTransaction(String id) async {}

  @override
  Future<List<Transaction>> getTransactions() async => [latestTransaction];

  @override
  Future<void> updateTransaction(Transaction transaction) async {
    receivedUpdatedAts.add(transaction.updatedAt);
    receivedDescriptions.add(transaction.description);

    if (_shouldConflict) {
      _shouldConflict = false;
      throw const TransactionConflictException();
    }
  }

  @override
  Stream<List<Transaction>> watchTransactions() {
    return const Stream<List<Transaction>>.empty();
  }
}

class _ConflictThenDeleteRepository implements TransactionRepository {
  final List<DateTime?> receivedUpdatedAts = [];
  var _shouldConflict = true;

  @override
  Future<void> addTransaction(Transaction transaction) async {}

  @override
  Future<void> deleteTransaction(String id) async {}

  @override
  Future<List<Transaction>> getTransactions() async => [];

  @override
  Future<void> updateTransaction(Transaction transaction) async {
    receivedUpdatedAts.add(transaction.updatedAt);

    if (_shouldConflict) {
      _shouldConflict = false;
      throw const TransactionConflictException();
    }
  }

  @override
  Stream<List<Transaction>> watchTransactions() {
    return const Stream<List<Transaction>>.empty();
  }
}

class _TransactionFormTestHost extends StatelessWidget {
  const _TransactionFormTestHost({
    required this.repository,
    required this.transaction,
  });

  final TransactionRepository repository;
  final Transaction transaction;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => RepositoryProvider<TransactionRepository>.value(
                  value: repository,
                  child: TransactionFormPage(transaction: transaction),
                ),
              ),
            );
          },
          child: const Text('Abrir formulario'),
        ),
      ),
    );
  }
}

class _NoopTransactionRepository implements TransactionRepository {
  @override
  Future<void> addTransaction(Transaction transaction) async {}

  @override
  Future<void> deleteTransaction(String id) async {}

  @override
  Future<List<Transaction>> getTransactions() async => [];

  @override
  Future<void> updateTransaction(Transaction transaction) async {}

  @override
  Stream<List<Transaction>> watchTransactions() {
    return const Stream<List<Transaction>>.empty();
  }
}

class _InMemoryTransactionCategoryRepository
    implements TransactionCategoryRepository {
  final List<String> addedLabels = [];
  final List<TransactionCategory> _categories = [
    ...TransactionCategoryCatalog.fallback.all,
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
    addedLabels.add(label);
    final category = TransactionCategory(
      id: label.toLowerCase(),
      label: label,
      type: type,
    );
    _categories.add(category);
    return category;
  }
}