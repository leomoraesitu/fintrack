import '../entities/transaction.dart';

abstract class TransactionRepository {
  List<Transaction> getTransactions();
  void addTransaction(Transaction transaction);
  void updateTransaction(Transaction transaction);
  void deleteTransaction(String id);
}