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
class FilterChipWidget1 extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback? onTap;
  final double? width;
  final double? height;

  const FilterChipWidget1({
    super.key,
    required this.icon,
    required this.label,
    this.selected = false,
    this.onTap,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = selected
        ? Theme.of(context).colorScheme.primary
        : Colors.black;
    final Color iconColor = Colors.white;
    final Color textColor = Colors.white;
    final FontWeight textWeight = selected ? FontWeight.bold : FontWeight.w600;
    final double iconOpacity = selected ? 1.0 : 0.7;
    final double textOpacity = selected ? 1.0 : 0.85;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            if (!selected)
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                blurRadius: 3,
                offset: const Offset(0, 1),
              ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: iconColor.withValues(alpha: iconOpacity), size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: textColor.withValues(alpha: textOpacity),
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
  name: 'Filter Chip 1',
  wrapper: previewMaterialApp,
)
Widget filterChipWidget1Preview() => const FilterChipWidget1(
  icon: Icons.filter_alt,
  label: 'Filtro',
  selected: true,
);
