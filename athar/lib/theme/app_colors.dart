import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  /// Set by the app theme controller before rebuilding MaterialApp.
  static bool isDark = false;

  // ==============================
  // Primary Colors
  // ==============================

  static Color get primaryColor =>
      isDark ? darkBlueBase : const Color.fromARGB(255, 232, 241, 250);
  static const Color darkBlueBase = Color.fromARGB(255, 17, 42, 69);

  static Color get primaryColorTrans => isDark
      ? darkBlueBase.withValues(alpha: 0.75)
      : const Color.fromARGB(191, 232, 241, 250);

  static Color get darkBlue =>
      isDark ? const Color.fromARGB(255, 232, 241, 250) : darkBlueBase;

  static const Color error = Color.fromARGB(255, 117, 23, 23);

  static const Color success = Color(0xFF1B5E20);
  static Color get unread =>
      isDark ? backgroundBase : const Color.fromARGB(255, 216, 157, 157);

  // ==============================
  // Gold Colors
  // ==============================

  // Gold used in most screens
  static const Color gold = Color(0xFFFFC107);

  // Light gold used in some screens
  static const Color lightGold = Color(0xFFE3B866);

  static const Color goldTrans = Color.fromARGB(143, 255, 193, 7);

  // ==============================
  // Secondary Colors
  // ==============================

  static Color get secondaryColor =>
      isDark ? backgroundBase : const Color.fromARGB(255, 241, 246, 250);

  static Color get secondaryText =>
      isDark ? borderColor : const Color(0xFF6B7B8C);

  static const Color borderColor = Color.fromARGB(255, 184, 203, 231);

  // ==============================
  // Background Colors
  // ==============================

  static Color get background =>
      isDark ? const Color.fromARGB(255, 34, 73, 116) : backgroundBase;
  static const Color backgroundBase = Color.fromARGB(255, 34, 73, 116);

  static Color get iconBackground =>
      isDark ? darkBlueBase : const Color.fromARGB(255, 201, 221, 242);

  // ==============================
  // Navigation Bar Colors
  // ==============================

  static Color get navigationBarBackground => backgroundBase;

  static const Color navigationBarSelected = Color.fromARGB(255, 240, 201, 138);

  static const Color navigationBarUnselected = Color.fromARGB(
    175,
    185,
    204,
    246,
  );

  static const Color navigationBarBorder = Color.fromARGB(255, 240, 201, 138);

  // =============================================
  // Favorites Screen Colors
  // =============================================

  static Color get emptyFavBackground =>
      isDark ? backgroundBase : const Color(0xFFF5F8FB);
  static Color get favBordar => isDark ? borderColor : const Color(0xFFC9DCEB);
  static Color get favBoxShadow =>
      isDark ? darkBlueBase.withValues(alpha: 0.25) : const Color(0x1A173B5E);
  static Color get moreColor => isDark ? borderColor : const Color(0xFF55708A);
  static Color get favButtonBackground =>
      isDark ? backgroundBase : const Color(0xFFFFF7E5);
  static Color get selectedCatButton =>
      isDark ? borderColor.withValues(alpha: 0.2) : const Color(0x30173B5E);
}
