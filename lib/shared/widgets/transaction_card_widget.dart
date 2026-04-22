import 'package:fintrack/design_system/widgets/widgets.dart';
import 'package:fintrack/shared/tokens/tokens.dart';
import 'package:flutter/material.dart';

@Deprecated('Use FtTransactionListItem from design_system/widgets/widgets.dart')
class TransactionCardWidget extends StatelessWidget {
  const TransactionCardWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.category,
    required this.date,
    required this.amount,
    required this.isIncome,
    this.width,
    this.height,
  });

  final IconData icon;
  final String title;
  final String category;
  final String date;
  final String amount;
  final bool isIncome;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final amountColor = isIncome
        ? AppColors.success(brightness)
        : Theme.of(context).colorScheme.error;

    return FtTransactionListItem(
      icon: icon,
      title: title,
      category: category,
      date: date,
      amount: amount,
      amountColor: amountColor,
      width: width,
      height: height,
    );
  }
}
