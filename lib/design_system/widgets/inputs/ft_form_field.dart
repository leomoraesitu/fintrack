import 'package:fintrack/shared/tokens/tokens.dart';
import 'package:flutter/material.dart';

/// Container de campo de formulário do Design System FinTrack.
///
/// Padroniza rótulo, marcação de obrigatório, helper e mensagem de erro
/// para qualquer tipo de input (text, dropdown, date picker, switch etc.).
class FtFormField extends StatelessWidget {
  final String? label;
  final Widget child;
  final String? helperText;
  final String? errorText;
  final bool requiredField;
  final bool enabled;
  final EdgeInsetsGeometry? margin;

  const FtFormField({
    super.key,
    this.label,
    required this.child,
    this.helperText,
    this.errorText,
    this.requiredField = false,
    this.enabled = true,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    final brightness = MediaQuery.platformBrightnessOf(context);
    final labelColor = enabled
        ? AppColors.primaryText(brightness)
        : AppColors.onSurface(brightness).withValues(alpha: 0.38);
    final helperColor = enabled
        ? AppColors.secondaryText(brightness)
        : AppColors.onSurface(brightness).withValues(alpha: 0.38);
    final errorColor = enabled
        ? AppColors.error(brightness)
        : AppColors.onSurface(brightness).withValues(alpha: 0.38);
    final hasError = errorText != null && errorText!.trim().isNotEmpty;
    final hasHelper = helperText != null && helperText!.trim().isNotEmpty;

    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (label != null) ...[
            RichText(
              text: TextSpan(
                style: AppTypography.labelMedium(brightness).copyWith(
                  color: labelColor,
                ),
                children: [
                  TextSpan(text: label),
                  if (requiredField)
                    TextSpan(
                      text: ' *',
                      style: AppTypography.labelMedium(brightness).copyWith(
                        color: errorColor,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
          ],
          child,
          if (hasError) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              errorText!,
              style: AppTypography.bodySmall(brightness).copyWith(
                color: errorColor,
              ),
            ),
          ] else if (hasHelper) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              helperText!,
              style: AppTypography.bodySmall(brightness).copyWith(
                color: helperColor,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
