import 'package:fintrack/shared/tokens/tokens.dart';
import 'package:flutter/material.dart';

class FtSkeletonItem extends StatelessWidget {
  const FtSkeletonItem({
    super.key,
    this.width,
    this.height,
  });

  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final baseColor = colorScheme.surfaceContainerHighest;

    Widget skeletonBox({double? w, double? h, BorderRadius? borderRadius}) {
      return Container(
        width: w,
        height: h,
        decoration: BoxDecoration(
          color: baseColor,
          borderRadius: borderRadius ?? BorderRadius.circular(AppBorders.radiusS),
        ),
      );
    }

    return Container(
      width: width ?? AppSizes.widthFull,
      height: height ?? (AppSizes.buttonLg + AppSpacing.xl + AppSpacing.xs),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(AppBorders.radiusM),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          skeletonBox(
            w: AppSizes.controlSm - AppSpacing.sm,
            h: AppSizes.controlSm - AppSpacing.sm,
            borderRadius: BorderRadius.circular(AppBorders.radiusS),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                skeletonBox(w: AppSizes.widthSm, h: AppSpacing.sm + AppBorders.widthThick),
                const SizedBox(height: AppSpacing.sm + AppSpacing.xs),
                skeletonBox(w: AppSizes.widthLg, h: AppSpacing.sm + AppBorders.widthThick),
                const SizedBox(height: AppSpacing.sm + AppSpacing.xs),
                skeletonBox(w: AppSizes.widthXs, h: AppSpacing.sm + AppBorders.widthThick),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
