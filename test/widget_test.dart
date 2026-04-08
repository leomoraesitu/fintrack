import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fintrack/app/app.dart';

void main() {
  testWidgets('deve iniciar na login page e navegar para a shell no modo demo', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const FinTrackApp());

    expect(find.text('Bem-vindo'), findsOneWidget);
    expect(find.text('Entrar no modo demo'), findsOneWidget);
    expect(
      find.textContaining('Ambiente de demonstra'),
      findsOneWidget,
    );

    await tester.tap(find.text('Entrar no modo demo'));
    await tester.pumpAndSettle();

    expect(find.text('FinTrack'), findsOneWidget);
    expect(find.text('Dashboard'), findsOneWidget);
    expect(find.text('Transações'), findsOneWidget);
    expect(find.text('Resumo financeiro em construção'), findsOneWidget);
    expect(find.byIcon(Icons.add), findsOneWidget);

    await tester.tap(find.text('Transações'));
    await tester.pumpAndSettle();

    expect(find.text('Lista de transações em construção'), findsOneWidget);
    expect(find.text('Resumo financeiro em construção'), findsNothing);
  });
}