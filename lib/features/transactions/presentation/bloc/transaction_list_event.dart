import 'package:fintrack/features/transactions/domain/entities/transaction_list_query.dart';

abstract class TransactionListEvent {
  const TransactionListEvent();
}

class TransactionListRequested extends TransactionListEvent {
  const TransactionListRequested({
    this.query = const TransactionListQuery(),
  });

  final TransactionListQuery query;
}