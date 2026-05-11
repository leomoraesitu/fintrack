import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fintrack/features/transactions/data/datasources/transaction_category_remote_data_source.dart';

class FirestoreTransactionCategoryRemoteDataSource
    implements TransactionCategoryRemoteDataSource {
  const FirestoreTransactionCategoryRemoteDataSource(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> _categoriesRef(String userId) {
    return _firestore.collection('users').doc(userId).collection('categories');
  }

  @override
  Future<List<TransactionCategoryRemoteDocument>> loadCategories({
    required String userId,
  }) async {
    final snapshot = await _categoriesRef(userId).orderBy('label').get();

    return snapshot.docs
        .map(
          (doc) => TransactionCategoryRemoteDocument(id: doc.id, data: doc.data()),
        )
        .toList();
  }

  @override
  Future<void> saveCategory({
    required String userId,
    required String categoryId,
    required Map<String, dynamic> data,
  }) async {
    await _categoriesRef(userId).doc(categoryId).set(data, SetOptions(merge: true));
  }
}