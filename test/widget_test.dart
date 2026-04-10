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

      expect(find.text('Nova transacao'), findsOneWidget);

      await tester.enterText(find.byType(TextFormField).at(0), '45,90');
      await tester.enterText(find.byType(TextFormField).at(1), 'Farmacia');
      await tester.enterText(find.byType(TextFormField).at(2), 'Saude');

      await tester.tap(find.text('Salvar transacao'));
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
}
