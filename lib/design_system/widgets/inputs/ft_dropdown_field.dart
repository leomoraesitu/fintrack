import 'package:fintrack/design_system/widgets/inputs/ft_form_field.dart';
import 'package:fintrack/shared/tokens/tokens.dart';
import 'package:flutter/material.dart';

class FtDropdownField<T> extends StatelessWidget {
  const FtDropdownField({
    super.key,
    required this.label,
    required this.items,
    this.value,
    this.hint,
    this.onChanged,
    this.validator,
    this.requiredField = false,
    this.helperText,
    this.errorText,
    this.enabled = true,
  });

  final String label;
  final List<DropdownMenuItem<T>> items;
  final T? value;
  final Widget? hint;
  final ValueChanged<T?>? onChanged;
  final FormFieldValidator<T>? validator;
  final bool requiredField;
  final String? helperText;
  final String? errorText;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final brightness = MediaQuery.platformBrightnessOf(context);
    final secondaryTextColor = AppColors.secondaryText(brightness);
    final hintColor = AppColors.hint(brightness);
    final borderColor = AppColors.divider(brightness);
    final focusColor = AppColors.primary(brightness);
    final errorColor = AppColors.error(brightness);
    final disabledForegroundColor = AppColors.onSurface(
      brightness,
    ).withValues(alpha: 0.38);
    final disabledContainerColor = AppColors.onSurface(
      brightness,
    ).withValues(alpha: 0.12);

    final baseOutline = OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppBorders.radiusS),
    );

    final border = baseOutline.copyWith(
      borderSide: BorderSide(
        color: borderColor,
        width: AppBorders.widthMedium,
      ),
    );

    final focusedBorder = baseOutline.copyWith(
      borderSide: BorderSide(
        color: focusColor,
        width: AppBorders.widthThick,
      ),
    );

    final errorBorder = baseOutline.copyWith(
      borderSide: BorderSide(
        color: errorColor,
        width: AppBorders.widthThick,
      ),
    );

    final disabledBorder = baseOutline.copyWith(
      borderSide: BorderSide(
        color: disabledForegroundColor.withValues(alpha: 0.32),
        width: AppBorders.widthMedium,
      ),
    );

    return FtFormField(
      label: label,
      requiredField: requiredField,
      helperText: helperText,
      errorText: errorText,
      enabled: enabled,
      child: DropdownButtonFormField<T>(
        initialValue: value,
        items: items,
        hint: hint,
        onChanged: enabled ? onChanged : null,
        validator: validator,
        style: AppTypography.bodyMedium(brightness).copyWith(
          color: enabled
              ? AppColors.primaryText(brightness)
              : disabledForegroundColor,
        ),
        iconEnabledColor: secondaryTextColor,
        iconDisabledColor: disabledForegroundColor,
        dropdownColor: AppColors.surface(brightness),
        decoration: InputDecoration(
          hintStyle: AppTypography.bodyMedium(
            brightness,
          ).copyWith(color: hintColor),
          errorStyle: AppTypography.bodySmall(
            brightness,
          ).copyWith(color: errorColor),
          filled: true,
          fillColor: enabled
              ? AppColors.surface(brightness)
              : disabledContainerColor,
          border: border,
          enabledBorder: border,
          focusedBorder: focusedBorder,
          disabledBorder: disabledBorder,
          errorBorder: errorBorder,
          focusedErrorBorder: errorBorder,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.sm,
          ),
        ),
      ),
    );
  }
}
