import 'package:fintrack/features/transactions/domain/entities/transaction_type.dart';

class TransactionCategory {
  const TransactionCategory({
    required this.id,
    required this.label,
    required this.type,
  });

  final String id;
  final String label;
  final TransactionType type;
}
