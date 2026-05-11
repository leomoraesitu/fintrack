import 'package:fintrack/features/transactions/domain/entities/transaction_category.dart';
import 'package:fintrack/features/transactions/domain/entities/transaction_type.dart';

class TransactionCategoryFirestoreMapper {
  const TransactionCategoryFirestoreMapper._();

  static Map<String, dynamic> toDocument(TransactionCategory category) {
    return {'label': category.label, 'type': _typeToValue(category.type)};
  }

  static TransactionCategory fromDocument({
    required String id,
    required Map<String, dynamic> data,
  }) {
    return TransactionCategory(
      id: id,
      label: data['label'] as String,
      type: _typeFromValue(data['type'] as String),
    );
  }

  static String _typeToValue(TransactionType type) {
    return switch (type) {
      TransactionType.income => 'income',
      TransactionType.expense => 'expense',
    };
  }

  static TransactionType _typeFromValue(String value) {
    return switch (value) {
      'income' => TransactionType.income,
      'expense' => TransactionType.expense,
      _ => throw ArgumentError.value(value, 'value', 'Tipo de categoria inválido'),
    };
  }
}