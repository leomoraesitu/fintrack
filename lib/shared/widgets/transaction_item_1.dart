import 'package:fintrack/design_system/widgets/widgets.dart';
import 'package:flutter/material.dart';

@Deprecated('Use FtTransactionListItem from design_system/widgets/widgets.dart')
class TransactionItem1 extends StatelessWidget {
  const TransactionItem1({
    super.key,
    required this.icon,
    required this.title,
    required this.category,
    required this.date,
    required this.amount,
    required this.amountColor,
    this.width,
    this.height,
  });

  final IconData icon;
  final String title;
  final String category;
  final String date;
  final String amount;
  final Color amountColor;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
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
