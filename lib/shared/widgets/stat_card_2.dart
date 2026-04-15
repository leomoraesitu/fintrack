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
class StatCard2 extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final double? width;
  final double? height;

  const StatCard2({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? 200,
      height: height ?? 90,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 18),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }
}

@Preview(
  name: 'Stat Card 2',
  wrapper: previewMaterialApp,
)
Widget statCard2Preview() => StatCard2(
  icon: Icons.trending_down,
  label: 'Despesa',
  value: 'R\$ 800',
  color: Colors.redAccent,
);
