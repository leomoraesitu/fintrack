import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';

Widget previewMaterialApp(Widget child) {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Scaffold(
      body: SafeArea(child: child),
    ),
  );
}

//@preview
class TransactionCardWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String category;
  final String date;
  final String amount;
  final bool isIncome;
  final double? width;
  final double? height;

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

  @override
  Widget build(BuildContext context) {
    final Color amountColor = isIncome ? Colors.greenAccent[400]! : Colors.redAccent[200]!;
    final IconData arrowIcon = isIncome ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded;
    final Color arrowColor = amountColor;

    return Container(
      width: width ?? 380,
      height: height ?? 100,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blueAccent, width: 2),
            ),
            child: Icon(icon, color: Colors.blueAccent, size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      category,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7),
                        fontSize: 13,
                      ),
                    ),
                    const Text(' · ', style: TextStyle(color: Colors.white38)),
                    Text(
                      date,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: TextStyle(
                  color: amountColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Icon(arrowIcon, color: arrowColor, size: 18),
            ],
          ),
        ],
      ),
    );
  }
}

@Preview(
  name: 'Transaction Card Widget',
  wrapper: previewMaterialApp,
)
Widget transactionCardWidgetPreview() => TransactionCardWidget(
  icon: Icons.shopping_cart,
  title: 'Compra no mercado',
  category: 'Alimentação',
  date: '15/04/2026',
  amount: 'R\$ 120,00',
  isIncome: false,
);
