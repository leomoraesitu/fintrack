import 'package:fintrack/shared/tokens/tokens.dart';
import 'package:flutter/material.dart';

class FtFilterChip extends StatelessWidget {
  const FtFilterChip({
    super.key,
    required this.icon,
    required this.label,
    this.selected = false,
    this.onTap,
    this.width,
    this.height,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback? onTap;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final bg = selected ? colorScheme.primary : colorScheme.surfaceContainerHighest;
    final fg = selected ? colorScheme.onPrimary : colorScheme.onSurface;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppBorders.radiusXM),
      child: Container(
        width: width,
        height: height,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm + AppSpacing.md,
          vertical: AppSpacing.sm + AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(AppBorders.radiusXM),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: AppSizes.iconMd, color: fg),
            const SizedBox(width: AppSpacing.sm),
            Text(
              label,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: fg,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
