class TransactionConflictException implements Exception {
  const TransactionConflictException([
    this.message =
        'Esta transação foi alterada em outro dispositivo. Reabra e tente novamente.',
  ]);

  final String message;

  @override
  String toString() => message;
}