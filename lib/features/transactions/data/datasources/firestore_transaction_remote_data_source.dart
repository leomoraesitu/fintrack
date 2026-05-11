import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fintrack/features/transactions/data/datasources/transaction_remote_data_source.dart';
import 'package:fintrack/features/transactions/domain/exceptions/transaction_conflict_exception.dart';

class FirestoreTransactionRemoteDataSource
    implements TransactionRemoteDataSource {
  const FirestoreTransactionRemoteDataSource(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> _transactionsRef(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('transactions');
  }

  @override
  Future<List<TransactionRemoteDocument>> loadTransactions({
    required String userId,
  }) async {
    final snapshot = await _transactionsRef(userId).orderBy('date').get();

    return snapshot.docs.map(_toRemoteDocument).toList();
  }

  @override
  Stream<List<TransactionRemoteDocument>> watchTransactions({
    required String userId,
  }) {
    return _transactionsRef(userId)
        .orderBy('date')
        .snapshots()
        .map((snapshot) => snapshot.docs.map(_toRemoteDocument).toList());
  }

  @override
  Future<void> saveTransaction({
    required String userId,
    required String transactionId,
    required Map<String, dynamic> data,
    DateTime? expectedUpdatedAt,
  }) async {
    final documentRef = _transactionsRef(userId).doc(transactionId);

    if (expectedUpdatedAt == null) {
      await documentRef.set({
        ...data,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      return;
    }

    await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(documentRef);
      if (!snapshot.exists) {
        throw const TransactionConflictException(
          'Esta transação não existe mais no backend.',
        );
      }

      final currentUpdatedAt = _readUpdatedAt(snapshot.data()?['updatedAt']);
      if (currentUpdatedAt == null ||
          !currentUpdatedAt.isAtSameMomentAs(expectedUpdatedAt)) {
        throw const TransactionConflictException();
      }

      transaction.set(documentRef, {
        ...data,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    });
  }

  @override
  Future<void> deleteTransaction({
    required String userId,
    required String transactionId,
  }) async {
    await _transactionsRef(userId).doc(transactionId).delete();
  }

  TransactionRemoteDocument _toRemoteDocument(
    QueryDocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    return TransactionRemoteDocument(id: doc.id, data: doc.data());
  }

  DateTime? _readUpdatedAt(Object? value) {
    if (value is Timestamp) {
      return value.toDate();
    }

    if (value is DateTime) {
      return value;
    }

    return null;
  }
}
