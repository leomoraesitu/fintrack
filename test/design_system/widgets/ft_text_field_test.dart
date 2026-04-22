import 'package:fintrack/app/theme/app_theme.dart';
import 'package:fintrack/design_system/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'golden_test_helpers.dart';

void main() {
  group('FtTextField', () {
    testWidgets('renderiza label e helper', (tester) async {
      await pumpDsWidget(
        tester,
        child: const FtTextField(
          label: 'Descrição',
          helper: 'Campo obrigatório',
          hint: 'Digite aqui',
        ),
      );

      expect(find.text('Descrição'), findsOneWidget);
      expect(find.text('Campo obrigatório'), findsOneWidget);
    });

    testWidgets('dispara onChanged ao digitar', (tester) async {
      String latest = '';

      await pumpDsWidget(
        tester,
        child: FtTextField(
          label: 'Descrição',
          onChanged: (value) => latest = value,
        ),
      );

      await tester.enterText(find.byType(TextFormField), 'Almoço');
      await tester.pump();

      expect(latest, 'Almoço');
    });

    testWidgets('golden light', (tester) async {
      await pumpDsWidget(
        tester,
        theme: AppTheme.light(),
        surfaceSize: const Size(620, 520),
        child: SingleChildScrollView(
          child: Column(
            children: const [
              FtTextField(
                label: 'Outlined',
                helper: 'Helper text',
                hint: 'Digite',
              ),
              SizedBox(height: 16),
              FtTextField(
                label: 'Filled',
                variant: FtTextFieldVariant.filled,
                hint: 'Digite',
              ),
              SizedBox(height: 16),
              FtTextField(label: 'Erro', error: true, hint: 'Campo inválido'),
              SizedBox(height: 16),
              FtTextField(
                label: 'Desabilitado',
                value: 'Somente leitura',
                enabled: false,
              ),
            ],
          ),
        ),
      );

      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile('goldens/ft_text_field_light.png'),
      );
    }, skip: shouldSkipGolden('ft_text_field_light.png'));

    testWidgets('golden dark', (tester) async {
      await pumpDsWidget(
        tester,
        theme: AppTheme.dark(),
        surfaceSize: const Size(620, 520),
        child: SingleChildScrollView(
          child: Column(
            children: const [
              FtTextField(
                label: 'Outlined',
                helper: 'Helper text',
                hint: 'Digite',
              ),
              SizedBox(height: 16),
              FtTextField(
                label: 'Filled',
                variant: FtTextFieldVariant.filled,
                hint: 'Digite',
              ),
              SizedBox(height: 16),
              FtTextField(label: 'Erro', error: true, hint: 'Campo inválido'),
              SizedBox(height: 16),
              FtTextField(
                label: 'Desabilitado',
                value: 'Somente leitura',
                enabled: false,
              ),
            ],
          ),
        ),
      );

      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile('goldens/ft_text_field_dark.png'),
      );
    }, skip: shouldSkipGolden('ft_text_field_dark.png'));
  });
}
