import 'package:flutter/material.dart';

// AMD Slingshot-inspired Black & Red palette
class AppColors {
  // Primary Palette
  static const Color primary    = Color(0xFFE8340A); // Vibrant Red-Orange
  static const Color secondary  = Color(0xFFFF5722); // Deep Orange
  static const Color accent     = Color(0xFFFF9800); // Amber accent

  // Backgrounds
  static const Color background = Color(0xFF0A0A0A); // Near-black
  static const Color surface    = Color(0xFF161616); // Card surface
  static const Color surfaceAlt = Color(0xFF1E1E1E); // Elevated card

  // Text
  static const Color textBody   = Color(0xFFE8E8E8);
  static const Color textLight  = Color(0xFF9E9E9E);

  // Safety
  static const Color safe    = Color(0xFF00C853); // Vivid green
  static const Color warning = Color(0xFFFFAB00); // Amber
  static const Color danger  = Color(0xFFE8340A); // Red-orange (same as primary)
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        primary:   AppColors.primary,
        secondary: AppColors.secondary,
        surface:   AppColors.surface,
        error:     AppColors.danger,
        onPrimary: Colors.white,
        onSurface: AppColors.textBody,
      ),
      scaffoldBackgroundColor: AppColors.background,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
          elevation: 4,
          shadowColor: AppColors.primary,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary),
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceAlt,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF2E2E2E)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF2E2E2E)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.danger),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.danger, width: 2),
        ),
        labelStyle: const TextStyle(color: AppColors.textLight),
        hintStyle: const TextStyle(color: AppColors.textLight),
      ),
      cardTheme: CardThemeData(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: AppColors.surface,
        shadowColor: AppColors.primary.withAlpha(40),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.surfaceAlt,
        selectedColor: AppColors.primary,
        labelStyle: const TextStyle(color: AppColors.textBody),
        secondaryLabelStyle: const TextStyle(color: Colors.white),
        side: const BorderSide(color: Color(0xFF2E2E2E)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      iconTheme: const IconThemeData(color: AppColors.textBody),
      listTileTheme: const ListTileThemeData(
        iconColor: AppColors.primary,
        textColor: AppColors.textBody,
      ),
      dividerColor: const Color(0xFF2E2E2E),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) =>
            states.contains(WidgetState.selected) ? AppColors.primary : AppColors.textLight),
        trackColor: WidgetStateProperty.resolveWith((states) =>
            states.contains(WidgetState.selected)
                ? AppColors.primary.withAlpha(80)
                : const Color(0xFF2E2E2E)),
      ),
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: AppColors.surface,
        contentTextStyle: TextStyle(color: AppColors.textBody),
      ),
    );
  }
}
