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

  test('deve retornar as transacoes mais recentes respeitando o limite', () {
    final transactionRepository = InMemoryTransactionRepository(
      initialTransactions: [
        Transaction(
          id: '1',
          type: TransactionType.expense,
          amount: 50,
          date: DateTime(2026, 4, 2),
          description: 'Conta antiga',
          category: TransactionCategories.bills,
        ),
        Transaction(
          id: '2',
          type: TransactionType.income,
          amount: 3500,
          date: DateTime(2026, 4, 5),
          description: 'Salário',
          category: TransactionCategories.salary,
        ),
        Transaction(
          id: '3',
          type: TransactionType.expense,
          amount: 18,
          date: DateTime(2026, 4, 7),
          description: 'Transporte',
          category: TransactionCategories.transport,
        ),
        Transaction(
          id: '4',
          type: TransactionType.expense,
          amount: 82.50,
          date: DateTime(2026, 4, 6),
          description: 'Supermercado',
          category: TransactionCategories.food,
        ),
      ],
    );

    final repository = TransactionDashboardRepository(transactionRepository);

    final recentTransactions = repository.getRecentTransactions(limit: 3);

    expect(recentTransactions.length, 3);
    expect(recentTransactions[0].description, 'Transporte');
    expect(recentTransactions[1].description, 'Supermercado');
    expect(recentTransactions[2].description, 'Salário');
  });

  test(
    'deve retornar resumo zerado e nenhuma transacao recente quando nao houver dados',
    () {
      final transactionRepository = InMemoryTransactionRepository();

      final repository = TransactionDashboardRepository(transactionRepository);

      final summary = repository.getFinancialSummary();
      final recentTransactions = repository.getRecentTransactions();

      expect(summary.totalIncome, 0);
      expect(summary.totalExpense, 0);
      expect(summary.balance, 0);
      expect(recentTransactions, isEmpty);
    },
  );
}
