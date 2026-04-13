import 'package:fintrack/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:fintrack/features/transactions/domain/entities/transaction.dart';

class GetRecentTransactions {
  const GetRecentTransactions(this._repository);

  final DashboardRepository _repository;

  List<Transaction> call({int limit = 3}) {
    return _repository.getRecentTransactions(limit: limit);
  }
}