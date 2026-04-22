import 'package:fintrack/design_system/widgets/widgets.dart';
import 'package:fintrack/shared/tokens/tokens.dart';
import 'package:flutter/material.dart';

@Deprecated('Use FtEmptyState/FtButton from design_system/widgets/widgets.dart')
class EmptyStateWidget extends StatelessWidget {
  const EmptyStateWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.buttonLabel = '',
    this.showButton = true,
    this.onButtonPressed,
  });

  final IconData icon;
  final String title;
  final String message;
  final String buttonLabel;
  final bool showButton;
  final VoidCallback? onButtonPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FtEmptyState(
          icon: icon,
          title: title,
          message: message,
        ),
        if (showButton && buttonLabel.trim().isNotEmpty) ...[
          const SizedBox(height: AppSpacing.md),
          FtButton(
            label: buttonLabel,
            onPressed: onButtonPressed,
          ),
        ],
      ],
    );
  }
}
