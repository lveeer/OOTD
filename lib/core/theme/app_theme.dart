import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.light(
        primary: const Color(AppConstants.primaryColorValue),
        secondary: const Color(AppConstants.secondaryColorValue),
        background: const Color(AppConstants.backgroundColorValue),
        surface: const Color(AppConstants.surfaceColorValue),
        error: const Color(AppConstants.errorColorValue),
      ),
      scaffoldBackgroundColor: const Color(AppConstants.backgroundColorValue),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black87,
        titleTextStyle: TextStyle(
          color: Colors.black87,
          fontSize: AppConstants.fontSizeL,
          fontWeight: FontWeight.w600,
        ),
      ),
      cardTheme: CardTheme(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusL),
        ),
        color: const Color(AppConstants.surfaceColorValue),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.spacingL,
            vertical: AppConstants.spacingM,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusM),
          ),
          textStyle: const TextStyle(
            fontSize: AppConstants.fontSizeL,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.spacingM,
            vertical: AppConstants.spacingS,
          ),
          textStyle: const TextStyle(
            fontSize: AppConstants.fontSizeM,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.spacingL,
            vertical: AppConstants.spacingM,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusM),
          ),
          side: const BorderSide(
            color: Color(AppConstants.primaryColorValue),
          ),
          textStyle: const TextStyle(
            fontSize: AppConstants.fontSizeL,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(AppConstants.surfaceColorValue),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppConstants.spacingM,
          vertical: AppConstants.spacingM,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusM),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusM),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusM),
          borderSide: const BorderSide(
            color: Color(AppConstants.primaryColorValue),
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusM),
          borderSide: const BorderSide(
            color: Color(AppConstants.errorColorValue),
          ),
        ),
        hintStyle: TextStyle(
          color: Colors.grey[400],
          fontSize: AppConstants.fontSizeM,
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: AppConstants.fontSizeXXXL,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
        displayMedium: TextStyle(
          fontSize: AppConstants.fontSizeXXL,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
        displaySmall: TextStyle(
          fontSize: AppConstants.fontSizeXL,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
        headlineMedium: TextStyle(
          fontSize: AppConstants.fontSizeL,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
        titleMedium: TextStyle(
          fontSize: AppConstants.fontSizeM,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
        bodyLarge: TextStyle(
          fontSize: AppConstants.fontSizeL,
          color: Colors.black87,
        ),
        bodyMedium: TextStyle(
          fontSize: AppConstants.fontSizeM,
          color: Colors.black87,
        ),
        bodySmall: TextStyle(
          fontSize: AppConstants.fontSizeS,
          color: Colors.grey,
        ),
        labelLarge: TextStyle(
          fontSize: AppConstants.fontSizeM,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Color(AppConstants.primaryColorValue),
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: TextStyle(
          fontSize: AppConstants.fontSizeXS,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: AppConstants.fontSizeXS,
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusXL),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: Colors.grey[100],
        selectedColor: const Color(AppConstants.primaryColorValue).withOpacity(0.1),
        labelStyle: const TextStyle(
          fontSize: AppConstants.fontSizeS,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusL),
        ),
      ),
      dividerTheme: const DividerThemeData(
        thickness: 0.5,
        color: Colors.grey,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        primary: const Color(AppConstants.primaryColorValue),
        secondary: const Color(AppConstants.secondaryColorValue),
        background: const Color(0xFF121212),
        surface: const Color(0xFF1E1E1E),
        error: const Color(AppConstants.errorColorValue),
      ),
      scaffoldBackgroundColor: const Color(0xFF121212),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: AppConstants.fontSizeL,
          fontWeight: FontWeight.w600,
        ),
      ),
      cardTheme: CardTheme(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusL),
        ),
        color: const Color(0xFF1E1E1E),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: AppConstants.fontSizeXXXL,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        displayMedium: TextStyle(
          fontSize: AppConstants.fontSizeXXL,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        displaySmall: TextStyle(
          fontSize: AppConstants.fontSizeXL,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        headlineMedium: TextStyle(
          fontSize: AppConstants.fontSizeL,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        titleMedium: TextStyle(
          fontSize: AppConstants.fontSizeM,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
        bodyLarge: TextStyle(
          fontSize: AppConstants.fontSizeL,
          color: Colors.white70,
        ),
        bodyMedium: TextStyle(
          fontSize: AppConstants.fontSizeM,
          color: Colors.white70,
        ),
        bodySmall: TextStyle(
          fontSize: AppConstants.fontSizeS,
          color: Colors.grey,
        ),
      ),
    );
  }
}