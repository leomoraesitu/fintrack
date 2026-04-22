import 'package:fintrack/features/transactions/domain/entities/transaction.dart';
import 'package:fintrack/features/transactions/presentation/mappers/transaction_category_icon_mapper.dart';
import 'package:fintrack/features/transactions/presentation/pages/transaction_form_page.dart';
import 'package:fintrack/features/transactions/presentation/widgets/transaction_list_item.dart';
import 'package:fintrack/design_system/widgets/widgets.dart';
import 'package:fintrack/shared/tokens/tokens.dart';
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
  const TransactionsPage({super.key, this.refreshSignal});

  final int? refreshSignal;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          TransactionListBloc(repository: context.read<TransactionRepository>())
            ..add(TransactionListRequested()),
      child: TransactionsView(refreshSignal: refreshSignal),
    );
  }
}

class TransactionsView extends StatefulWidget {
  const TransactionsView({super.key, this.refreshSignal});

  final int? refreshSignal;

  @override
  State<TransactionsView> createState() => _TransactionsViewState();
}

class _TransactionsViewState extends State<TransactionsView> {
  TransactionListQuery _currentQuery = const TransactionListQuery();

  @override
  void didUpdateWidget(covariant TransactionsView oldWidget) {
    super.didUpdateWidget(oldWidget);

    final oldSignal = oldWidget.refreshSignal ?? 0;
    final newSignal = widget.refreshSignal ?? 0;
    if (oldSignal == newSignal) {
      return;
    }

    context.read<TransactionListBloc>().add(
      TransactionListRequested(query: _currentQuery),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;
    return BlocBuilder<TransactionListBloc, TransactionListState>(
      builder: (context, state) {
        if (state is TransactionListLoading ||
            state is TransactionListInitial) {
          return const FtLoadingState();
        }

        if (state is TransactionListError) {
          return FtErrorState(
            message: state.message,
            onRetry: () {
              context.read<TransactionListBloc>().add(
                TransactionListRequested(query: state.query),
              );
            },
          );
        }

        if (state is TransactionListEmpty) {
          return const FtEmptyState(
            title: 'Nenhuma transação encontrada',
            message:
                'Adicione uma transação ou ajuste os filtros para visualizar resultados.',
          );
        }

        if (state is TransactionListSuccess) {
          final transactions = state.transactions;

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.md,
                  AppSpacing.md,
                  AppSpacing.md,
                  AppSpacing.sm,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: FtButton(
                        onPressed: _openFiltersBottomSheet,
                        label: 'Filtros',
                        icon: Icon(Icons.filter_alt_outlined),
                        size: FtButtonSize.large,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.xm),
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
                        height: AppSizes.buttonLg,
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.xm,
                          vertical: AppSpacing.xm,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.primary,
                          borderRadius: BorderRadius.circular(
                            AppBorders.radiusS,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.swap_vert, color: colorScheme.onPrimary),
                            const SizedBox(width: AppSpacing.sm),
                            Text(
                              _currentSortLabel(),
                              style: textTheme.labelLarge?.copyWith(
                                color: colorScheme.onPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: transactions.isEmpty
                    ? const FtEmptyState(
                        title: 'Nenhuma transação encontrada',
                        message:
                            'Nenhuma transação encontrada para os filtros selecionados',
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(
                          AppSpacing.md,
                          AppSpacing.sm,
                          AppSpacing.md,
                          AppSpacing.md,
                        ),
                        itemCount: transactions.length,
                        separatorBuilder: (_, _) => const SizedBox(
                          height: AppSpacing.xm,
                        ),
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
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.md,
                  AppSpacing.sm,
                  AppSpacing.md,
                  AppSpacing.lg,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Filtrar Transações',
                        style: Theme.of(context).textTheme.titleLarge
                      ),
                      const SizedBox(height: AppSpacing.md + AppSpacing.xs),
                      Text(
                        'TIPO',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Wrap(
                        spacing: AppSpacing.sm,
                        runSpacing: AppSpacing.sm,
                        children: [
                          FtChoiceChip(
                            icon: Icons.star,
                            label: 'Todas',
                            selected: draftType == null,
                            onSelected: (_) {
                              setModalState(() {
                                draftType = null;
                              });
                            },
                          ),
                          FtChoiceChip(
                            icon: Icons.arrow_upward_rounded,
                            label: 'Receitas',
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
                          FtChoiceChip(
                            icon: Icons.arrow_downward_rounded,
                            label: 'Despesas',
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
                      const SizedBox(height: AppSpacing.md + AppSpacing.xs),
                      Text(
                        'PERÍODO',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Wrap(
                        spacing: AppSpacing.sm,
                        runSpacing: AppSpacing.sm,
                        children: [
                          FtChoiceChip(
                            icon: Icons.star,
                            label: 'Todo o período',
                            selected: draftPeriod == null,
                            onSelected: (_) {
                              setModalState(() {
                                draftPeriod = null;
                              });
                            },
                          ),
                          FtChoiceChip(
                            icon: Icons.star,
                            label: 'Últimos 7 dias',
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
                          FtChoiceChip(
                            icon: Icons.star,
                            label: 'Este mês',
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
                      const SizedBox(height: AppSpacing.lmd),
                      Text(
                        'CATEGORIA',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Wrap(
                        spacing: AppSpacing.sm,
                        runSpacing: AppSpacing.sm,
                        children: [
                          FtChoiceChip(
                            icon: Icons.star,
                            label: 'Todas as categorias',
                            selected: draftCategoryId == null,
                            onSelected: (_) {
                              setModalState(() {
                                draftCategoryId = null;
                              });
                            },
                          ),
                          ...availableDraftCategories().map(
                            (category) => FtChoiceChip(
                              icon:TransactionCategoryIconMapper.fromCategory(category),
                              label: category.label,
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

                      const SizedBox(height: AppSpacing.lg),
                      Row(
                        children: [
                          Expanded(
                            child: FtButton(
                              variant: FtButtonVariant.outline,
                              label: 'Limpar',
                              //variant: FtButtonVariant.outline,
                              onPressed: () {
                                setModalState(() {
                                  draftType = null;
                                  draftCategoryId = null;
                                  draftPeriod = null;
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: AppSpacing.xm),
                          Expanded(
                            child: FtButton(
                              label: 'Aplicar filtros',
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
    final now = DateTime.now();

    return TransactionPeriodFilter(
      startDate: DateTime(now.year, now.month, 1),
      endDate: DateTime(now.year, now.month + 1, 0),
    );
  }

  TransactionPeriodFilter _last7DaysPeriod() {
    final now = DateTime.now();

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
