import 'package:fintrack/features/transactions/domain/entities/transaction.dart';

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
  const TransactionListEmpty();
}

class TransactionListSuccess extends TransactionListState {
  final List<Transaction> transactions;

  const TransactionListSuccess({required this.transactions});
}