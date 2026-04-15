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
  final bool error;
  final bool enabled;
  final FtTextFieldVariant variant;
  final Widget? leadingIcon;
  final Widget? trailingIcon;
  final ValueChanged<String>? onChanged;
  final int? maxLines;

  const FtTextField({
    super.key,
    this.label,
    this.helper,
    this.hint,
    this.value,
    this.error = false,
    this.enabled = true,
    this.variant = FtTextFieldVariant.outlined,
    this.leadingIcon,
    this.trailingIcon,
    this.onChanged,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    final InputBorder border;
    final Color fillColor;
    switch (variant) {
      case FtTextFieldVariant.outlined:
        border = OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: error ? Colors.red : Colors.grey,
            width: 1.5,
          ),
        );
        fillColor = Colors.transparent;
        break;
      case FtTextFieldVariant.filled:
        border = OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        );
        fillColor = Colors.grey.withOpacity(0.15);
        break;
      case FtTextFieldVariant.ghost:
        border = InputBorder.none;
        fillColor = Colors.transparent;
        break;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(
              label!,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        TextField(
          controller: value != null ? TextEditingController(text: value) : null,
          enabled: enabled,
          maxLines: maxLines,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hint,
            helperText: helper,
            prefixIcon: leadingIcon,
            suffixIcon: trailingIcon,
            filled: variant == FtTextFieldVariant.filled,
            fillColor: fillColor,
            border: border,
            enabledBorder: border,
            focusedBorder: border.copyWith(
              borderSide: border is OutlineInputBorder
                  ? BorderSide(
                      color: error ? Colors.red : Theme.of(context).colorScheme.primary,
                      width: 2,
                    )
                  : BorderSide.none,
            ),
            errorText: error ? ' ' : null,
            errorBorder: border is OutlineInputBorder
                ? border.copyWith(
                    borderSide: BorderSide(color: Colors.red, width: 2),
                  )
                : null,
            focusedErrorBorder: border is OutlineInputBorder
                ? border.copyWith(
                    borderSide: BorderSide(color: Colors.red, width: 2),
                  )
                : null,
          ),
        ),
      ],
    );
  }
}

enum FtTextFieldVariant { outlined, filled, ghost }
