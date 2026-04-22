import 'package:fintrack/design_system/widgets/widgets.dart';
import 'package:flutter/material.dart';

@Deprecated('Use FtSectionHeader from design_system/widgets/widgets.dart')
class SectionHeaderWidget extends StatelessWidget {
  const SectionHeaderWidget({
    super.key,
    required this.title,
    this.width,
    this.height,
  });

  final String title;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return FtSectionHeader(
      title: title,
      width: width,
      height: height,
    );
  }
}
