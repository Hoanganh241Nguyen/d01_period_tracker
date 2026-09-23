import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static const _lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.primary,
    onPrimary: AppColors.onPrimary,
    primaryContainer: AppColors.primaryContainer,
    onPrimaryContainer: AppColors.primary,
    secondary: AppColors.secondary,
    onSecondary: Colors.white,
    secondaryContainer: Color(0xFFFFD9E4),
    onSecondaryContainer: AppColors.secondary,
    tertiary: AppColors.tertiary,
    onTertiary: Colors.white,
    tertiaryContainer: Color(0xFFEFE2B8),
    onTertiaryContainer: AppColors.tertiary,
    error: AppColors.error,
    onError: Colors.white,
    errorContainer: Color(0xFFFFDAD6),
    onErrorContainer: Color(0xFF410002),
    surface: AppColors.surface,
    onSurface: Color(0xFF24191D),
    surfaceContainerHighest: AppColors.primaryContainer,
    onSurfaceVariant: Color(0xFF6E5D64),
    outline: AppColors.outline,
    outlineVariant: Color(0xFFE7CBD2),
    shadow: Colors.black,
    scrim: Colors.black,
    inverseSurface: Color(0xFF3A2D31),
    onInverseSurface: Color(0xFFFFEEF3),
    inversePrimary: AppColors.darkPrimary,
  );

  static const _darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: AppColors.darkPrimary,
    onPrimary: AppColors.darkOnPrimary,
    primaryContainer: AppColors.darkPrimaryContainer,
    onPrimaryContainer: Colors.white,
    secondary: AppColors.darkSecondary,
    onSecondary: Color(0xFF3D2931),
    secondaryContainer: Color(0xFF543942),
    onSecondaryContainer: AppColors.darkSecondary,
    tertiary: AppColors.darkTertiary,
    onTertiary: Color(0xFF3A2F10),
    tertiaryContainer: Color(0xFF51451D),
    onTertiaryContainer: AppColors.darkTertiary,
    error: AppColors.darkError,
    onError: Color(0xFF690005),
    errorContainer: Color(0xFF93000A),
    onErrorContainer: Color(0xFFFFDAD6),
    surface: AppColors.darkSurface,
    onSurface: Color(0xFFF4DEE4),
    surfaceContainerHighest: Color(0xFF3B2D31),
    onSurfaceVariant: Color(0xFFD8C1C7),
    outline: AppColors.darkOutline,
    outlineVariant: Color(0xFF514347),
    shadow: Colors.black,
    scrim: Colors.black,
    inverseSurface: Color(0xFFF4DEE4),
    onInverseSurface: Color(0xFF24191D),
    inversePrimary: AppColors.primary,
  );

  static ThemeData light = ThemeData(
    useMaterial3: true,
    colorScheme: _lightColorScheme,
    scaffoldBackgroundColor: AppColors.background,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      foregroundColor: Color(0xFF351821),
      elevation: 0,
      centerTitle: false,
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      color: AppColors.surface.withValues(alpha: 0.94),
      margin: EdgeInsets.zero,
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        disabledBackgroundColor: AppColors.primaryContainer,
        disabledForegroundColor: AppColors.primary.withValues(alpha: 0.55),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: AppColors.primary),
    ),
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(
        foregroundColor: AppColors.primary,
        disabledForegroundColor: AppColors.primary.withValues(alpha: 0.32),
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.surface.withValues(alpha: 0.88),
      selectedColor: AppColors.primary,
      checkmarkColor: AppColors.onPrimary,
      labelStyle: const TextStyle(color: Color(0xFF2B2025)),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
    ),
    sliderTheme: const SliderThemeData(
      activeTrackColor: AppColors.primary,
      thumbColor: AppColors.primary,
      overlayColor: Color(0x29C2185B),
      inactiveTrackColor: AppColors.primaryContainer,
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.selected)
            ? Colors.white
            : AppColors.outline,
      ),
      trackColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.selected)
            ? AppColors.primary
            : AppColors.primaryContainer,
      ),
    ),
  );

  static ThemeData dark = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: _darkColorScheme,
    scaffoldBackgroundColor: AppColors.darkBackground,
  );
}
