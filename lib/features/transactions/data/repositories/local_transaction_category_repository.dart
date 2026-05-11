import 'package:fintrack/features/transactions/domain/entities/transaction_category.dart';
import 'package:fintrack/features/transactions/domain/entities/transaction_category_catalog.dart';
import 'package:fintrack/features/transactions/domain/entities/transaction_type.dart';
import 'package:fintrack/features/transactions/domain/repositories/transaction_category_repository.dart';

class LocalTransactionCategoryRepository implements TransactionCategoryRepository {
  const LocalTransactionCategoryRepository();

  @override
  Future<TransactionCategoryCatalog> getCategoryCatalog() async {
    return TransactionCategoryCatalog.fallback;
  }

  @override
  Future<TransactionCategory> addCategory({
    required String label,
    required TransactionType type,
  }) {
    throw UnsupportedError('Categorias customizadas nao estao disponiveis no modo demo.');
  }
}