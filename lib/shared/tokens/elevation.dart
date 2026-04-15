/// Design System Elevation
/// Defina aqui os tokens de elevação/sombreamento do projeto FinTrack.
library;

import 'package:flutter/material.dart';

class AppShadows {
  static const List<BoxShadow> sm = [
    BoxShadow(
      color: Color(0x1A000000), // #0000000D
      offset: Offset(0, 2),
      blurRadius: 4,
      spreadRadius: 0,
    ),
  ];

  static const List<BoxShadow> md = [
    BoxShadow(
      color: Color(0x1A000000), // #0000001A
      offset: Offset(0, 4),
      blurRadius: 12,
      spreadRadius: 0,
    ),
  ];

  static const List<BoxShadow> lg = [
    BoxShadow(
      color: Color(0x26000000), // #00000026
      offset: Offset(0, 8),
      blurRadius: 24,
      spreadRadius: 0,
    ),
  ];

  static const List<BoxShadow> xl = [
    BoxShadow(
      color: Color(0x33000000), // #00000033
      offset: Offset(0, 12),
      blurRadius: 32,
      spreadRadius: 0,
    ),
  ];
}
