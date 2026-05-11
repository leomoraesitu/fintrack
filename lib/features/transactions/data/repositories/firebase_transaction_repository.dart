import 'package:fintrack/features/transactions/data/datasources/transaction_remote_data_source.dart';
import 'package:fintrack/features/transactions/data/models/transaction_firestore_mapper.dart';
import 'package:fintrack/features/transactions/domain/entities/transaction.dart';
import 'package:fintrack/features/transactions/domain/repositories/transaction_repository.dart';

class FirebaseTransactionRepository implements TransactionRepository {
  const FirebaseTransactionRepository({
    required TransactionRemoteDataSource remoteDataSource,
    required String userId,
  }) : _remoteDataSource = remoteDataSource,
       _userId = userId;

  final TransactionRemoteDataSource _remoteDataSource;
  final String _userId;

  @override
  Future<List<Transaction>> getTransactions() async {
    final documents = await _remoteDataSource.loadTransactions(userId: _userId);

    return _mapDocuments(documents);
  }

  @override
  Stream<List<Transaction>> watchTransactions() {
    return _remoteDataSource
        .watchTransactions(userId: _userId)
        .map(_mapDocuments);
  }

  @override
  Future<void> addTransaction(Transaction transaction) async {
    await _save(transaction);
  }

  @override
  Future<void> updateTransaction(Transaction transaction) async {
    await _save(transaction);
  }

  @override
  Future<void> deleteTransaction(String id) async {
    await _remoteDataSource.deleteTransaction(
      userId: _userId,
      transactionId: id,
    );
  }

  Future<void> _save(Transaction transaction) async {
    await _remoteDataSource.saveTransaction(
      userId: _userId,
      transactionId: transaction.id,
      data: TransactionFirestoreMapper.toDocument(transaction),
      expectedUpdatedAt: transaction.updatedAt,
    );
  }

  List<Transaction> _mapDocuments(List<TransactionRemoteDocument> documents) {
    return documents
        .map(
          (document) => TransactionFirestoreMapper.fromDocument(
            id: document.id,
            data: document.data,
          ),
        )
        .toList();
  }
}
