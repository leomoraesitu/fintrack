import 'package:fintrack/shared/tokens/tokens.dart';
import 'package:flutter/material.dart';

class FtNavItem extends StatelessWidget {
  const FtNavItem({
    super.key,
    required this.icon,
    required this.label,
    this.active = false,
    this.onTap,
    this.width,
    this.height,
  });

  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback? onTap;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final iconColor = active ? colorScheme.primary : colorScheme.onSurfaceVariant;
    final textColor = active ? colorScheme.primary : colorScheme.onSurfaceVariant;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppBorders.radiusM),
      child: Container(
        width: width,
        height: height,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(AppBorders.radiusM),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: AppSizes.iconLg, color: iconColor),
            const SizedBox(height: AppSpacing.sm),
            Text(
              label,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: textColor,
                    fontWeight: active ? FontWeight.w700 : FontWeight.w600,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
