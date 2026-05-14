import 'package:flutter/material.dart';

@immutable
class AppColors {
  const AppColors._();

  // Shared brand colors
  static const Color primary = Color(0xFF38BDF8);
  static const Color secondary = Color(0xFF0EA5E9);
  static const Color primarySoft = Color(0x2638BDF8);
  static const Color success = Color(0xFF56C288);

  // Dark palette
  static const Color bgDark = Color(0xFF070B12);
  static const Color bgDarkAlt = Color(0xFF0B1220);
  static const Color surfaceDark = Color(0xFF0B1220);
  static const Color surfaceMutedDark = Color(0xFF1E293B);
  static const Color textPrimaryDark = Color(0xFFF8FAFC);
  static const Color textMutedDark = Color(0xFF94A3BB);
  static const Color borderDark = Color(0xFF1E293B);

  // Light palette
  static const Color bgLight = Color(0xFFF6FBFF);
  static const Color bgLightAlt = Color(0xFFEAF6FF);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceMutedLight = Color(0xFFF1F8FE);
  static const Color textPrimaryLight = Color(0xFF0F172A);
  static const Color textMutedLight = Color(0xFF64748B);
  static const Color borderLight = Color(0xFFD7E7F3);
}
