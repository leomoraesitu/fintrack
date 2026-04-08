import 'package:fintrack/app/theme/app_theme.dart';
import 'package:fintrack/features/auth/presentation/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:fintrack/features/shell/presentation/pages/shell_page.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fintrack/features/auth/presentation/bloc/auth_session_bloc.dart';
import 'package:fintrack/features/auth/presentation/bloc/auth_session_event.dart';
import 'package:fintrack/features/auth/presentation/bloc/auth_session_state.dart';

class FinTrackApp extends StatelessWidget {
  const FinTrackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthSessionBloc(),
      child: MaterialApp(
        title: 'FinTrack',
        theme: AppTheme.light(),
        home: const _AppEntryPage(),
      ),
    );
  }
}

class _AppEntryPage extends StatelessWidget {
  const _AppEntryPage();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthSessionBloc, AuthSessionState>(
      builder: (context, state) {
        if (state is AuthSessionAuthenticated) {
          return ShellPage(
            onLogout: () {
              context.read<AuthSessionBloc>().add(const AuthSessionLoggedOut());
            },
          );
        }

        return LoginPage(
          onEnterDemo: () {
            context.read<AuthSessionBloc>().add(const AuthSessionEnteredDemo());
          },
        );
      },
    );
  }
}
