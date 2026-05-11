import 'package:fintrack/features/transactions/data/datasources/transaction_category_remote_data_source.dart';
import 'package:fintrack/features/transactions/data/models/transaction_category_firestore_mapper.dart';
import 'package:fintrack/features/transactions/data/services/remote_transaction_category_catalog_service.dart';
import 'package:fintrack/features/transactions/domain/entities/transaction_categories.dart';
import 'package:fintrack/features/transactions/domain/entities/transaction_type.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RemoteTransactionCategoryCatalogService', () {
    test('carrega e completa categorias padrao ausentes no backend', () async {
      final remoteDataSource = _FakeTransactionCategoryRemoteDataSource(
        documents: [
          TransactionCategoryRemoteDocument(
            id: TransactionCategories.salary.id,
            data: TransactionCategoryFirestoreMapper.toDocument(
              TransactionCategories.salary,
            ),
          ),
        ],
      );
      final service = RemoteTransactionCategoryCatalogService(
        remoteDataSource: remoteDataSource,
      );

      final catalog = await service.syncAndLoad(userId: 'user-1');

      expect(catalog.all, hasLength(TransactionCategories.all.length));
      expect(remoteDataSource.savedCategoryIds, contains(TransactionCategories.food.id));
      expect(remoteDataSource.savedCategoryIds, isNot(contains(TransactionCategories.salary.id)));
    });

    test('preserva categorias remotas existentes fora do conjunto padrao', () async {
      final remoteDataSource = _FakeTransactionCategoryRemoteDataSource(
        documents: const [
          TransactionCategoryRemoteDocument(
            id: 'viagem',
            data: {'label': 'Viagem', 'type': 'expense'},
          ),
        ],
      );
      final service = RemoteTransactionCategoryCatalogService(
        remoteDataSource: remoteDataSource,
      );

      final catalog = await service.syncAndLoad(userId: 'user-1');

      expect(catalog.all.any((category) => category.id == 'viagem'), isTrue);
      expect(
        catalog.all.where((category) => category.type == TransactionType.expense),
        isNotEmpty,
      );
    });
  });
}

class _FakeTransactionCategoryRemoteDataSource
    implements TransactionCategoryRemoteDataSource {
  _FakeTransactionCategoryRemoteDataSource({this.documents = const []});

  final List<TransactionCategoryRemoteDocument> documents;
  final List<String> savedCategoryIds = [];

  @override
  Future<List<TransactionCategoryRemoteDocument>> loadCategories({
    required String userId,
  }) async {
    return documents;
  }

  @override
  Future<void> saveCategory({
    required String userId,
    required String categoryId,
    required Map<String, dynamic> data,
  }) async {
    savedCategoryIds.add(categoryId);
  }
}