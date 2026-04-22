import 'package:fintrack/design_system/widgets/widgets.dart';
import 'package:flutter/material.dart';

@Deprecated('Use FtSkeletonItem from design_system/widgets/widgets.dart')
class SkeletonItemWidget extends StatelessWidget {
  const SkeletonItemWidget({super.key, this.width, this.height});

  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return FtSkeletonItem(width: width, height: height);
  }
}
