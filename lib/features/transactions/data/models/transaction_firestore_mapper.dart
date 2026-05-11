import 'package:cloud_firestore/cloud_firestore.dart' hide Transaction;
import 'package:fintrack/features/transactions/domain/entities/transaction.dart';
import 'package:fintrack/features/transactions/domain/entities/transaction_category.dart';
import 'package:fintrack/features/transactions/domain/entities/transaction_type.dart';

class TransactionFirestoreMapper {
  const TransactionFirestoreMapper._();

  static Map<String, dynamic> toDocument(Transaction transaction) {
    return {
      'type': transaction.type.name,
      'amount': transaction.amount,
      'date': Timestamp.fromDate(transaction.date),
      'description': transaction.description,
      'categoryId': transaction.category.id,
      'categoryLabel': transaction.category.label,
      'categoryType': transaction.category.type.name,
    };
  }

  static Transaction fromDocument({
    required String id,
    required Map<String, dynamic> data,
  }) {
    final type = TransactionType.values.byName(data['type'] as String);
    final categoryType = TransactionType.values.byName(
      data['categoryType'] as String,
    );

    return Transaction(
      id: id,
      type: type,
      amount: (data['amount'] as num).toDouble(),
      date: _readDate(data['date']),
      description: data['description'] as String,
      category: TransactionCategory(
        id: data['categoryId'] as String,
        label: data['categoryLabel'] as String,
        type: categoryType,
      ),
      updatedAt: _readOptionalDate(data['updatedAt']),
    );
  }

  static DateTime _readDate(Object? value) {
    if (value is Timestamp) {
      return value.toDate();
    }

    if (value is DateTime) {
      return value;
    }

    throw ArgumentError.value(value, 'date', 'Data inválida do Firestore');
  }

  static DateTime? _readOptionalDate(Object? value) {
    if (value == null) {
      return null;
    }

    return _readDate(value);
  }
}
