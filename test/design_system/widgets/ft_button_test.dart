import 'package:fintrack/app/theme/app_theme.dart';
import 'package:fintrack/design_system/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'golden_test_helpers.dart';

void main() {
  group('FtButton', () {
    testWidgets('aciona callback quando habilitado', (tester) async {
      var tapped = false;

      await pumpDsWidget(
        tester,
        child: FtButton(
          label: 'Salvar',
          onPressed: () => tapped = true,
        ),
      );

      await tester.tap(find.text('Salvar'));
      await tester.pump();

      expect(tapped, isTrue);
    });

    testWidgets('não aciona callback quando loading=true', (tester) async {
      var tapped = false;

      await pumpDsWidget(
        tester,
        child: FtButton(
          label: 'Salvar',
          loading: true,
          onPressed: () => tapped = true,
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      await tester.tap(find.byType(FtButton));
      await tester.pump();

      expect(tapped, isFalse);
    });

    testWidgets('golden light', (tester) async {
      await pumpDsWidget(
        tester,
        theme: AppTheme.light(),
        surfaceSize: const Size(560, 340),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const FtButton(label: 'Primary', onPressed: _noop),
            const SizedBox(height: 12),
            FtButton(
              label: 'Secondary',
              variant: FtButtonVariant.secondary,
              onPressed: _noop,
            ),
            const SizedBox(height: 12),
            FtButton(
              label: 'Outline',
              variant: FtButtonVariant.outline,
              onPressed: _noop,
            ),
            const SizedBox(height: 12),
            FtButton(
              label: 'Ghost',
              variant: FtButtonVariant.ghost,
              onPressed: _noop,
            ),
            const SizedBox(height: 12),
            FtButton(
              label: 'Destructive',
              variant: FtButtonVariant.destructive,
              onPressed: _noop,
            ),
          ],
        ),
      );

      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile('goldens/ft_button_light.png'),
      );
    }, skip: shouldSkipGolden('ft_button_light.png'));

    testWidgets('golden dark', (tester) async {
      await pumpDsWidget(
        tester,
        theme: AppTheme.dark(),
        surfaceSize: const Size(560, 340),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const FtButton(label: 'Primary', onPressed: _noop),
            const SizedBox(height: 12),
            FtButton(
              label: 'Secondary',
              variant: FtButtonVariant.secondary,
              onPressed: _noop,
            ),
            const SizedBox(height: 12),
            FtButton(
              label: 'Outline',
              variant: FtButtonVariant.outline,
              onPressed: _noop,
            ),
            const SizedBox(height: 12),
            FtButton(
              label: 'Ghost',
              variant: FtButtonVariant.ghost,
              onPressed: _noop,
            ),
            const SizedBox(height: 12),
            FtButton(
              label: 'Destructive',
              variant: FtButtonVariant.destructive,
              onPressed: _noop,
            ),
          ],
        ),
      );

      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile('goldens/ft_button_dark.png'),
      );
    }, skip: shouldSkipGolden('ft_button_dark.png'));
  });
}

void _noop() {}
