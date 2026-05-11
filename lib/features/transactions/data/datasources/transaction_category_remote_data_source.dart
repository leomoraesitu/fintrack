abstract interface class TransactionCategoryRemoteDataSource {
  Future<List<TransactionCategoryRemoteDocument>> loadCategories({
    required String userId,
  });

  Future<void> saveCategory({
    required String userId,
    required String categoryId,
    required Map<String, dynamic> data,
  });
}

class TransactionCategoryRemoteDocument {
  const TransactionCategoryRemoteDocument({required this.id, required this.data});

  final String id;
  final Map<String, dynamic> data;
}