import 'package:fintrack/features/transactions/data/datasources/transaction_local_data_source.dart';
import 'package:fintrack/features/transactions/data/repositories/local_transaction_repository.dart';
import 'package:fintrack/features/transactions/domain/entities/transaction.dart';
import 'package:fintrack/features/transactions/domain/entities/transaction_categories.dart';
import 'package:fintrack/features/transactions/domain/entities/transaction_type.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:fintrack/features/transactions/data/datasources/shared_prefs_transaction_local_data_source.dart';
import 'package:fintrack/features/transactions/data/models/transaction_storage_mapper.dart';

void main() {
  test('atualiza transacao em memoria e emite mudanca local', () async {
    final repository = LocalTransactionRepository(
      localDataSource: _FakeTransactionLocalDataSource(),
      initialTransactions: [_transaction(id: 'transaction-1')],
    );

    final expectedEmission = expectLater(
      repository.watchTransactions(),
      emits(
        predicate<List<Transaction>>(
          (transactions) =>
              transactions.single.id == 'transaction-1' &&
              transactions.single.description == 'Mercado do bairro',
        ),
      ),
    );

    await repository.updateTransaction(
      _transaction(id: 'transaction-1', description: 'Mercado do bairro'),
    );

    final transactions = await repository.getTransactions();

    expect(transactions.single.description, 'Mercado do bairro');
    await expectedEmission;
  });

  test('ignora JSON corrompido no storage local', () async {
    SharedPreferences.setMockInitialValues({
      'transactions': '{json-invalido',
    });
    final sharedPreferences = await SharedPreferences.getInstance();
    final dataSource = SharedPrefsTransactionLocalDataSource(sharedPreferences);

    final transactions = await dataSource.loadTransactions();

    expect(transactions, isEmpty);
  });

  test('ignora item invalido ao reconstruir transacoes salvas', () {
    final valid = TransactionStorageMapper.toMap(_transaction(id: 'valid-1'));
    final invalid = <String, dynamic>{
      'id': 'invalid-1',
      'type': 'desconhecido',
    };

    final rebuilt = [valid, invalid]
        .map(TransactionStorageMapper.tryFromMap)
        .whereType<Transaction>()
        .toList();

    expect(rebuilt, hasLength(1));
    expect(rebuilt.single.id, 'valid-1');
  });
}

Transaction _transaction({
  required String id,
  String description = 'Supermercado',
}) {
  return Transaction(
    id: id,
    type: TransactionType.expense,
    amount: 82.5,
    date: DateTime(2026, 4, 6),
    description: description,
    category: TransactionCategories.food,
  );
}

class _FakeTransactionLocalDataSource implements TransactionLocalDataSource {
  @override
  Future<List<Map<String, dynamic>>> loadTransactions() async {
    return [];
  }

  @override
  Future<void> saveTransactions(List<Map<String, dynamic>> transactions) async {}
}
