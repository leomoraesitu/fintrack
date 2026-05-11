import 'package:fintrack/design_system/widgets/widgets.dart';
import 'package:fintrack/features/transactions/domain/entities/transaction_category.dart';
import 'package:fintrack/features/transactions/domain/entities/transaction_type.dart';
import 'package:fintrack/features/transactions/presentation/cubit/transaction_category_catalog_cubit.dart';
import 'package:fintrack/features/transactions/presentation/cubit/transaction_category_catalog_state.dart';
import 'package:fintrack/features/transactions/presentation/mappers/transaction_category_icon_mapper.dart';
import 'package:fintrack/shared/tokens/tokens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TransactionCategoriesPage extends StatelessWidget {
  const TransactionCategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Brightness brightness = Theme.of(context).brightness;
    return Scaffold(
      appBar: AppBar(title: const Text('Categorias')),
      body: BlocBuilder<
        TransactionCategoryCatalogCubit,
        TransactionCategoryCatalogState
      >(
        builder: (context, state) {
          final categories = state.catalog.all;

          if (categories.isEmpty) {
            return const FtEmptyState(
              title: 'Nenhuma categoria disponível',
              message: 'Crie uma categoria para usá-la em lançamentos e filtros.',
            );
          }

          return ListView(
            padding: const EdgeInsets.all(AppSpacing.md),
            children: [
              if (state.canManage) ...[
                SizedBox(
                  width: double.infinity,
                  child: FtButton(
                    label: 'Nova categoria',
                    icon: const Icon(Icons.add),
                    onPressed: () => _showCreateCategoryDialog(context),
                    fullWidth: true,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
              ],
              ...categories.map(
                (category) => Card(
                  margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: ListTile(
                    leading: Icon(
                      TransactionCategoryIconMapper.fromCategory(category),
                      color: AppColors.hint(brightness),
                    ),
                    title: Text(category.label, style: AppTypography.titleMedium(brightness)),
                    subtitle: Text(
                      category.type == TransactionType.income
                          ? 'Receita'
                          : 'Despesa',
                      style: AppTypography.bodySmall(brightness),    
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _showCreateCategoryDialog(BuildContext context) async {
    final controller = TextEditingController();
    final cubit = context.read<TransactionCategoryCatalogCubit>();
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    var selectedType = TransactionType.expense;

    final createdCategory = await showDialog<TransactionCategory>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Nova categoria'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: controller,
                    autofocus: true,
                    decoration: const InputDecoration(
                      labelText: 'Nome da categoria',
                      hintText: 'Ex: Viagem',
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  SegmentedButton<TransactionType>(
                    segments: const [
                      ButtonSegment<TransactionType>(
                        value: TransactionType.expense,
                        label: Text('Despesa'),
                        icon: Icon(Icons.arrow_upward),
                      ),
                      ButtonSegment<TransactionType>(
                        value: TransactionType.income,
                        label: Text('Receita'),
                        icon: Icon(Icons.arrow_downward),
                      ),
                    ],
                    selected: {selectedType},
                    onSelectionChanged: (selection) {
                      setDialogState(() {
                        selectedType = selection.first;
                      });
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: const Text('Cancelar'),
                ),
                FilledButton(
                  onPressed: () async {
                    final label = controller.text.trim();
                    if (label.isEmpty) {
                      return;
                    }

                    try {
                      final category = await cubit.addCategory(
                        label: label,
                        type: selectedType,
                      );

                      if (!dialogContext.mounted) {
                        return;
                      }

                      Navigator.of(dialogContext).pop(category);
                    } catch (_) {
                      if (!dialogContext.mounted) {
                        return;
                      }

                      scaffoldMessenger.showSnackBar(
                        const SnackBar(
                          content: Text('Nao foi possivel salvar a categoria agora.'),
                        ),
                      );
                    }
                  },
                  child: const Text('Salvar'),
                ),
              ],
            );
          },
        );
      },
    );

    if (createdCategory == null) {
      return;
    }

    scaffoldMessenger.showSnackBar(
      SnackBar(content: Text('Categoria "${createdCategory.label}" criada.')),
    );
  }
}