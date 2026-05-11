import 'package:fintrack/features/dashboard/domain/entities/financial_summary.dart';
import 'package:fintrack/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:fintrack/features/transactions/domain/entities/transaction.dart';
import 'package:fintrack/features/transactions/domain/repositories/transaction_repository.dart';

class TransactionDashboardRepository implements DashboardRepository {
  const TransactionDashboardRepository(this._transactionRepository);

  final TransactionRepository _transactionRepository;

  @override
  Future<FinancialSummary> getFinancialSummary() async {
    final transactions = await _transactionRepository.getTransactions();

    double totalIncome = 0;
    double totalExpense = 0;

    for (final transaction in transactions) {
      if (transaction.isIncome) {
        totalIncome += transaction.amount;
      } else if (transaction.isExpense) {
        totalExpense += transaction.amount;
      }
    }

    return FinancialSummary(
      balance: totalIncome - totalExpense,
      totalIncome: totalIncome,
      totalExpense: totalExpense,
    );
  }

  @override
  Future<List<Transaction>> getRecentTransactions({int limit = 3}) async {
    final transactions = List<Transaction>.from(
      await _transactionRepository.getTransactions(),
    );

    transactions.sort((a, b) => b.date.compareTo(a.date));

    return transactions.take(limit).toList();
  }
}
