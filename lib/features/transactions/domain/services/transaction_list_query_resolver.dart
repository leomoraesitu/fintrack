import 'package:fintrack/features/transactions/domain/entities/transaction.dart';
import 'package:fintrack/features/transactions/domain/entities/transaction_list_query.dart';

class TransactionListQueryResolver {
  const TransactionListQueryResolver();

  List<Transaction> resolve(
    List<Transaction> transactions, {
    TransactionListQuery query = const TransactionListQuery(),
  }) {
    final period = query.period;

    if (period != null && !period.isValid) {
      return const [];
    }

    final filteredTransactions = transactions.where((transaction) {
      if (query.type != null && transaction.type != query.type) {
        return false;
      }

      if (query.categoryId != null &&
          transaction.category.id != query.categoryId) {
        return false;
      }

      if (period != null &&
          period.isActive &&
          !_isWithinPeriod(transaction.date, period)) {
        return false;
      }

      return true;
    }).toList(growable: false);

    final sortedTransactions = List<Transaction>.from(filteredTransactions);

    sortedTransactions.sort((first, second) {
      final comparison = first.date.compareTo(second.date);

      if (comparison == 0) {
        return query.sortOrder == TransactionSortOrder.newestFirst
            ? second.id.compareTo(first.id)
            : first.id.compareTo(second.id);
      }

      return query.sortOrder == TransactionSortOrder.newestFirst
          ? second.date.compareTo(first.date)
          : first.date.compareTo(second.date);
    });

    return List.unmodifiable(sortedTransactions);
  }

  bool _isWithinPeriod(
    DateTime date,
    TransactionPeriodFilter period,
  ) {
    final dateOnly = DateTime(date.year, date.month, date.day);

    if (period.startDate != null) {
      final startDateOnly = DateTime(
        period.startDate!.year,
        period.startDate!.month,
        period.startDate!.day,
      );

      if (dateOnly.isBefore(startDateOnly)) {
        return false;
      }
    }

    if (period.endDate != null) {
      final endDateOnly = DateTime(
        period.endDate!.year,
        period.endDate!.month,
        period.endDate!.day,
      );

      if (dateOnly.isAfter(endDateOnly)) {
        return false;
      }
    }

    return true;
  }
}