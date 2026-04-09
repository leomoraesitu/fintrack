import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fintrack/features/transactions/domain/repositories/transaction_repository.dart';

import 'transaction_list_event.dart';
import 'transaction_list_state.dart';

class TransactionListBloc
    extends Bloc<TransactionListEvent, TransactionListState> {
  TransactionListBloc({required TransactionRepository repository})
    : _repository = repository,
      super(const TransactionListInitial()) {
    on<TransactionListRequested>(_onTransactionListRequested);
  }

  final TransactionRepository _repository;

  void _onTransactionListRequested(
    TransactionListRequested event,
    Emitter<TransactionListState> emit,
  ) {
    emit(const TransactionListLoading());

    final transactions = _repository.getTransactions();

    if (transactions.isEmpty) {
      emit(const TransactionListEmpty());
      return;
    }

    emit(TransactionListSuccess(transactions: transactions));
  }
}
