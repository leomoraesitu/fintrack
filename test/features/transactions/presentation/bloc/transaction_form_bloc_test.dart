import 'package:fintrack/features/transactions/domain/entities/transaction.dart';
import 'package:fintrack/features/transactions/domain/entities/transaction_categories.dart';
import 'package:fintrack/features/transactions/domain/entities/transaction_type.dart';
import 'package:fintrack/features/transactions/domain/exceptions/transaction_conflict_exception.dart';
import 'package:fintrack/features/transactions/domain/repositories/transaction_repository.dart';
import 'package:fintrack/features/transactions/presentation/bloc/transaction_form_bloc.dart';
import 'package:fintrack/features/transactions/presentation/bloc/transaction_form_event.dart';
import 'package:fintrack/features/transactions/presentation/bloc/transaction_form_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('emite conflito explicito quando update remoto encontra versao divergente', () async {
    final repository = _ConflictTransactionRepository();
    final bloc = TransactionFormBloc(repository: repository);
    addTearDown(bloc.close);

    bloc.add(TransactionUpdated(_transaction(id: 'tx-1')));

    await expectLater(
      bloc.stream,
      emitsInOrder([
        isA<TransactionFormSubmitting>(),
        isA<TransactionFormConflict>().having(
          (state) => state.message,
          'message',
          contains('outro dispositivo'),
        ),
      ]),
    );
  });
}

Transaction _transaction({required String id}) {
  return Transaction(
    id: id,
    type: TransactionType.expense,
    amount: 82.5,
    date: DateTime(2026, 4, 6),
    description: 'Supermercado',
    category: TransactionCategories.food,
    updatedAt: DateTime(2026, 4, 8, 12),
  );
}

class _ConflictTransactionRepository implements TransactionRepository {
  @override
  Future<void> addTransaction(Transaction transaction) async {}

  @override
  Future<void> deleteTransaction(String id) async {}

  @override
  Future<List<Transaction>> getTransactions() async => [];

  @override
  Future<void> updateTransaction(Transaction transaction) async {
    throw const TransactionConflictException();
  }

  @override
  Stream<List<Transaction>> watchTransactions() {
    return const Stream<List<Transaction>>.empty();
  }
}