import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';

Widget previewMaterialApp(Widget child) {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Scaffold(
      body: SafeArea(child: child),
    ),
  );
}

//@preview
class NavItemWidget extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback? onTap;
  final double? width;
  final double? height;

  const NavItemWidget({
    super.key,
    required this.icon,
    required this.label,
    this.active = false,
    this.onTap,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = Colors.black;
    final Color iconColor = active
        ? Theme.of(context).colorScheme.primary
        : Colors.white.withValues(alpha: 0.7);
    final Color textColor = active
        ? Theme.of(context).colorScheme.primary
        : Colors.white.withValues(alpha: 0.85);
    final FontWeight textWeight = active ? FontWeight.bold : FontWeight.w600;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: iconColor, size: 28),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: textColor,
                fontWeight: textWeight,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

@Preview(
  name: 'Nav Item Widget',
  wrapper: previewMaterialApp,
)
Widget navItemWidgetPreview() => const NavItemWidget(
  icon: Icons.home,
  label: 'Início',
  active: true,
);
