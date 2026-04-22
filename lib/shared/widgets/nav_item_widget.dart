import 'package:fintrack/design_system/widgets/widgets.dart';
import 'package:flutter/material.dart';

@Deprecated('Use FtNavItem from design_system/widgets/widgets.dart')
class NavItemWidget extends StatelessWidget {
  const NavItemWidget({
    super.key,
    required this.icon,
    required this.label,
    this.active = false,
    this.onTap,
    this.width,
    this.height,
  });

  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback? onTap;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return FtNavItem(
      icon: icon,
      label: label,
      active: active,
      onTap: onTap,
      width: width,
      height: height,
    );
  }
}
