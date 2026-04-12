import 'package:fintrack/features/dashboard/domain/entities/financial_summary.dart';
import 'package:fintrack/features/dashboard/domain/repositories/dashboard_repository.dart';

class GetFinancialSummary {
  const GetFinancialSummary(this._repository);

  final DashboardRepository _repository;

  FinancialSummary call() {
    return _repository.getFinancialSummary();
  }
}
