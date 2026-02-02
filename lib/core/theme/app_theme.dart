import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_constants.dart';
import 'app_colors.dart';

/// iOS HIG 风格主题配置
/// 遵循清晰性（Clarity）、顺从性（Deference）和深度感（Depth）三大哲学
/// 支持 Liquid Glass 材质效果、动态字体类型、触觉反馈
class AppTheme {
  // ==================== iOS 风格圆角 ====================
  static const double squircleRadius = 12.0; // iOS 风格圆角矩形（Squircle）
  static const double cardRadius = 16.0;
  static const double buttonRadius = 10.0;
  static const double inputRadius = 10.0;

  // ==================== iOS 风格动画时长 ====================
  static const Duration fastAnimation = Duration(milliseconds: 200);
  static const Duration normalAnimation = Duration(milliseconds: 250);
  static const Duration slowAnimation = Duration(milliseconds: 300);

  // ==================== 触觉反馈 ====================
  static void lightImpact() {
    HapticFeedback.lightImpact();
  }

  static void mediumImpact() {
    HapticFeedback.mediumImpact();
  }

  static void heavyImpact() {
    HapticFeedback.heavyImpact();
  }

  static void selectionClick() {
    HapticFeedback.selectionClick();
  }

  // ==================== 浅色主题 ====================
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      
      // iOS 风格颜色方案
      colorScheme: ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.lightSecondaryBackground,
        error: AppColors.errorLight,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: AppColors.lightLabel,
        onError: Colors.white,
      ),
      
      scaffoldBackgroundColor: AppColors.lightBackground,
      
      // iOS 风格应用栏
      appBarTheme: const AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.lightLabel,
        titleTextStyle: TextStyle(
          color: AppColors.lightLabel,
          fontSize: AppConstants.fontSizeL,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.5,
        ),
        iconTheme: IconThemeData(
          color: AppColors.primary,
          size: 22,
        ),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      
      // iOS 风格卡片（Liquid Glass 效果）
      cardTheme: CardTheme(
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(cardRadius),
        ),
        color: AppColors.lightSecondaryBackground,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      
      // iOS 风格按钮
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          shadowColor: Colors.transparent,
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          disabledBackgroundColor: AppColors.lightTertiaryFill,
          disabledForegroundColor: AppColors.lightTertiaryLabel,
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.spacingL,
            vertical: AppConstants.spacingM,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(buttonRadius),
          ),
          textStyle: const TextStyle(
            fontSize: AppConstants.fontSizeL,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.3,
          ),
        ).copyWith(
          overlayColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.pressed)) {
              return AppColors.primary.withOpacity(0.2);
            }
            if (states.contains(WidgetState.hovered)) {
              return AppColors.primary.withOpacity(0.1);
            }
            return null;
          }),
        ),
      ),
      
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          disabledForegroundColor: AppColors.lightTertiaryLabel,
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.spacingM,
            vertical: AppConstants.spacingS,
          ),
          textStyle: const TextStyle(
            fontSize: AppConstants.fontSizeM,
            fontWeight: FontWeight.w500,
            letterSpacing: -0.2,
          ),
        ),
      ),
      
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          disabledForegroundColor: AppColors.lightTertiaryLabel,
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.spacingL,
            vertical: AppConstants.spacingM,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(buttonRadius),
          ),
          side: const BorderSide(
            color: AppColors.primary,
            width: 1.5,
          ),
          textStyle: const TextStyle(
            fontSize: AppConstants.fontSizeL,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.3,
          ),
        ),
      ),
      
      // iOS 风格输入框
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.lightSecondaryBackground,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppConstants.spacingM,
          vertical: AppConstants.spacingM,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(inputRadius),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(inputRadius),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(inputRadius),
          borderSide: const BorderSide(
            color: AppColors.primary,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(inputRadius),
          borderSide: const BorderSide(
            color: AppColors.errorLight,
            width: 1.5,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(inputRadius),
          borderSide: const BorderSide(
            color: AppColors.errorLight,
            width: 2,
          ),
        ),
        hintStyle: TextStyle(
          color: AppColors.lightTertiaryLabel,
          fontSize: AppConstants.fontSizeM,
        ),
        labelStyle: TextStyle(
          color: AppColors.lightSecondaryLabel,
          fontSize: AppConstants.fontSizeM,
        ),
      ),
      
      // iOS 风格文本主题（支持动态字体）
      textTheme: TextTheme(
        displayLarge: const TextStyle(
          fontSize: AppConstants.fontSizeXXXL,
          fontWeight: FontWeight.bold,
          color: AppColors.lightLabel,
          letterSpacing: -1.0,
          height: 1.2,
        ),
        displayMedium: const TextStyle(
          fontSize: AppConstants.fontSizeXXL,
          fontWeight: FontWeight.bold,
          color: AppColors.lightLabel,
          letterSpacing: -0.8,
          height: 1.2,
        ),
        displaySmall: const TextStyle(
          fontSize: AppConstants.fontSizeXL,
          fontWeight: FontWeight.w600,
          color: AppColors.lightLabel,
          letterSpacing: -0.5,
          height: 1.3,
        ),
        headlineMedium: const TextStyle(
          fontSize: AppConstants.fontSizeL,
          fontWeight: FontWeight.w600,
          color: AppColors.lightLabel,
          letterSpacing: -0.3,
          height: 1.3,
        ),
        titleMedium: const TextStyle(
          fontSize: AppConstants.fontSizeM,
          fontWeight: FontWeight.w500,
          color: AppColors.lightLabel,
          letterSpacing: -0.2,
          height: 1.4,
        ),
        bodyLarge: const TextStyle(
          fontSize: AppConstants.fontSizeL,
          color: AppColors.lightLabel,
          letterSpacing: -0.2,
          height: 1.5,
        ),
        bodyMedium: const TextStyle(
          fontSize: AppConstants.fontSizeM,
          color: AppColors.lightLabel,
          letterSpacing: -0.1,
          height: 1.5,
        ),
        bodySmall: TextStyle(
          fontSize: AppConstants.fontSizeS,
          color: AppColors.lightSecondaryLabel,
          letterSpacing: -0.1,
          height: 1.4,
        ),
        labelLarge: const TextStyle(
          fontSize: AppConstants.fontSizeM,
          fontWeight: FontWeight.w500,
          color: AppColors.lightLabel,
          letterSpacing: -0.2,
        ),
      ).apply(
        fontFamily: '.SF Pro Text',
        displayColor: AppColors.lightLabel,
        bodyColor: AppColors.lightLabel,
      ),
      
      // iOS 风格底部导航栏
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        elevation: 0,
        backgroundColor: AppColors.lightSecondaryBackground,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.lightTertiaryLabel,
        selectedLabelStyle: const TextStyle(
          fontSize: AppConstants.fontSizeXS,
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: AppConstants.fontSizeXS,
          fontWeight: FontWeight.w400,
        ),
        showUnselectedLabels: true,
      ),
      
      // iOS 风格浮动按钮
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        elevation: 0,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        iconSize: 24,
      ),
      
      // iOS 风格标签
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.lightFill,
        selectedColor: AppColors.primary.withOpacity(0.15),
        disabledColor: AppColors.lightTertiaryFill,
        labelStyle: const TextStyle(
          fontSize: AppConstants.fontSizeS,
          color: AppColors.lightLabel,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        side: BorderSide.none,
      ),
      
      // iOS 风格分割线
      dividerTheme: const DividerThemeData(
        thickness: 0.5,
        color: AppColors.lightSeparator,
        space: 1,
      ),
      
      // iOS 风格图标
      iconTheme: const IconThemeData(
        color: AppColors.lightLabel,
        size: 24,
      ),
      
      // iOS 风格列表瓦片
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      
      // iOS 风格对话框
      dialogTheme: DialogTheme(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        backgroundColor: AppColors.lightSecondaryBackground,
        titleTextStyle: const TextStyle(
          fontSize: AppConstants.fontSizeL,
          fontWeight: FontWeight.w600,
          color: AppColors.lightLabel,
        ),
        contentTextStyle: const TextStyle(
          fontSize: AppConstants.fontSizeM,
          color: AppColors.lightLabel,
        ),
      ),
      
      // iOS 风格底部弹窗
      bottomSheetTheme: const BottomSheetThemeData(
        elevation: 0,
        backgroundColor: AppColors.lightSecondaryBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        modalBackgroundColor: AppColors.lightSecondaryBackground,
      ),
      
      // iOS 风格进度指示器
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: AppColors.primary,
        linearTrackColor: AppColors.lightFill,
        circularTrackColor: AppColors.lightFill,
      ),
      
      // iOS 风格滑块
      sliderTheme: SliderThemeData(
        activeTrackColor: AppColors.primary,
        inactiveTrackColor: AppColors.lightFill,
        thumbColor: AppColors.primary,
        overlayColor: AppColors.primary.withOpacity(0.2),
        trackHeight: 4,
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
        overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
      ),
      
      // iOS 风格开关
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return AppColors.lightTertiaryFill;
          }
          return AppColors.primary;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary.withOpacity(0.5);
          }
          return AppColors.lightFill;
        }),
        trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
      ),
    );
  }

  // ==================== 深色主题 ====================
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      
      // iOS 风格颜色方案
      colorScheme: ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.darkSecondaryBackground,
        error: AppColors.errorDark,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: AppColors.darkLabel,
        onError: Colors.white,
      ),
      
      scaffoldBackgroundColor: AppColors.darkBackground,
      
      // iOS 风格应用栏
      appBarTheme: const AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.darkLabel,
        titleTextStyle: TextStyle(
          color: AppColors.darkLabel,
          fontSize: AppConstants.fontSizeL,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.5,
        ),
        iconTheme: IconThemeData(
          color: AppColors.primary,
          size: 22,
        ),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      
      // iOS 风格卡片（Liquid Glass 效果）
      cardTheme: CardTheme(
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(cardRadius),
        ),
        color: AppColors.darkSecondaryBackground,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      
      // iOS 风格按钮
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          shadowColor: Colors.transparent,
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          disabledBackgroundColor: AppColors.darkTertiaryFill,
          disabledForegroundColor: AppColors.darkTertiaryLabel,
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.spacingL,
            vertical: AppConstants.spacingM,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(buttonRadius),
          ),
          textStyle: const TextStyle(
            fontSize: AppConstants.fontSizeL,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.3,
          ),
        ).copyWith(
          overlayColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.pressed)) {
              return AppColors.primary.withOpacity(0.3);
            }
            if (states.contains(WidgetState.hovered)) {
              return AppColors.primary.withOpacity(0.15);
            }
            return null;
          }),
        ),
      ),
      
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          disabledForegroundColor: AppColors.darkTertiaryLabel,
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.spacingM,
            vertical: AppConstants.spacingS,
          ),
          textStyle: const TextStyle(
            fontSize: AppConstants.fontSizeM,
            fontWeight: FontWeight.w500,
            letterSpacing: -0.2,
          ),
        ),
      ),
      
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          disabledForegroundColor: AppColors.darkTertiaryLabel,
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.spacingL,
            vertical: AppConstants.spacingM,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(buttonRadius),
          ),
          side: const BorderSide(
            color: AppColors.primary,
            width: 1.5,
          ),
          textStyle: const TextStyle(
            fontSize: AppConstants.fontSizeL,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.3,
          ),
        ),
      ),
      
      // iOS 风格输入框
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkSecondaryBackground,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppConstants.spacingM,
          vertical: AppConstants.spacingM,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(inputRadius),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(inputRadius),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(inputRadius),
          borderSide: const BorderSide(
            color: AppColors.primary,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(inputRadius),
          borderSide: const BorderSide(
            color: AppColors.errorDark,
            width: 1.5,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(inputRadius),
          borderSide: const BorderSide(
            color: AppColors.errorDark,
            width: 2,
          ),
        ),
        hintStyle: TextStyle(
          color: AppColors.darkTertiaryLabel,
          fontSize: AppConstants.fontSizeM,
        ),
        labelStyle: TextStyle(
          color: AppColors.darkSecondaryLabel,
          fontSize: AppConstants.fontSizeM,
        ),
      ),
      
      // iOS 风格文本主题（支持动态字体）
      textTheme: TextTheme(
        displayLarge: const TextStyle(
          fontSize: AppConstants.fontSizeXXXL,
          fontWeight: FontWeight.bold,
          color: AppColors.darkLabel,
          letterSpacing: -1.0,
          height: 1.2,
        ),
        displayMedium: const TextStyle(
          fontSize: AppConstants.fontSizeXXL,
          fontWeight: FontWeight.bold,
          color: AppColors.darkLabel,
          letterSpacing: -0.8,
          height: 1.2,
        ),
        displaySmall: const TextStyle(
          fontSize: AppConstants.fontSizeXL,
          fontWeight: FontWeight.w600,
          color: AppColors.darkLabel,
          letterSpacing: -0.5,
          height: 1.3,
        ),
        headlineMedium: const TextStyle(
          fontSize: AppConstants.fontSizeL,
          fontWeight: FontWeight.w600,
          color: AppColors.darkLabel,
          letterSpacing: -0.3,
          height: 1.3,
        ),
        titleMedium: const TextStyle(
          fontSize: AppConstants.fontSizeM,
          fontWeight: FontWeight.w500,
          color: AppColors.darkLabel,
          letterSpacing: -0.2,
          height: 1.4,
        ),
        bodyLarge: const TextStyle(
          fontSize: AppConstants.fontSizeL,
          color: AppColors.darkLabel,
          letterSpacing: -0.2,
          height: 1.5,
        ),
        bodyMedium: const TextStyle(
          fontSize: AppConstants.fontSizeM,
          color: AppColors.darkLabel,
          letterSpacing: -0.1,
          height: 1.5,
        ),
        bodySmall: TextStyle(
          fontSize: AppConstants.fontSizeS,
          color: AppColors.darkSecondaryLabel,
          letterSpacing: -0.1,
          height: 1.4,
        ),
        labelLarge: const TextStyle(
          fontSize: AppConstants.fontSizeM,
          fontWeight: FontWeight.w500,
          color: AppColors.darkLabel,
          letterSpacing: -0.2,
        ),
      ).apply(
        fontFamily: '.SF Pro Text',
        displayColor: AppColors.darkLabel,
        bodyColor: AppColors.darkLabel,
      ),
      
      // iOS 风格底部导航栏
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        elevation: 0,
        backgroundColor: AppColors.darkSecondaryBackground,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.darkTertiaryLabel,
        selectedLabelStyle: const TextStyle(
          fontSize: AppConstants.fontSizeXS,
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: AppConstants.fontSizeXS,
          fontWeight: FontWeight.w400,
        ),
        showUnselectedLabels: true,
      ),
      
      // iOS 风格浮动按钮
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        elevation: 0,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        iconSize: 24,
      ),
      
      // iOS 风格标签
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.darkFill,
        selectedColor: AppColors.primary.withOpacity(0.2),
        disabledColor: AppColors.darkTertiaryFill,
        labelStyle: const TextStyle(
          fontSize: AppConstants.fontSizeS,
          color: AppColors.darkLabel,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        side: BorderSide.none,
      ),
      
      // iOS 风格分割线
      dividerTheme: const DividerThemeData(
        thickness: 0.5,
        color: AppColors.darkSeparator,
        space: 1,
      ),
      
      // iOS 风格图标
      iconTheme: const IconThemeData(
        color: AppColors.darkLabel,
        size: 24,
      ),
      
      // iOS 风格列表瓦片
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      
      // iOS 风格对话框
      dialogTheme: DialogTheme(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        backgroundColor: AppColors.darkSecondaryBackground,
        titleTextStyle: const TextStyle(
          fontSize: AppConstants.fontSizeL,
          fontWeight: FontWeight.w600,
          color: AppColors.darkLabel,
        ),
        contentTextStyle: const TextStyle(
          fontSize: AppConstants.fontSizeM,
          color: AppColors.darkLabel,
        ),
      ),
      
      // iOS 风格底部弹窗
      bottomSheetTheme: const BottomSheetThemeData(
        elevation: 0,
        backgroundColor: AppColors.darkSecondaryBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        modalBackgroundColor: AppColors.darkSecondaryBackground,
      ),
      
      // iOS 风格进度指示器
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: AppColors.primary,
        linearTrackColor: AppColors.darkFill,
        circularTrackColor: AppColors.darkFill,
      ),
      
      // iOS 风格滑块
      sliderTheme: SliderThemeData(
        activeTrackColor: AppColors.primary,
        inactiveTrackColor: AppColors.darkFill,
        thumbColor: AppColors.primary,
        overlayColor: AppColors.primary.withOpacity(0.3),
        trackHeight: 4,
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
        overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
      ),
      
      // iOS 风格开关
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return AppColors.darkTertiaryFill;
          }
          return AppColors.primary;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary.withOpacity(0.5);
          }
          return AppColors.darkFill;
        }),
        trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
      ),
    );
  }
}