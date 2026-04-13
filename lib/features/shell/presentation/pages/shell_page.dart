import 'package:fintrack/features/dashboard/data/repositories/transaction_dashboard_repository.dart';
import 'package:fintrack/features/dashboard/domain/usecases/get_financial_summary.dart';
import 'package:fintrack/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:fintrack/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:fintrack/features/transactions/domain/repositories/transaction_repository.dart';
import 'package:fintrack/features/transactions/presentation/pages/transaction_form_page.dart';
import 'package:fintrack/features/transactions/presentation/pages/transactions_page.dart';
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

  Widget _buildCurrentPage() {
    switch (_currentIndex) {
      case 1:
        return const TransactionsPage();
      case 0:
      default:
        return BlocProvider(
          create: (context) => DashboardBloc(
            GetFinancialSummary(
              TransactionDashboardRepository(
                context.read<TransactionRepository>(),
              ),
            ),
          ),
          child: const DashboardPage(),
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
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FinTrack'),
        actions: [
          IconButton(
            onPressed: widget.onLogout,
            icon: const Icon(Icons.logout),
            tooltip: 'Sair',
          ),
        ],
      ),
      body: _buildCurrentPage(),
      floatingActionButton: FloatingActionButton(
        onPressed: _openTransactionFormPage,
        tooltip: 'Nova transação',
        child: const Icon(Icons.add),
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
            icon: Icon(Icons.home_outlined),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_outlined),
            label: 'Transações',
          ),
        ],
      ),
    );
  }
}
