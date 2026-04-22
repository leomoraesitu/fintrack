import 'dart:io';

import 'package:fintrack/app/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> pumpDsWidget(
  WidgetTester tester, {
  required Widget child,
  ThemeData? theme,
  Size surfaceSize = const Size(420, 260),
}) async {
  tester.view.devicePixelRatio = 1.0;
  tester.view.physicalSize = surfaceSize;
  addTearDown(() {
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });

  await tester.pumpWidget(
    MaterialApp(
      theme: theme ?? AppTheme.light(),
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Align(
            alignment: Alignment.topCenter,
            child: child,
          ),
        ),
      ),
    ),
  );
  // Avoid pumpAndSettle here because some widgets (e.g. indeterminate
  // progress indicators) keep animating and would never settle.
  await tester.pump();
}

bool shouldSkipGolden(String fileName) {
  if (autoUpdateGoldenFiles) {
    return false;
  }

  final baseline = File('test/design_system/widgets/goldens/$fileName');
  return !baseline.existsSync();
}
