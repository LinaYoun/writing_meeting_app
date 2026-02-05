import 'package:flutter/material.dart';

class AppColors {
  // Primary
  static const Color primary = Color(0xFF24748F);

  // Background colors
  static const Color backgroundLight = Color(0xFFF5F2F0);
  static const Color backgroundDark = Color(0xFF16181D);

  // Card colors
  static const Color cardLight = Colors.white;
  static const Color cardDark = Color(0xFF0F172A); // slate-900

  // Border colors
  static const Color borderLight = Color(0xFFF1F5F9); // slate-100
  static const Color borderDark = Color(0xFF1E293B); // slate-800

  // Text colors
  static const Color textPrimaryLight = Color(0xFF1E293B); // slate-800
  static const Color textPrimaryDark = Colors.white;
  static const Color textSecondaryLight = Color(0xFF64748B); // slate-500
  static const Color textSecondaryDark = Color(0xFF94A3B8); // slate-400

  // Status colors
  static const Color liked = Color(0xFFEF4444); // red-500
  static const Color verified = primary;

  // Surface colors for toggle
  static const Color surfaceLight = Color(0xFFE2E8F0); // slate-200 with 50% opacity
  static const Color surfaceDark = Color(0xFF1E293B); // slate-800 with 50% opacity
}
