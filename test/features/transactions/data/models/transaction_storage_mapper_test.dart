import 'package:fintrack/features/transactions/data/models/transaction_storage_mapper.dart';
import 'package:fintrack/features/transactions/domain/entities/transaction.dart';
import 'package:fintrack/features/transactions/domain/entities/transaction_categories.dart';
import 'package:fintrack/features/transactions/domain/entities/transaction_type.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('deve converter transacao para map e reconstruir sem perder dados', () {
    final transaction = Transaction(
      id: '1',
      type: TransactionType.expense,
      amount: 82.50,
      date: DateTime(2026, 4, 6),
      description: 'Supermercado',
      category: TransactionCategories.food,
    );

    final map = TransactionStorageMapper.toMap(transaction);
    final restored = TransactionStorageMapper.fromMap(map);

    expect(restored.id, transaction.id);
    expect(restored.type, transaction.type);
    expect(restored.amount, transaction.amount);
    expect(restored.date, transaction.date);
    expect(restored.description, transaction.description);
    expect(restored.category.id, transaction.category.id);
    expect(restored.category.label, transaction.category.label);
    expect(restored.category.type, transaction.category.type);
  });
}