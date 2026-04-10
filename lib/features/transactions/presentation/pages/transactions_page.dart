import 'package:fintrack/features/transactions/domain/entities/transaction.dart';
import 'package:fintrack/features/transactions/presentation/pages/transaction_form_page.dart';
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

class _TransactionsView extends StatefulWidget {
  const _TransactionsView();

  @override
  State<_TransactionsView> createState() => _TransactionsViewState();
}

class _TransactionsViewState extends State<_TransactionsView> {
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
          final transactions = state.transactions;

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: transactions.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final transaction = transactions[index];
              return TransactionListItem(
                transaction: transaction,
                onTap: () => _openTransactionForm(context, transaction),
              );
            },
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Future<void> _openTransactionForm(
    BuildContext context,
    Transaction transaction,
  ) async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => TransactionFormPage(transaction: transaction),
      ),
    );

    if (!context.mounted) return;

    if (result == true) {
      context.read<TransactionListBloc>().add(const TransactionListRequested());
    }
  }
}
