abstract class TransactionLocalDataSource {
  Future<List<Map<String, dynamic>>> loadTransactions();
  Future<void> saveTransactions(List<Map<String, dynamic>> transactions);
}
