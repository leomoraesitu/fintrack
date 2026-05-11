import 'package:fintrack/features/transactions/domain/entities/transaction.dart';
import 'package:fintrack/features/transactions/domain/entities/transaction_category.dart';
import 'package:fintrack/features/transactions/domain/entities/transaction_type.dart';
import 'package:fintrack/features/transactions/domain/repositories/transaction_repository.dart';
import 'package:fintrack/features/transactions/data/repositories/local_transaction_category_repository.dart';
import 'package:fintrack/features/transactions/presentation/cubit/transaction_category_catalog_cubit.dart';
import 'package:fintrack/features/transactions/presentation/cubit/transaction_category_catalog_state.dart';
import 'package:fintrack/features/transactions/presentation/bloc/transaction_form_bloc.dart';
import 'package:fintrack/features/transactions/presentation/bloc/transaction_form_event.dart';
import 'package:fintrack/features/transactions/presentation/bloc/transaction_form_state.dart';
import 'package:fintrack/design_system/widgets/widgets.dart';
import 'package:fintrack/features/transactions/presentation/mappers/transaction_category_icon_mapper.dart';
import 'package:fintrack/shared/tokens/tokens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:fintrack/core/utils/currency_parser.dart';

class TransactionFormPage extends StatelessWidget {
  const TransactionFormPage({super.key, this.transaction});

  final Transaction? transaction;

  @override
  Widget build(BuildContext context) {
    final hasCategoryCatalogCubit = _hasCategoryCatalogCubit(context);

    return BlocProvider(
      create: (context) => TransactionFormBloc(
        repository: context.read<TransactionRepository>(),
      ),
      child: hasCategoryCatalogCubit
          ? _TransactionFormView(transaction: transaction)
          : BlocProvider(
              create: (_) =>
                  TransactionCategoryCatalogCubit(
                    repository: const LocalTransactionCategoryRepository(),
                    canManage: false,
                  )
                    ..load(),
              child: _TransactionFormView(transaction: transaction),
            ),
    );
  }

  bool _hasCategoryCatalogCubit(BuildContext context) {
    try {
      context.read<TransactionCategoryCatalogCubit>();
      return true;
    } on ProviderNotFoundException {
      return false;
    }
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
  Transaction? _loadedTransaction;
  _TransactionFormDraft? _localDraftSnapshot;
  Transaction? _conflictBaseTransaction;
  Transaction? _conflictRemoteTransaction;

  late TransactionType _selectedType;
  late DateTime _selectedDate;
  String? _conflictMessage;
  List<_TransactionConflictHighlight> _conflictHighlights = const [];
  bool _isReloadingConflict = false;
  bool _conflictRequiresClose = false;

  bool get isEditing => widget.transaction != null;

  @override
  void initState() {
    super.initState();

    final t = widget.transaction;

    if (t != null) {
      _applyTransaction(t);
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

  void _applyTransaction(Transaction transaction) {
    _loadedTransaction = transaction;
    _amountController.text = CurrencyParser.format(transaction.amount);
    _descriptionController.text = transaction.description;
    _selectedCategory = transaction.category;
    _selectedType = transaction.type;
    _selectedDate = transaction.date;
  }

  _TransactionFormDraft _captureDraft() {
    return _TransactionFormDraft(
      type: _selectedType,
      amount: CurrencyParser.parse(_amountController.text) ?? 0,
      description: _descriptionController.text.trim(),
      category: _selectedCategory,
      date: _selectedDate,
    );
  }

  void _applyDraft(_TransactionFormDraft draft) {
    _amountController.text = CurrencyParser.format(draft.amount);
    _descriptionController.text = draft.description;
    _selectedCategory = draft.category;
    _selectedType = draft.type;
    _selectedDate = draft.date;
  }

  Future<void> _reloadLatestTransaction() async {
    final transactionId = _loadedTransaction?.id ?? widget.transaction?.id;
    if (transactionId == null) {
      return;
    }

    final previousTransaction = _loadedTransaction ?? widget.transaction;

    setState(() {
      _isReloadingConflict = true;
    });

    try {
      final transactions = await context.read<TransactionRepository>().getTransactions();
      final latestTransaction = transactions
          .where((transaction) => transaction.id == transactionId)
          .firstOrNull;

      if (!mounted) {
        return;
      }

      if (latestTransaction == null) {
        setState(() {
          _conflictMessage =
              'A transação não está mais disponível no backend. Feche esta tela e atualize a lista.';
          _conflictHighlights = const [];
          _conflictRemoteTransaction = null;
          _isReloadingConflict = false;
          _conflictRequiresClose = true;
        });
        return;
      }

      setState(() {
        _conflictBaseTransaction = previousTransaction;
        _conflictRemoteTransaction = latestTransaction;
        _conflictHighlights = _buildRemoteConflictHighlights(
          previousTransaction,
          latestTransaction,
        );
        _applyTransaction(latestTransaction);
        _conflictMessage =
            'Versão mais recente carregada. Revise os dados antes de salvar novamente.';
        _isReloadingConflict = false;
        _conflictRequiresClose = false;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }

      setState(() {
        _conflictMessage =
            'Não foi possível recarregar a transação agora. Tente novamente.';
        _conflictHighlights = const [];
        _conflictRemoteTransaction = null;
        _isReloadingConflict = false;
        _conflictRequiresClose = false;
      });
    }
  }

  Future<void> _showCreateCategoryDialog(FormFieldState<TransactionCategory> field) async {
    final controller = TextEditingController();
    final categoryCatalogCubit = context.read<TransactionCategoryCatalogCubit>();
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    final createdCategory = await showDialog<TransactionCategory>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            _selectedType == TransactionType.income
                ? 'Nova categoria de receita'
                : 'Nova categoria de despesa',
          ),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(
              labelText: 'Nome da categoria',
              hintText: 'Ex: Viagem',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () async {
                final label = controller.text.trim();
                if (label.isEmpty) {
                  return;
                }

                final navigator = Navigator.of(context);

                try {
                  final category = await categoryCatalogCubit.addCategory(
                    label: label,
                    type: _selectedType,
                  );

                  if (!context.mounted) {
                    return;
                  }

                  navigator.pop(category);
                } catch (_) {
                  if (!context.mounted) {
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

    if (!mounted || createdCategory == null) {
      return;
    }

    setState(() {
      _selectedCategory = createdCategory;
    });
    field.didChange(createdCategory);
  }

  List<_TransactionConflictHighlight> _buildRemoteConflictHighlights(
    Transaction? previousTransaction,
    Transaction latestTransaction,
  ) {
    if (previousTransaction == null) {
      return const [];
    }

    final highlights = <_TransactionConflictHighlight>[];

    if (previousTransaction.description != latestTransaction.description) {
      highlights.add(
        _TransactionConflictHighlight(
          label: 'Descrição',
          value: latestTransaction.description,
          source: _TransactionConflictHighlightSource.remote,
        ),
      );
    }

    if (previousTransaction.amount != latestTransaction.amount) {
      highlights.add(
        _TransactionConflictHighlight(
          label: 'Valor',
          value: CurrencyParser.format(latestTransaction.amount),
          source: _TransactionConflictHighlightSource.remote,
        ),
      );
    }

    if (previousTransaction.category.id != latestTransaction.category.id) {
      highlights.add(
        _TransactionConflictHighlight(
          label: 'Categoria',
          value: latestTransaction.category.label,
          source: _TransactionConflictHighlightSource.remote,
        ),
      );
    }

    if (previousTransaction.type != latestTransaction.type) {
      highlights.add(
        _TransactionConflictHighlight(
          label: 'Tipo',
          value: _labelForType(latestTransaction.type),
          source: _TransactionConflictHighlightSource.remote,
        ),
      );
    }

    if (!_isSameDay(previousTransaction.date, latestTransaction.date)) {
      highlights.add(
        _TransactionConflictHighlight(
          label: 'Data',
          value: _formatDate(latestTransaction.date),
          source: _TransactionConflictHighlightSource.remote,
        ),
      );
    }

    return highlights;
  }

  List<_TransactionConflictHighlight> _buildResolvedConflictHighlights({
    required Transaction? previousTransaction,
    required Transaction remoteTransaction,
    required _TransactionFormDraft localDraft,
  }) {
    final highlights = <_TransactionConflictHighlight>[];

    void addHighlight({
      required String label,
      required bool remoteChanged,
      required bool localChanged,
      required String remoteValue,
      required String localValue,
    }) {
      if (!remoteChanged && !localChanged) {
        return;
      }

      highlights.add(
        _TransactionConflictHighlight(
          label: label,
          value: localChanged ? localValue : remoteValue,
          source: localChanged
              ? _TransactionConflictHighlightSource.local
              : _TransactionConflictHighlightSource.remote,
        ),
      );
    }

    addHighlight(
      label: 'Descrição',
      remoteChanged: previousTransaction?.description != remoteTransaction.description,
      localChanged: localDraft.description != remoteTransaction.description,
      remoteValue: remoteTransaction.description,
      localValue: localDraft.description,
    );
    addHighlight(
      label: 'Valor',
      remoteChanged: previousTransaction?.amount != remoteTransaction.amount,
      localChanged: localDraft.amount != remoteTransaction.amount,
      remoteValue: CurrencyParser.format(remoteTransaction.amount),
      localValue: CurrencyParser.format(localDraft.amount),
    );
    addHighlight(
      label: 'Categoria',
      remoteChanged: previousTransaction?.category.id != remoteTransaction.category.id,
      localChanged: localDraft.category?.id != remoteTransaction.category.id,
      remoteValue: remoteTransaction.category.label,
      localValue: localDraft.category?.label ?? 'Sem categoria',
    );
    addHighlight(
      label: 'Tipo',
      remoteChanged: previousTransaction?.type != remoteTransaction.type,
      localChanged: localDraft.type != remoteTransaction.type,
      remoteValue: _labelForType(remoteTransaction.type),
      localValue: _labelForType(localDraft.type),
    );
    addHighlight(
      label: 'Data',
      remoteChanged: previousTransaction == null
          ? false
          : !_isSameDay(previousTransaction.date, remoteTransaction.date),
      localChanged: !_isSameDay(localDraft.date, remoteTransaction.date),
      remoteValue: _formatDate(remoteTransaction.date),
      localValue: _formatDate(localDraft.date),
    );

    return highlights;
  }

  String _labelForType(TransactionType type) {
    return type == TransactionType.income ? 'Receita' : 'Despesa';
  }

  bool _isSameDay(DateTime first, DateTime second) {
    return first.year == second.year &&
        first.month == second.month &&
        first.day == second.day;
  }

  void _dismissConflict() {
    setState(() {
      _conflictMessage = null;
      _conflictHighlights = const [];
      _conflictBaseTransaction = null;
      _conflictRemoteTransaction = null;
      _isReloadingConflict = false;
      _conflictRequiresClose = false;
    });
  }

  void _restoreLocalDraft() {
    final localDraftSnapshot = _localDraftSnapshot;
    final conflictRemoteTransaction = _conflictRemoteTransaction;
    if (localDraftSnapshot == null) {
      return;
    }
    if (conflictRemoteTransaction == null) {
      return;
    }

    setState(() {
      _applyDraft(localDraftSnapshot);
      _conflictMessage =
          'Sua edição local foi reaplicada sobre a versão mais recente. Revise os dados antes de salvar.';
      _conflictHighlights = _buildResolvedConflictHighlights(
        previousTransaction: _conflictBaseTransaction,
        remoteTransaction: conflictRemoteTransaction,
        localDraft: localDraftSnapshot,
      );
      _conflictRequiresClose = false;
    });
  }

  void _closeForm() {
    FocusScope.of(context).unfocus();
    Navigator.of(context).pop(false);
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final amount = CurrencyParser.parse(_amountController.text);

    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Informe um valor valido.')));
      return;
    }

    final transaction = Transaction(
      id: _loadedTransaction?.id ??
          widget.transaction?.id ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      type: _selectedType,
      amount: amount,
      date: _selectedDate,
      description: _descriptionController.text.trim(),
      category: _selectedCategory!,
      updatedAt: _loadedTransaction?.updatedAt,
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

  @override
  Widget build(BuildContext context) {
    return BlocListener<TransactionFormBloc, TransactionFormState>(
      listener: (context, state) {
        if (state is TransactionFormSuccess) {
          if (!context.mounted) return;

          FocusScope.of(context).unfocus();
          Navigator.of(context).pop(true);
        }

        if (state is TransactionFormConflict) {
          setState(() {
            _localDraftSnapshot = _captureDraft();
            _conflictMessage = state.message;
            _conflictHighlights = const [];
            _conflictBaseTransaction = _loadedTransaction ?? widget.transaction;
            _conflictRequiresClose = false;
          });
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
                  if (_conflictMessage != null) ...[
                    _TransactionConflictBanner(
                      message: _conflictMessage!,
                      highlights: _conflictHighlights,
                      isReloading: _isReloadingConflict,
                      onReload: isEditing && !_conflictRequiresClose
                          ? _reloadLatestTransaction
                          : null,
                      onRestoreLocalDraft: _localDraftSnapshot != null &&
                              !_conflictRequiresClose
                          ? _restoreLocalDraft
                          : null,
                      onClose: _conflictRequiresClose ? _closeForm : null,
                      onDismiss: _dismissConflict,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                  ],
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
                            final formatted = CurrencyParser.format(number);

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
                  BlocBuilder<
                    TransactionCategoryCatalogCubit,
                    TransactionCategoryCatalogState
                  >(
                    builder: (context, categoryState) {
                      final availableCategories = categoryState.catalog.byType(
                        _selectedType,
                      );

                      return FormField<TransactionCategory>(
                        validator: (_) {
                          if (_selectedCategory == null) {
                            return 'Selecione a categoria.';
                          }

                          return null;
                        },
                        builder: (field) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              FtFormField(
                                label: 'Categoria',
                                requiredField: true,
                                errorText: field.errorText,
                                child: Wrap(
                                  spacing: AppSpacing.sm,
                                  runSpacing: AppSpacing.sm,
                                  children: availableCategories
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
                              ),
                              if (categoryState.canManage) ...[
                                const SizedBox(height: AppSpacing.xs),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: TextButton.icon(
                                    onPressed: () => _showCreateCategoryDialog(field),
                                    icon: const Icon(Icons.add),
                                    label: Text(
                                      _selectedType == TransactionType.income
                                          ? 'Nova categoria de receita'
                                          : 'Nova categoria de despesa',
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          );
                        },
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

class _TransactionConflictBanner extends StatelessWidget {
  const _TransactionConflictBanner({
    required this.message,
    required this.highlights,
    required this.isReloading,
    required this.onDismiss,
    this.onReload,
    this.onRestoreLocalDraft,
    this.onClose,
  });

  final String message;
  final List<_TransactionConflictHighlight> highlights;
  final bool isReloading;
  final VoidCallback onDismiss;
  final VoidCallback? onReload;
  final VoidCallback? onRestoreLocalDraft;
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(AppBorders.radiusM),
        border: Border.all(
          color: colorScheme.error.withValues(alpha: 0.24),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.sync_problem_outlined, color: colorScheme.error),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  'Conflito detectado',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onErrorContainer,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            message,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: colorScheme.onErrorContainer,
            ),
          ),
          if (highlights.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            ...highlights.map(
              (highlight) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                child: Wrap(
                  spacing: AppSpacing.xs,
                  runSpacing: AppSpacing.xs,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    _ConflictHighlightPill(source: highlight.source),
                    Text(
                      '${highlight.label}:',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onErrorContainer,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      highlight.value,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onErrorContainer,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              if (onReload != null)
                TextButton.icon(
                  onPressed: isReloading ? null : onReload,
                  icon: isReloading
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.refresh),
                  label: Text(
                    isReloading ? 'Recarregando...' : 'Recarregar dados',
                  ),
                ),
              if (onRestoreLocalDraft != null)
                TextButton.icon(
                  onPressed: onRestoreLocalDraft,
                  icon: const Icon(Icons.history),
                  label: const Text('Reaplicar minha edição'),
                ),
              if (onClose != null)
                TextButton.icon(
                  onPressed: onClose,
                  icon: const Icon(Icons.close),
                  label: const Text('Fechar tela'),
                ),
              TextButton(
                onPressed: onDismiss,
                child: const Text('Dispensar'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ConflictHighlightPill extends StatelessWidget {
  const _ConflictHighlightPill({required this.source});

  final _TransactionConflictHighlightSource source;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isLocal = source == _TransactionConflictHighlightSource.local;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: isLocal
            ? colorScheme.primary.withValues(alpha: 0.16)
            : colorScheme.error.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppBorders.radiusXM),
      ),
      child: Text(
        isLocal ? 'Local reaplicado' : 'Versão remota',
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.w600,
          color: isLocal ? colorScheme.primary : colorScheme.error,
        ),
      ),
    );
  }
}

class _TransactionConflictHighlight {
  const _TransactionConflictHighlight({
    required this.label,
    required this.value,
    required this.source,
  });

  final String label;
  final String value;
  final _TransactionConflictHighlightSource source;
}

enum _TransactionConflictHighlightSource { remote, local }

class _TransactionFormDraft {
  const _TransactionFormDraft({
    required this.type,
    required this.amount,
    required this.description,
    required this.category,
    required this.date,
  });

  final TransactionType type;
  final double amount;
  final String description;
  final TransactionCategory? category;
  final DateTime date;
}
