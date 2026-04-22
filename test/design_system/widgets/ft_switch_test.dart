import 'package:fintrack/app/theme/app_theme.dart';
import 'package:fintrack/design_system/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'golden_test_helpers.dart';

void main() {
  group('FtSwitch', () {
    testWidgets('renderiza label', (tester) async {
      await pumpDsWidget(
        tester,
        child: FtSwitch(
          value: true,
          onChanged: (_) {},
          label: 'Notificações',
        ),
      );

      expect(find.text('Notificações'), findsOneWidget);
    });

    testWidgets('dispara callback no toggle android', (tester) async {
      bool current = false;
      bool? emitted;

      await pumpDsWidget(
        tester,
        child: StatefulBuilder(
          builder: (context, setState) {
            return FtSwitch(
              value: current,
              onChanged: (value) {
                emitted = value;
                setState(() => current = value);
              },
            );
          },
        ),
      );

      await tester.tap(find.byType(Switch));
      await tester.pump();

      expect(emitted, isTrue);
    });

    testWidgets('golden light', (tester) async {
      await pumpDsWidget(
        tester,
        theme: AppTheme.light(),
        surfaceSize: const Size(520, 260),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FtSwitch(
              value: true,
              onChanged: (_) {},
              variant: FtSwitchVariant.android,
              label: 'Android',
            ),
            const SizedBox(height: 16),
            FtSwitch(
              value: false,
              onChanged: (_) {},
              variant: FtSwitchVariant.ios,
              label: 'iOS',
            ),
            const SizedBox(height: 16),
            FtSwitch(
              value: true,
              onChanged: (_) {},
              variant: FtSwitchVariant.ios26,
              label: 'iOS 26+',
            ),
          ],
        ),
      );

      expect(find.byType(CupertinoSwitch), findsNWidgets(2));
      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile('goldens/ft_switch_light.png'),
      );
    }, skip: shouldSkipGolden('ft_switch_light.png'));

    testWidgets('golden dark', (tester) async {
      await pumpDsWidget(
        tester,
        theme: AppTheme.dark(),
        surfaceSize: const Size(520, 260),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FtSwitch(
              value: true,
              onChanged: (_) {},
              variant: FtSwitchVariant.android,
              label: 'Android',
            ),
            const SizedBox(height: 16),
            FtSwitch(
              value: false,
              onChanged: (_) {},
              variant: FtSwitchVariant.ios,
              label: 'iOS',
            ),
            const SizedBox(height: 16),
            FtSwitch(
              value: true,
              onChanged: (_) {},
              variant: FtSwitchVariant.ios26,
              label: 'iOS 26+',
            ),
          ],
        ),
      );

      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile('goldens/ft_switch_dark.png'),
      );
    }, skip: shouldSkipGolden('ft_switch_dark.png'));
  });
}
