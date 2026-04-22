import 'package:fintrack/design_system/widgets/widgets.dart';
import 'package:flutter/material.dart';

@Deprecated('Use FtSocialLoginButton from design_system/widgets/widgets.dart')
class SocialLoginButtonWidget extends StatelessWidget {
  const SocialLoginButtonWidget({
    super.key,
    required this.icon,
    required this.label,
    this.onTap,
    this.width,
    this.height,
  });

  final Widget icon;
  final String label;
  final VoidCallback? onTap;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return FtSocialLoginButton(
      icon: icon,
      label: label,
      onTap: onTap,
      width: width,
      height: height,
    );
  }
}
