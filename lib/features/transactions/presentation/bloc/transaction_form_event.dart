import 'package:fintrack/features/transactions/domain/entities/transaction.dart';

abstract class TransactionFormEvent {
  const TransactionFormEvent();
}

class TransactionCreated extends TransactionFormEvent {
  const TransactionCreated(this.transaction);

  final Transaction transaction;
}

class TransactionUpdated extends TransactionFormEvent {
  const TransactionUpdated(this.transaction);

  final Transaction transaction;
}

class TransactionDeleted extends TransactionFormEvent {
  const TransactionDeleted(this.id);

  final String id;
}