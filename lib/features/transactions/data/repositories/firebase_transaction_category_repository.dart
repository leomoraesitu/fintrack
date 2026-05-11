import 'package:fintrack/features/transactions/data/datasources/transaction_category_remote_data_source.dart';
import 'package:fintrack/features/transactions/data/models/transaction_category_firestore_mapper.dart';
import 'package:fintrack/features/transactions/data/services/remote_transaction_category_catalog_service.dart';
import 'package:fintrack/features/transactions/domain/entities/transaction_category.dart';
import 'package:fintrack/features/transactions/domain/entities/transaction_category_catalog.dart';
import 'package:fintrack/features/transactions/domain/entities/transaction_type.dart';
import 'package:fintrack/features/transactions/domain/repositories/transaction_category_repository.dart';

class FirebaseTransactionCategoryRepository
    implements TransactionCategoryRepository {
  const FirebaseTransactionCategoryRepository({
    required TransactionCategoryRemoteDataSource remoteDataSource,
    required String userId,
  }) : _remoteDataSource = remoteDataSource,
       _userId = userId;

  final TransactionCategoryRemoteDataSource _remoteDataSource;
  final String _userId;

  @override
  Future<TransactionCategoryCatalog> getCategoryCatalog() {
    return RemoteTransactionCategoryCatalogService(
      remoteDataSource: _remoteDataSource,
    ).syncAndLoad(userId: _userId);
  }

  @override
  Future<TransactionCategory> addCategory({
    required String label,
    required TransactionType type,
  }) async {
    final categories = await _remoteDataSource.loadCategories(userId: _userId);
    final existingIds = categories.map((category) => category.id).toSet();
    final category = TransactionCategory(
      id: _buildUniqueId(label, existingIds),
      label: label.trim(),
      type: type,
    );

    await _remoteDataSource.saveCategory(
      userId: _userId,
      categoryId: category.id,
      data: TransactionCategoryFirestoreMapper.toDocument(category),
    );

    return category;
  }

  String _buildUniqueId(String label, Set<String> existingIds) {
    final baseId = _slugify(label);
    var candidate = baseId;
    var suffix = 2;

    while (existingIds.contains(candidate)) {
      candidate = '$baseId-$suffix';
      suffix++;
    }

    return candidate;
  }

  String _slugify(String value) {
    final normalized = value
        .trim()
        .toLowerCase()
        .replaceAll('á', 'a')
        .replaceAll('à', 'a')
        .replaceAll('â', 'a')
        .replaceAll('ã', 'a')
        .replaceAll('ä', 'a')
        .replaceAll('é', 'e')
        .replaceAll('è', 'e')
        .replaceAll('ê', 'e')
        .replaceAll('ë', 'e')
        .replaceAll('í', 'i')
        .replaceAll('ì', 'i')
        .replaceAll('î', 'i')
        .replaceAll('ï', 'i')
        .replaceAll('ó', 'o')
        .replaceAll('ò', 'o')
        .replaceAll('ô', 'o')
        .replaceAll('õ', 'o')
        .replaceAll('ö', 'o')
        .replaceAll('ú', 'u')
        .replaceAll('ù', 'u')
        .replaceAll('û', 'u')
        .replaceAll('ü', 'u')
        .replaceAll('ç', 'c');

    final slug = normalized
        .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
        .replaceAll(RegExp(r'^-|-$'), '');

    return slug.isEmpty ? 'categoria' : slug;
  }
}