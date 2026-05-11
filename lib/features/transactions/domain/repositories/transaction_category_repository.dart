import 'package:fintrack/features/transactions/domain/entities/transaction_category.dart';
import 'package:fintrack/features/transactions/domain/entities/transaction_category_catalog.dart';
import 'package:fintrack/features/transactions/domain/entities/transaction_type.dart';

abstract interface class TransactionCategoryRepository {
  Future<TransactionCategoryCatalog> getCategoryCatalog();

  Future<TransactionCategory> addCategory({
    required String label,
    required TransactionType type,
  });
}