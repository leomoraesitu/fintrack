import 'package:fintrack/features/transactions/domain/entities/transaction.dart';
import 'package:fintrack/features/transactions/domain/entities/transaction_category.dart';
import 'package:fintrack/features/transactions/domain/entities/transaction_type.dart';

class TransactionStorageMapper {
  const TransactionStorageMapper._();

  static Map<String, dynamic> toMap(Transaction transaction) {
    return {
      'id': transaction.id,
      'type': transaction.type.name,
      'amount': transaction.amount,
      'date': transaction.date.toIso8601String(),
      'description': transaction.description,
      'categoryId': transaction.category.id,
      'categoryLabel': transaction.category.label,
      'categoryType': transaction.category.type.name,
    };
  }

  static Transaction fromMap(Map<String, dynamic> map) {
    final type = TransactionType.values.byName(map['type'] as String);
    final categoryType = TransactionType.values.byName(
      map['categoryType'] as String,
    );

    return Transaction(
      id: map['id'] as String,
      type: type,
      amount: map['amount'] as double,
      date: DateTime.parse(map['date'] as String),
      description: map['description'] as String,
      category: TransactionCategory(
        id: map['categoryId'] as String,
        label: map['categoryLabel'] as String,
        type: categoryType,
      ),
    );
  }
}
