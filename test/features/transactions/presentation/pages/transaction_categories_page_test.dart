import 'package:fintrack/features/transactions/domain/entities/transaction_category.dart';
import 'package:fintrack/features/transactions/domain/entities/transaction_category_catalog.dart';
import 'package:fintrack/features/transactions/domain/entities/transaction_type.dart';
import 'package:fintrack/features/transactions/domain/repositories/transaction_category_repository.dart';
import 'package:fintrack/features/transactions/presentation/cubit/transaction_category_catalog_cubit.dart';
import 'package:fintrack/features/transactions/presentation/pages/transaction_categories_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('lista categorias e permite criar nova categoria', (tester) async {
    final repository = _InMemoryTransactionCategoryRepository();

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider(
          create: (_) =>
              TransactionCategoryCatalogCubit(
                repository: repository,
                canManage: true,
              )
                ..load(),
          child: const TransactionCategoriesPage(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Categorias'), findsOneWidget);
    expect(find.text('Nova categoria'), findsOneWidget);
    expect(find.text('Alimentação'), findsOneWidget);

    await tester.tap(find.text('Nova categoria'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).last, 'Viagem');
    await tester.tap(find.text('Receita'));
    await tester.tap(find.text('Salvar'));
    await tester.pumpAndSettle();

    expect(repository.addedLabels, ['Viagem']);
    expect(find.text('Viagem'), findsOneWidget);
    expect(find.text('Receita'), findsWidgets);
  });
}

class _InMemoryTransactionCategoryRepository
    implements TransactionCategoryRepository {
  final List<String> addedLabels = [];
  final List<TransactionCategory> _categories = [
    const TransactionCategory(
      id: 'alimentacao',
      label: 'Alimentação',
      type: TransactionType.expense,
    ),
  ];

  @override
  Future<TransactionCategoryCatalog> getCategoryCatalog() async {
    return TransactionCategoryCatalog(List.unmodifiable(_categories));
  }

  @override
  Future<TransactionCategory> addCategory({
    required String label,
    required TransactionType type,
  }) async {
    addedLabels.add(label);
    final category = TransactionCategory(
      id: label.toLowerCase(),
      label: label,
      type: type,
    );
    _categories.add(category);
    return category;
  }
}