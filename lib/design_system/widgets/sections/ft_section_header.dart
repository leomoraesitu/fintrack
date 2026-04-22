import 'package:fintrack/shared/tokens/tokens.dart';
import 'package:flutter/material.dart';

class FtSectionHeader extends StatelessWidget {
  const FtSectionHeader({
    super.key,
    required this.title,
    this.width,
    this.height,
  });

  final String title;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: width,
      height: height ?? AppSizes.controlMd,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppBorders.radiusXM),
      ),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
      ),
    );
  }
}
