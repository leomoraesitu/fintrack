import 'package:flutter/material.dart';
import 'package:fintrack/shared/tokens/tokens.dart';

class AuthDemoInfoBanner extends StatelessWidget {
  const AuthDemoInfoBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border.all(
          color: colorScheme.onSurface.withValues(alpha: 0.2),
          width: AppBorders.widthThin,
        ),
        borderRadius: BorderRadius.circular(AppBorders.radiusXM),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: colorScheme.tertiary,
            size: AppSizes.iconSm,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              'Ambiente de demonstracao. Nenhuma credencial real é necessaria.',
              style: textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}
