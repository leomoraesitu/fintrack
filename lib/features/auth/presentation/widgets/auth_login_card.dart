import 'package:flutter/material.dart';
import 'package:fintrack/design_system/widgets/widgets.dart';
import 'package:fintrack/shared/tokens/tokens.dart';

class AuthLoginCard extends StatelessWidget {
  const AuthLoginCard({super.key, this.onEnterDemo});
  final VoidCallback? onEnterDemo;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border.all(
          color: colorScheme.onSurface.withValues(alpha: 0.2),
          width: AppBorders.widthThin,
        ),
        borderRadius: BorderRadius.circular(AppBorders.radiusM),

        boxShadow: AppShadows.sm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Bem-vindo',
            style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Use o acesso demonstrativo para entrar e explorar o fluxo inicial.',
            style: textTheme.bodySmall,
          ),
          Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppSpacing.md),
                const FtTextField(
                  label: 'E-mail',
                  hint: 'seu@email.com',
                  leadingIcon: Icon(
                    Icons.email_outlined,
                    size: AppSizes.iconSm,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                const FtTextField(
                  label: 'Senha',
                  hint: '........',
                  leadingIcon: Icon(Icons.lock_outline, size: AppSizes.iconSm),
                  trailingIcon: Icon(
                    Icons.visibility_off_outlined,
                    size: AppSizes.iconSm,
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                FtButton(
                  label: 'Entrar no modo demo',
                  onPressed: onEnterDemo,
                  fullWidth: true,
                  icon: Icon(
                    Icons.login,
                    color: colorScheme.onPrimary,
                    size: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
