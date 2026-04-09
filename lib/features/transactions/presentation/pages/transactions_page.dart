import 'package:fintrack/features/transactions/presentation/widgets/transaction_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fintrack/features/transactions/domain/repositories/transaction_repository.dart';

import '../bloc/transaction_list_bloc.dart';
import '../bloc/transaction_list_event.dart';
import '../bloc/transaction_list_state.dart';

class TransactionsPage extends StatelessWidget {
  const TransactionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          TransactionListBloc(repository: context.read<TransactionRepository>())
            ..add(const TransactionListRequested()),
      child: const _TransactionsView(),
    );
  }
}

class _TransactionsView extends StatelessWidget {
  const _TransactionsView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionListBloc, TransactionListState>(
      builder: (context, state) {
        if (state is TransactionListLoading ||
            state is TransactionListInitial) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is TransactionListEmpty) {
          return const Center(
            child: Text('Nenhuma transação cadastrada ainda'),
          );
        }

        if (state is TransactionListSuccess) {
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: state.transactions.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final transaction = state.transactions[index];
              return TransactionListItem(transaction: transaction);
            },
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
