import 'package:fintrack/features/transactions/domain/entities/transaction_category.dart';
import 'package:fintrack/features/transactions/domain/entities/transaction_type.dart';
import 'package:flutter/material.dart';

class TransactionCategoryIconMapper {
  const TransactionCategoryIconMapper._();

  static IconData fromCategory(TransactionCategory category) {
    return fromId(category.id, fallbackType: category.type);
  }

  static IconData fromId(String categoryId, {TransactionType? fallbackType}) {
    switch (categoryId) {
      case 'salario':
        return Icons.badge_rounded;
      case 'freelance':
        return Icons.work_rounded;
      case 'investimentos':
        return Icons.trending_up;
      case 'outras_receitas':
        return Icons.attach_money;
      case 'alimentacao':
        return Icons.restaurant_rounded;
      case 'transporte':
        return Icons.directions_bus_rounded;
      case 'moradia':
        return Icons.home_rounded;
      case 'saude':
        return Icons.health_and_safety_rounded;
      case 'educacao':
        return Icons.school_rounded;
      case 'lazer':
        return Icons.sports_esports_rounded;
      case 'compras':
        return Icons.shopping_bag_rounded;
      case 'contas':
        return Icons.receipt_long_rounded;
      case 'outras_despesas':
        return Icons.payments_rounded;
      default:
        if (fallbackType == TransactionType.income) {
          return Icons.arrow_downward_rounded;
        }

        return Icons.arrow_upward_rounded;
    }
  }
}
