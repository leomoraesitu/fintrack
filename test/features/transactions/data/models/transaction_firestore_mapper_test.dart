import 'package:cloud_firestore/cloud_firestore.dart' hide Transaction;
import 'package:fintrack/features/transactions/data/models/transaction_firestore_mapper.dart';
import 'package:fintrack/features/transactions/domain/entities/transaction.dart';
import 'package:fintrack/features/transactions/domain/entities/transaction_categories.dart';
import 'package:fintrack/features/transactions/domain/entities/transaction_type.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('deve converter transacao para documento Firestore', () {
    final transaction = Transaction(
      id: 'transaction-id',
      type: TransactionType.expense,
      amount: 82.50,
      date: DateTime(2026, 4, 6),
      description: 'Supermercado',
      category: TransactionCategories.food,
    );

    final document = TransactionFirestoreMapper.toDocument(transaction);

    expect(document['type'], 'expense');
    expect(document['amount'], 82.50);
    expect((document['date'] as Timestamp).toDate(), transaction.date);
    expect(document['description'], 'Supermercado');
    expect(document['categoryId'], TransactionCategories.food.id);
    expect(document['categoryLabel'], TransactionCategories.food.label);
    expect(document['categoryType'], 'expense');
  });

  test('deve reconstruir transacao a partir de documento Firestore', () {
    final updatedAt = Timestamp.fromDate(DateTime(2026, 4, 8));
    final transaction = TransactionFirestoreMapper.fromDocument(
      id: 'transaction-id',
      data: {
        'type': 'income',
        'amount': 3500,
        'date': Timestamp.fromDate(DateTime(2026, 4, 5)),
        'description': 'Salário',
        'categoryId': TransactionCategories.salary.id,
        'categoryLabel': TransactionCategories.salary.label,
        'categoryType': 'income',
        'updatedAt': updatedAt,
      },
    );

    expect(transaction.id, 'transaction-id');
    expect(transaction.type, TransactionType.income);
    expect(transaction.amount, 3500);
    expect(transaction.date, DateTime(2026, 4, 5));
    expect(transaction.description, 'Salário');
    expect(transaction.category.id, TransactionCategories.salary.id);
    expect(transaction.category.label, TransactionCategories.salary.label);
    expect(transaction.category.type, TransactionType.income);
    expect(transaction.updatedAt, updatedAt.toDate());
  });
}
