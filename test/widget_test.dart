import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fintrack/app/app.dart';

void main() {
  testWidgets('deve carregar a shell inicial do FinTrack', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const FinTrackApp());

    expect(find.text('FinTrack'), findsOneWidget);
    expect(find.text('Dashboard'), findsOneWidget);
    expect(find.text('Transações'), findsOneWidget);
    expect(find.text('Resumo financeiro em construção'), findsOneWidget);
    expect(find.byIcon(Icons.add), findsOneWidget);

    await tester.tap(find.text('Transações'));
    await tester.pump();

    expect(find.text('Lista de transações em construção'), findsOneWidget);
    expect(find.text('Resumo financeiro em construção'), findsNothing);
  });
}
