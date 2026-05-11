import 'package:fintrack/features/transactions/domain/entities/transaction_category_catalog.dart';

class TransactionCategoryCatalogState {
  const TransactionCategoryCatalogState({
    required this.catalog,
    required this.canManage,
  });

  const TransactionCategoryCatalogState.fallback({required bool canManage})
    : this(
        catalog: TransactionCategoryCatalog.fallback,
        canManage: canManage,
      );

  final TransactionCategoryCatalog catalog;
  final bool canManage;

  TransactionCategoryCatalogState copyWith({
    TransactionCategoryCatalog? catalog,
    bool? canManage,
  }) {
    return TransactionCategoryCatalogState(
      catalog: catalog ?? this.catalog,
      canManage: canManage ?? this.canManage,
    );
  }
}