import 'package:fintrack/features/dashboard/domain/usecases/get_recent_transactions.dart';
import 'package:fintrack/features/dashboard/presentation/bloc/dashboard_event.dart';
import 'package:fintrack/features/dashboard/presentation/bloc/dashboard_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fintrack/features/dashboard/domain/usecases/get_financial_summary.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc(this._getFinancialSummary, this._getRecentTransactions)
    : super(DashboardInitial()) {
    on<DashboardRequested>(_onDashboardRequested);
  }

  final GetFinancialSummary _getFinancialSummary;
  final GetRecentTransactions _getRecentTransactions;

  void _onDashboardRequested(
    DashboardRequested event,
    Emitter<DashboardState> emit,
  ) {
    emit(DashboardLoading());

    try {
      final summary = _getFinancialSummary();
      final recentTransactions = _getRecentTransactions();

      if (summary.totalIncome == 0 && summary.totalExpense == 0) {
        emit(DashboardEmpty());
        return;
      }
      emit(
        DashboardSuccess(
          summary: summary,
          recentTransactions: recentTransactions,
        ),
      );
    } catch (error) {
      emit(DashboardError(message: 'Não foi possível carregar o dashboard'));
    }
  }
}
