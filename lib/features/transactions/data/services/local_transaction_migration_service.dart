import 'package:fintrack/features/transactions/data/datasources/transaction_local_data_source.dart';
import 'package:fintrack/features/transactions/data/datasources/transaction_remote_data_source.dart';
import 'package:fintrack/features/transactions/data/models/transaction_firestore_mapper.dart';
import 'package:fintrack/features/transactions/data/models/transaction_storage_mapper.dart';

class LocalTransactionMigrationService {
  const LocalTransactionMigrationService({
    required TransactionLocalDataSource localDataSource,
    required TransactionRemoteDataSource remoteDataSource,
  }) : _localDataSource = localDataSource,
       _remoteDataSource = remoteDataSource;

  final TransactionLocalDataSource _localDataSource;
  final TransactionRemoteDataSource _remoteDataSource;

  Future<void> migrate({required String userId}) async {
    final localPayload = await _localDataSource.loadTransactions();
    if (localPayload.isEmpty) {
      return;
    }

    final remoteDocuments = await _remoteDataSource.loadTransactions(
      userId: userId,
    );
    final remoteIds = remoteDocuments.map((document) => document.id).toSet();

    for (final localData in localPayload) {
      final transaction = TransactionStorageMapper.fromMap(localData);
      if (remoteIds.contains(transaction.id)) {
        continue;
      }

      await _remoteDataSource.saveTransaction(
        userId: userId,
        transactionId: transaction.id,
        data: TransactionFirestoreMapper.toDocument(transaction),
      );
    }
  }
}
