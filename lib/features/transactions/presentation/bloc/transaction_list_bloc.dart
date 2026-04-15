import 'package:fintrack/features/transactions/domain/services/transaction_list_query_resolver.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fintrack/features/transactions/domain/repositories/transaction_repository.dart';

import 'transaction_list_event.dart';
import 'transaction_list_state.dart';

class TransactionListBloc
    extends Bloc<TransactionListEvent, TransactionListState> {
  TransactionListBloc({
    required TransactionRepository repository,
    TransactionListQueryResolver? queryResolver,
  }) : _repository = repository,
       _queryResolver = queryResolver ?? const TransactionListQueryResolver(),
       super(const TransactionListInitial()) {
    on<TransactionListRequested>(_onTransactionListRequested);
  }

  final TransactionRepository _repository;
  final TransactionListQueryResolver _queryResolver;

  void _onTransactionListRequested(
    TransactionListRequested event,
    Emitter<TransactionListState> emit,
  ) {
    emit(const TransactionListLoading());
    try {
      final transactions = _queryResolver.resolve(
        _repository.getTransactions(),
        query: event.query,
      );

      if (transactions.isEmpty) {
        emit(TransactionListEmpty(query: event.query));
        return;
      }

      emit(
        TransactionListSuccess(transactions: transactions, query: event.query),
      );
    } catch (e) {
      emit(
        TransactionListError(
          message: 'Erro ao carregar transações',
          query: event.query,
        ),
      );
    }
  }
}
