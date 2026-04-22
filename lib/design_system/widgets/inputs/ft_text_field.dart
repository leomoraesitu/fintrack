import 'package:fintrack/shared/tokens/tokens.dart';
import 'package:flutter/material.dart';

/// TextField padrão do Design System FinTrack
///
/// Variantes: outlined, filled, ghost
/// Estados: erro, enabled/disabled
/// Suporte a ícones, label, helper, hint
class FtTextField extends StatelessWidget {
  final String? label;
  final String? helper;
  final String? hint;
  final String? value;
  final TextEditingController? controller;
  final bool error;
  final bool enabled;
  final FtTextFieldVariant variant;
  final Widget? leadingIcon;
  final Widget? trailingIcon;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;
  final TextInputType? keyboardType;
  final bool obscureText;
  final int? maxLines;

  const FtTextField({
    super.key,
    this.label,
    this.helper,
    this.hint,
    this.value,
    this.controller,
    this.error = false,
    this.enabled = true,
    this.variant = FtTextFieldVariant.outlined,
    this.leadingIcon,
    this.trailingIcon,
    this.onChanged,
    this.validator,
    this.keyboardType,
    this.obscureText = false,
    this.maxLines = 1,
  }) : assert(
         controller == null || value == null,
         'Use controller ou value, não ambos.',
       );

  @override
  Widget build(BuildContext context) {
    final brightness = MediaQuery.platformBrightnessOf(context);
    final primaryTextColor = AppColors.primaryText(brightness);
    final secondaryTextColor = AppColors.secondaryText(brightness);
    final hintColor = AppColors.hint(brightness);
    final borderColor = AppColors.divider(brightness);
    final errorColor = AppColors.error(brightness);
    final focusColor = AppColors.primary(brightness);
    final disabledForegroundColor = AppColors.onSurface(
      brightness,
    ).withValues(alpha: 0.38);
    final disabledContainerColor = AppColors.onSurface(
      brightness,
    ).withValues(alpha: 0.12);

    final OutlineInputBorder baseOutline = OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppBorders.radiusS),
    );

    final InputBorder border;
    final InputBorder enabledBorder;
    final InputBorder focusedBorder;
    final InputBorder? errorBorder;
    final bool filled;
    final Color? fillColor;

    switch (variant) {
      case FtTextFieldVariant.outlined:
        border = baseOutline.copyWith(
          borderSide: BorderSide(
            color: borderColor,
            width: AppBorders.widthMedium,
          ),
        );
        enabledBorder = baseOutline.copyWith(
          borderSide: BorderSide(
            color: borderColor,
            width: AppBorders.widthMedium,
          ),
        );
        focusedBorder = baseOutline.copyWith(
          borderSide: BorderSide(
            color: focusColor,
            width: AppBorders.widthThick,
          ),
        );
        errorBorder = baseOutline.copyWith(
          borderSide: BorderSide(
            color: errorColor,
            width: AppBorders.widthThick,
          ),
        );
        filled = false;
        fillColor = null;
        break;
      case FtTextFieldVariant.filled:
        border = baseOutline.copyWith(borderSide: BorderSide.none);
        enabledBorder = baseOutline.copyWith(borderSide: BorderSide.none);
        focusedBorder = baseOutline.copyWith(
          borderSide: BorderSide(
            color: focusColor,
            width: AppBorders.widthMedium,
          ),
        );
        errorBorder = baseOutline.copyWith(
          borderSide: BorderSide(
            color: errorColor,
            width: AppBorders.widthMedium,
          ),
        );
        filled = true;
        fillColor = AppColors.surface(brightness);
        break;
      case FtTextFieldVariant.ghost:
        border = InputBorder.none;
        enabledBorder = InputBorder.none;
        focusedBorder = InputBorder.none;
        errorBorder = InputBorder.none;
        filled = false;
        fillColor = null;
        break;
    }

    final InputBorder disabledBorder = switch (variant) {
      FtTextFieldVariant.outlined => baseOutline.copyWith(
        borderSide: BorderSide(
          color: disabledForegroundColor.withValues(alpha: 0.32),
          width: AppBorders.widthMedium,
        ),
      ),
      FtTextFieldVariant.filled => baseOutline.copyWith(borderSide: BorderSide.none),
      FtTextFieldVariant.ghost => InputBorder.none,
    };

    final decoration = InputDecoration(
      hintText: hint,
      helperText: helper,
      hintStyle: AppTypography.bodyMedium(brightness).copyWith(color: hintColor),
      helperStyle: AppTypography.bodySmall(
        brightness,
      ).copyWith(color: secondaryTextColor),
      errorStyle: AppTypography.bodySmall(
        brightness,
      ).copyWith(color: errorColor),
      prefixIcon: leadingIcon,
      suffixIcon: trailingIcon,
      prefixIconColor: enabled ? primaryTextColor : disabledForegroundColor,
      suffixIconColor: enabled ? primaryTextColor : disabledForegroundColor,
      filled: filled,
      fillColor: enabled
          ? fillColor
          : (filled ? disabledContainerColor : AppColors.transparent(brightness)),
      border: border,
      enabledBorder: enabledBorder,
      focusedBorder: focusedBorder,
      disabledBorder: disabledBorder,
      errorBorder: errorBorder,
      focusedErrorBorder: errorBorder,
      errorText: error ? ' ' : null,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.sm,
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.xs),
            child: Text(
              label!,
              style: AppTypography.labelLarge(brightness).copyWith(
                color: enabled ? primaryTextColor : disabledForegroundColor,
              ),
            ),
          ),
        TextFormField(
          controller: controller,
          initialValue: controller == null ? value : null,
          enabled: enabled,
          obscureText: obscureText,
          keyboardType: keyboardType,
          maxLines: maxLines,
          style: AppTypography.bodyMedium(brightness).copyWith(
            color: enabled ? primaryTextColor : disabledForegroundColor,
          ),
          onChanged: onChanged,
          validator: validator,
          decoration: decoration,
        ),
      ],
    );
  }
}

enum FtTextFieldVariant { outlined, filled, ghost }
