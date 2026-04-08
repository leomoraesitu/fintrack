import 'package:fintrack/app/theme/app_theme.dart';
import 'package:fintrack/features/auth/presentation/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:fintrack/features/shell/presentation/pages/shell_page.dart';

class FinTrackApp extends StatelessWidget {
  const FinTrackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FinTrack',
      theme: AppTheme.light(),
      home: const _AppEntryPage(),
    );
  }
}

class _AppEntryPage extends StatelessWidget {
  const _AppEntryPage();

  @override
  Widget build(BuildContext context) {
    return LoginPage(
      onEnterDemo: () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => const ShellPage(),
          ),
        );
      },
    );
  }
}
