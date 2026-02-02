import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

/// 极简白灰风格颜色系统 (Ver 1.0)
/// 设计原则：内容至上、克制用色、呼吸感、杂志质感
/// 色彩严格限制在白、黑、灰三级色阶中
class AppColors {
  // ==================== 极简白灰色阶 ====================
  // Level 0 背景 - App主背景、卡片背景、弹窗底色
  static const Color background = Color(0xFFFFFFFF);
  
  // Level 1 底色 - 信息流背景、功能区分块背景
  static const Color secondaryBackground = Color(0xFFF5F5F5);
  
  // Level 2 文本 - 主标题、正文、重要按钮文字
  static const Color textPrimary = Color(0xFF333333);
  
  // Level 3 文本 - 次要信息（时间、点赞数、作者名）
  static const Color textSecondary = Color(0xFF999999);
  
  // Level 4 线条 - 分割线、卡片边框
  static const Color divider = Color(0xFFEEEEEE);
  
  // 点缀色（慎用）- 主按钮、选中态图标
  static const Color accent = Color(0xFF000000);

  // ==================== 语义化颜色 - 浅色模式（极简白灰） ====================
  static const Color lightLabel = Color(0xFF333333);
  static Color get lightSecondaryLabel => const Color(0xFF999999);
  static Color get lightTertiaryLabel => const Color(0xFFCCCCCC);
  
  static const Color lightBackground = Color(0xFFFFFFFF);
  static const Color lightSecondaryBackground = Color(0xFFF5F5F5);
  static const Color lightTertiaryBackground = Color(0xFFFFFFFF);
  
  static Color get lightFill => const Color(0xFF333333).withOpacity(0.05);
  static Color get lightSecondaryFill => const Color(0xFF333333).withOpacity(0.03);
  static Color get lightTertiaryFill => const Color(0xFF333333).withOpacity(0.02);
  
  static const Color lightSeparator = Color(0xFFEEEEEE);
  static const Color lightSeparatorOpaque = Color(0xFFEEEEEE);

  // ==================== 语义化颜色 - 深色模式（极简黑灰） ====================
  static const Color darkLabel = Color(0xFFFFFFFF);
  static Color get darkSecondaryLabel => const Color(0xFF999999);
  static Color get darkTertiaryLabel => const Color(0xFF666666);
  
  static const Color darkBackground = Color(0xFF000000);
  static const Color darkSecondaryBackground = Color(0xFF1A1A1A);
  static const Color darkTertiaryBackground = Color(0xFF000000);
  
  static Color get darkFill => const Color(0xFFFFFFFF).withOpacity(0.08);
  static Color get darkSecondaryFill => const Color(0xFFFFFFFF).withOpacity(0.05);
  static Color get darkTertiaryFill => const Color(0xFFFFFFFF).withOpacity(0.03);
  
  static const Color darkSeparator = Color(0xFF333333);
  static const Color darkSeparatorOpaque = Color(0xFF333333);

  // ==================== 功能色（保持低调，仅用于必要场景） ====================
  static const Color error = Color(0xFF333333); // 错误信息使用深灰而非红色
  static const Color errorLight = Color(0xFF333333);
  static const Color errorDark = Color(0xFFCCCCCC);
  
  static const Color warning = Color(0xFF333333); // 警告信息使用深灰而非橙色
  static const Color warningLight = Color(0xFF333333);
  static const Color warningDark = Color(0xFFCCCCCC);
  
  static const Color success = Color(0xFF333333); // 成功信息使用深灰而非绿色
  static const Color successLight = Color(0xFF333333);
  static const Color successDark = Color(0xFFCCCCCC);

  // ==================== 中性色（完整灰阶） ====================
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

  // ==================== 扁平材质颜色（移除玻璃态效果） ====================
  // 纯色背景，无模糊效果
  static const Color glassLight = Color(0xFFFFFFFF);
  static const Color glassDark = Color(0xFF000000);
  
  // 边框色
  static const Color glassBorderLight = Color(0xFFEEEEEE);
  static const Color glassBorderDark = Color(0xFF333333);
  
  // 高光效果（移除，保持扁平）
  static const Color glassHighlightLight = Color(0x00000000);
  static const Color glassHighlightDark = Color(0x00000000);

  // ==================== 透明度层 ====================
  static const Color transparent = Color(0x00000000);
  static const Color overlayLight = Color(0x40000000);
  static const Color overlayDark = Color(0x60000000);

  // ==================== 渐变色（移除，保持纯色） ====================
  // 极简风格不使用渐变，所有渐变改为纯色
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF000000), Color(0xFF000000)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkGradient = LinearGradient(
    colors: [Color(0xFF000000), Color(0xFF000000)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // 移除玻璃态渐变，改为纯色
  static LinearGradient glassGradientLight = const LinearGradient(
    colors: [Color(0x00000000), Color(0x00000000)],
  );

  static LinearGradient glassGradientDark = const LinearGradient(
    colors: [Color(0x00000000), Color(0x00000000)],
  );

  // ==================== 极简风格阴影（移除所有阴影） ====================
  // 扁平设计，不使用阴影
  static List<BoxShadow> get lightCardShadow => [];
  static List<BoxShadow> get darkCardShadow => [];
  static List<BoxShadow> get lightElevatedShadow => [];
  static List<BoxShadow> get darkElevatedShadow => [];
  static List<BoxShadow> get lightInnerShadow => [];

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