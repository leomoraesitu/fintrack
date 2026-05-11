import 'dart:async';

import 'package:fintrack/features/transactions/domain/entities/transaction_list_query.dart';
import 'package:fintrack/features/transactions/domain/services/transaction_list_query_resolver.dart';
import 'package:fintrack/features/transactions/domain/entities/transaction.dart';
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
    on<_TransactionListChanged>(_onTransactionListChanged);
    on<_TransactionListFailed>(_onTransactionListFailed);
  }

  final TransactionRepository _repository;
  final TransactionListQueryResolver _queryResolver;
  StreamSubscription<List<Transaction>>? _transactionsSubscription;

  Future<void> _onTransactionListRequested(
    TransactionListRequested event,
    Emitter<TransactionListState> emit,
  ) async {
    emit(const TransactionListLoading());
    _transactionsSubscription?.cancel();
    _transactionsSubscription = null;

    try {
      _emitTransactions(
        await _repository.getTransactions(),
        query: event.query,
        emit: emit,
      );

      _transactionsSubscription = _repository.watchTransactions().listen(
        (transactions) {
          add(_TransactionListChanged(transactions, query: event.query));
        },
        onError: (_) {
          add(_TransactionListFailed(query: event.query));
        },
      );
    } catch (_) {
      add(_TransactionListFailed(query: event.query));
    }
  }

  void _onTransactionListChanged(
    _TransactionListChanged event,
    Emitter<TransactionListState> emit,
  ) {
    _emitTransactions(event.transactions, query: event.query, emit: emit);
  }

  void _emitTransactions(
    List<Transaction> sourceTransactions, {
    required TransactionListQuery query,
    required Emitter<TransactionListState> emit,
  }) {
    final transactions = _queryResolver.resolve(
      sourceTransactions,
      query: query,
    );

    if (transactions.isEmpty) {
      emit(TransactionListEmpty(query: query));
      return;
    }

    emit(TransactionListSuccess(transactions: transactions, query: query));
  }

  void _onTransactionListFailed(
    _TransactionListFailed event,
    Emitter<TransactionListState> emit,
  ) {
    emit(
      TransactionListError(
        message: 'Erro ao carregar transações',
        query: event.query,
      ),
    );
  }

  @override
  Future<void> close() async {
    await _transactionsSubscription?.cancel();
    return super.close();
  }
}

class _TransactionListChanged extends TransactionListEvent {
  const _TransactionListChanged(this.transactions, {required this.query});

  final List<Transaction> transactions;
  final TransactionListQuery query;
}

class _TransactionListFailed extends TransactionListEvent {
  const _TransactionListFailed({required this.query});

  final TransactionListQuery query;
}
