import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

class AppColors {
  // 主色
  static const Color primary = Color(AppConstants.primaryColorValue);
  static const Color secondary = Color(AppConstants.secondaryColorValue);

  // 背景色
  static const Color background = Color(AppConstants.backgroundColorValue);
  static const Color surface = Color(AppConstants.surfaceColorValue);

  // 功能色
  static const Color error = Color(AppConstants.errorColorValue);
  static const Color warning = Color(AppConstants.warningColorValue);
  static const Color success = Color(AppConstants.successColorValue);

  // 中性色
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

  // 透明色
  static const Color transparent = Color(0x00000000);

  // 渐变色
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

  // 阴影
  static List<BoxShadow> get cardShadow => [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 10,
          offset: const Offset(0, 2),
        ),
      ];

  static List<BoxShadow> get elevatedShadow => [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 20,
          offset: const Offset(0, 4),
        ),
      ];
}