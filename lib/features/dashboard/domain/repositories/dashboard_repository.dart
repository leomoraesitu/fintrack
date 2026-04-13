import 'package:fintrack/features/dashboard/domain/entities/financial_summary.dart';
import 'package:fintrack/features/transactions/domain/entities/transaction.dart';

abstract class DashboardRepository {
  FinancialSummary getFinancialSummary();
  List<Transaction> getRecentTransactions({int limit = 3});
}
