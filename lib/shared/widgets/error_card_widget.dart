import 'package:fintrack/design_system/widgets/widgets.dart';
import 'package:flutter/material.dart';

@Deprecated('Use FtErrorState from design_system/widgets/widgets.dart')
class ErrorCardWidget extends StatelessWidget {
  const ErrorCardWidget({
    super.key,
    required this.title,
    required this.message,
    this.buttonLabel = 'Tentar novamente',
    this.onButtonPressed,
  });

  final String title;
  final String message;
  final String buttonLabel;
  final VoidCallback? onButtonPressed;

  @override
  Widget build(BuildContext context) {
    final combinedMessage = '$title\n$message';

    return FtErrorState(
      message: combinedMessage,
      retryLabel: buttonLabel,
      onRetry: onButtonPressed,
    );
  }
}
