import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_constants.dart';
import 'app_colors.dart';

/// 极简白灰风格主题配置 (Ver 1.0)
/// 设计原则：内容至上、克制用色、呼吸感、杂志质感
/// 扁平设计，无阴影，圆角 4-8px，黑白灰配色
class AppTheme {
  // ==================== 极简风格圆角 ====================
  static const double squircleRadius = 4.0; // 小圆角，避免游戏感
  static const double cardRadius = 8.0;      // 卡片圆角 4-8px
  static const double buttonRadius = 4.0;    // 方正硬朗或胶囊状
  static const double inputRadius = 4.0;

  // ==================== 极简风格动画时长 ====================
  static const Duration fastAnimation = Duration(milliseconds: 150);  // 更快，减少干扰
  static const Duration normalAnimation = Duration(milliseconds: 200);
  static const Duration slowAnimation = Duration(milliseconds: 250);

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

  // ==================== 浅色主题（极简白灰） ====================
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      
      // 极简白灰颜色方案
      colorScheme: ColorScheme.light(
        primary: AppColors.accent,        // 黑色作为主色
        secondary: AppColors.textPrimary, // 深灰作为辅助色
        surface: AppColors.lightSecondaryBackground,
        error: AppColors.errorLight,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: AppColors.lightLabel,
        onError: Colors.white,
      ),
      
      scaffoldBackgroundColor: AppColors.lightBackground,
      
      // 极简风格应用栏
      appBarTheme: const AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.lightLabel,
        titleTextStyle: TextStyle(
          color: AppColors.lightLabel,
          fontSize: 18, // 一级标题 18-20px
          fontWeight: FontWeight.w700, // Bold
          letterSpacing: -0.5,
        ),
        iconTheme: IconThemeData(
          color: AppColors.lightLabel, // 黑色线性图标
          size: 22,
        ),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      
      // 极简风格卡片（扁平，无阴影）
      cardTheme: CardTheme(
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(cardRadius),
        ),
        color: AppColors.lightSecondaryBackground,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      
      // 极简风格按钮（黑底白字/白底黑框）
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          shadowColor: Colors.transparent,
          backgroundColor: AppColors.accent, // 黑底
          foregroundColor: Colors.white,     // 白字
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
            fontWeight: FontWeight.w500, // Medium
            letterSpacing: -0.3,
          ),
        ).copyWith(
          overlayColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.pressed)) {
              return AppColors.lightSecondaryLabel.withOpacity(0.2);
            }
            if (states.contains(WidgetState.hovered)) {
              return AppColors.lightSecondaryLabel.withOpacity(0.1);
            }
            return null;
          }),
        ),
      ),
      
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.lightLabel, // 黑色文字
          disabledForegroundColor: AppColors.lightTertiaryLabel,
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.spacingM,
            vertical: AppConstants.spacingS,
          ),
          textStyle: const TextStyle(
            fontSize: AppConstants.fontSizeM,
            fontWeight: FontWeight.w400, // Regular
            letterSpacing: -0.2,
          ),
        ),
      ),
      
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.lightLabel, // 黑色文字
          disabledForegroundColor: AppColors.lightTertiaryLabel,
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.spacingL,
            vertical: AppConstants.spacingM,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(buttonRadius),
          ),
          side: const BorderSide(
            color: AppColors.lightLabel, // 黑色边框
            width: 1.0,
          ),
          textStyle: const TextStyle(
            fontSize: AppConstants.fontSizeL,
            fontWeight: FontWeight.w500, // Medium
            letterSpacing: -0.3,
          ),
        ),
      ),
      
      // 极简风格输入框（浅灰底，无边框）
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.lightSecondaryBackground, // 浅灰底 #F5F5F5
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppConstants.spacingM,
          vertical: AppConstants.spacingM,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(inputRadius),
          borderSide: BorderSide.none, // 无边框
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(inputRadius),
          borderSide: BorderSide.none, // 无边框
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(inputRadius),
          borderSide: const BorderSide(
            color: AppColors.lightLabel, // 黑色边框
            width: 1,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(inputRadius),
          borderSide: const BorderSide(
            color: AppColors.errorLight,
            width: 1,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(inputRadius),
          borderSide: const BorderSide(
            color: AppColors.errorLight,
            width: 1,
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
      
      // 极简风格文本主题（杂志质感）
      textTheme: TextTheme(
        displayLarge: const TextStyle(
          fontSize: 20, // 一级标题 18-20px
          fontWeight: FontWeight.w700, // Bold
          color: AppColors.lightLabel,
          letterSpacing: -0.5,
          height: 1.2,
        ),
        displayMedium: const TextStyle(
          fontSize: 16, // 二级标题 14-16px
          fontWeight: FontWeight.w500, // Medium
          color: AppColors.lightLabel,
          letterSpacing: -0.3,
          height: 1.4, // 最多显示2行
        ),
        displaySmall: TextStyle(
          fontSize: 12, // 辅助信息 11-12px
          fontWeight: FontWeight.w400, // Regular
          color: AppColors.lightSecondaryLabel, // 灰色
          letterSpacing: -0.1,
          height: 1.3,
        ),
        headlineMedium: TextStyle(
          fontSize: 12, // 数据统计 11-12px
          fontWeight: FontWeight.w500, // Medium
          color: AppColors.lightSecondaryLabel, // 灰色
          letterSpacing: -0.1,
          height: 1.3,
        ),
        titleMedium: const TextStyle(
          fontSize: 14, // 穿搭描述
          fontWeight: FontWeight.w500, // Medium
          color: AppColors.lightLabel,
          letterSpacing: -0.2,
          height: 1.4,
        ),
        bodyLarge: const TextStyle(
          fontSize: 16,
          color: AppColors.lightLabel,
          letterSpacing: -0.2,
          height: 1.5,
        ),
        bodyMedium: const TextStyle(
          fontSize: 14,
          color: AppColors.lightLabel,
          letterSpacing: -0.1,
          height: 1.5,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          color: AppColors.lightSecondaryLabel,
          letterSpacing: -0.1,
          height: 1.4,
        ),
        labelLarge: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppColors.lightLabel,
          letterSpacing: -0.2,
        ),
      ).apply(
        fontFamily: '.SF Pro Text',
        displayColor: AppColors.lightLabel,
        bodyColor: AppColors.lightLabel,
      ),
      
      // 极简风格底部导航栏（线性图标，选中变实心黑）
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        elevation: 0,
        backgroundColor: AppColors.lightSecondaryBackground,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.lightLabel, // 黑色
        unselectedItemColor: AppColors.lightSecondaryLabel, // 灰色
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
      
      // 极简风格浮动按钮（黑色）
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        elevation: 0,
        backgroundColor: AppColors.accent, // 黑色
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(buttonRadius),
        ),
        iconSize: 24,
      ),
      
      // iOS 风格标签
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.lightFill,
        selectedColor: AppColors.accent.withOpacity(0.15), // 黑色 15%
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
        color: AppColors.accent, // 黑色
        linearTrackColor: AppColors.lightFill,
        circularTrackColor: AppColors.lightFill,
      ),
      
      // iOS 风格滑块
      sliderTheme: SliderThemeData(
        activeTrackColor: AppColors.accent, // 黑色
        inactiveTrackColor: AppColors.lightFill,
        thumbColor: AppColors.accent, // 黑色
        overlayColor: AppColors.accent.withOpacity(0.2), // 黑色 20%
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
          return AppColors.accent; // 黑色
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.accent.withOpacity(0.5); // 黑色 50%
          }
          return AppColors.lightFill;
        }),
        trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
      ),
    );
  }

  // ==================== 深色主题（极简黑灰） ====================
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      
      // 极简黑灰颜色方案
      colorScheme: ColorScheme.dark(
        primary: AppColors.accent,        // 黑色作为主色
        secondary: AppColors.textPrimary, // 深灰作为辅助色
        surface: AppColors.darkSecondaryBackground,
        error: AppColors.errorDark,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: AppColors.darkLabel,
        onError: Colors.white,
      ),
      
      scaffoldBackgroundColor: AppColors.darkBackground,
      
      // 极简风格应用栏
      appBarTheme: const AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.darkLabel,
        titleTextStyle: TextStyle(
          color: AppColors.darkLabel,
          fontSize: 18, // 一级标题 18-20px
          fontWeight: FontWeight.w700, // Bold
          letterSpacing: -0.5,
        ),
        iconTheme: IconThemeData(
          color: AppColors.darkLabel, // 白色线性图标
          size: 22,
        ),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      
      // 极简风格卡片（扁平，无阴影）
      cardTheme: CardTheme(
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(cardRadius),
        ),
        color: AppColors.darkSecondaryBackground,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      
      // 极简风格按钮（黑底白字/白底黑框）
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          shadowColor: Colors.transparent,
          backgroundColor: AppColors.accent, // 黑底
          foregroundColor: Colors.white,     // 白字
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
            fontWeight: FontWeight.w500, // Medium
            letterSpacing: -0.3,
          ),
        ).copyWith(
          overlayColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.pressed)) {
              return AppColors.darkSecondaryLabel.withOpacity(0.2);
            }
            if (states.contains(WidgetState.hovered)) {
              return AppColors.darkSecondaryLabel.withOpacity(0.1);
            }
            return null;
          }),
        ),
      ),
      
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.darkLabel, // 白色文字
          disabledForegroundColor: AppColors.darkTertiaryLabel,
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.spacingM,
            vertical: AppConstants.spacingS,
          ),
          textStyle: const TextStyle(
            fontSize: AppConstants.fontSizeM,
            fontWeight: FontWeight.w400, // Regular
            letterSpacing: -0.2,
          ),
        ),
      ),
      
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.darkLabel, // 白色文字
          disabledForegroundColor: AppColors.darkTertiaryLabel,
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.spacingL,
            vertical: AppConstants.spacingM,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(buttonRadius),
          ),
          side: const BorderSide(
            color: AppColors.darkLabel, // 白色边框
            width: 1.0,
          ),
          textStyle: const TextStyle(
            fontSize: AppConstants.fontSizeL,
            fontWeight: FontWeight.w500, // Medium
            letterSpacing: -0.3,
          ),
        ),
      ),
      
      // 极简风格输入框（浅灰底，无边框）
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkSecondaryBackground, // 浅灰底
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppConstants.spacingM,
          vertical: AppConstants.spacingM,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(inputRadius),
          borderSide: BorderSide.none, // 无边框
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(inputRadius),
          borderSide: BorderSide.none, // 无边框
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(inputRadius),
          borderSide: const BorderSide(
            color: AppColors.darkLabel, // 白色边框
            width: 1,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(inputRadius),
          borderSide: const BorderSide(
            color: AppColors.errorDark,
            width: 1,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(inputRadius),
          borderSide: const BorderSide(
            color: AppColors.errorDark,
            width: 1,
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
      
      // 极简风格文本主题（杂志质感）
      textTheme: TextTheme(
        displayLarge: const TextStyle(
          fontSize: 20, // 一级标题 18-20px
          fontWeight: FontWeight.w700, // Bold
          color: AppColors.darkLabel,
          letterSpacing: -0.5,
          height: 1.2,
        ),
        displayMedium: const TextStyle(
          fontSize: 16, // 二级标题 14-16px
          fontWeight: FontWeight.w500, // Medium
          color: AppColors.darkLabel,
          letterSpacing: -0.3,
          height: 1.4, // 最多显示2行
        ),
        displaySmall: TextStyle(
          fontSize: 12, // 辅助信息 11-12px
          fontWeight: FontWeight.w400, // Regular
          color: AppColors.darkSecondaryLabel, // 灰色
          letterSpacing: -0.1,
          height: 1.3,
        ),
        headlineMedium: TextStyle(
          fontSize: 12, // 数据统计 11-12px
          fontWeight: FontWeight.w500, // Medium
          color: AppColors.darkSecondaryLabel, // 灰色
          letterSpacing: -0.1,
          height: 1.3,
        ),
        titleMedium: const TextStyle(
          fontSize: 14, // 穿搭描述
          fontWeight: FontWeight.w500, // Medium
          color: AppColors.darkLabel,
          letterSpacing: -0.2,
          height: 1.4,
        ),
        bodyLarge: const TextStyle(
          fontSize: 16,
          color: AppColors.darkLabel,
          letterSpacing: -0.2,
          height: 1.5,
        ),
        bodyMedium: const TextStyle(
          fontSize: 14,
          color: AppColors.darkLabel,
          letterSpacing: -0.1,
          height: 1.5,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          color: AppColors.darkSecondaryLabel,
          letterSpacing: -0.1,
          height: 1.4,
        ),
        labelLarge: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppColors.darkLabel,
          letterSpacing: -0.2,
        ),
      ).apply(
        fontFamily: '.SF Pro Text',
        displayColor: AppColors.darkLabel,
        bodyColor: AppColors.darkLabel,
      ),
      
      // 极简风格底部导航栏（线性图标，选中变实心白）
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        elevation: 0,
        backgroundColor: AppColors.darkSecondaryBackground,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.darkLabel, // 白色
        unselectedItemColor: AppColors.darkSecondaryLabel, // 灰色
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
      
      // 极简风格浮动按钮（黑色）
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        elevation: 0,
        backgroundColor: AppColors.accent, // 黑色
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(buttonRadius),
        ),
        iconSize: 24,
      ),
      
      // iOS 风格标签
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.darkFill,
        selectedColor: AppColors.accent.withOpacity(0.2), // 黑色 20%
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
        color: AppColors.accent, // 黑色
        linearTrackColor: AppColors.darkFill,
        circularTrackColor: AppColors.darkFill,
      ),
      
      // iOS 风格滑块
      sliderTheme: SliderThemeData(
        activeTrackColor: AppColors.accent, // 黑色
        inactiveTrackColor: AppColors.darkFill,
        thumbColor: AppColors.accent, // 黑色
        overlayColor: AppColors.accent.withOpacity(0.3), // 黑色 30%
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
          return AppColors.accent; // 黑色
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.accent.withOpacity(0.5); // 黑色 50%
          }
          return AppColors.darkFill;
        }),
        trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
      ),
    );
  }
}