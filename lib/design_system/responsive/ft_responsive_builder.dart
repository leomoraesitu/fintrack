import 'package:flutter/material.dart';
import 'app_breakpoints.dart';

/// Widget que constrói diferentes layouts conforme o breakpoint.
class FtResponsiveBuilder extends StatelessWidget {
  final Widget Function(BuildContext context) mobile;
  final Widget Function(BuildContext context)? tablet;
  final Widget Function(BuildContext context)? desktop;

  const FtResponsiveBuilder({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (AppBreakpoints.isDesktop(width) && desktop != null) {
      return desktop!(context);
    }
    if (AppBreakpoints.isTablet(width) && tablet != null) {
      return tablet!(context);
    }
    return mobile(context);
  }
}
