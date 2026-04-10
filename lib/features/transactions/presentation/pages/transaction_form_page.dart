import 'package:fintrack/features/transactions/domain/entities/transaction.dart';
import 'package:fintrack/features/transactions/domain/repositories/transaction_repository.dart';
import 'package:fintrack/features/transactions/presentation/bloc/transaction_form_bloc.dart';
import 'package:fintrack/features/transactions/presentation/bloc/transaction_form_event.dart';
import 'package:fintrack/features/transactions/presentation/bloc/transaction_form_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  final _categoryController = TextEditingController();

  late TransactionType _selectedType;
  late DateTime _selectedDate;

  bool get isEditing => widget.transaction != null;

  @override
  void initState() {
    super.initState();

    final t = widget.transaction;

    if (t != null) {
      _amountController.text = t.amount.toStringAsFixed(2);
      _descriptionController.text = t.description;
      _categoryController.text = t.category;
      _selectedType = t.type;
      _selectedDate = t.date;
    } else {
      _selectedType = TransactionType.expense;
      _selectedDate = DateTime.now();
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
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
      category: _categoryController.text.trim(),
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
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isEditing
                        ? 'Edite os dados da transação.'
                        : 'Preencha os dados para adicionar uma transação.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 24),
                  Text('Tipo', style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: 8),
                  SegmentedButton<TransactionType>(
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
                      });
                    },
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: _amountController,
                    decoration: const InputDecoration(
                      labelText: 'Valor',
                      hintText: '0,00',
                    ),
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Informe o valor.';
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(labelText: 'Descricao'),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Informe a descricao.';
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _categoryController,
                    decoration: const InputDecoration(labelText: 'Categoria'),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Informe a categoria.';
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Data'),
                    subtitle: Text(_formatDate(_selectedDate)),
                    trailing: TextButton(
                      onPressed: _selectDate,
                      child: const Text('Selecionar'),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child:
                        BlocBuilder<TransactionFormBloc, TransactionFormState>(
                          builder: (context, state) {
                            final isSubmitting =
                                state is TransactionFormSubmitting;

                            return ElevatedButton(
                              onPressed: isSubmitting ? null : _submit,
                              child: isSubmitting
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : Text(
                                      isEditing
                                          ? 'Salvar alterações'
                                          : 'Salvar transação',
                                    ),
                            );
                          },
                        ),
                  ),
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
        return AlertDialog(
          title: const Text('Excluir transação'),
          content: Text(
            'Deseja excluir "${transaction.description}" '
            'de R\$ ${transaction.amount.toStringAsFixed(2)}?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Excluir'),
            ),
          ],
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
