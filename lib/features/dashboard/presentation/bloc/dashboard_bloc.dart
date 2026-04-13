import 'package:fintrack/features/dashboard/presentation/bloc/dashboard_event.dart';
import 'package:fintrack/features/dashboard/presentation/bloc/dashboard_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fintrack/features/dashboard/domain/usecases/get_financial_summary.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc(this._getFinancialSummary) : super(DashboardInitial()) {
    on<DashboardRequested>(_onDashboardRequested);
  }

  final GetFinancialSummary _getFinancialSummary;

  void _onDashboardRequested(
    DashboardRequested event,
    Emitter<DashboardState> emit,
  ) {
    emit(DashboardLoading());

    final summary = _getFinancialSummary();

    if (summary.totalIncome == 0 && summary.totalExpense == 0) {
      emit(DashboardEmpty());
      return;
    }
    emit(DashboardSuccess(summary));
  }
}
