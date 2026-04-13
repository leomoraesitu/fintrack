import 'package:fintrack/features/transactions/data/datasources/shared_prefs_transaction_local_data_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('deve retornar lista vazia quando nao houver transacoes salvas', () async {
    SharedPreferences.setMockInitialValues({});
    final sharedPreferences = await SharedPreferences.getInstance();

    final dataSource = SharedPrefsTransactionLocalDataSource(sharedPreferences);

    final transactions = await dataSource.loadTransactions();

    expect(transactions, isEmpty);
  });

  test('deve salvar e carregar transacoes em formato serializado', () async {
    SharedPreferences.setMockInitialValues({});
    final sharedPreferences = await SharedPreferences.getInstance();

    final dataSource = SharedPrefsTransactionLocalDataSource(sharedPreferences);

    final payload = [
      {
        'id': '1',
        'type': 'expense',
        'amount': 82.5,
        'date': '2026-04-06T00:00:00.000',
        'description': 'Supermercado',
        'categoryId': 'alimentacao',
        'categoryLabel': 'Alimentação',
        'categoryType': 'expense',
      },
    ];

    await dataSource.saveTransactions(payload);

    final loaded = await dataSource.loadTransactions();

    expect(loaded.length, 1);
    expect(loaded.first['id'], '1');
    expect(loaded.first['description'], 'Supermercado');
    expect(loaded.first['categoryId'], 'alimentacao');
  });
}