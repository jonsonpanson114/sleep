import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/constants.dart';

class AppTheme {
  static ThemeData get darkTheme {
    final baseTheme = ThemeData.dark();
    final textTheme = GoogleFonts.notoSansJpTextTheme(baseTheme.textTheme);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.accent,
        surface: AppColors.cardBackground,
        error: AppColors.danger,
      ),
      scaffoldBackgroundColor: AppColors.background,
      cardColor: AppColors.cardBackground,
      textTheme: textTheme.copyWith(
        bodyLarge: GoogleFonts.notoSansJp(
          textStyle: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 16,
          ),
        ),
        bodyMedium: GoogleFonts.notoSansJp(
          textStyle: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 14,
          ),
        ),
        titleLarge: GoogleFonts.notoSansJp(
          textStyle: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 48,
            fontWeight: FontWeight.bold,
          ),
        ),
        labelLarge: GoogleFonts.notoSansJp(
          textStyle: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 32,
            fontWeight: FontWeight.w300,
          ),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.background,
        elevation: 0,
        titleTextStyle: GoogleFonts.notoSansJp(
          textStyle: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.background,
        selectedItemColor: AppColors.accent,
        unselectedItemColor: AppColors.textSecondary,
        selectedLabelStyle: TextStyle(
          color: AppColors.accent,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyle(
          color: AppColors.textSecondary,
        ),
        elevation: 0,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) => AppColors.accent),
        trackColor: WidgetStateProperty.resolveWith((states) => AppColors.cardBackground),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) => AppColors.success),
        checkColor: WidgetStateProperty.all(Colors.white),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accent,
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.notoSansJp(
            textStyle: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
