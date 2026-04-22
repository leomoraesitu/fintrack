import 'package:fintrack/shared/tokens/tokens.dart';
import 'package:flutter/material.dart';

class FtChoiceChip extends StatelessWidget {
  const FtChoiceChip({
    super.key,
    this.icon,
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  final String label;
  final IconData? icon;
  final bool selected;
  final ValueChanged<bool> onSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return ChoiceChip(      
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: 18,
              color: selected
                  ? colorScheme.onPrimary
                  : colorScheme.outline.withAlpha(80),
            ),
            const SizedBox(width: AppSpacing.xs),
          ],
          Text(
            label,
            style: textTheme.labelLarge?.copyWith(
              fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
              color: selected
                  ? colorScheme.onPrimaryContainer
                  : colorScheme.onSurface,
            ),
          ),
        ],
      ),
      selected: selected,
      onSelected: onSelected,
      selectedColor: colorScheme.primaryContainer,
      backgroundColor: colorScheme.surfaceContainerHighest,
      side: BorderSide(
        color: selected ? colorScheme.primary : colorScheme.outline.withAlpha(20),
        width: AppBorders.widthThin,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppBorders.radiusL),
      ),
      labelStyle: TextStyle(
        color: selected
            ? colorScheme.onPrimaryContainer
            : colorScheme.onSurface,
      ),
      materialTapTargetSize: MaterialTapTargetSize.padded,
    );
  }
}
