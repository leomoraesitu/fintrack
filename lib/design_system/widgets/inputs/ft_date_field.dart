import 'package:fintrack/design_system/widgets/inputs/ft_form_field.dart';
import 'package:fintrack/shared/tokens/tokens.dart';
import 'package:flutter/material.dart';

class FtDateField extends StatelessWidget {
  const FtDateField({
    super.key,
    required this.label,
    required this.valueText,
    required this.onSelectDate,
    this.requiredField = false,
    this.helperText,
    this.errorText,
    this.enabled = true,
  });

  final String label;
  final String valueText;
  final VoidCallback onSelectDate;
  final bool requiredField;
  final String? helperText;
  final String? errorText;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final brightness = MediaQuery.platformBrightnessOf(context);
    final borderColor = AppColors.divider(brightness);
    final disabledForegroundColor = AppColors.onSurface(
      brightness,
    ).withValues(alpha: 0.38);
    final disabledContainerColor = AppColors.onSurface(
      brightness,
    ).withValues(alpha: 0.12);

    return FtFormField(
      label: label,
      requiredField: requiredField,
      helperText: helperText,
      errorText: errorText,
      enabled: enabled,
      child: Container(
        decoration: BoxDecoration(
          color: enabled
              ? AppColors.surface(brightness)
              : disabledContainerColor,
          border: Border.all(
            color: enabled
                ? borderColor
                : disabledForegroundColor.withValues(alpha: 0.32),
            width: AppBorders.widthMedium,
          ),
          borderRadius: BorderRadius.circular(AppBorders.radiusS),
        ),
        padding: const EdgeInsets.symmetric(          
          vertical: AppSpacing.xs,
        ),
        child: Row(
          children: [
            SizedBox(width: AppSpacing.md,),
            Expanded(
              child: Text(
                valueText,
                style: AppTypography.bodyMedium(brightness).copyWith(
                  color: enabled
                      ? AppColors.primaryText(brightness)
                      : disabledForegroundColor,
                ),
              ),
            ),
            IconButton(
              onPressed: enabled ? onSelectDate : null,
              icon: Icon(Icons.calendar_today_rounded),
              iconSize: AppSizes.iconSm,
            ),
          ],
        ),
      ),
    );
  }
}
