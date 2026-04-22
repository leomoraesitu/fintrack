import 'package:fintrack/shared/tokens/tokens.dart';
import 'package:flutter/material.dart';

class AuthBrandingHeader extends StatelessWidget {
  const AuthBrandingHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return SizedBox(
      child: Center(
        child: Column(
          children: [
            Stack(
              alignment: AlignmentGeometry.center,
              children: [
                Container(
                  width: AppSizes.widthXs,
                  height: AppSizes.widthXs,
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.all(
                        Radius.circular(AppBorders.radiusL),
                      ),
                    ),
                    color: colorScheme.primary,
                  ),
                ),
                Icon(
                  Icons.account_balance_wallet,
                  size: AppSizes.iconLg + 8,
                  color: colorScheme.onPrimary,
                ),
              ],
            ),
            SizedBox(height: AppSpacing.sm,),
            Text('FinTrack', style: textTheme.headlineLarge),
            Text(
              'Controle suas finanças com clareza',
              style: textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );

    /* Image.asset(
      'assets/branding/logo/logo-fintrack-light.png',
      width: double.infinity,
      height: 144,
      fit: BoxFit.contain,
    ); */
  }
}
