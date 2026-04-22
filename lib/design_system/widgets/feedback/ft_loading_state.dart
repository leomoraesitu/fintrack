import 'package:fintrack/shared/tokens/tokens.dart';
import 'package:flutter/material.dart';

class FtLoadingState extends StatelessWidget {
  const FtLoadingState({super.key, this.label});

  final String? label;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: AppSizes.loaderMd,
            height: AppSizes.loaderMd,
            child: const CircularProgressIndicator(
              strokeWidth: AppBorders.widthThick,
            ),
          ),
          if (label != null) ...[
            const SizedBox(height: AppSpacing.md),
            Text(
              label!,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}
