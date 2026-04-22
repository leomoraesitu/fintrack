import 'package:flutter/material.dart';
import 'package:fintrack/shared/tokens/tokens.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData light() {
    final colorScheme = ColorScheme.light(
      primary: AppColorsLight.primary,
      onPrimary: AppColorsLight.onPrimary,
      secondary: AppColorsLight.secondary,
      onSecondary: AppColorsLight.onSecondary,
      surface: AppColorsLight.surface,
      onSurface: AppColorsLight.onSurface,
      error: AppColorsLight.error,
      onError: AppColorsLight.onError,
      tertiary: AppColorsLight.accent,
    );
    return _buildTheme(
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColorsLight.background,
      cardColor: AppColorsLight.surface,
      appBarForegroundColor: AppColorsLight.primaryText,
      navigationUnselectedColor: AppColorsLight.secondaryText,
    );
  }

  static ThemeData dark() {
    final colorScheme = ColorScheme.dark(
      primary: AppColorsDark.primary,
      onPrimary: AppColorsDark.onPrimary,
      secondary: AppColorsDark.secondary,
      onSecondary: AppColorsDark.onSecondary,
      surface: AppColorsDark.surface,
      onSurface: AppColorsDark.onSurface,
      error: AppColorsDark.error,
      onError: AppColorsDark.onError,
      tertiary: AppColorsDark.accent,
    );
    return _buildTheme(
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColorsDark.background,
      cardColor: AppColorsDark.surface,
      appBarForegroundColor: AppColorsDark.primaryText,
      navigationUnselectedColor: AppColorsDark.secondaryText,
    );
  }

  static ThemeData _buildTheme({
    required ColorScheme colorScheme,
    required Color scaffoldBackgroundColor,
    required Color cardColor,
    required Color appBarForegroundColor,
    required Color navigationUnselectedColor,
  }) {
    final brightness = colorScheme.brightness;

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: scaffoldBackgroundColor,
      cardTheme: CardThemeData(
        color: cardColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppBorders.radiusL),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: scaffoldBackgroundColor,
        foregroundColor: appBarForegroundColor,
        elevation: 0,
        centerTitle: false,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppBorders.radiusXL),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: cardColor,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: navigationUnselectedColor,
        type: BottomNavigationBarType.fixed,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: cardColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppBorders.radiusS),
          borderSide: BorderSide.none,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppBorders.radiusXM),
          ),
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return colorScheme.onSurface.withValues(alpha: 0.38);
          }
          if (states.contains(WidgetState.selected)) {
            return colorScheme.onPrimary;
          }
          return colorScheme.outline;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return colorScheme.onSurface.withValues(alpha: 0.12);
          }
          if (states.contains(WidgetState.selected)) {
            return colorScheme.primary;
          }
          return colorScheme.surfaceContainerHighest;
        }),
        trackOutlineColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return Colors.transparent;
          }
          return colorScheme.outline;
        }),
        materialTapTargetSize: MaterialTapTargetSize.padded,
      ),

      textTheme: TextTheme(
        headlineLarge: AppTypography.headlineLarge(brightness),
        headlineMedium: AppTypography.headlineMedium(brightness),
        titleLarge: AppTypography.titleLarge(brightness),
        titleMedium: AppTypography.titleMedium(brightness),
        bodyLarge: AppTypography.bodyLarge(brightness),
        bodyMedium: AppTypography.bodyMedium(brightness),
        bodySmall: AppTypography.bodySmall(brightness),
        labelLarge: AppTypography.labelLarge(brightness),
        labelMedium: AppTypography.labelMedium(brightness),
        labelSmall: AppTypography.labelSmall(brightness),
      ),
    );
  }
}
