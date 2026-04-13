import 'package:fintrack/features/transactions/domain/entities/transaction.dart';
import 'package:fintrack/features/transactions/domain/entities/transaction_list_query.dart';

abstract class TransactionListState {
  const TransactionListState();
}

class TransactionListInitial extends TransactionListState {
  const TransactionListInitial();
}

class TransactionListLoading extends TransactionListState {
  const TransactionListLoading();
}

class TransactionListEmpty extends TransactionListState {
  const TransactionListEmpty({
    this.query = const TransactionListQuery(),
  });

  final TransactionListQuery query;
}

class TransactionListSuccess extends TransactionListState {
  const TransactionListSuccess({
    required this.transactions,
    this.query = const TransactionListQuery(),
  });

  final List<Transaction> transactions;
  final TransactionListQuery query;
}