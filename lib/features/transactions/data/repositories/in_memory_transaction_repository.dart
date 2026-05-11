import 'dart:async';

import 'package:fintrack/features/transactions/domain/entities/transaction.dart';
import 'package:fintrack/features/transactions/domain/repositories/transaction_repository.dart';

class InMemoryTransactionRepository implements TransactionRepository {
  InMemoryTransactionRepository({List<Transaction>? initialTransactions})
    : _transactions = List<Transaction>.from(initialTransactions ?? []);

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
    _emitTransactions();
  }

  @override
  Future<void> updateTransaction(Transaction transaction) async {
    final index = _transactions.indexWhere((item) => item.id == transaction.id);
    if (index == -1) {
      return;
    }

    _transactions[index] = transaction;
    _emitTransactions();
  }

  @override
  Future<void> deleteTransaction(String id) async {
    _transactions.removeWhere((item) => item.id == id);
    _emitTransactions();
  }

  void _emitTransactions() {
    _transactionsController.add(List.unmodifiable(_transactions));
  }
}
