import 'package:fintrack/features/dashboard/data/repositories/transaction_dashboard_repository.dart';
import 'package:fintrack/features/transactions/data/repositories/in_memory_transaction_repository.dart';
import 'package:fintrack/features/transactions/domain/entities/transaction.dart';
import 'package:fintrack/features/transactions/domain/entities/transaction_categories.dart';
import 'package:fintrack/features/transactions/domain/entities/transaction_type.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('deve calcular o resumo financeiro a partir das transacoes', () {
    final transactionRepository = InMemoryTransactionRepository(
      initialTransactions: [
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
    );

    final repository = TransactionDashboardRepository(transactionRepository);
    final summary = repository.getFinancialSummary();

    expect(summary.totalIncome, 3500);
    expect(summary.totalExpense, 100.5);
    expect(summary.balance, 3399.5);
  });
}
