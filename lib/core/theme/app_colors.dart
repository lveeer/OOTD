import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

/// iOS HIG 风格颜色系统
/// 支持语义化颜色、深色模式和 Liquid Glass 材质效果
class AppColors {
  // ==================== 品牌色 ====================
  static const Color primary = Color(AppConstants.primaryColorValue);
  static const Color secondary = Color(AppConstants.secondaryColorValue);
  
  // 强调色（Tint Color）- 用于可交互元素，比品牌色更饱和、偏白
  static const Color accent = Color(0xFFFF8FB3);
  static const Color accentSecondary = Color(0xFF6EE7DD);

  // ==================== 语义化颜色 - 浅色模式 ====================
  static const Color lightLabel = Color(0xFF000000);
  static Color get lightSecondaryLabel => const Color(0xFF3C3C43).withOpacity(0.60);
  static Color get lightTertiaryLabel => const Color(0xFF3C3C43).withOpacity(0.30);
  static Color get lightQuaternaryLabel => const Color(0xFF3C3C43).withOpacity(0.18);
  
  static const Color lightBackground = Color(0xFFF2F2F7);
  static const Color lightSecondaryBackground = Color(0xFFFFFFFF);
  static const Color lightTertiaryBackground = Color(0xFFF2F2F7);
  
  static Color get lightFill => const Color(0xFF787880).withOpacity(0.12);
  static Color get lightSecondaryFill => const Color(0xFF787880).withOpacity(0.08);
  static Color get lightTertiaryFill => const Color(0xFF767680).withOpacity(0.05);
  
  static const Color lightSeparator = Color(0xFFC6C6C8);
  static const Color lightSeparatorOpaque = Color(0xFF48484A);

  // ==================== 语义化颜色 - 深色模式 ====================
  static const Color darkLabel = Color(0xFFFFFFFF);
  static Color get darkSecondaryLabel => const Color(0xFFEBEBF5).withOpacity(0.60);
  static Color get darkTertiaryLabel => const Color(0xFFEBEBF5).withOpacity(0.30);
  static Color get darkQuaternaryLabel => const Color(0xFFEBEBF5).withOpacity(0.16);
  
  static const Color darkBackground = Color(0xFF000000);
  static const Color darkSecondaryBackground = Color(0xFF1C1C1E);
  static const Color darkTertiaryBackground = Color(0xFF2C2C2E);
  
  static Color get darkFill => const Color(0xFF787880).withOpacity(0.22);
  static Color get darkSecondaryFill => const Color(0xFF787880).withOpacity(0.14);
  static Color get darkTertiaryFill => const Color(0xFF767680).withOpacity(0.08);
  
  static const Color darkSeparator = Color(0xFF38383A);
  static const Color darkSeparatorOpaque = Color(0xFF636366);

  // ==================== 功能色 ====================
  static const Color error = Color(AppConstants.errorColorValue);
  static const Color errorLight = Color(0xFFFF453A);
  static const Color errorDark = Color(0xFFFF453A);
  
  static const Color warning = Color(AppConstants.warningColorValue);
  static const Color warningLight = Color(0xFFFF9F0A);
  static const Color warningDark = Color(0xFFFF9F0A);
  
  static const Color success = Color(AppConstants.successColorValue);
  static const Color successLight = Color(0xFF30D158);
  static const Color successDark = Color(0xFF30D158);

  // ==================== 中性色 ====================
  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);
  static const Color grey50 = Color(0xFFFAFAFA);
  static const Color grey100 = Color(0xFFF5F5F5);
  static const Color grey200 = Color(0xFFEEEEEE);
  static const Color grey300 = Color(0xFFE0E0E0);
  static const Color grey400 = Color(0xFFBDBDBD);
  static const Color grey500 = Color(0xFF9E9E9E);
  static const Color grey600 = Color(0xFF757575);
  static const Color grey700 = Color(0xFF616161);
  static const Color grey800 = Color(0xFF424242);
  static const Color grey900 = Color(0xFF212121);

  // ==================== Liquid Glass 材质颜色 ====================
  // 半透明玻璃层，用于背景模糊效果
  static const Color glassLight = Color(0xCCFFFFFF);
  static const Color glassDark = Color(0xCC1C1C1E);
  
  // 玻璃边框色
  static const Color glassBorderLight = Color(0x33FFFFFF);
  static const Color glassBorderDark = Color(0x33FFFFFF);
  
  // 高光反射效果
  static const Color glassHighlightLight = Color(0x33FFFFFF);
  static const Color glassHighlightDark = Color(0x1AFFFFFF);

  // ==================== 透明度层 ====================
  static const Color transparent = Color(0x00000000);
  static const Color overlayLight = Color(0x40000000);
  static const Color overlayDark = Color(0x60000000);

  // ==================== 渐变色 ====================
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, secondary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkGradient = LinearGradient(
    colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Liquid Glass 渐变效果
  static LinearGradient glassGradientLight = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      glassHighlightLight,
      Colors.transparent,
      glassHighlightLight,
    ],
    stops: const [0.0, 0.5, 1.0],
  );

  static LinearGradient glassGradientDark = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      glassHighlightDark,
      Colors.transparent,
      glassHighlightDark,
    ],
    stops: const [0.0, 0.5, 1.0],
  );

  // ==================== iOS 风格阴影 ====================
  // 轻微阴影，用于普通卡片
  static List<BoxShadow> get lightCardShadow => [
        BoxShadow(
          color: Colors.black.withOpacity(0.03),
          blurRadius: 8,
          offset: const Offset(0, 2),
          spreadRadius: 0,
        ),
      ];

  static List<BoxShadow> get darkCardShadow => [
        BoxShadow(
          color: Colors.black.withOpacity(0.15),
          blurRadius: 8,
          offset: const Offset(0, 2),
          spreadRadius: 0,
        ),
      ];

  // 提升阴影，用于浮动元素
  static List<BoxShadow> get lightElevatedShadow => [
        BoxShadow(
          color: Colors.black.withOpacity(0.08),
          blurRadius: 16,
          offset: const Offset(0, 4),
          spreadRadius: 0,
        ),
      ];

  static List<BoxShadow> get darkElevatedShadow => [
        BoxShadow(
          color: Colors.black.withOpacity(0.25),
          blurRadius: 16,
          offset: const Offset(0, 4),
          spreadRadius: 0,
        ),
      ];

  // 内阴影，用于凹陷效果
  static List<BoxShadow> get lightInnerShadow => [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          offset: const Offset(0, -1),
          blurRadius: 0,
          spreadRadius: 0,
        ),
        BoxShadow(
          color: Colors.white.withOpacity(0.05),
          offset: const Offset(0, 1),
          blurRadius: 0,
          spreadRadius: 0,
        ),
      ];

  // ==================== 根据主题获取颜色 ====================
  /// 根据主题亮度获取语义化颜色
  static Color labelColor(Brightness brightness) {
    return brightness == Brightness.light ? lightLabel : darkLabel;
  }

  static Color secondaryLabelColor(Brightness brightness) {
    return brightness == Brightness.light ? lightSecondaryLabel : darkSecondaryLabel;
  }

  static Color tertiaryLabelColor(Brightness brightness) {
    return brightness == Brightness.light ? lightTertiaryLabel : darkTertiaryLabel;
  }

  static Color backgroundColor(Brightness brightness) {
    return brightness == Brightness.light ? lightBackground : darkBackground;
  }

  static Color secondaryBackgroundColor(Brightness brightness) {
    return brightness == Brightness.light ? lightSecondaryBackground : darkSecondaryBackground;
  }

  static Color fillColor(Brightness brightness) {
    return brightness == Brightness.light ? lightFill : darkFill;
  }

  static Color separatorColor(Brightness brightness) {
    return brightness == Brightness.light ? lightSeparator : darkSeparator;
  }

  static Color glassColor(Brightness brightness) {
    return brightness == Brightness.light ? glassLight : glassDark;
  }

  static List<BoxShadow> cardShadow(Brightness brightness) {
    return brightness == Brightness.light ? lightCardShadow : darkCardShadow;
  }

  static List<BoxShadow> elevatedShadow(Brightness brightness) {
    return brightness == Brightness.light ? lightElevatedShadow : darkElevatedShadow;
  }
}