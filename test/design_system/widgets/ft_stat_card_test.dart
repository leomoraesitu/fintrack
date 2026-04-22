import 'package:fintrack/app/theme/app_theme.dart';
import 'package:fintrack/design_system/widgets/widgets.dart';
import 'package:fintrack/shared/tokens/tokens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'golden_test_helpers.dart';

void main() {
  group('FtStatCard', () {
    testWidgets('renderiza label e value', (tester) async {
      await pumpDsWidget(
        tester,
        child: FtStatCard(
          icon: Icons.trending_up,
          label: 'RECEITAS',
          value: '+ R\$ 1500.00',
          color: AppColors.success(Brightness.light),
          width: 260,
          height: 120,
        ),
      );

      expect(find.text('RECEITAS'), findsOneWidget);
      expect(find.text('+ R\$ 1500.00'), findsOneWidget);
      expect(find.byIcon(Icons.trending_up), findsOneWidget);
    });

    testWidgets('golden light', (tester) async {
      await pumpDsWidget(
        tester,
        theme: AppTheme.light(),
        surfaceSize: const Size(560, 320),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FtStatCard(
              icon: Icons.trending_up_rounded,
              label: 'RECEITAS',
              value: '+ R\$ 2520.00',
              color: AppColors.success(Brightness.light),
              width: 240,
              height: 120,
            ),
            const SizedBox(width: 12),
            FtStatCard(
              icon: Icons.trending_down_rounded,
              label: 'DESPESAS',
              value: '- R\$ 1100.00',
              color: AppColors.error(Brightness.light),
              width: 240,
              height: 120,
            ),
          ],
        ),
      );

      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile('goldens/ft_stat_card_light.png'),
      );
    }, skip: shouldSkipGolden('ft_stat_card_light.png'));

    testWidgets('golden dark', (tester) async {
      await pumpDsWidget(
        tester,
        theme: AppTheme.dark(),
        surfaceSize: const Size(560, 320),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FtStatCard(
              icon: Icons.trending_up_rounded,
              label: 'RECEITAS',
              value: '+ R\$ 2520.00',
              color: AppColors.success(Brightness.dark),
              width: 240,
              height: 120,
            ),
            const SizedBox(width: 12),
            FtStatCard(
              icon: Icons.trending_down_rounded,
              label: 'DESPESAS',
              value: '- R\$ 1100.00',
              color: AppColors.error(Brightness.dark),
              width: 240,
              height: 120,
            ),
          ],
        ),
      );

      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile('goldens/ft_stat_card_dark.png'),
      );
    }, skip: shouldSkipGolden('ft_stat_card_dark.png'));
  });
}
