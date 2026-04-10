import 'package:fintrack/features/transactions/domain/entities/transaction.dart';

abstract class TransactionFormEvent {
  const TransactionFormEvent();
}

class TransactionFormSubmitted extends TransactionFormEvent {
  const TransactionFormSubmitted({required this.transaction});

  final Transaction transaction;
}