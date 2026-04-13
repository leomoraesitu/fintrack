import 'package:fintrack/features/dashboard/domain/entities/financial_summary.dart';

abstract class DashboardState {}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardEmpty extends DashboardState {}

class DashboardSuccess extends DashboardState {
  DashboardSuccess(this.summary);

  final FinancialSummary summary;
}
