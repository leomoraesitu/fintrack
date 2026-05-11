import 'dart:async';

import 'package:fintrack/features/transactions/domain/entities/transaction.dart';
import 'package:fintrack/features/transactions/domain/entities/transaction_categories.dart';
import 'package:fintrack/features/transactions/domain/entities/transaction_type.dart';
import 'package:fintrack/features/transactions/domain/repositories/transaction_repository.dart';
import 'package:fintrack/features/transactions/presentation/bloc/transaction_list_bloc.dart';
import 'package:fintrack/features/transactions/presentation/bloc/transaction_list_event.dart';
import 'package:fintrack/features/transactions/presentation/bloc/transaction_list_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'atualiza a lista quando o repositorio emite novas transacoes',
    () async {
      final repository = _FakeTransactionRepository();
      final bloc = TransactionListBloc(repository: repository);
      addTearDown(bloc.close);

      final expectedStates = expectLater(
        bloc.stream,
        emitsInOrder([
          isA<TransactionListLoading>(),
          isA<TransactionListEmpty>(),
          isA<TransactionListSuccess>().having(
            (state) => state.transactions.single.description,
            'description',
            'Salário',
          ),
        ]),
      );

      bloc.add(TransactionListRequested());
      repository.emit([_transaction(id: 'transaction-1')]);

      await expectedStates;
    },
  );
}

Transaction _transaction({required String id}) {
  return Transaction(
    id: id,
    type: TransactionType.income,
    amount: 3500,
    date: DateTime(2026, 4, 5),
    description: 'Salário',
    category: TransactionCategories.salary,
  );
}

class _FakeTransactionRepository implements TransactionRepository {
  final StreamController<List<Transaction>> _controller =
      StreamController<List<Transaction>>();

  @override
  Future<List<Transaction>> getTransactions() async {
    return [];
  }

  @override
  Stream<List<Transaction>> watchTransactions() {
    return _controller.stream;
  }

  void emit(List<Transaction> transactions) {
    _controller.add(transactions);
  }

  @override
  Future<void> addTransaction(Transaction transaction) async {}

  @override
  Future<void> updateTransaction(Transaction transaction) async {}

  @override
  Future<void> deleteTransaction(String id) async {}
}
