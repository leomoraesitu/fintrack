import 'package:fintrack/features/transactions/domain/entities/transaction.dart';
import 'package:fintrack/features/transactions/domain/repositories/transaction_repository.dart';

class InMemoryTransactionRepository implements TransactionRepository {
  InMemoryTransactionRepository({List<Transaction>? initialTransactions})
    : _transactions = List<Transaction>.from(initialTransactions ?? []);

  final List<Transaction> _transactions;

  @override
  List<Transaction> getTransactions() {
    return List.unmodifiable(_transactions);
  }

  @override
  void addTransaction(Transaction transaction) {
    _transactions.add(transaction);
  }

  @override
  void updateTransaction(Transaction transaction) {
    final index = _transactions.indexWhere((item) => item.id == transaction.id);
    if (index == -1) {
      return;
    }

    _transactions[index] = transaction;
  }

  @override
  void deleteTransaction(String id) {
    _transactions.removeWhere((item) => item.id == id);
  }
}
