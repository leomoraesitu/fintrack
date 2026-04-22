import 'package:fintrack/app/theme/app_theme.dart';
import 'package:fintrack/design_system/widgets/widgets.dart';
import 'package:fintrack/shared/tokens/tokens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'golden_test_helpers.dart';

void main() {
  group('FtTransactionListItem', () {
    testWidgets('renderiza dados principais', (tester) async {
      await pumpDsWidget(
        tester,
        child: FtTransactionListItem(
          icon: Icons.restaurant,
          title: 'Almoço',
          category: 'Alimentação',
          date: '22/04/2026',
          amount: '- R\$ 35.90',
          amountColor: AppColors.error(Brightness.light),
          width: 360,
          height: 92,
        ),
      );

      expect(find.text('Almoço'), findsOneWidget);
      expect(find.text('Alimentação • 22/04/2026'), findsOneWidget);
      expect(find.text('- R\$ 35.90'), findsOneWidget);
    });

    testWidgets('aciona onTap quando definido', (tester) async {
      var tapped = false;

      await pumpDsWidget(
        tester,
        child: FtTransactionListItem(
          icon: Icons.shopping_bag,
          title: 'Compras',
          category: 'Mercado',
          date: '22/04/2026',
          amount: '- R\$ 120.00',
          amountColor: AppColors.error(Brightness.light),
          onTap: () => tapped = true,
          width: 360,
          height: 92,
        ),
      );

      await tester.tap(find.byType(InkWell));
      await tester.pump();

      expect(tapped, isTrue);
    });

    testWidgets('golden light', (tester) async {
      await pumpDsWidget(
        tester,
        theme: AppTheme.light(),
        surfaceSize: const Size(620, 340),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FtTransactionListItem(
              icon: Icons.restaurant,
              title: 'Almoço',
              category: 'Alimentação',
              date: '22/04/2026',
              amount: '- R\$ 35.90',
              amountColor: AppColors.error(Brightness.light),
              width: 540,
              height: 92,
            ),
            const SizedBox(height: 12),
            FtTransactionListItem(
              icon: Icons.work,
              title: 'Salário',
              category: 'Receita',
              date: '21/04/2026',
              amount: '+ R\$ 4500.00',
              amountColor: AppColors.success(Brightness.light),
              width: 540,
              height: 92,
            ),
          ],
        ),
      );

      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile('goldens/ft_transaction_list_item_light.png'),
      );
    }, skip: shouldSkipGolden('ft_transaction_list_item_light.png'));

    testWidgets('golden dark', (tester) async {
      await pumpDsWidget(
        tester,
        theme: AppTheme.dark(),
        surfaceSize: const Size(620, 340),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FtTransactionListItem(
              icon: Icons.restaurant,
              title: 'Almoço',
              category: 'Alimentação',
              date: '22/04/2026',
              amount: '- R\$ 35.90',
              amountColor: AppColors.error(Brightness.dark),
              width: 540,
              height: 92,
            ),
            const SizedBox(height: 12),
            FtTransactionListItem(
              icon: Icons.work,
              title: 'Salário',
              category: 'Receita',
              date: '21/04/2026',
              amount: '+ R\$ 4500.00',
              amountColor: AppColors.success(Brightness.dark),
              width: 540,
              height: 92,
            ),
          ],
        ),
      );

      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile('goldens/ft_transaction_list_item_dark.png'),
      );
    }, skip: shouldSkipGolden('ft_transaction_list_item_dark.png'));
  });
}
