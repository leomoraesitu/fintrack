import 'package:fintrack/features/transactions/domain/entities/transaction_categories.dart';
import 'package:fintrack/features/transactions/domain/entities/transaction_category.dart';
import 'package:fintrack/features/transactions/domain/entities/transaction_type.dart';

class TransactionCategoryCatalog {
  const TransactionCategoryCatalog(this.all);

  static const fallback = TransactionCategoryCatalog(TransactionCategories.all);

  final List<TransactionCategory> all;

  List<TransactionCategory> byType(TransactionType? type) {
    if (type == null) {
      return all;
    }

    return all.where((category) => category.type == type).toList();
  }

  bool containsCompatible(String? categoryId, TransactionType? type) {
    if (categoryId == null || type == null) {
      return true;
    }

    return all.any(
      (category) => category.id == categoryId && category.type == type,
    );
  }
}