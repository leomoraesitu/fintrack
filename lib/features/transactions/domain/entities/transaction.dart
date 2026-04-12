import 'package:fintrack/features/transactions/domain/entities/transaction_category.dart';
import 'package:fintrack/features/transactions/domain/entities/transaction_type.dart';

class Transaction {
  const Transaction({
    required this.id,
    required this.type,
    required this.amount,
    required this.date,
    required this.description,
    required this.category,
  });

  final String id;
  final TransactionType type;
  final double amount;
  final DateTime date;
  final String description;
  final TransactionCategory category;

  bool get isIncome => type == TransactionType.income;
  bool get isExpense => type == TransactionType.expense;
}
