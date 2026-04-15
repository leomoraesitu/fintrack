import 'package:fintrack/features/transactions/domain/entities/transaction.dart';
import 'package:fintrack/features/transactions/domain/repositories/transaction_repository.dart';
import 'package:fintrack/features/transactions/presentation/bloc/transaction_list_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:fintrack/app/app.dart';
import 'package:fintrack/features/transactions/presentation/bloc/transaction_list_bloc.dart';
import 'package:fintrack/features/transactions/presentation/pages/transactions_page.dart';
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

class DummyTransactionRepository implements TransactionRepository {
  @override
  List<Transaction> getTransactions() => [];
  @override
  void addTransaction(Transaction transaction) {}
  @override
  void updateTransaction(Transaction transaction) {}
  @override
  void deleteTransaction(String id) {}
}

class FakeBloc extends TransactionListBloc {
  FakeBloc() : super(repository: DummyTransactionRepository());
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

    // Abrir o bottom sheet de filtros
    await tester.tap(find.text('Filtros'));
    await tester.pumpAndSettle();

    // Selecionar Receitas
    await tester.tap(find.text('Receitas'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Aplicar filtros'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Aplicar filtros'));
    await tester.pumpAndSettle();

    expect(find.text('+ R\$ 3500.00'), findsOneWidget);
    expect(find.text('Supermercado'), findsNothing);
    expect(find.text('- R\$ 18.00'), findsNothing);

    // Abrir o bottom sheet de filtros novamente
    await tester.tap(find.text('Filtros'));
    await tester.pumpAndSettle();

    // Selecionar Despesas
    await tester.tap(find.text('Despesas'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Aplicar filtros'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Aplicar filtros'));
    await tester.pumpAndSettle();

    expect(find.text('+ R\$ 3500.00'), findsNothing);
    expect(find.text('Supermercado'), findsOneWidget);
    expect(find.text('- R\$ 18.00'), findsOneWidget);

    // Abrir o bottom sheet de filtros novamente
    await tester.tap(find.text('Filtros'));
    await tester.pumpAndSettle();

    // Selecionar Todas
    await tester.tap(find.text('Todas'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Aplicar filtros'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Aplicar filtros'));
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

      // Abrir o bottom sheet de filtros
      await tester.tap(find.text('Filtros'));
      await tester.pumpAndSettle();

      // Selecionar categoria "Alimentação"
      await tester.tap(find.text('Alimentação'));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('Aplicar filtros'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Aplicar filtros'));
      await tester.pumpAndSettle();

      expect(find.text('Supermercado'), findsOneWidget);
      expect(find.text('+ R\$ 3500.00'), findsNothing);
      expect(find.text('- R\$ 18.00'), findsNothing);

      // Abrir o bottom sheet de filtros novamente
      await tester.tap(find.text('Filtros'));
      await tester.pumpAndSettle();

      // Selecionar Receitas (tipo incompatível com categoria Alimentação)
      await tester.tap(find.text('Receitas'));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('Aplicar filtros'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Aplicar filtros'));
      await tester.pumpAndSettle();

      expect(find.text('+ R\$ 3500.00'), findsOneWidget);
      expect(find.text('Supermercado'), findsNothing);
      expect(find.text('- R\$ 18.00'), findsNothing);

      // Categoria deve ser limpa
      await tester.tap(find.text('Filtros'));
      await tester.pumpAndSettle();
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

    // Abrir o bottom sheet de filtros
    await tester.tap(find.text('Filtros'));
    await tester.pumpAndSettle();

    // Selecionar "Últimos 7 dias"
    await tester.ensureVisible(find.text('Últimos 7 dias'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Últimos 7 dias'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Aplicar filtros'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Aplicar filtros'));
    await tester.pumpAndSettle();

    // Abrir o bottom sheet de filtros novamente
    await tester.tap(find.text('Filtros'));
    await tester.pumpAndSettle();

    // Selecionar "Este mês"
    await tester.ensureVisible(find.text('Este mês'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Este mês'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Aplicar filtros'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Aplicar filtros'));
    await tester.pumpAndSettle();

    expect(find.text('+ R\$ 3500.00'), findsOneWidget);
    expect(find.text('Supermercado'), findsOneWidget);
    expect(find.text('- R\$ 18.00'), findsOneWidget);

    // Abrir o bottom sheet de filtros novamente
    await tester.tap(find.text('Filtros'));
    await tester.pumpAndSettle();

    // Selecionar "Todo o período"
    await tester.ensureVisible(find.text('Todo o período'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Todo o período'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Aplicar filtros'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Aplicar filtros'));
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

  testWidgets(
    'exibe estado vazio na TransactionsPage quando não há transações',
    (WidgetTester tester) async {
      await tester.pumpWidget(await _buildTestApp());
      await tester.tap(find.text('Entrar no modo demo'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Transações'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Filtros'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Outras despesas'));
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.text('Aplicar filtros'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Aplicar filtros'));
      await tester.pumpAndSettle();

      expect(find.text('Nenhuma transação encontrada'), findsOneWidget);
      expect(find.byIcon(Icons.inbox_outlined), findsOneWidget);
    },
  );

  testWidgets('exibe loading ao abrir TransactionsPage', (tester) async {
    await tester.pumpWidget(await _buildTestApp());
    await tester.tap(find.text('Entrar no modo demo'));
    await tester.pump();

    await tester.tap(find.text('Transações'));
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsWidgets);
  });

  testWidgets('TransactionsPage exibe estado de erro isolado', (tester) async {
    final bloc = FakeBloc();

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<TransactionListBloc>.value(
          value: bloc,
          child: const TransactionsView(),
        ),
      ),
    );

    bloc.emit(
      const TransactionListError(message: 'Erro ao carregar transações'),
    );
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.error_outline), findsOneWidget);
    expect(find.text('Erro ao carregar transações'), findsOneWidget);
    expect(find.text('Tentar novamente'), findsOneWidget);
  });
}
