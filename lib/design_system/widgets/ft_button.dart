import 'package:flutter/material.dart';

/// Botão padrão do Design System FinTrack
///
/// Variantes: primary, secondary, outline, ghost, destructive
/// Tamanhos: small, medium, large
/// Estados: loading, disabled, fullWidth
class FtButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final FtButtonVariant variant;
  final FtButtonSize size;
  final bool loading;
  final bool disabled;
  final bool fullWidth;
  final Widget? icon;
  final Widget? iconEnd;

  const FtButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = FtButtonVariant.primary,
    this.size = FtButtonSize.medium,
    this.loading = false,
    this.disabled = false,
    this.fullWidth = false,
    this.icon,
    this.iconEnd,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = disabled || loading;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final ButtonStyle style = _getButtonStyle(colorScheme);

    final Widget child = loading
        ? SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                _getContentColor(colorScheme),
              ),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                icon!,
                const SizedBox(width: 8),
              ],
              Flexible(
                child: Text(
                  label,
                  style: TextStyle(
                    color: _getContentColor(colorScheme),
                    fontWeight: FontWeight.w600,
                    fontSize: _getFontSize(),
                  ),
                ),
              ),
              if (iconEnd != null) ...[
                const SizedBox(width: 8),
                iconEnd!,
              ],
            ],
          );

    return SizedBox(
      width: fullWidth ? double.infinity : null,
      height: _getHeight(),
      child: ElevatedButton(
        onPressed: isDisabled ? null : onPressed,
        style: style,
        child: child,
      ),
    );
  }

  ButtonStyle _getButtonStyle(ColorScheme colorScheme) {
    switch (variant) {
      case FtButtonVariant.primary:
        return ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 0,
        );
      case FtButtonVariant.secondary:
        return ElevatedButton.styleFrom(
          backgroundColor: colorScheme.secondary,
          foregroundColor: colorScheme.onSecondary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 0,
        );
      case FtButtonVariant.outline:
        return OutlinedButton.styleFrom(
          foregroundColor: colorScheme.primary,
          side: BorderSide(color: colorScheme.primary, width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        );
      case FtButtonVariant.ghost:
        return TextButton.styleFrom(
          foregroundColor: colorScheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        );
      case FtButtonVariant.destructive:
        return ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 0,
        );
    }
  }

  Color _getContentColor(ColorScheme colorScheme) {
    switch (variant) {
      case FtButtonVariant.primary:
        return colorScheme.onPrimary;
      case FtButtonVariant.secondary:
        return colorScheme.onSecondary;
      case FtButtonVariant.outline:
      case FtButtonVariant.ghost:
        return colorScheme.primary;
      case FtButtonVariant.destructive:
        return Colors.white;
    }
  }

  double _getHeight() {
    switch (size) {
      case FtButtonSize.small:
        return 36;
      case FtButtonSize.medium:
        return 48;
      case FtButtonSize.large:
        return 56;
    }
  }

  double _getFontSize() {
    switch (size) {
      case FtButtonSize.small:
        return 14;
      case FtButtonSize.medium:
        return 16;
      case FtButtonSize.large:
        return 18;
    }
  }
}

enum FtButtonVariant { primary, secondary, outline, ghost, destructive }
enum FtButtonSize { small, medium, large }
