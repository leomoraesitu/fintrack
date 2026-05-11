import 'package:fintrack/features/transactions/domain/entities/transaction_category.dart';
import 'package:fintrack/features/transactions/domain/entities/transaction_category_catalog.dart';
import 'package:fintrack/features/transactions/domain/entities/transaction_type.dart';
import 'package:fintrack/features/transactions/domain/repositories/transaction_category_repository.dart';
import 'package:fintrack/features/transactions/presentation/cubit/transaction_category_catalog_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TransactionCategoryCatalogCubit
    extends Cubit<TransactionCategoryCatalogState> {
  TransactionCategoryCatalogCubit({
    required TransactionCategoryRepository repository,
    required bool canManage,
  }) : _repository = repository,
       super(TransactionCategoryCatalogState.fallback(canManage: canManage));

  final TransactionCategoryRepository _repository;

  Future<void> load() async {
    final catalog = await _repository.getCategoryCatalog();
    emit(state.copyWith(catalog: catalog));
  }

  Future<TransactionCategory?> addCategory({
    required String label,
    required TransactionType type,
  }) async {
    if (!state.canManage) {
      return null;
    }

    final category = await _repository.addCategory(label: label, type: type);
    final updatedCatalog = _mergeCategory(category);
    emit(state.copyWith(catalog: updatedCatalog));
    return category;
  }

  TransactionCategoryCatalog _mergeCategory(TransactionCategory category) {
    final categories = [
      ...state.catalog.all.where((current) => current.id != category.id),
      category,
    ]..sort((left, right) => left.label.compareTo(right.label));

    return TransactionCategoryCatalog(List.unmodifiable(categories));
  }
}