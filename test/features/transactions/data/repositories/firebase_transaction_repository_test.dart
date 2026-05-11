import 'dart:async';

import 'package:fintrack/features/transactions/data/datasources/transaction_remote_data_source.dart';
import 'package:fintrack/features/transactions/data/models/transaction_firestore_mapper.dart';
import 'package:fintrack/features/transactions/data/repositories/firebase_transaction_repository.dart';
import 'package:fintrack/features/transactions/domain/entities/transaction.dart';
import 'package:fintrack/features/transactions/domain/entities/transaction_categories.dart';
import 'package:fintrack/features/transactions/domain/entities/transaction_type.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FirebaseTransactionRepository', () {
    test('deve carregar transacoes do data source remoto', () async {
      final transaction = _transaction(id: 'transaction-1');
      final remoteDataSource = _FakeTransactionRemoteDataSource(
        documents: [
          TransactionRemoteDocument(
            id: transaction.id,
            data: TransactionFirestoreMapper.toDocument(transaction),
          ),
        ],
      );
      final repository = FirebaseTransactionRepository(
        remoteDataSource: remoteDataSource,
        userId: 'user-1',
      );

      final transactions = await repository.getTransactions();

      expect(remoteDataSource.loadedUserId, 'user-1');
      expect(transactions, hasLength(1));
      expect(transactions.first.id, 'transaction-1');
      expect(transactions.first.description, 'Salário');
    });

    test('deve observar transacoes do data source remoto', () async {
      final transaction = _transaction(id: 'transaction-1');
      final remoteDataSource = _FakeTransactionRemoteDataSource();
      final repository = FirebaseTransactionRepository(
        remoteDataSource: remoteDataSource,
        userId: 'user-1',
      );

      final expectedEmission = expectLater(
        repository.watchTransactions(),
        emits(
          predicate<List<Transaction>>(
            (transactions) =>
                transactions.length == 1 &&
                transactions.first.id == 'transaction-1' &&
                transactions.first.description == 'Salário',
          ),
        ),
      );

      remoteDataSource.emitDocuments([
        TransactionRemoteDocument(
          id: transaction.id,
          data: TransactionFirestoreMapper.toDocument(transaction),
        ),
      ]);

      await expectedEmission;
      expect(remoteDataSource.watchedUserId, 'user-1');
    });

    test('deve salvar uma nova transacao no data source remoto', () async {
      final transaction = _transaction(id: 'transaction-1');
      final remoteDataSource = _FakeTransactionRemoteDataSource();
      final repository = FirebaseTransactionRepository(
        remoteDataSource: remoteDataSource,
        userId: 'user-1',
      );

      await repository.addTransaction(transaction);

      expect(remoteDataSource.savedUserId, 'user-1');
      expect(remoteDataSource.savedTransactionId, 'transaction-1');
      expect(remoteDataSource.savedData?['description'], 'Salário');
    });

    test('deve atualizar uma transacao no data source remoto', () async {
      final updatedAt = DateTime(2026, 4, 8, 12);
      final transaction = _transaction(
        id: 'transaction-1',
        description: 'Salário atualizado',
        updatedAt: updatedAt,
      );
      final remoteDataSource = _FakeTransactionRemoteDataSource();
      final repository = FirebaseTransactionRepository(
        remoteDataSource: remoteDataSource,
        userId: 'user-1',
      );

      await repository.updateTransaction(transaction);

      expect(remoteDataSource.savedUserId, 'user-1');
      expect(remoteDataSource.savedTransactionId, 'transaction-1');
      expect(remoteDataSource.savedData?['description'], 'Salário atualizado');
      expect(remoteDataSource.savedExpectedUpdatedAt, updatedAt);
    });

    test('deve excluir uma transacao do data source remoto', () async {
      final remoteDataSource = _FakeTransactionRemoteDataSource();
      final repository = FirebaseTransactionRepository(
        remoteDataSource: remoteDataSource,
        userId: 'user-1',
      );

      await repository.deleteTransaction('transaction-1');

      expect(remoteDataSource.deletedUserId, 'user-1');
      expect(remoteDataSource.deletedTransactionId, 'transaction-1');
    });
  });
}

Transaction _transaction({
  required String id,
  String description = 'Salário',
  DateTime? updatedAt,
}) {
  return Transaction(
    id: id,
    type: TransactionType.income,
    amount: 3500,
    date: DateTime(2026, 4, 5),
    description: description,
    category: TransactionCategories.salary,
    updatedAt: updatedAt,
  );
}

class _FakeTransactionRemoteDataSource implements TransactionRemoteDataSource {
  _FakeTransactionRemoteDataSource({
    List<TransactionRemoteDocument> documents = const [],
  }) : _documents = documents;

  final List<TransactionRemoteDocument> _documents;
  final StreamController<List<TransactionRemoteDocument>> _controller =
      StreamController<List<TransactionRemoteDocument>>();

  String? loadedUserId;
  String? watchedUserId;
  String? savedUserId;
  String? savedTransactionId;
  Map<String, dynamic>? savedData;
  DateTime? savedExpectedUpdatedAt;
  String? deletedUserId;
  String? deletedTransactionId;

  @override
  Future<List<TransactionRemoteDocument>> loadTransactions({
    required String userId,
  }) async {
    loadedUserId = userId;
    return _documents;
  }

  @override
  Stream<List<TransactionRemoteDocument>> watchTransactions({
    required String userId,
  }) {
    watchedUserId = userId;
    return _controller.stream;
  }

  void emitDocuments(List<TransactionRemoteDocument> documents) {
    _controller.add(documents);
  }

  @override
  Future<void> saveTransaction({
    required String userId,
    required String transactionId,
    required Map<String, dynamic> data,
    DateTime? expectedUpdatedAt,
  }) async {
    savedUserId = userId;
    savedTransactionId = transactionId;
    savedData = data;
    savedExpectedUpdatedAt = expectedUpdatedAt;
  }

  @override
  Future<void> deleteTransaction({
    required String userId,
    required String transactionId,
  }) async {
    deletedUserId = userId;
    deletedTransactionId = transactionId;
  }
}
