import 'package:fintrack/features/transactions/domain/entities/transaction.dart';
import 'package:fintrack/features/transactions/domain/entities/transaction_category.dart';
import 'package:fintrack/features/transactions/presentation/pages/transaction_form_page.dart';
import 'package:fintrack/features/transactions/presentation/widgets/transaction_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fintrack/features/transactions/domain/repositories/transaction_repository.dart';

import '../bloc/transaction_list_bloc.dart';
import '../bloc/transaction_list_event.dart';
import '../bloc/transaction_list_state.dart';

import 'package:fintrack/features/transactions/domain/entities/transaction_list_query.dart';
import 'package:fintrack/features/transactions/domain/entities/transaction_type.dart';
import 'package:fintrack/features/transactions/domain/entities/transaction_categories.dart';

class TransactionsPage extends StatelessWidget {
  const TransactionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          TransactionListBloc(repository: context.read<TransactionRepository>())
            ..add(TransactionListRequested()),
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
  TransactionListQuery _currentQuery = const TransactionListQuery();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionListBloc, TransactionListState>(
      builder: (context, state) {
        if (state is TransactionListLoading ||
            state is TransactionListInitial) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is TransactionListEmpty || state is TransactionListSuccess) {
          final transactions = state is TransactionListSuccess
              ? state.transactions
              : const <Transaction>[];

          return Column(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Row(
                  children: [
                    ChoiceChip(
                      label: const Text('Todas'),
                      selected: _currentQuery.type == null,
                      onSelected: (_) => _updateTypeFilter(null),
                    ),
                    const SizedBox(width: 8),
                    ChoiceChip(
                      label: const Text('Receitas'),
                      selected: _currentQuery.type == TransactionType.income,
                      onSelected: (_) =>
                          _updateTypeFilter(TransactionType.income),
                    ),
                    const SizedBox(width: 8),
                    ChoiceChip(
                      label: const Text('Despesas'),
                      selected: _currentQuery.type == TransactionType.expense,
                      onSelected: (_) =>
                          _updateTypeFilter(TransactionType.expense),
                    ),
                  ],
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: Row(
                  children: [
                    ChoiceChip(
                      label: const Text('Todas as categorias'),
                      selected: _currentQuery.categoryId == null,
                      onSelected: (_) => _updateCategoryFilter(null),
                    ),
                    const SizedBox(width: 8),
                    ..._availableCategories().map(
                      (category) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(category.label),
                          selected: _currentQuery.categoryId == category.id,
                          onSelected: (_) => _updateCategoryFilter(category.id),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: Row(
                  children: [
                    ChoiceChip(
                      label: const Text('Todo o período'),
                      selected: _currentQuery.period == null,
                      onSelected: (_) => _updatePeriodFilter(null),
                    ),
                    const SizedBox(width: 8),
                    ChoiceChip(
                      label: const Text('Últimos 7 dias'),
                      selected: _samePeriod(
                        _currentQuery.period,
                        _last7DaysPeriod(),
                      ),
                      onSelected: (_) =>
                          _updatePeriodFilter(_last7DaysPeriod()),
                    ),
                    const SizedBox(width: 8),
                    ChoiceChip(
                      label: const Text('Este mês'),
                      selected: _samePeriod(
                        _currentQuery.period,
                        _currentMonthPeriod(),
                      ),
                      onSelected: (_) =>
                          _updatePeriodFilter(_currentMonthPeriod()),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: transactions.isEmpty
                    ? const Center(
                        child: Text(
                          'Nenhuma transação encontrada para os filtros selecionados',
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                        itemCount: transactions.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final transaction = transactions[index];
                          return TransactionListItem(
                            transaction: transaction,
                            onTap: () =>
                                _openTransactionForm(context, transaction),
                          );
                        },
                      ),
              ),
            ],
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
      context.read<TransactionListBloc>().add(
        TransactionListRequested(query: _currentQuery),
      );
    }
  }

  void _applyQuery(TransactionListQuery query) {
    setState(() {
      _currentQuery = query;
    });

    context.read<TransactionListBloc>().add(
      TransactionListRequested(query: query),
    );
  }

  bool _isCategoryCompatibleWithType(
    String? categoryId,
    TransactionType? type,
  ) {
    if (categoryId == null || type == null) {
      return true;
    }

    return TransactionCategories.all.any(
      (category) => category.id == categoryId && category.type == type,
    );
  }

  void _updateTypeFilter(TransactionType? type) {
    final nextCategoryId =
        _isCategoryCompatibleWithType(_currentQuery.categoryId, type)
        ? _currentQuery.categoryId
        : null;

    _applyQuery(
      TransactionListQuery(
        type: type,
        categoryId: nextCategoryId,
        period: _currentQuery.period,
        sortOrder: _currentQuery.sortOrder,
      ),
    );
  }

  void _updateCategoryFilter(String? categoryId) {
    _applyQuery(
      TransactionListQuery(
        type: _currentQuery.type,
        categoryId: categoryId,
        period: _currentQuery.period,
        sortOrder: _currentQuery.sortOrder,
      ),
    );
  }

  void _updatePeriodFilter(TransactionPeriodFilter? period) {
    _applyQuery(
      TransactionListQuery(
        type: _currentQuery.type,
        categoryId: _currentQuery.categoryId,
        period: period,
        sortOrder: _currentQuery.sortOrder,
      ),
    );
  }

  TransactionPeriodFilter _currentMonthPeriod() {
    final now = DateTime(2026, 4, 13);

    return TransactionPeriodFilter(
      startDate: DateTime(now.year, now.month, 1),
      endDate: DateTime(now.year, now.month + 1, 0),
    );
  }

  TransactionPeriodFilter _last7DaysPeriod() {
    final now = DateTime(2026, 4, 13);

    return TransactionPeriodFilter(
      startDate: now.subtract(const Duration(days: 6)),
      endDate: now,
    );
  }

  bool _samePeriod(
    TransactionPeriodFilter? first,
    TransactionPeriodFilter? second,
  ) {
    if (first == null && second == null) {
      return true;
    }

    if (first == null || second == null) {
      return false;
    }

    return first.startDate == second.startDate &&
        first.endDate == second.endDate;
  }

  List<TransactionCategory> _availableCategories() {
    if (_currentQuery.type == TransactionType.income) {
      return TransactionCategories.incomeCategories;
    }

    if (_currentQuery.type == TransactionType.expense) {
      return TransactionCategories.expenseCategories;
    }

    return TransactionCategories.all;
  }
}
