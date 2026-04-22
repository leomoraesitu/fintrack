import 'package:fintrack/features/dashboard/data/repositories/transaction_dashboard_repository.dart';
import 'package:fintrack/features/dashboard/domain/usecases/get_financial_summary.dart';
import 'package:fintrack/features/dashboard/domain/usecases/get_recent_transactions.dart';
import 'package:fintrack/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:fintrack/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:fintrack/features/transactions/domain/repositories/transaction_repository.dart';
import 'package:fintrack/features/transactions/presentation/pages/transaction_form_page.dart';
import 'package:fintrack/features/transactions/presentation/pages/transactions_page.dart';
import 'package:fintrack/shared/tokens/tokens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShellPage extends StatefulWidget {
  const ShellPage({super.key, this.onLogout});
  final VoidCallback? onLogout;

  @override
  State<ShellPage> createState() => _ShellPageState();
}

class _ShellPageState extends State<ShellPage> {
  int _currentIndex = 0;
  int _transactionsRefreshSignal = 0;

  Widget _buildCurrentPage() {
    switch (_currentIndex) {
      case 1:
        return TransactionsPage(refreshSignal: _transactionsRefreshSignal);
      case 0:
      default:
        return BlocProvider(
          create: (context) {
            final dashboardRepository = TransactionDashboardRepository(
              context.read<TransactionRepository>(),
            );

            return DashboardBloc(
              GetFinancialSummary(dashboardRepository),
              GetRecentTransactions(dashboardRepository),
            );
          },
          child: DashboardPage(
            onViewAllTransactions: () {
              setState(() {
                _currentIndex = 1;
              });
            },
          ),
        );
    }
  }

  Future<void> _openTransactionFormPage() async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => const TransactionFormPage()),
    );

    if (result == true) {
      setState(() {
        _currentIndex = 1;
        _transactionsRefreshSignal++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Bom dia, 👋', style: textTheme.bodyLarge),
              Text('FinTrack', style: textTheme.headlineMedium),
            ],
          ),
        ),
        actions: [
          IconButton(
            onPressed: widget.onLogout,
            icon: const Icon(Icons.logout),
            tooltip: 'Sair',
          ),
        ],
      ),
      body: _buildCurrentPage(),
      floatingActionButton: SizedBox(
        width: AppSizes.widthXs,
        height: AppSizes.widthXs,
        child: FloatingActionButton(
          shape: CircleBorder(),
          onPressed: _openTransactionFormPage,
          tooltip: 'Nova transação',
          child: const Icon(Icons.add, size: AppSizes.iconLg),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view_rounded),
            label: 'Início',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.swap_horiz_rounded),
            label: 'Extrato',
          ),
        ],
      ),
    );
  }
}
