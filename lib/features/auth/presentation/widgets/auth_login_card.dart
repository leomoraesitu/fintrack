import 'package:fintrack/features/auth/presentation/bloc/auth_form_bloc.dart';
import 'package:fintrack/features/auth/presentation/bloc/auth_form_event.dart';
import 'package:fintrack/features/auth/presentation/bloc/auth_form_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fintrack/design_system/widgets/widgets.dart';
import 'package:fintrack/shared/tokens/tokens.dart';

class AuthLoginCard extends StatefulWidget {
  const AuthLoginCard({super.key, this.onEnterDemo});

  final VoidCallback? onEnterDemo;

  @override
  State<AuthLoginCard> createState() => _AuthLoginCardState();
}

class _AuthLoginCardState extends State<AuthLoginCard> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit({required bool isSignUp}) {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (isSignUp) {
      context.read<AuthFormBloc>().add(
        AuthFormSignUpSubmitted(email: email, password: password),
      );
      return;
    }

    context.read<AuthFormBloc>().add(
      AuthFormSignInSubmitted(email: email, password: password),
    );
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return BlocListener<AuthFormBloc, AuthFormState>(
      listener: (context, state) {
        if (state is AuthFormError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: BlocBuilder<AuthFormBloc, AuthFormState>(
        builder: (context, state) {
          final isSubmitting = state is AuthFormSubmitting;

          return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.xl),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              border: Border.all(
                color: colorScheme.onSurface.withValues(alpha: 0.2),
                width: AppBorders.widthThin,
              ),
              borderRadius: BorderRadius.circular(AppBorders.radiusM),
              boxShadow: AppShadows.sm,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bem-vindo',
                  style: textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Entre com sua conta, crie uma nova ou use o acesso '
                  'demonstrativo.',
                  style: textTheme.bodySmall,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: AppSpacing.md),
                      FtTextField(
                        label: 'E-mail',
                        hint: 'seu@email.com',
                        controller: _emailController,
                        enabled: !isSubmitting,
                        keyboardType: TextInputType.emailAddress,
                        leadingIcon: const Icon(
                          Icons.email_outlined,
                          size: AppSizes.iconSm,
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Informe o e-mail.';
                          }

                          return null;
                        },
                      ),
                      const SizedBox(height: AppSpacing.md),
                      FtTextField(
                        label: 'Senha',
                        hint: '........',
                        controller: _passwordController,
                        enabled: !isSubmitting,
                        obscureText: _obscurePassword,
                        leadingIcon: const Icon(
                          Icons.lock_outline,
                          size: AppSizes.iconSm,
                        ),
                        trailingIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            size: AppSizes.iconSm,
                          ),
                          onPressed: isSubmitting
                              ? null
                              : _togglePasswordVisibility,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Informe a senha.';
                          }

                          if (value.length < 6) {
                            return 'A senha deve ter pelo menos 6 caracteres.';
                          }

                          return null;
                        },
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      FtButton(
                        label: 'Entrar',
                        onPressed: () => _submit(isSignUp: false),
                        loading: isSubmitting,
                        fullWidth: true,
                        icon: Icon(
                          Icons.login,
                          color: colorScheme.onPrimary,
                          size: 16,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      FtButton(
                        label: 'Criar conta',
                        onPressed: isSubmitting
                            ? null
                            : () => _submit(isSignUp: true),
                        fullWidth: true,
                        icon: Icon(
                          Icons.person_add_alt_1_outlined,
                          color: colorScheme.onPrimary,
                          size: 16,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      FtButton(
                        label: 'Entrar no modo demo',
                        onPressed: isSubmitting ? null : widget.onEnterDemo,
                        variant: FtButtonVariant.outline,
                        fullWidth: true,
                        icon: Icon(
                          Icons.explore_outlined,
                          color: colorScheme.onSurface,
                          size: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
