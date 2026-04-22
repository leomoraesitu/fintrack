import 'package:fintrack/design_system/widgets/buttons/ft_button.dart';
import 'package:fintrack/shared/tokens/tokens.dart';
import 'package:flutter/material.dart';

class FtErrorState extends StatelessWidget {
  const FtErrorState({
    super.key,
    this.icon = Icons.error_outline,
    required this.message,
    this.retryLabel = 'Tentar novamente',
    this.onRetry,
    this.padding = const EdgeInsets.all(AppSpacing.lg),
  });

  final IconData icon;
  final String message;
  final String retryLabel;
  final VoidCallback? onRetry;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: padding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: AppSizes.iconLg),
            const SizedBox(height: AppSpacing.md),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: AppSpacing.md),
              FtButton(
                label: retryLabel,
                onPressed: onRetry,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
