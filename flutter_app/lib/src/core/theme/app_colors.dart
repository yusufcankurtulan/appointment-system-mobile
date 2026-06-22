import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const background = Color(0xFF060B16);
  static const accent = Color(0xFF3B82F6);
  static const accentLight = Color(0xFF60A5FA);
  static const secondaryAccent = Color(0xFF8B5CF6);
  static const imagePlaceholder = Color(0xFF111827);
  static const open = Colors.green;

  static Color get cardFill => Colors.white.withOpacity(0.04);
  static Color get cardFillElevated => Colors.white.withOpacity(0.05);
  static Color get cardStroke => Colors.white.withOpacity(0.08);
  static Color get textSecondary => Colors.white.withOpacity(0.65);
  static Color get textMuted => Colors.white.withOpacity(0.54);
}
