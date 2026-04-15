import 'package:fintrack/features/transactions/domain/entities/transaction.dart';
import 'package:fintrack/features/transactions/presentation/pages/transaction_form_page.dart';
import 'package:fintrack/features/transactions/presentation/widgets/transaction_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/transaction_list_bloc.dart';
import '../bloc/transaction_list_event.dart';
import '../bloc/transaction_list_state.dart';

import 'package:fintrack/features/transactions/domain/entities/transaction_category.dart';
import 'package:fintrack/features/transactions/domain/entities/transaction_list_query.dart';
import 'package:fintrack/features/transactions/domain/entities/transaction_type.dart';
import 'package:fintrack/features/transactions/domain/entities/transaction_categories.dart';
import 'package:fintrack/features/transactions/domain/repositories/transaction_repository.dart';

class TransactionsPage extends StatelessWidget {
  const TransactionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          TransactionListBloc(repository: context.read<TransactionRepository>())
            ..add(TransactionListRequested()),
      child: const TransactionsView(),
    );
  }
}

class TransactionsView extends StatefulWidget {
  const TransactionsView({super.key});

  @override
  State<TransactionsView> createState() => _TransactionsViewState();
}

class _TransactionsViewState extends State<TransactionsView> {
  TransactionListQuery _currentQuery = const TransactionListQuery();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionListBloc, TransactionListState>(
      builder: (context, state) {
        if (state is TransactionListLoading ||
            state is TransactionListInitial) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is TransactionListError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, size: 48),
                  const SizedBox(height: 16),
                  Text(
                    state.message,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () {
                      context.read<TransactionListBloc>().add(
                        TransactionListRequested(query: state.query),
                      );
                    },
                    child: const Text('Tentar novamente'),
                  ),
                ],
              ),
            ),
          );
        }

        if (state is TransactionListEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.inbox_outlined, size: 48),
                  SizedBox(height: 16),
                  Text(
                    'Nenhuma transação encontrada',
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Adicione uma transação ou ajuste os filtros para visualizar resultados.',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }

        if (state is TransactionListSuccess) {
          final transactions = state.transactions;

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _openFiltersBottomSheet,
                        icon: const Icon(Icons.filter_alt_outlined),
                        label: const Text('Filtros'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    PopupMenuButton<TransactionSortOrder>(
                      tooltip: 'Ordenar',
                      onSelected: _updateSortOrder,
                      itemBuilder: (context) => const [
                        PopupMenuItem(
                          value: TransactionSortOrder.newestFirst,
                          child: Text('Mais recentes'),
                        ),
                        PopupMenuItem(
                          value: TransactionSortOrder.oldestFirst,
                          child: Text('Mais antigas'),
                        ),
                      ],
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Theme.of(context).colorScheme.outline,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.swap_vert),
                            const SizedBox(width: 8),
                            Text(_currentSortLabel()),
                          ],
                        ),
                      ),
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

  Future<void> _openFiltersBottomSheet() async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) {
        TransactionType? draftType = _currentQuery.type;
        String? draftCategoryId = _currentQuery.categoryId;
        TransactionPeriodFilter? draftPeriod = _currentQuery.period;

        bool isCategoryCompatibleWithDraftType(
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

        List<TransactionCategory> availableDraftCategories() {
          if (draftType == TransactionType.income) {
            return TransactionCategories.incomeCategories;
          }

          if (draftType == TransactionType.expense) {
            return TransactionCategories.expenseCategories;
          }

          return TransactionCategories.all;
        }

        return StatefulBuilder(
          builder: (context, setModalState) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Filtros',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Tipo',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          ChoiceChip(
                            label: const Text('Todas'),
                            selected: draftType == null,
                            onSelected: (_) {
                              setModalState(() {
                                draftType = null;
                              });
                            },
                          ),
                          ChoiceChip(
                            label: const Text('Receitas'),
                            selected: draftType == TransactionType.income,
                            onSelected: (_) {
                              setModalState(() {
                                draftType = TransactionType.income;
                                if (!isCategoryCompatibleWithDraftType(
                                  draftCategoryId,
                                  draftType,
                                )) {
                                  draftCategoryId = null;
                                }
                              });
                            },
                          ),
                          ChoiceChip(
                            label: const Text('Despesas'),
                            selected: draftType == TransactionType.expense,
                            onSelected: (_) {
                              setModalState(() {
                                draftType = TransactionType.expense;
                                if (!isCategoryCompatibleWithDraftType(
                                  draftCategoryId,
                                  draftType,
                                )) {
                                  draftCategoryId = null;
                                }
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Categoria',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          ChoiceChip(
                            label: const Text('Todas as categorias'),
                            selected: draftCategoryId == null,
                            onSelected: (_) {
                              setModalState(() {
                                draftCategoryId = null;
                              });
                            },
                          ),
                          ...availableDraftCategories().map(
                            (category) => ChoiceChip(
                              label: Text(category.label),
                              selected: draftCategoryId == category.id,
                              onSelected: (_) {
                                setModalState(() {
                                  draftCategoryId = category.id;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Período',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          ChoiceChip(
                            label: const Text('Todo o período'),
                            selected: draftPeriod == null,
                            onSelected: (_) {
                              setModalState(() {
                                draftPeriod = null;
                              });
                            },
                          ),
                          ChoiceChip(
                            label: const Text('Últimos 7 dias'),
                            selected: _samePeriod(
                              draftPeriod,
                              _last7DaysPeriod(),
                            ),
                            onSelected: (_) {
                              setModalState(() {
                                draftPeriod = _last7DaysPeriod();
                              });
                            },
                          ),
                          ChoiceChip(
                            label: const Text('Este mês'),
                            selected: _samePeriod(
                              draftPeriod,
                              _currentMonthPeriod(),
                            ),
                            onSelected: (_) {
                              setModalState(() {
                                draftPeriod = _currentMonthPeriod();
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                setModalState(() {
                                  draftType = null;
                                  draftCategoryId = null;
                                  draftPeriod = null;
                                });
                              },
                              child: const Text('Limpar'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: FilledButton(
                              onPressed: () {
                                _applyQuery(
                                  TransactionListQuery(
                                    type: draftType,
                                    categoryId: draftCategoryId,
                                    period: draftPeriod,
                                    sortOrder: _currentQuery.sortOrder,
                                  ),
                                );

                                Navigator.of(context).pop();
                              },
                              child: const Text('Aplicar filtros'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _applyQuery(TransactionListQuery query) {
    setState(() {
      _currentQuery = query;
    });

    context.read<TransactionListBloc>().add(
      TransactionListRequested(query: query),
    );
  }

  void _updateSortOrder(TransactionSortOrder sortOrder) {
    _applyQuery(
      TransactionListQuery(
        type: _currentQuery.type,
        categoryId: _currentQuery.categoryId,
        period: _currentQuery.period,
        sortOrder: sortOrder,
      ),
    );
  }

  String _currentSortLabel() {
    switch (_currentQuery.sortOrder) {
      case TransactionSortOrder.oldestFirst:
        return 'Mais antigas';
      case TransactionSortOrder.newestFirst:
        return 'Mais recentes';
    }
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
}
