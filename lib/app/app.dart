import 'package:fintrack/app/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:fintrack/features/shell/presentation/pages/shell_page.dart';

class FinTrackApp extends StatelessWidget {
  const FinTrackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FinTrack',
      theme: AppTheme.light(),
      home: const ShellPage()
    );
  }
}
