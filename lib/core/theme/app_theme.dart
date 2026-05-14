import 'package:flutter/material.dart';

import 'app_colors.dart';

@immutable
class AppThemePalette extends ThemeExtension<AppThemePalette> {
  const AppThemePalette({
    required this.background,
    required this.backgroundAlt,
    required this.surface,
    required this.surfaceMuted,
    required this.border,
    required this.textPrimary,
    required this.textMuted,
    required this.pageGradientStart,
    required this.pageGradientEnd,
    required this.heroGlow,
    required this.shadow,
  });

  final Color background;
  final Color backgroundAlt;
  final Color surface;
  final Color surfaceMuted;
  final Color border;
  final Color textPrimary;
  final Color textMuted;
  final Color pageGradientStart;
  final Color pageGradientEnd;
  final Color heroGlow;
  final Color shadow;

  @override
  AppThemePalette copyWith({
    Color? background,
    Color? backgroundAlt,
    Color? surface,
    Color? surfaceMuted,
    Color? border,
    Color? textPrimary,
    Color? textMuted,
    Color? pageGradientStart,
    Color? pageGradientEnd,
    Color? heroGlow,
    Color? shadow,
  }) {
    return AppThemePalette(
      background: background ?? this.background,
      backgroundAlt: backgroundAlt ?? this.backgroundAlt,
      surface: surface ?? this.surface,
      surfaceMuted: surfaceMuted ?? this.surfaceMuted,
      border: border ?? this.border,
      textPrimary: textPrimary ?? this.textPrimary,
      textMuted: textMuted ?? this.textMuted,
      pageGradientStart: pageGradientStart ?? this.pageGradientStart,
      pageGradientEnd: pageGradientEnd ?? this.pageGradientEnd,
      heroGlow: heroGlow ?? this.heroGlow,
      shadow: shadow ?? this.shadow,
    );
  }

  @override
  AppThemePalette lerp(ThemeExtension<AppThemePalette>? other, double t) {
    if (other is! AppThemePalette) {
      return this;
    }

    return AppThemePalette(
      background: Color.lerp(background, other.background, t) ?? background,
      backgroundAlt:
          Color.lerp(backgroundAlt, other.backgroundAlt, t) ?? backgroundAlt,
      surface: Color.lerp(surface, other.surface, t) ?? surface,
      surfaceMuted:
          Color.lerp(surfaceMuted, other.surfaceMuted, t) ?? surfaceMuted,
      border: Color.lerp(border, other.border, t) ?? border,
      textPrimary:
          Color.lerp(textPrimary, other.textPrimary, t) ?? textPrimary,
      textMuted: Color.lerp(textMuted, other.textMuted, t) ?? textMuted,
      pageGradientStart:
          Color.lerp(pageGradientStart, other.pageGradientStart, t) ??
              pageGradientStart,
      pageGradientEnd:
          Color.lerp(pageGradientEnd, other.pageGradientEnd, t) ??
              pageGradientEnd,
      heroGlow: Color.lerp(heroGlow, other.heroGlow, t) ?? heroGlow,
      shadow: Color.lerp(shadow, other.shadow, t) ?? shadow,
    );
  }
}

extension AppThemeX on ThemeData {
  AppThemePalette get appPalette => extension<AppThemePalette>()!;
}

extension AppThemeContextX on BuildContext {
  AppThemePalette get palette => Theme.of(this).appPalette;
}

class AppTheme {
  const AppTheme._();

  static ThemeData get darkTheme {
    final base = ThemeData.dark(useMaterial3: true);

    const colorScheme = ColorScheme(
      brightness: Brightness.dark,
      primary: AppColors.primary,
      onPrimary: AppColors.textPrimaryDark,
      secondary: AppColors.secondary,
      onSecondary: AppColors.textPrimaryDark,
      error: Colors.redAccent,
      onError: AppColors.textPrimaryDark,
      surface: AppColors.surfaceDark,
      onSurface: AppColors.textPrimaryDark,
    );

    const palette = AppThemePalette(
      background: AppColors.bgDark,
      backgroundAlt: AppColors.bgDarkAlt,
      surface: AppColors.surfaceDark,
      surfaceMuted: AppColors.surfaceMutedDark,
      border: AppColors.borderDark,
      textPrimary: AppColors.textPrimaryDark,
      textMuted: AppColors.textMutedDark,
      pageGradientStart: Color(0xFF070B12),
      pageGradientEnd: Color(0xFF0B1220),
      heroGlow: Color(0x4038BDF8),
      shadow: Color(0x66030A16),
    );

    return _buildTheme(base, colorScheme, palette);
  }

  static ThemeData get lightTheme {
    final base = ThemeData.light(useMaterial3: true);

    const colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.primary,
      onPrimary: AppColors.surfaceLight,
      secondary: AppColors.secondary,
      onSecondary: AppColors.surfaceLight,
      error: Colors.redAccent,
      onError: AppColors.surfaceLight,
      surface: AppColors.surfaceLight,
      onSurface: AppColors.textPrimaryLight,
    );

    const palette = AppThemePalette(
      background: AppColors.bgLight,
      backgroundAlt: AppColors.bgLightAlt,
      surface: AppColors.surfaceLight,
      surfaceMuted: AppColors.surfaceMutedLight,
      border: AppColors.borderLight,
      textPrimary: AppColors.textPrimaryLight,
      textMuted: AppColors.textMutedLight,
      pageGradientStart: Color(0xFFF6FBFF),
      pageGradientEnd: Color(0xFFEAF6FF),
      heroGlow: Color(0x2238BDF8),
      shadow: Color(0x140F172A),
    );

    return _buildTheme(base, colorScheme, palette);
  }

  static ThemeData _buildTheme(
    ThemeData base,
    ColorScheme colorScheme,
    AppThemePalette palette,
  ) {
    return base.copyWith(
      colorScheme: colorScheme,
      scaffoldBackgroundColor: palette.background,
      canvasColor: palette.background,
      dividerColor: palette.border,
      textTheme: _buildTextTheme(
        base.textTheme,
        palette.textPrimary,
        palette.textMuted,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: palette.textPrimary),
      ),
      elevatedButtonTheme: _buildElevatedButton(
        colorScheme.primary,
        colorScheme.onPrimary,
      ),
      outlinedButtonTheme: _buildOutlinedButton(
        palette.textPrimary,
        palette.border,
      ),
      inputDecorationTheme: _buildInputDecoration(
        palette.surface,
        palette.border,
        palette.textMuted,
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(foregroundColor: palette.textPrimary),
      ),
      cardTheme: _buildCardTheme(palette.surface, palette.border),
      extensions: <ThemeExtension<dynamic>>[palette],
    );
  }

  static TextTheme _buildTextTheme(
    TextTheme base,
    Color primaryColor,
    Color mutedColor,
  ) {
    return base.copyWith(
      displayLarge: TextStyle(
        fontSize: 64,
        fontWeight: FontWeight.w700,
        color: primaryColor,
        height: 1.05,
      ),
      displayMedium: TextStyle(
        fontSize: 48,
        fontWeight: FontWeight.w700,
        color: primaryColor,
        height: 1.1,
      ),
      displaySmall: TextStyle(
        fontSize: 40,
        fontWeight: FontWeight.w700,
        color: primaryColor,
        height: 1.12,
      ),
      headlineSmall: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: primaryColor,
      ),
      headlineMedium: TextStyle(
        fontSize: 34,
        fontWeight: FontWeight.w700,
        color: primaryColor,
      ),
      titleLarge: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: primaryColor,
      ),
      titleMedium: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: primaryColor,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        height: 1.7,
        color: primaryColor,
      ),
      bodyMedium: TextStyle(
        fontSize: 15,
        height: 1.6,
        color: mutedColor,
      ),
      bodySmall: TextStyle(
        fontSize: 13,
        height: 1.5,
        color: mutedColor,
      ),
      labelLarge: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
    );
  }

  static ElevatedButtonThemeData _buildElevatedButton(
    Color bgColor,
    Color fgColor,
  ) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: bgColor,
        foregroundColor: fgColor,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
      ),
    );
  }

  static OutlinedButtonThemeData _buildOutlinedButton(
    Color fgColor,
    Color borderColor,
  ) {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: fgColor,
        side: BorderSide(color: borderColor),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
      ),
    );
  }

  static InputDecorationTheme _buildInputDecoration(
    Color fillColor,
    Color borderColor,
    Color labelColor,
  ) {
    return InputDecorationTheme(
      filled: true,
      fillColor: fillColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.primary),
      ),
      labelStyle: TextStyle(color: labelColor),
    );
  }

  static CardThemeData _buildCardTheme(Color color, Color borderColor) {
    return CardThemeData(
      color: color,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(color: borderColor),
      ),
    );
  }
}
