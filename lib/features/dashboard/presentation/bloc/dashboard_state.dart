import 'package:fintrack/features/dashboard/domain/entities/financial_summary.dart';
import 'package:fintrack/features/transactions/domain/entities/transaction.dart';

abstract class DashboardState {}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardEmpty extends DashboardState {}

class DashboardSuccess extends DashboardState {
  DashboardSuccess({required this.summary, required this.recentTransactions});

  final FinancialSummary summary;
  final List<Transaction> recentTransactions;
}
