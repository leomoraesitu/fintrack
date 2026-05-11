import 'package:fintrack/features/transactions/data/datasources/transaction_category_remote_data_source.dart';
import 'package:fintrack/features/transactions/data/models/transaction_category_firestore_mapper.dart';
import 'package:fintrack/features/transactions/domain/entities/transaction_categories.dart';
import 'package:fintrack/features/transactions/domain/entities/transaction_category_catalog.dart';

class RemoteTransactionCategoryCatalogService {
  const RemoteTransactionCategoryCatalogService({required TransactionCategoryRemoteDataSource remoteDataSource})
    : _remoteDataSource = remoteDataSource;

  final TransactionCategoryRemoteDataSource _remoteDataSource;

  Future<TransactionCategoryCatalog> syncAndLoad({required String userId}) async {
    final remoteDocuments = await _remoteDataSource.loadCategories(userId: userId);
    final categories = remoteDocuments
        .map(
          (document) => TransactionCategoryFirestoreMapper.fromDocument(
            id: document.id,
            data: document.data,
          ),
        )
        .toList();
    final remoteIds = categories.map((category) => category.id).toSet();

    for (final category in TransactionCategories.all) {
      if (remoteIds.contains(category.id)) {
        continue;
      }

      await _remoteDataSource.saveCategory(
        userId: userId,
        categoryId: category.id,
        data: TransactionCategoryFirestoreMapper.toDocument(category),
      );
      categories.add(category);
    }

    categories.sort((left, right) => left.label.compareTo(right.label));
    return TransactionCategoryCatalog(List.unmodifiable(categories));
  }
}