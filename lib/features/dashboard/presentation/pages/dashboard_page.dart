import 'package:fintrack/design_system/widgets/widgets.dart';
import 'package:fintrack/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:fintrack/features/dashboard/presentation/bloc/dashboard_event.dart';
import 'package:fintrack/features/dashboard/presentation/bloc/dashboard_state.dart';
import 'package:fintrack/features/transactions/presentation/widgets/transaction_list_item.dart';
import 'package:fintrack/shared/tokens/tokens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class DashboardPage extends StatefulWidget {
  final VoidCallback? onViewAllTransactions;

  const DashboardPage({super.key, this.onViewAllTransactions});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();
    context.read<DashboardBloc>().add(const DashboardRequested());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    final currencyFormat = NumberFormat.currency(
      locale: 'pt_BR',
      symbol: 'R\$',
    );

    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {
        if (state is DashboardInitial || state is DashboardLoading) {
          return const FtLoadingState();
        }

        if (state is DashboardEmpty) {
          return const FtEmptyState(
            title: 'Nenhuma transação para resumir ainda',
            message:
                'Adicione uma transação para visualizar saldo, receitas e despesas.',
          );
        }

        if (state is DashboardError) {
          return FtErrorState(
            message: state.message,
            onRetry: () {
              context.read<DashboardBloc>().add(const DashboardRequested());
            },
          );
        }

        if (state is DashboardSuccess) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: AppSizes.widthFull,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        AppBorders.radiusXL,
                      ),
                    ),
                    color: Theme.of(context).colorScheme.primary,
                    elevation: AppShadows.sm.first.blurRadius,
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'SALDO TOTAL',
                                    style: textTheme.labelMedium?.copyWith(
                                      color: colorScheme.surface,
                                    ),
                                  ),

                                  Text(
                                    currencyFormat.format(state.summary.balance),
                                    style: textTheme.headlineLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: colorScheme.surface,
                                    ),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              Container(
                                width: AppSizes.controlLg,
                                height: AppSizes.controlLg,
                                decoration: BoxDecoration(
                                  color: colorScheme.surface.withAlpha(40),
                                  borderRadius: BorderRadius.circular(
                                    AppBorders.radiusM,
                                  ),
                                ),
                                child: Icon(
                                  Icons.account_balance_wallet,
                                  size: AppSizes.iconLg,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface,
                                ),
                              ),
                            ],
                          ),
                          Divider(
                            height: AppSizes.controlMd,
                            color: Theme.of(
                              context,
                            ).colorScheme.surface.withAlpha(40),
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_month_outlined,
                                size: AppSizes.iconSm,
                                color: colorScheme.surface,
                              ),
                              const SizedBox(width: AppSpacing.sm),
                              Text(
                                'Referente a\n${DateTime.now().month}/${DateTime.now().year}',
                                style: textTheme.bodySmall?.copyWith(
                                  color: colorScheme.surface,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Spacer(),
                              Row(
                                children: [
                                  Icon(
                                    Icons.trending_up_rounded,
                                    size: 16,
                                    color: colorScheme.surface,
                                  ),
                                  Text(
                                    ' +2,4% este mês',
                                    style: textTheme.bodySmall?.copyWith(
                                      color: colorScheme.surface,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              Icon(
                                Icons.remove_red_eye,
                                size: AppSizes.iconSm,
                                color: colorScheme.surface,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    Expanded(
                      child: FtStatCard(
                        icon: Icons.trending_up_rounded,
                        label: 'RECEITAS',
                        value:
                            '+ ${currencyFormat.format(state.summary.totalIncome)}',
                        color: AppColors.success(Theme.of(context).brightness),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: FtStatCard(
                        icon: Icons.trending_down_rounded,
                        label: 'DESPESAS',
                        value:
                            '- ${currencyFormat.format(state.summary.totalExpense)}',
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  'Transações recentes',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.xm),
                if (state.recentTransactions.isEmpty)
                  const Text('Nenhuma transação recente')
                else
                  Column(
                    children: [
                      for (final transaction in state.recentTransactions) ...[
                        TransactionListItem(transaction: transaction),
                        const SizedBox(height: AppSpacing.xm),
                      ],
                    ],
                  ),
              ],
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
