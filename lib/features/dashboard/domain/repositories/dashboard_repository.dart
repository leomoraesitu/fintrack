import 'package:fintrack/features/dashboard/domain/entities/financial_summary.dart';

abstract class DashboardRepository {
  FinancialSummary getFinancialSummary();
}
