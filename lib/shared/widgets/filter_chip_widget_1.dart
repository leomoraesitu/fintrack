import 'package:fintrack/design_system/widgets/widgets.dart';
import 'package:flutter/material.dart';

@Deprecated('Use FtFilterChip from design_system/widgets/widgets.dart')
class FilterChipWidget1 extends StatelessWidget {
  const FilterChipWidget1({
    super.key,
    required this.icon,
    required this.label,
    this.selected = false,
    this.onTap,
    this.width,
    this.height,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback? onTap;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return FtFilterChip(
      icon: icon,
      label: label,
      selected: selected,
      onTap: onTap,
      width: width,
      height: height,
    );
  }
}
