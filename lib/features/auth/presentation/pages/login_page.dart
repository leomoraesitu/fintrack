import 'package:fintrack/features/auth/presentation/widgets/auth_branding_header.dart';
import 'package:fintrack/features/auth/presentation/widgets/auth_demo_info_banner.dart';
import 'package:fintrack/features/auth/presentation/widgets/auth_login_card.dart';
import 'package:fintrack/shared/tokens/tokens.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key, this.onEnterDemo});
  final VoidCallback? onEnterDemo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: AppSpacing.xs),
                      const AuthBrandingHeader(),
                      const SizedBox(height: AppSpacing.xl),
                      AuthLoginCard(onEnterDemo: onEnterDemo),
                      const SizedBox(height: AppSpacing.md),
                      const AuthDemoInfoBanner(),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
