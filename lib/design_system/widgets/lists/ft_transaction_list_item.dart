import 'package:fintrack/shared/tokens/tokens.dart';
import 'package:flutter/material.dart';

class FtTransactionListItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String category;
  final String date;
  final String amount;
  final Color amountColor;
  final double? width;
  final double? height;
  final VoidCallback? onTap;

  const FtTransactionListItem({
    super.key,
    required this.icon,
    required this.title,
    required this.category,
    required this.date,
    required this.amount,
    required this.amountColor,
    this.width,
    this.height,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? AppSizes.widthFull,
      height: height,
      constraints: BoxConstraints(
        minHeight: AppSizes.controlLg + AppSpacing.lg + AppSpacing.sm,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(AppBorders.radiusM),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppBorders.radiusM),
        onTap: onTap,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: AppSizes.controlMd,
              height: AppSizes.controlMd,
              decoration: BoxDecoration(
                color: AppColors.secondaryText(
                  Theme.of(context).brightness,
                ).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppBorders.radiusS),
              ),
              child: Icon(
                icon,
                color: AppColors.primary(Theme.of(context).brightness),
                size: AppSizes.iconMd,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppColors.primaryText(Theme.of(context).brightness),
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    '$category • $date',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.secondaryText(
                            Theme.of(context).brightness,
                          ),
                        ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm + AppSpacing.xs),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  amount,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: amountColor,
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
