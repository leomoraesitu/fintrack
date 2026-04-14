import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fintrack/app/app.dart';
import 'package:fintrack/features/transactions/data/datasources/shared_prefs_transaction_local_data_source.dart';
import 'package:fintrack/features/transactions/data/models/transaction_storage_mapper.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<FinTrackApp> _buildTestApp({
  Map<String, Object> mockInitialValues = const {},
}) async {
  SharedPreferences.setMockInitialValues(mockInitialValues);
  final sharedPreferences = await SharedPreferences.getInstance();
  final localDataSource = SharedPrefsTransactionLocalDataSource(
    sharedPreferences,
  );
  final storedTransactions = await localDataSource.loadTransactions();
  final initialTransactions = storedTransactions
      .map(TransactionStorageMapper.fromMap)
      .toList();

  return FinTrackApp(
    sharedPreferences: sharedPreferences,
    initialTransactions: initialTransactions,
  );
}

void main() {
  testWidgets(
    'deve iniciar na login page, criar uma transacao no modo demo e voltar para a login page ao sair',
    (WidgetTester tester) async {
      await tester.pumpWidget(await _buildTestApp());

      expect(find.text('Bem-vindo'), findsOneWidget);
      expect(find.text('Entrar no modo demo'), findsOneWidget);
      expect(find.textContaining('Ambiente de demonstra'), findsOneWidget);

      await tester.tap(find.text('Entrar no modo demo'));
      await tester.pumpAndSettle();

      expect(find.text('FinTrack'), findsOneWidget);
      expect(find.text('Dashboard'), findsOneWidget);
      expect(find.text('Transações'), findsOneWidget);
      expect(find.text('Resumo financeiro'), findsOneWidget);
      expect(find.text('Saldo atual'), findsOneWidget);
      expect(find.text('Receitas'), findsOneWidget);
      expect(find.text('Despesas'), findsOneWidget);

      expect(find.text('R\$ 3399.50'), findsOneWidget);
      expect(find.text('R\$ 3500.00'), findsOneWidget);
      expect(find.text('R\$ 100.50'), findsOneWidget);

      expect(find.text('Transações recentes'), findsOneWidget);
      expect(find.text('Ver todas'), findsOneWidget);

      expect(find.text('- R\$ 18.00'), findsOneWidget);
      expect(find.text('Supermercado'), findsOneWidget);
      expect(find.text('+ R\$ 3500.00'), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
      expect(find.byIcon(Icons.logout), findsOneWidget);

      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      expect(find.text('Nova transação'), findsOneWidget);

      await tester.enterText(find.byType(TextFormField).at(0), '45,90');
      await tester.enterText(find.byType(TextFormField).at(1), 'Farmacia');

      await tester.tap(find.text('Categoria'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Saúde').last);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Salvar transação'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Transações'));
      await tester.pumpAndSettle();

      expect(find.text('Farmacia'), findsOneWidget);
      expect(find.textContaining('Saúde •'), findsOneWidget);

      await tester.scrollUntilVisible(
        find.text('+ R\$ 3500.00'),
        200,
        scrollable: find.byType(Scrollable).last,
      );
      await tester.pumpAndSettle();

      expect(find.text('+ R\$ 3500.00'), findsOneWidget);
      expect(find.text('Supermercado'), findsOneWidget);
      expect(find.text('- R\$ 18.00'), findsOneWidget);

      await tester.tap(find.byTooltip('Sair'));
      await tester.pumpAndSettle();

      expect(find.text('Bem-vindo'), findsOneWidget);
      expect(find.text('Entrar no modo demo'), findsOneWidget);
    },
  );

  testWidgets('deve editar e excluir uma transacao existente no modo demo', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(await _buildTestApp());

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

    expect(find.text('Alimentação'), findsOneWidget);

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
    expect(find.text('+ R\$ 3500.00'), findsOneWidget);
    expect(find.text('- R\$ 18.00'), findsOneWidget);
  });

  testWidgets(
    'deve limpar categoria incompatível ao trocar o tipo da transação',
    (WidgetTester tester) async {
      await tester.pumpWidget(await _buildTestApp());

      await tester.tap(find.text('Entrar no modo demo'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Transações'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Supermercado'));
      await tester.pumpAndSettle();

      expect(find.text('Editar transação'), findsOneWidget);
      expect(find.text('Alimentação'), findsOneWidget);

      await tester.tap(find.text('Receita'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Salvar alterações'));
      await tester.pumpAndSettle();

      expect(find.text('Selecione a categoria.'), findsOneWidget);
      expect(find.text('Editar transação'), findsOneWidget);
    },
  );

  testWidgets(
    'deve editar a categoria de uma transacao existente e refletir a alteracao na lista',
    (WidgetTester tester) async {
      await tester.pumpWidget(await _buildTestApp());

      await tester.tap(find.text('Entrar no modo demo'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Transações'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Supermercado'));
      await tester.pumpAndSettle();

      expect(find.text('Editar transação'), findsOneWidget);
      expect(find.text('Alimentação'), findsOneWidget);

      await tester.tap(find.text('Alimentação'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Saúde').last);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Salvar alterações'));
      await tester.pumpAndSettle();

      expect(find.text('Supermercado'), findsOneWidget);
      expect(find.textContaining('Saúde •'), findsOneWidget);
    },
  );

  testWidgets(
    'deve abrir a aba de transações ao tocar em ver todas no dashboard',
    (WidgetTester tester) async {
      await tester.pumpWidget(await _buildTestApp());

      await tester.tap(find.text('Entrar no modo demo'));
      await tester.pumpAndSettle();

      expect(find.text('Resumo financeiro'), findsOneWidget);
      expect(find.text('Ver todas'), findsOneWidget);

      await tester.tap(find.text('Ver todas'));
      await tester.pumpAndSettle();

      expect(find.text('Transações'), findsWidgets);
      expect(find.text('+ R\$ 3500.00'), findsOneWidget);
      expect(find.text('Supermercado'), findsOneWidget);
      expect(find.text('- R\$ 18.00'), findsOneWidget);
    },
  );

  testWidgets(
    'deve manter uma transacao criada ao reiniciar o app com o mesmo storage',
    (WidgetTester tester) async {
      await tester.pumpWidget(await _buildTestApp());

      await tester.tap(find.text('Entrar no modo demo'));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField).at(0), '120,00');
      await tester.enterText(find.byType(TextFormField).at(1), 'Consulta');

      await tester.tap(find.text('Categoria'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Saúde').last);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Salvar transação'));
      await tester.pumpAndSettle();

      expect(find.text('Consulta'), findsOneWidget);

      final savedTransactions = (await SharedPreferences.getInstance())
          .getString('transactions');

      expect(savedTransactions, isNotNull);

      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpAndSettle();

      await tester.pumpWidget(
        await _buildTestApp(
          mockInitialValues: {'transactions': savedTransactions!},
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Entrar no modo demo'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Transações'));
      await tester.pumpAndSettle();

      expect(find.text('Consulta'), findsOneWidget);
      expect(find.textContaining('Saúde •'), findsOneWidget);
    },
  );

  testWidgets('deve filtrar a lista de transações por tipo', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(await _buildTestApp());

    await tester.tap(find.text('Entrar no modo demo'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Transações'));
    await tester.pumpAndSettle();

    expect(find.text('+ R\$ 3500.00'), findsOneWidget);
    expect(find.text('Supermercado'), findsOneWidget);
    expect(find.text('- R\$ 18.00'), findsOneWidget);

    await tester.tap(find.text('Receitas'));
    await tester.pumpAndSettle();

    expect(find.text('+ R\$ 3500.00'), findsOneWidget);
    expect(find.text('Supermercado'), findsNothing);
    expect(find.text('- R\$ 18.00'), findsNothing);

    await tester.tap(find.text('Despesas'));
    await tester.pumpAndSettle();

    expect(find.text('+ R\$ 3500.00'), findsNothing);
    expect(find.text('Supermercado'), findsOneWidget);
    expect(find.text('- R\$ 18.00'), findsOneWidget);

    await tester.tap(find.text('Todas'));
    await tester.pumpAndSettle();

    expect(find.text('+ R\$ 3500.00'), findsOneWidget);
    expect(find.text('Supermercado'), findsOneWidget);
    expect(find.text('- R\$ 18.00'), findsOneWidget);
  });

  testWidgets(
    'deve filtrar por categoria e limpar categoria incompatível ao trocar o tipo',
    (WidgetTester tester) async {
      await tester.pumpWidget(await _buildTestApp());

      await tester.tap(find.text('Entrar no modo demo'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Transações'));
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.text('Alimentação'));
      await tester.tap(find.text('Alimentação'));
      await tester.pumpAndSettle();

      expect(find.text('Supermercado'), findsOneWidget);
      expect(find.text('+ R\$ 3500.00'), findsNothing);
      expect(find.text('- R\$ 18.00'), findsNothing);

      await tester.tap(find.text('Receitas'));
      await tester.pumpAndSettle();

      expect(find.text('+ R\$ 3500.00'), findsOneWidget);
      expect(find.text('Supermercado'), findsNothing);
      expect(find.text('- R\$ 18.00'), findsNothing);

      expect(find.text('Todas as categorias'), findsOneWidget);
    },
  );

  testWidgets('deve filtrar a lista por período', (WidgetTester tester) async {
    await tester.pumpWidget(await _buildTestApp());

    await tester.tap(find.text('Entrar no modo demo'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Transações'));
    await tester.pumpAndSettle();

    expect(find.text('+ R\$ 3500.00'), findsOneWidget);
    expect(find.text('Supermercado'), findsOneWidget);
    expect(find.text('- R\$ 18.00'), findsOneWidget);

    await tester.tap(find.text('Últimos 7 dias'));
    await tester.pumpAndSettle();

    expect(find.text('- R\$ 18.00'), findsOneWidget);
    expect(find.text('Supermercado'), findsNothing);
    expect(find.text('+ R\$ 3500.00'), findsNothing);

    await tester.tap(find.text('Este mês'));
    await tester.pumpAndSettle();

    expect(find.text('+ R\$ 3500.00'), findsOneWidget);
    expect(find.text('Supermercado'), findsOneWidget);
    expect(find.text('- R\$ 18.00'), findsOneWidget);

    await tester.tap(find.text('Todo o período'));
    await tester.pumpAndSettle();

    expect(find.text('+ R\$ 3500.00'), findsOneWidget);
    expect(find.text('Supermercado'), findsOneWidget);
    expect(find.text('- R\$ 18.00'), findsOneWidget);
  });

  testWidgets(
    'deve abrir o bottom sheet de filtros e aplicar filtro por tipo',
    (WidgetTester tester) async {
      await tester.pumpWidget(await _buildTestApp());

      await tester.tap(find.text('Entrar no modo demo'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Transações'));
      await tester.pumpAndSettle();

      expect(find.text('+ R\$ 3500.00'), findsOneWidget);
      expect(find.text('Supermercado'), findsOneWidget);
      expect(find.text('- R\$ 18.00'), findsOneWidget);

      await tester.tap(find.text('Filtros'));
      await tester.pumpAndSettle();

      expect(find.text('Aplicar filtros'), findsOneWidget);
      expect(find.text('Tipo'), findsOneWidget);
      expect(find.text('Categoria'), findsOneWidget);
      expect(find.text('Período'), findsOneWidget);

      await tester.tap(find.text('Receitas'));
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.text('Aplicar filtros'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Aplicar filtros'));
      await tester.pumpAndSettle();

      expect(find.text('+ R\$ 3500.00'), findsOneWidget);
      expect(find.text('Supermercado'), findsNothing);
      expect(find.text('- R\$ 18.00'), findsNothing);
    },
  );

  testWidgets('deve limpar os filtros no bottom sheet antes de aplicar', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(await _buildTestApp());

    await tester.tap(find.text('Entrar no modo demo'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Transações'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Filtros'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Receitas'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Este mês'));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Limpar'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Limpar'));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Aplicar filtros'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Aplicar filtros'));
    await tester.pumpAndSettle();

    expect(find.text('+ R\$ 3500.00'), findsOneWidget);
    expect(find.text('Supermercado'), findsOneWidget);
    expect(find.text('- R\$ 18.00'), findsOneWidget);
  });

  testWidgets('deve alterar a ordenação da lista para mais antigas primeiro', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(await _buildTestApp());

    await tester.tap(find.text('Entrar no modo demo'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Transações'));
    await tester.pumpAndSettle();

    final transporteAntes = tester.getTopLeft(find.text('Transporte')).dy;
    final salarioAntes = tester.getTopLeft(find.text('Salário')).dy;

    expect(transporteAntes, lessThan(salarioAntes));

    await tester.tap(find.text('Mais recentes'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Mais antigas').last);
    await tester.pumpAndSettle();

    final transporteDepois = tester.getTopLeft(find.text('Transporte')).dy;
    final salarioDepois = tester.getTopLeft(find.text('Salário')).dy;

    expect(salarioDepois, lessThan(transporteDepois));
    expect(find.text('Mais antigas'), findsOneWidget);
  });
}
