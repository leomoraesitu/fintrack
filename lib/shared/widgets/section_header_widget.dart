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
class SectionHeaderWidget extends StatelessWidget {
  final String title;
  final double? width;
  final double? height;

  const SectionHeaderWidget({
    super.key,
    required this.title,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height ?? 48,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 16,
          letterSpacing: 1.1,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

@Preview(
  name: 'Section Header Widget',
  wrapper: previewMaterialApp,
)
Widget sectionHeaderWidgetPreview() => const SectionHeaderWidget(
  title: 'Seção',
);
