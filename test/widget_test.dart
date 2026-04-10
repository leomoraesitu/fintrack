import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fintrack/app/app.dart';

void main() {
  testWidgets(
    'deve iniciar na login page, criar uma transacao no modo demo e voltar para a login page ao sair',
    (WidgetTester tester) async {
      await tester.pumpWidget(const FinTrackApp());

      expect(find.text('Bem-vindo'), findsOneWidget);
      expect(find.text('Entrar no modo demo'), findsOneWidget);
      expect(find.textContaining('Ambiente de demonstra'), findsOneWidget);

      await tester.tap(find.text('Entrar no modo demo'));
      await tester.pumpAndSettle();

      expect(find.text('FinTrack'), findsOneWidget);
      expect(find.text('Dashboard'), findsOneWidget);
      expect(find.text('Transações'), findsOneWidget);
      expect(find.text('Resumo financeiro em construção'), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
      expect(find.byIcon(Icons.logout), findsOneWidget);

      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      expect(find.text('Nova transação'), findsOneWidget);

      await tester.enterText(find.byType(TextFormField).at(0), '45,90');
      await tester.enterText(find.byType(TextFormField).at(1), 'Farmacia');
      await tester.enterText(find.byType(TextFormField).at(2), 'Saude');

      await tester.tap(find.text('Salvar transação'));
      await tester.pumpAndSettle();

      expect(find.text('Salário'), findsOneWidget);
      expect(find.text('Supermercado'), findsOneWidget);
      expect(find.text('Transporte'), findsOneWidget);
      expect(find.text('Farmacia'), findsOneWidget);

      await tester.tap(find.byTooltip('Sair'));
      await tester.pumpAndSettle();

      expect(find.text('Bem-vindo'), findsOneWidget);
      expect(find.text('Entrar no modo demo'), findsOneWidget);
    },
  );

  testWidgets('deve editar e excluir uma transacao existente no modo demo', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const FinTrackApp());

    expect(find.text('Bem-vindo'), findsOneWidget);
    expect(find.text('Entrar no modo demo'), findsOneWidget);

    await tester.tap(find.text('Entrar no modo demo'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Transações'));
    await tester.pumpAndSettle();

    expect(find.text('Supermercado'), findsOneWidget);

    await tester.tap(find.text('Supermercado'));
    await tester.pumpAndSettle();

    expect(find.text('Editar transação'), findsOneWidget);
    expect(find.text('Salvar alterações'), findsOneWidget);

    await tester.enterText(
      find.byType(TextFormField).at(1),
      'Mercado do bairro',
    );
    await tester.tap(find.text('Salvar alterações'));
    await tester.pumpAndSettle();

    expect(find.text('Mercado do bairro'), findsOneWidget);
    expect(find.text('Supermercado'), findsNothing);

    await tester.tap(find.text('Mercado do bairro'));
    await tester.pumpAndSettle();

    expect(find.text('Editar transação'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.delete));
    await tester.pumpAndSettle();

    expect(find.text('Excluir transação'), findsOneWidget);

    await tester.tap(find.text('Excluir'));
    await tester.pumpAndSettle();

    expect(find.text('Mercado do bairro'), findsNothing);
    expect(find.text('Salário'), findsOneWidget);
    expect(find.text('Transporte'), findsOneWidget);
  });
}
