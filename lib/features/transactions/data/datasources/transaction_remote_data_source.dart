class TransactionRemoteDocument {
  const TransactionRemoteDocument({required this.id, required this.data});

  final String id;
  final Map<String, dynamic> data;
}

abstract class TransactionRemoteDataSource {
  Future<List<TransactionRemoteDocument>> loadTransactions({
    required String userId,
  });

  Stream<List<TransactionRemoteDocument>> watchTransactions({
    required String userId,
  });

  Future<void> saveTransaction({
    required String userId,
    required String transactionId,
    required Map<String, dynamic> data,
    DateTime? expectedUpdatedAt,
  });

  Future<void> deleteTransaction({
    required String userId,
    required String transactionId,
  });
}
