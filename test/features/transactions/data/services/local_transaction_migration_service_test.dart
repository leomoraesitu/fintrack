import 'package:fintrack/features/transactions/data/datasources/transaction_local_data_source.dart';
import 'package:fintrack/features/transactions/data/datasources/transaction_remote_data_source.dart';
import 'package:fintrack/features/transactions/data/models/transaction_firestore_mapper.dart';
import 'package:fintrack/features/transactions/data/models/transaction_storage_mapper.dart';
import 'package:fintrack/features/transactions/data/services/local_transaction_migration_service.dart';
import 'package:fintrack/features/transactions/domain/entities/transaction.dart';
import 'package:fintrack/features/transactions/domain/entities/transaction_categories.dart';
import 'package:fintrack/features/transactions/domain/entities/transaction_type.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LocalTransactionMigrationService', () {
    test(
      'migra apenas transacoes locais que ainda nao existem no remoto',
      () async {
        final localTransactions = [
          _transaction(id: 'local-only', description: 'Local'),
          _transaction(id: 'already-remote', description: 'Duplicada'),
        ];
        final localDataSource = _FakeTransactionLocalDataSource(
          transactions: localTransactions
              .map(TransactionStorageMapper.toMap)
              .toList(),
        );
        final remoteDataSource = _FakeTransactionRemoteDataSource(
          documents: [
            TransactionRemoteDocument(
              id: 'already-remote',
              data: TransactionFirestoreMapper.toDocument(
                _transaction(id: 'already-remote', description: 'Remota'),
              ),
            ),
          ],
        );
        final service = LocalTransactionMigrationService(
          localDataSource: localDataSource,
          remoteDataSource: remoteDataSource,
        );

        await service.migrate(userId: 'user-1');

        expect(remoteDataSource.loadedUserId, 'user-1');
        expect(remoteDataSource.savedTransactions, hasLength(1));
        expect(
          remoteDataSource.savedTransactions.single.transactionId,
          'local-only',
        );
        expect(remoteDataSource.savedTransactions.single.userId, 'user-1');
        expect(localDataSource.savedTransactions, isNull);
      },
    );
  });
}

Transaction _transaction({required String id, required String description}) {
  return Transaction(
    id: id,
    type: TransactionType.income,
    amount: 3500,
    date: DateTime(2026, 4, 5),
    description: description,
    category: TransactionCategories.salary,
  );
}

class _FakeTransactionLocalDataSource implements TransactionLocalDataSource {
  _FakeTransactionLocalDataSource({required this.transactions});

  final List<Map<String, dynamic>> transactions;
  List<Map<String, dynamic>>? savedTransactions;

  @override
  Future<List<Map<String, dynamic>>> loadTransactions() async {
    return transactions;
  }

  @override
  Future<void> saveTransactions(List<Map<String, dynamic>> transactions) async {
    savedTransactions = transactions;
  }
}

class _FakeTransactionRemoteDataSource implements TransactionRemoteDataSource {
  _FakeTransactionRemoteDataSource({required this.documents});

  final List<TransactionRemoteDocument> documents;
  final List<_SavedTransaction> savedTransactions = [];
  String? loadedUserId;

  @override
  Future<List<TransactionRemoteDocument>> loadTransactions({
    required String userId,
  }) async {
    loadedUserId = userId;
    return documents;
  }

  @override
  Stream<List<TransactionRemoteDocument>> watchTransactions({
    required String userId,
  }) {
    return Stream.value(documents);
  }

  @override
  Future<void> saveTransaction({
    required String userId,
    required String transactionId,
    required Map<String, dynamic> data,
    DateTime? expectedUpdatedAt,
  }) async {
    savedTransactions.add(
      _SavedTransaction(
        userId: userId,
        transactionId: transactionId,
        data: data,
      ),
    );
  }

  @override
  Future<void> deleteTransaction({
    required String userId,
    required String transactionId,
  }) async {}
}

class _SavedTransaction {
  const _SavedTransaction({
    required this.userId,
    required this.transactionId,
    required this.data,
  });

  final String userId;
  final String transactionId;
  final Map<String, dynamic> data;
}
