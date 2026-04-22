import 'package:fintrack/features/transactions/domain/entities/transaction.dart';
import 'package:fintrack/features/transactions/domain/entities/transaction_categories.dart';
import 'package:fintrack/features/transactions/domain/entities/transaction_category.dart';
import 'package:fintrack/features/transactions/domain/entities/transaction_type.dart';
import 'package:fintrack/features/transactions/domain/repositories/transaction_repository.dart';
import 'package:fintrack/features/transactions/presentation/bloc/transaction_form_bloc.dart';
import 'package:fintrack/features/transactions/presentation/bloc/transaction_form_event.dart';
import 'package:fintrack/features/transactions/presentation/bloc/transaction_form_state.dart';
import 'package:fintrack/design_system/widgets/widgets.dart';
import 'package:fintrack/features/transactions/presentation/mappers/transaction_category_icon_mapper.dart';
import 'package:fintrack/shared/tokens/tokens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:intl/intl.dart';

class TransactionFormPage extends StatelessWidget {
  const TransactionFormPage({super.key, this.transaction});

  final Transaction? transaction;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TransactionFormBloc(
        repository: context.read<TransactionRepository>(),
      ),
      child: _TransactionFormView(transaction: transaction),
    );
  }
}

class _TransactionFormView extends StatefulWidget {
  const _TransactionFormView({this.transaction});

  final Transaction? transaction;

  @override
  State<_TransactionFormView> createState() => _TransactionFormViewState();
}

class _TransactionFormViewState extends State<_TransactionFormView> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  TransactionCategory? _selectedCategory;

  late TransactionType _selectedType;
  late DateTime _selectedDate;

  bool get isEditing => widget.transaction != null;

  List<TransactionCategory> get _availableCategories {
    if (_selectedType == TransactionType.income) {
      return TransactionCategories.incomeCategories;
    }

    return TransactionCategories.expenseCategories;
  }

  @override
  void initState() {
    super.initState();

    final t = widget.transaction;

    final currencyFormat = NumberFormat.currency(locale: 'pt_BR', symbol: '');

    if (t != null) {
      _amountController.text = currencyFormat.format(t.amount);
      _descriptionController.text = t.description;
      _selectedCategory = t.category;
      _selectedType = t.type;
      _selectedDate = t.date;
    } else {
      _selectedType = TransactionType.expense;
      _selectedDate = DateTime.now();
      _selectedCategory = null;
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (selectedDate == null) {
      return;
    }

    setState(() {
      _selectedDate = selectedDate;
    });
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final normalizedAmount = _amountController.text.replaceAll(',', '.');
    final amount = double.tryParse(normalizedAmount);

    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Informe um valor valido.')));
      return;
    }

    final transaction = Transaction(
      id:
          widget.transaction?.id ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      type: _selectedType,
      amount: amount,
      date: _selectedDate,
      description: _descriptionController.text.trim(),
      category: _selectedCategory!,
    );

    if (isEditing) {
      context.read<TransactionFormBloc>().add(TransactionUpdated(transaction));
    } else {
      context.read<TransactionFormBloc>().add(TransactionCreated(transaction));
    }
  }

  String _formatDate(DateTime value) {
    final day = value.day.toString().padLeft(2, '0');
    final month = value.month.toString().padLeft(2, '0');
    final year = value.year.toString();
    return '$day/$month/$year';
  }

  /* Widget _buildDesignSystemStatesPreview() {
    final brightness = MediaQuery.platformBrightnessOf(context);
    final surfaceColor = AppColors.surface(brightness);
    final dividerColor = AppColors.divider(brightness);
    final errorColor = AppColors.error(brightness);
    final disabledContainerColor = AppColors.onSurface(
      brightness,
    ).withValues(alpha: 0.12);
    final disabledBorderColor = AppColors.onSurface(
      brightness,
    ).withValues(alpha: 0.32);
    final disabledTextColor = AppColors.onSurface(
      brightness,
    ).withValues(alpha: 0.38);

    return ExpansionTile(
      tilePadding: EdgeInsets.zero,
      childrenPadding: const EdgeInsets.only(bottom: AppSpacing.sm),
      title: Text(
        'Estados DS (exemplos)',
        style: AppTypography.titleMedium(brightness),
      ),
      children: [
        const FtTextField(
          label: 'Texto com helper',
          hint: 'Digite um e-mail',
          helper: 'Exemplo de helper em campo de texto.',
          leadingIcon: Icon(Icons.email_outlined, size: AppSizes.iconSm),
        ),
        const SizedBox(height: AppSpacing.sm),
        const FtTextField(
          label: 'Texto com erro',
          hint: 'Campo inválido',
          error: true,
          helper: 'Borda e estado de erro ativos.',
        ),
        const SizedBox(height: AppSpacing.sm),
        const FtTextField(
          label: 'Texto desabilitado',
          value: 'Valor somente leitura',
          helper: 'Exemplo de estado desabilitado.',
          enabled: false,
        ),
        const SizedBox(height: AppSpacing.sm),
        FtDropdownField<String>(
          label: 'Dropdown com helper',
          value: 'alimentacao',
          helperText: 'Exemplo de helper em dropdown.',
          items: const [
            DropdownMenuItem(value: 'alimentacao', child: Text('Alimentação')),
            DropdownMenuItem(value: 'transporte', child: Text('Transporte')),
          ],
          onChanged: (_) {},
        ),
        const SizedBox(height: AppSpacing.sm),
        FtDropdownField<String>(
          label: 'Dropdown com erro',
          errorText: 'Selecione uma categoria válida.',
          items: const [
            DropdownMenuItem(value: 'moradia', child: Text('Moradia')),
          ],
          onChanged: (_) {},
        ),
        const SizedBox(height: AppSpacing.sm),
        FtDropdownField<String>(
          label: 'Dropdown desabilitado',
          value: 'saude',
          helperText: 'Exemplo de estado desabilitado.',
          enabled: false,
          items: const [DropdownMenuItem(value: 'saude', child: Text('Saúde'))],
          onChanged: (_) {},
        ),
        const SizedBox(height: AppSpacing.sm),
        FtDateField(
          label: 'Data com helper',
          valueText: _formatDate(_selectedDate),
          helperText: 'Exemplo de helper em campo de data.',
          onSelectDate: () {},
        ),
        const SizedBox(height: AppSpacing.sm),
        FtDateField(
          label: 'Data com erro',
          valueText: '--/--/----',
          errorText: 'Informe uma data válida.',
          onSelectDate: () {},
        ),
        const SizedBox(height: AppSpacing.sm),
        FtDateField(
          label: 'Data desabilitada',
          valueText: _formatDate(_selectedDate),
          helperText: 'Exemplo de estado desabilitado.',
          enabled: false,
          onSelectDate: () {},
        ),
        const SizedBox(height: AppSpacing.sm),
        FtFormField(
          label: 'Container FtFormField (direto)',
          helperText: 'Helper aplicado pelo FtFormField.',
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: surfaceColor,
              border: Border.all(
                color: dividerColor,
                width: AppBorders.widthMedium,
              ),
              borderRadius: BorderRadius.circular(AppBorders.radiusS),
            ),
            child: Text(
              'Exemplo de child customizado.',
              style: AppTypography.bodyMedium(brightness),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        FtFormField(
          label: 'Container FtFormField com erro',
          errorText: 'Erro demonstrativo do wrapper.',
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: surfaceColor,
              border: Border.all(
                color: errorColor,
                width: AppBorders.widthMedium,
              ),
              borderRadius: BorderRadius.circular(AppBorders.radiusS),
            ),
            child: Text(
              'Estado de erro no FtFormField.',
              style: AppTypography.bodyMedium(brightness),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        FtFormField(
          label: 'Container FtFormField desabilitado',
          helperText: 'Estado desabilitado no wrapper.',
          enabled: false,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: disabledContainerColor,
              border: Border.all(
                color: disabledBorderColor,
                width: AppBorders.widthMedium,
              ),
              borderRadius: BorderRadius.circular(AppBorders.radiusS),
            ),
            child: Text(
              'Child desabilitado.',
              style: AppTypography.bodyMedium(
                brightness,
              ).copyWith(color: disabledTextColor),
            ),
          ),
        ),
      ],
    );
  } */

  @override
  Widget build(BuildContext context) {
    return BlocListener<TransactionFormBloc, TransactionFormState>(
      listener: (context, state) {
        if (state is TransactionFormSuccess) {
          if (!context.mounted) return;

          Navigator.of(context).pop(true);
        }

        if (state is TransactionFormError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(isEditing ? 'Editar transação' : 'Nova transação'),
          actions: [
            if (isEditing)
              BlocBuilder<TransactionFormBloc, TransactionFormState>(
                builder: (context, state) {
                  final isSubmitting = state is TransactionFormSubmitting;

                  return IconButton(
                    icon: isSubmitting
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.delete),
                    onPressed: isSubmitting ? null : _confirmDelete,
                  );
                },
              ),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      isEditing ? 'Valor da transação' : 'Valor da transação',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Row(
                    spacing: AppSpacing.xs,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'R\$',
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                      IntrinsicWidth(
                        child: TextField(
                          controller: _amountController,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.displayLarge
                              ?.copyWith(fontWeight: FontWeight.w500),
                          decoration: const InputDecoration(
                            hintText: '0,00',
                            border: InputBorder.none,
                            filled: false,
                            isCollapsed: true,
                          ),
                          onChanged: (value) {
                            final numbersOnly = value.replaceAll(
                              RegExp(r'[^0-9]'),
                              '',
                            );

                            if (numbersOnly.isEmpty) {
                              _amountController.value = const TextEditingValue(
                                text: '',
                                selection: TextSelection.collapsed(offset: 0),
                              );
                              return;
                            }

                            final number = double.parse(numbersOnly) / 100;

                            final formatted = number
                                .toStringAsFixed(2)
                                .replaceAll('.', ',')
                                .replaceAllMapped(
                                  RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
                                  (match) => '${match[1]}.',
                                );

                            _amountController.value = TextEditingValue(
                              text: formatted,
                              selection: TextSelection.collapsed(
                                offset: formatted.length,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text('Tipo', style: Theme.of(context).textTheme.labelLarge),
                  const SizedBox(height: AppSpacing.sm),
                  Center(
                    child: SizedBox(
                      width: AppSizes.widthFull,
                      child: SegmentedButton<TransactionType>(
                        style: SegmentedButton.styleFrom(
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.surface,
                          selectedForegroundColor: Theme.of(
                            context,
                          ).colorScheme.onPrimary,
                          selectedBackgroundColor: Theme.of(
                            context,
                          ).colorScheme.primary,
                          side: BorderSide(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withValues(alpha: 0.12),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              AppBorders.radiusXM,
                            ),
                          ),
                        ),
                        segments: const [
                          ButtonSegment<TransactionType>(
                            value: TransactionType.income,
                            label: Text('Receita'),
                            icon: Icon(Icons.arrow_downward),
                          ),
                          ButtonSegment<TransactionType>(
                            value: TransactionType.expense,
                            label: Text('Despesa'),
                            icon: Icon(Icons.arrow_upward),
                          ),
                        ],
                        selected: {_selectedType},
                        onSelectionChanged: (selection) {
                          setState(() {
                            _selectedType = selection.first;

                            if (_selectedCategory?.type != _selectedType) {
                              _selectedCategory = null;
                            }
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  const SizedBox(height: AppSpacing.md),
                  FtTextField(
                    label: 'Descrição',
                    controller: _descriptionController,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Informe a descricao.';
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: AppSpacing.md),
                  FormField<TransactionCategory>(
                    validator: (_) {
                      if (_selectedCategory == null) {
                        return 'Selecione a categoria.';
                      }

                      return null;
                    },
                    builder: (field) {
                      return FtFormField(
                        label: 'Categoria',
                        requiredField: true,
                        errorText: field.errorText,
                        child: Wrap(
                          spacing: AppSpacing.sm,
                          runSpacing: AppSpacing.sm,
                          children: _availableCategories
                              .map(
                                (category) => FtChoiceChip(
                                  icon:
                                      TransactionCategoryIconMapper.fromCategory(
                                        category,
                                      ),
                                  label: category.label,
                                  selected:
                                      _selectedCategory?.id == category.id,
                                  onSelected: (_) {
                                    setState(() {
                                      _selectedCategory = category;
                                    });
                                    field.didChange(category);
                                  },
                                ),
                              )
                              .toList(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: AppSpacing.md),
                  FtDateField(
                    label: 'Data',
                    valueText: _formatDate(_selectedDate),
                    onSelectDate: _selectDate,
                    requiredField: true,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  SizedBox(
                    width: double.infinity,
                    child:
                        BlocBuilder<TransactionFormBloc, TransactionFormState>(
                          builder: (context, state) {
                            final isSubmitting =
                                state is TransactionFormSubmitting;

                            return FtButton(
                              label: isEditing
                                  ? 'Salvar alterações'
                                  : 'Salvar transação',
                              onPressed: isSubmitting ? null : _submit,
                              loading: isSubmitting,
                              fullWidth: true,
                            );
                          },
                        ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  //_buildDesignSystemStatesPreview(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _confirmDelete() async {
    final transaction = widget.transaction;
    if (transaction == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        final Brightness brightness = Theme.of(context).brightness;
        return Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: AlertDialog(
            icon: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: AppColors.error(brightness).withAlpha(80),
                    shape: BoxShape.circle,
                  ),
                ),
                Icon(
                  Icons.delete_forever_rounded,
                  color: AppColors.surface(brightness),
                ),
              ],
            ),
            title: Center(child: const Text('Excluir transação?')),
            content: Text(
              'Deseja excluir "${transaction.description}" '
              'de R\$ ${transaction.amount.toStringAsFixed(2)}?',
            ),
            actions: [
              Center(
                child: SizedBox(
                  width: AppSizes.widthFull,
                  child: FtButton(
                    label: 'Excluir',
                    icon: Icon(Icons.delete_outline_rounded),
                    variant: FtButtonVariant.destructive,
                    onPressed: () => Navigator.of(context).pop(true),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Center(
                child: SizedBox(
                  width: AppSizes.widthFull,
                  child: FtButton(
                    label: 'Cancelar',
                    variant: FtButtonVariant.outline,
                    onPressed: () => Navigator.of(context).pop(false),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );

    if (confirmed != true) return;

    _delete();
  }

  void _delete() {
    final transaction = widget.transaction;
    if (transaction == null) return;

    context.read<TransactionFormBloc>().add(TransactionDeleted(transaction.id));
  }
}
