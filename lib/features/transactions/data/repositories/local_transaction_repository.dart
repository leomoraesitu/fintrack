import 'dart:async';

import 'package:fintrack/features/transactions/data/datasources/transaction_local_data_source.dart';
import 'package:fintrack/features/transactions/data/models/transaction_storage_mapper.dart';
import 'package:fintrack/features/transactions/domain/entities/transaction.dart';
import 'package:fintrack/features/transactions/domain/repositories/transaction_repository.dart';

class LocalTransactionRepository implements TransactionRepository {
  LocalTransactionRepository({
    required TransactionLocalDataSource localDataSource,
    List<Transaction>? initialTransactions,
  }) : _localDataSource = localDataSource,
       _transactions = List<Transaction>.from(initialTransactions ?? []);

  final TransactionLocalDataSource _localDataSource;
  final List<Transaction> _transactions;
  final StreamController<List<Transaction>> _transactionsController =
      StreamController<List<Transaction>>.broadcast();

  @override
  Future<List<Transaction>> getTransactions() async {
    return List.unmodifiable(_transactions);
  }

  @override
  Stream<List<Transaction>> watchTransactions() {
    return _transactionsController.stream;
  }

  @override
  Future<void> addTransaction(Transaction transaction) async {
    _transactions.add(transaction);
    await _persist();
  }

  @override
  Future<void> updateTransaction(Transaction transaction) async {
    final index = _transactions.indexWhere((item) => item.id == transaction.id);
    if (index == -1) {
      return;
    }

    _transactions[index] = transaction;
    await _persist();
  }

  @override
  Future<void> deleteTransaction(String id) async {
    _transactions.removeWhere((item) => item.id == id);
    await _persist();
  }

  Future<void> _persist() async {
    final payload = _transactions.map(TransactionStorageMapper.toMap).toList();
    await _localDataSource.saveTransactions(payload);
    _transactionsController.add(List.unmodifiable(_transactions));
  }
}
