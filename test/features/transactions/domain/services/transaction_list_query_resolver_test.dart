import 'package:fintrack/features/transactions/domain/entities/transaction.dart';
import 'package:fintrack/features/transactions/domain/entities/transaction_categories.dart';
import 'package:fintrack/features/transactions/domain/entities/transaction_list_query.dart';
import 'package:fintrack/features/transactions/domain/entities/transaction_type.dart';
import 'package:fintrack/features/transactions/domain/services/transaction_list_query_resolver.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const resolver = TransactionListQueryResolver();

  final transactions = [
    Transaction(
      id: 'expense_transport',
      type: TransactionType.expense,
      amount: 20,
      date: DateTime(2026, 4, 7),
      description: 'Transporte',
      category: TransactionCategories.transport,
    ),
    Transaction(
      id: 'income_salary',
      type: TransactionType.income,
      amount: 3500,
      date: DateTime(2026, 4, 5),
      description: 'Salário',
      category: TransactionCategories.salary,
    ),
    Transaction(
      id: 'expense_food',
      type: TransactionType.expense,
      amount: 80,
      date: DateTime(2026, 4, 6),
      description: 'Mercado',
      category: TransactionCategories.food,
    ),
  ];

  test('deve ordenar por data da mais recente para a mais antiga por padrao', () {
    final resolvedTransactions = resolver.resolve(transactions);

    expect(
      resolvedTransactions.map((transaction) => transaction.id).toList(),
      ['expense_transport', 'expense_food', 'income_salary'],
    );
    expect(
      transactions.map((transaction) => transaction.id).toList(),
      ['expense_transport', 'income_salary', 'expense_food'],
    );
  });

  test('deve combinar filtros por tipo e categoria sem alterar a origem', () {
    const query = TransactionListQuery(
      type: TransactionType.expense,
      categoryId: 'alimentacao',
    );

    final resolvedTransactions = resolver.resolve(transactions, query: query);

    expect(resolvedTransactions, hasLength(1));
    expect(resolvedTransactions.first.id, 'expense_food');
  });

  test('deve aplicar filtro de periodo valido', () {
    final query = TransactionListQuery(
      period: TransactionPeriodFilter(
        startDate: DateTime(2026, 4, 6),
        endDate: DateTime(2026, 4, 7),
      ),
    );

    final resolvedTransactions = resolver.resolve(transactions, query: query);

    expect(
      resolvedTransactions.map((transaction) => transaction.id).toList(),
      ['expense_transport', 'expense_food'],
    );
  });

  test('deve retornar lista vazia quando o periodo for invalido', () {
    final query = TransactionListQuery(
      period: TransactionPeriodFilter(
        startDate: DateTime(2026, 4, 8),
        endDate: DateTime(2026, 4, 7),
      ),
    );

    final resolvedTransactions = resolver.resolve(transactions, query: query);

    expect(resolvedTransactions, isEmpty);
  });
}