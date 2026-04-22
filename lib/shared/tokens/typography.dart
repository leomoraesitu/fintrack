/// Design System Typography
/// Defina aqui os tokens de tipografia do projeto FinTrack.
library;

import 'package:fintrack/shared/tokens/colors.dart';
import 'package:flutter/material.dart';

class AppTypography {
  static const String fontFamily = 'Inter';

  // Headlines
  static TextStyle headlineLarge(Brightness brightness) => TextStyle(
    fontSize: 34,
    fontWeight: FontWeight.w700,
    height: 1.2,
    color: AppColors.primaryText(brightness),
    fontFamily: fontFamily,
  );
  static TextStyle headlineMedium(Brightness brightness) => TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    height: 1.2,
    color: AppColors.primaryText(brightness),
    fontFamily: fontFamily,
  );

  // Titles
  static TextStyle titleLarge(Brightness brightness) => TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    height: 1.2,
    color: AppColors.primaryText(brightness),
    fontFamily: fontFamily,
  );
  static TextStyle titleMedium(Brightness brightness) => TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w600,
    height: 1.3,
    color: AppColors.primaryText(brightness),
    fontFamily: fontFamily,
  );

  // Body
  static TextStyle bodyLarge(Brightness brightness) => TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: AppColors.secondaryText(brightness),
    fontFamily: fontFamily,
  );
  static TextStyle bodyMedium(Brightness brightness) => TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    height: 1.4,
    color: AppColors.secondaryText(brightness),
    fontFamily: fontFamily,
  );
  static TextStyle bodySmall(Brightness brightness) => TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    height: 1.4,
    color: AppColors.secondaryText(brightness),
    fontFamily: fontFamily,
  );

  // Labels
  static TextStyle labelLarge(Brightness brightness) => TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    height: 1.3,
    color: AppColors.primaryText(brightness),
    fontFamily: fontFamily,
  );
  static TextStyle labelMedium(Brightness brightness) => TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    height: 1.3,
    color: AppColors.primaryText(brightness),
    fontFamily: fontFamily,
  );
  static TextStyle labelSmall(Brightness brightness) => TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    height: 1.2,
    color: AppColors.primaryText(brightness),
    fontFamily: fontFamily,
  );
}
