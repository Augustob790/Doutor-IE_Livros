import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTheme {
  static const double _radius = 10;
  static const String fontSans = 'DMSans';
  static const String fontDisplay = 'PlusJakartaSans';

  static ThemeData get lightTheme {
    final ColorScheme colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.lightPrimary,
      brightness: Brightness.light,
      surface: AppColors.lightCard,
      onSurface: AppColors.lightForeground,
      error: AppColors.lightDestructive,
      primary: AppColors.lightPrimary,
      onPrimary: AppColors.lightPrimaryForeground,
      secondary: AppColors.lightSecondary,
      onSecondary: AppColors.lightSecondaryForeground,
      outline: AppColors.lightBorder,
    );

    final TextTheme textTheme = _buildTextTheme(
      base: ThemeData.light().textTheme,
      bodyColor: AppColors.lightForeground,
      mutedColor: AppColors.lightMutedForeground,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.lightBackground,
      cardColor: AppColors.lightCard,
      canvasColor: AppColors.lightBackground,
      textTheme: textTheme,
      primaryTextTheme: textTheme,
      dividerColor: AppColors.lightBorder,
      visualDensity: VisualDensity.standard,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.lightForeground,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          fontSize: 20,
          color: AppColors.lightForeground,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.lightCard,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.lightBorder),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.lightPrimary,
          foregroundColor: AppColors.lightPrimaryForeground,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_radius),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
          textStyle: textTheme.labelLarge?.copyWith(
            fontSize: 14,
            letterSpacing: -0.1,
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.lightPrimary,
          foregroundColor: AppColors.lightPrimaryForeground,
          minimumSize: const Size(0, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_radius),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          textStyle: textTheme.labelLarge,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.lightForeground,
          side: const BorderSide(color: AppColors.lightBorder),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_radius),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
          textStyle: textTheme.labelLarge?.copyWith(
            fontSize: 14,
            letterSpacing: -0.1,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.lightPrimary,
          textStyle: textTheme.labelLarge?.copyWith(
            fontSize: 14,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.lightCard,
        hintStyle: textTheme.bodyMedium?.copyWith(
          color: AppColors.lightMutedForeground,
          fontWeight: FontWeight.w500,
        ),
        labelStyle: textTheme.bodyMedium?.copyWith(
          color: AppColors.lightMutedForeground,
          fontWeight: FontWeight.w500,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_radius),
          borderSide: const BorderSide(color: AppColors.lightBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_radius),
          borderSide: const BorderSide(color: AppColors.lightBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_radius),
          borderSide: const BorderSide(color: AppColors.lightRing, width: 1.2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_radius),
          borderSide: const BorderSide(color: AppColors.lightDestructive),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_radius),
          borderSide:
              const BorderSide(color: AppColors.lightDestructive, width: 1.2),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.lightPrimary,
        foregroundColor: AppColors.lightPrimaryForeground,
        elevation: 2,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.lightCard,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedLabelStyle:
            textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w700),
        unselectedLabelStyle: textTheme.labelSmall,
      ),
    );
  }

  static ThemeData get darkTheme {
    final ColorScheme colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.darkPrimary,
      brightness: Brightness.dark,
      surface: AppColors.darkCard,
      onSurface: AppColors.darkForeground,
      error: AppColors.darkDestructive,
      primary: AppColors.darkPrimary,
      onPrimary: AppColors.darkPrimaryForeground,
      secondary: AppColors.darkSecondary,
      onSecondary: AppColors.darkSecondaryForeground,
      outline: AppColors.darkBorder,
    );

    final TextTheme textTheme = _buildTextTheme(
      base: ThemeData.dark().textTheme,
      bodyColor: AppColors.darkForeground,
      mutedColor: AppColors.darkMutedForeground,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,
      cardColor: AppColors.darkCard,
      canvasColor: colorScheme.surface,
      textTheme: textTheme,
      primaryTextTheme: textTheme,
      dividerColor: AppColors.darkBorder,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.darkForeground,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          fontSize: 20,
          color: AppColors.darkForeground,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.darkPrimary,
          foregroundColor: AppColors.darkPrimaryForeground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_radius),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
          textStyle: textTheme.labelLarge?.copyWith(
            fontSize: 14,
            // letterSpacing: -0.1,
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.darkPrimary,
          foregroundColor: AppColors.darkPrimaryForeground,
          minimumSize: const Size(0, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_radius),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          textStyle: textTheme.labelLarge,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.darkForeground,
          side: const BorderSide(color: AppColors.darkBorder),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_radius),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
          textStyle: textTheme.labelLarge?.copyWith(
            fontSize: 14,
            // letterSpacing: -0.1,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkInput,
        hintStyle: textTheme.bodyMedium?.copyWith(
          color: AppColors.darkMutedForeground,
          fontWeight: FontWeight.w500,
        ),
        labelStyle: textTheme.bodyMedium?.copyWith(
          color: AppColors.darkMutedForeground,
          fontWeight: FontWeight.w500,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_radius),
          borderSide: const BorderSide(color: AppColors.darkBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_radius),
          borderSide: const BorderSide(color: AppColors.darkBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_radius),
          borderSide: const BorderSide(color: AppColors.darkRing, width: 1.2),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.darkPrimary,
        foregroundColor: AppColors.darkPrimaryForeground,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.darkCard,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedLabelStyle:
            textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w700),
        unselectedLabelStyle: textTheme.labelSmall,
      ),
    );
  }

  static TextTheme _buildTextTheme({
    required TextTheme base,
    required Color bodyColor,
    required Color mutedColor,
  }) {
    final TextTheme dmSansBase = base.apply(
      fontFamily: fontSans,
      bodyColor: bodyColor,
      displayColor: bodyColor,
    );

    return dmSansBase.copyWith(
      displayLarge: dmSansBase.displayLarge?.copyWith(
        fontFamily: fontDisplay,
        fontWeight: FontWeight.w700,
        letterSpacing: -1.0,
      ),
      displayMedium: dmSansBase.displayMedium?.copyWith(
        fontFamily: fontDisplay,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.8,
      ),
      displaySmall: dmSansBase.displaySmall?.copyWith(
        fontFamily: fontDisplay,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.6,
      ),
      headlineLarge: dmSansBase.headlineLarge?.copyWith(
        fontFamily: fontDisplay,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
      ),
      headlineMedium: dmSansBase.headlineMedium?.copyWith(
        fontFamily: fontDisplay,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.4,
      ),
      headlineSmall: dmSansBase.headlineSmall?.copyWith(
        fontFamily: fontDisplay,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.3,
      ),
      titleLarge: dmSansBase.titleLarge?.copyWith(
        fontFamily: fontDisplay,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.2,
      ),
      titleMedium: dmSansBase.titleMedium?.copyWith(
        fontWeight: FontWeight.w700,
        letterSpacing: -0.1,
      ),
      titleSmall: dmSansBase.titleSmall?.copyWith(
        fontWeight: FontWeight.w700,
      ),
      bodyLarge: dmSansBase.bodyLarge?.copyWith(
        color: bodyColor,
        fontWeight: FontWeight.w500,
      ),
      bodyMedium: dmSansBase.bodyMedium?.copyWith(
        color: bodyColor,
        fontWeight: FontWeight.w500,
      ),
      bodySmall: dmSansBase.bodySmall?.copyWith(
        color: mutedColor,
        fontWeight: FontWeight.w500,
      ),
      labelLarge: dmSansBase.labelLarge?.copyWith(
        fontWeight: FontWeight.w700,
      ),
      labelMedium: dmSansBase.labelMedium?.copyWith(
        fontWeight: FontWeight.w600,
      ),
      labelSmall: dmSansBase.labelSmall?.copyWith(
        color: mutedColor,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
