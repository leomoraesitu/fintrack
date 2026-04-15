/// Design System Colors
/// Defina aqui os tokens de cor do projeto FinTrack.
library;

import 'package:flutter/material.dart';


/// Tokens de cor para Light Mode
class AppColorsLight {
  static const Color primary = Color(0xFF007AFF);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color secondary = Color(0xFF5856D6);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFF2F2F7);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color onSurface = Color(0xFF1C1C1E);
  static const Color error = Color(0xFFFF3B30);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color accent = Color(0xFFFF9500);
  static const Color divider = Color(0xFFC6C6C8);
  static const Color hint = Color(0x3C3C434D);
  static const Color primaryText = Color(0xFF000000);
  static const Color secondaryText = Color(0x3C3C4399);
  static const Color success = Color(0xFF34C759);
  static const Color transparent = Color(0x00000000);
}

/// Tokens de cor para Dark Mode
class AppColorsDark {
  static const Color primary = Color(0xFF0A84FF);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color secondary = Color(0xFF5E5CE6);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color background = Color(0xFF000000);
  static const Color surface = Color(0xFF1C1C1E);
  static const Color onSurface = Color(0xFFFFFFFF);
  static const Color error = Color(0xFFFF453A);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color accent = Color(0xFFFF9F0A);
  static const Color divider = Color(0xFF38383A);
  static const Color hint = Color(0xEBEBF54D);
  static const Color primaryText = Color(0xFFFFFFFF);
  static const Color secondaryText = Color(0xEBEBF599);
  static const Color success = Color(0xFF30D158);
  static const Color transparent = Color(0x00000000);
}

/// Helper para obter as cores conforme o tema atual
class AppColors {
  static Color primary(Brightness brightness) => brightness == Brightness.dark ? AppColorsDark.primary : AppColorsLight.primary;
  static Color onPrimary(Brightness brightness) => brightness == Brightness.dark ? AppColorsDark.onPrimary : AppColorsLight.onPrimary;
  static Color secondary(Brightness brightness) => brightness == Brightness.dark ? AppColorsDark.secondary : AppColorsLight.secondary;
  static Color onSecondary(Brightness brightness) => brightness == Brightness.dark ? AppColorsDark.onSecondary : AppColorsLight.onSecondary;
  static Color background(Brightness brightness) => brightness == Brightness.dark ? AppColorsDark.background : AppColorsLight.background;
  static Color surface(Brightness brightness) => brightness == Brightness.dark ? AppColorsDark.surface : AppColorsLight.surface;
  static Color onSurface(Brightness brightness) => brightness == Brightness.dark ? AppColorsDark.onSurface : AppColorsLight.onSurface;
  static Color error(Brightness brightness) => brightness == Brightness.dark ? AppColorsDark.error : AppColorsLight.error;
  static Color onError(Brightness brightness) => brightness == Brightness.dark ? AppColorsDark.onError : AppColorsLight.onError;
  static Color accent(Brightness brightness) => brightness == Brightness.dark ? AppColorsDark.accent : AppColorsLight.accent;
  static Color divider(Brightness brightness) => brightness == Brightness.dark ? AppColorsDark.divider : AppColorsLight.divider;
  static Color hint(Brightness brightness) => brightness == Brightness.dark ? AppColorsDark.hint : AppColorsLight.hint;
  static Color primaryText(Brightness brightness) => brightness == Brightness.dark ? AppColorsDark.primaryText : AppColorsLight.primaryText;
  static Color secondaryText(Brightness brightness) => brightness == Brightness.dark ? AppColorsDark.secondaryText : AppColorsLight.secondaryText;
  static Color success(Brightness brightness) => brightness == Brightness.dark ? AppColorsDark.success : AppColorsLight.success;
  static Color transparent(Brightness brightness) => AppColorsLight.transparent;
}
