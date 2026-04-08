import 'package:flutter/material.dart';

class AuthBrandingHeader extends StatelessWidget {
  const AuthBrandingHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/branding/logo/logo-fintrack-light.png',
      width: double.infinity,
      height: 144,
      fit: BoxFit.contain,
    );
  }
}
