import 'package:flutter/material.dart';
import 'package:fintrack/shared/tokens/tokens.dart';

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
    final Brightness brightness = Theme.of(context).brightness;
    final bool isDisabled = disabled || loading;
    final ButtonStyle style = _getButtonStyle(brightness);

    final Widget child = loading
        ? SizedBox(
            width: AppSizes.loaderSm,
            height: AppSizes.loaderSm,
            child: CircularProgressIndicator(
              strokeWidth: AppBorders.widthThick,
              valueColor: AlwaysStoppedAnimation<Color>(
                _getContentColor(brightness),
              ),
            ),
          )
        : Row(
            mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                icon!,
                const SizedBox(width: AppSpacing.sm),
              ],
              if (fullWidth)
                Expanded(
                  child: Text(
                    label,
                    style: _getTextStyle(brightness).copyWith(
                      color: _getContentColor(brightness),
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                  ),
                )
              else
                Text(
                  label,
                  style: _getTextStyle(brightness).copyWith(
                    color: _getContentColor(brightness),
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  textAlign: TextAlign.center,
                ),
              if (iconEnd != null) ...[
                const SizedBox(width: AppSpacing.sm),
                iconEnd!,
              ],
            ],
          );

    return SizedBox(
      width: fullWidth ? AppSizes.widthFull : null,
      height: _getHeight(),
      child: ElevatedButton(
        onPressed: isDisabled ? null : onPressed,
        style: style,
        child: child,
      ),
    );
  }


  ButtonStyle _getButtonStyle(Brightness brightness) {
    switch (variant) {
      case FtButtonVariant.primary:
        return ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary(brightness),
          foregroundColor: AppColors.onPrimary(brightness),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppBorders.radiusS),
          ),
          elevation: 0,
        );
      case FtButtonVariant.secondary:
        return ElevatedButton.styleFrom(
          backgroundColor: AppColors.secondary(brightness),
          foregroundColor: AppColors.onSecondary(brightness),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppBorders.radiusS),
          ),
          elevation: 0,
        );
      case FtButtonVariant.outline:
        return OutlinedButton.styleFrom(          
          backgroundColor: AppColors.surface(brightness),
          side: BorderSide(
            color: AppColors.divider(brightness),
            width: AppBorders.widthHairline,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppBorders.radiusS),
          ),
        );
      case FtButtonVariant.ghost:
        return TextButton.styleFrom(
          foregroundColor: AppColors.primary(brightness),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppBorders.radiusS),
          ),
        );
      case FtButtonVariant.destructive:
        return ElevatedButton.styleFrom(
          backgroundColor: AppColors.error(brightness),
          foregroundColor: AppColors.onError(brightness),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppBorders.radiusS),
          ),
          elevation: 0,
        );
    }
  }

  Color _getContentColor(Brightness brightness) {
    switch (variant) {
      case FtButtonVariant.primary:
        return AppColors.onPrimary(brightness);
      case FtButtonVariant.secondary:
        return AppColors.onSecondary(brightness);
      case FtButtonVariant.outline:
      return AppColors.onSurface(brightness);
      case FtButtonVariant.ghost:
        return AppColors.primary(brightness);
      case FtButtonVariant.destructive:
        return AppColors.onError(brightness);
    }
  }

  double _getHeight() {
    switch (size) {
      case FtButtonSize.small:
        return AppSizes.buttonSm;
      case FtButtonSize.medium:
        return AppSizes.buttonMd;
      case FtButtonSize.large:
        return AppSizes.buttonLg;
    }
  }

  TextStyle _getTextStyle(Brightness brightness) {
    switch (size) {
      case FtButtonSize.small:
        return AppTypography.labelSmall(brightness);
      case FtButtonSize.medium:
        return AppTypography.labelMedium(brightness);
      case FtButtonSize.large:
        return AppTypography.labelLarge(brightness);
    }
  }
}

enum FtButtonVariant { primary, secondary, outline, ghost, destructive }
enum FtButtonSize { small, medium, large }
