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

  @override
  List<Transaction> getTransactions() {
    return List.unmodifiable(_transactions);
  }

  @override
  void addTransaction(Transaction transaction) {
    _transactions.add(transaction);
    _persist();
  }

  @override
  void updateTransaction(Transaction transaction) {
    final index = _transactions.indexWhere((item) => item.id == transaction.id);
    if (index == -1) {
      return;
    }

    _transactions[index] = transaction;
    _persist();
  }

  @override
  void deleteTransaction(String id) {
    _transactions.removeWhere((item) => item.id == id);
    _persist();
  }

  void _persist() {
    final payload = _transactions.map(TransactionStorageMapper.toMap).toList();
    _localDataSource.saveTransactions(payload);
  }
}
