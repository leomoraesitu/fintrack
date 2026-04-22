import 'package:fintrack/design_system/widgets/widgets.dart';
import 'package:fintrack/features/transactions/presentation/mappers/transaction_category_icon_mapper.dart';
import 'package:flutter/material.dart';
import 'package:fintrack/features/transactions/domain/entities/transaction.dart';
import 'package:fintrack/shared/tokens/tokens.dart';
import 'package:intl/intl.dart';

class TransactionListItem extends StatelessWidget {
  const TransactionListItem({super.key, required this.transaction, this.onTap});

  final Transaction transaction;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final colorScheme = Theme.of(context).colorScheme;
    final amountColor = transaction.isIncome
        ? AppColors.success(brightness)
        : colorScheme.error;
    final amountPrefix = transaction.isIncome ? '+' : '-';

    final currencyFormat = NumberFormat.currency(
      locale: 'pt_BR',
      symbol: 'R\$',
    );

    return FtTransactionListItem(
      icon: TransactionCategoryIconMapper.fromCategory(transaction.category),
      title: transaction.description,
      category: transaction.category.label,
      date:
          '${transaction.date.day}/${transaction.date.month}/${transaction.date.year}',
      amount: '$amountPrefix ${currencyFormat.format(transaction.amount)}',
      amountColor: amountColor,
      onTap: onTap,
    );
  }
}
