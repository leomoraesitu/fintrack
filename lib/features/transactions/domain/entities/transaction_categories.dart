import 'package:fintrack/features/transactions/domain/entities/transaction_category.dart';
import 'package:fintrack/features/transactions/domain/entities/transaction_type.dart';

class TransactionCategories {
  const TransactionCategories._();

  static const salary = TransactionCategory(
    id: 'salario',
    label: 'Salário',
    type: TransactionType.income,
  );

  static const freelance = TransactionCategory(
    id: 'freelance',
    label: 'Freelance',
    type: TransactionType.income,
  );

  static const investments = TransactionCategory(
    id: 'investimentos',
    label: 'Investimentos',
    type: TransactionType.income,
  );

  static const otherIncome = TransactionCategory(
    id: 'outras_receitas',
    label: 'Outras receitas',
    type: TransactionType.income,
  );

  static const food = TransactionCategory(
    id: 'alimentacao',
    label: 'Alimentação',
    type: TransactionType.expense,
  );

  static const transport = TransactionCategory(
    id: 'transporte',
    label: 'Transporte',
    type: TransactionType.expense,
  );

  static const housing = TransactionCategory(
    id: 'moradia',
    label: 'Moradia',
    type: TransactionType.expense,
  );

  static const health = TransactionCategory(
    id: 'saude',
    label: 'Saúde',
    type: TransactionType.expense,
  );

  static const education = TransactionCategory(
    id: 'educacao',
    label: 'Educação',
    type: TransactionType.expense,
  );

  static const leisure = TransactionCategory(
    id: 'lazer',
    label: 'Lazer',
    type: TransactionType.expense,
  );

  static const shopping = TransactionCategory(
    id: 'compras',
    label: 'Compras',
    type: TransactionType.expense,
  );

  static const bills = TransactionCategory(
    id: 'contas',
    label: 'Contas',
    type: TransactionType.expense,
  );

  static const otherExpense = TransactionCategory(
    id: 'outras_despesas',
    label: 'Outras despesas',
    type: TransactionType.expense,
  );

  static const incomeCategories = [salary, freelance, investments, otherIncome];

  static const expenseCategories = [
    food,
    transport,
    housing,
    health,
    education,
    leisure,
    shopping,
    bills,
    otherExpense,
  ];

  static const all = [...incomeCategories, ...expenseCategories];
}
