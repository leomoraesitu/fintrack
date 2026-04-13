import 'package:fintrack/features/transactions/domain/entities/transaction_type.dart';

enum TransactionSortOrder {
  newestFirst,
  oldestFirst,
}

class TransactionPeriodFilter {
  const TransactionPeriodFilter({
    this.startDate,
    this.endDate,
  });

  final DateTime? startDate;
  final DateTime? endDate;

  bool get isActive => startDate != null || endDate != null;

  bool get isValid {
    if (startDate == null || endDate == null) {
      return true;
    }

    return !startDate!.isAfter(endDate!);
  }
}

class TransactionListQuery {
  const TransactionListQuery({
    this.type,
    this.categoryId,
    this.period,
    this.sortOrder = TransactionSortOrder.newestFirst,
  });

  final TransactionType? type;
  final String? categoryId;
  final TransactionPeriodFilter? period;
  final TransactionSortOrder sortOrder;

  bool get hasFilters {
    return type != null ||
        categoryId != null ||
        (period != null && period!.isActive);
  }
}