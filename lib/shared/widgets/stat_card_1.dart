import 'package:fintrack/design_system/widgets/widgets.dart';
import 'package:flutter/material.dart';

@Deprecated('Use FtStatCard from design_system/widgets/widgets.dart')
class StatCard1 extends StatelessWidget {
  const StatCard1({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    this.width,
    this.height,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return FtStatCard(
      icon: icon,
      label: label,
      value: value,
      color: color,
      width: width,
      height: height,
    );
  }
}
