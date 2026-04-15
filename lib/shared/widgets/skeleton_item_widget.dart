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
class SkeletonItemWidget extends StatelessWidget {
  final double? width;
  final double? height;

  const SkeletonItemWidget({
    super.key,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final baseColor = Colors.grey[800]!;

    Widget skeletonBox({double? w, double? h, BorderRadius? borderRadius}) {
      return Container(
        width: w,
        height: h,
        decoration: BoxDecoration(
          color: baseColor,
          borderRadius: borderRadius ?? BorderRadius.circular(8),
        ),
      );
    }

    return Container(
      width: width ?? 380,
      height: height ?? 90,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          skeletonBox(w: 32, h: 32, borderRadius: BorderRadius.circular(8)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                skeletonBox(w: 120, h: 12),
                const SizedBox(height: 10),
                skeletonBox(w: 180, h: 12),
                const SizedBox(height: 10),
                skeletonBox(w: 80, h: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

@Preview(
  name: 'Skeleton Item Widget',
  wrapper: previewMaterialApp,
)
Widget skeletonItemWidgetPreview() => const SkeletonItemWidget();
