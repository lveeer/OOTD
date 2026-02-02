import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/app_constants.dart';

/// 极简白灰风格按钮组件
/// 黑底白字 / 白底黑框 / 纯文字风格
enum AppButtonType {
  primary,   // 黑底白字
  secondary, // 白底黑框
  outline,   // 白底黑框（与 secondary 相同）
  text,      // 纯文字
  glass,     // 移除，改为 secondary
}

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final AppButtonType type;
  final bool isLoading;
  final bool isFullWidth;
  final bool isDisabled;
  final Widget? icon;
  final double? width;
  final double? height;
  final double borderRadius;
  final bool enableHapticFeedback;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = AppButtonType.primary,
    this.isLoading = false,
    this.isFullWidth = false,
    this.isDisabled = false,
    this.icon,
    this.width,
    this.height,
    this.borderRadius = AppTheme.buttonRadius,
    this.enableHapticFeedback = true,
  });

  bool get _isEnabled => onPressed != null && !isLoading && !isDisabled;

  @override
  Widget build(BuildContext context) {
    final button = _buildButton(context);

    if (isFullWidth) {
      return SizedBox(
        width: double.infinity,
        child: button,
      );
    }

    return SizedBox(
      width: width,
      height: height,
      child: button,
    );
  }

  Widget _buildButton(BuildContext context) {
    final theme = Theme.of(context);
    final brightness = theme.brightness;

    switch (type) {
      case AppButtonType.primary:
        return _buildPrimaryButton(context, brightness);
      case AppButtonType.secondary:
        return _buildSecondaryButton(context, brightness);
      case AppButtonType.outline:
        return _buildOutlineButton(context, brightness);
      case AppButtonType.text:
        return _buildTextButton(context, brightness);
      case AppButtonType.glass:
        return _buildGlassButton(context, brightness);
    }
  }

  Widget _buildPrimaryButton(BuildContext context, Brightness brightness) {
    return ElevatedButton(
      onPressed: _isEnabled ? _handlePress : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.accent, // 黑底
        foregroundColor: Colors.white,     // 白字
        disabledBackgroundColor: brightness == Brightness.light
            ? AppColors.lightTertiaryFill
            : AppColors.darkTertiaryFill,
        disabledForegroundColor: brightness == Brightness.light
            ? AppColors.lightTertiaryLabel
            : AppColors.darkTertiaryLabel,
        elevation: 0,
        shadowColor: Colors.transparent,
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.spacingL,
          vertical: AppConstants.spacingM,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        textStyle: const TextStyle(
          fontSize: AppConstants.fontSizeL,
          fontWeight: FontWeight.w500, // Medium
          letterSpacing: -0.3,
        ),
      ).copyWith(
        overlayColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.pressed)) {
            return AppColors.lightLabel.withOpacity(0.1); // 黑色而非品牌色
          }
          if (states.contains(WidgetState.hovered)) {
            return AppColors.lightLabel.withOpacity(0.05);
          }
          return null;
        }),
      ),
      child: _buildContent(),
    );
  }

  Widget _buildSecondaryButton(BuildContext context, Brightness brightness) {
    return OutlinedButton(
      onPressed: _isEnabled ? _handlePress : null,
      style: OutlinedButton.styleFrom(
        backgroundColor: brightness == Brightness.light
            ? AppColors.lightBackground // 白底
            : AppColors.darkBackground,
        foregroundColor: AppColors.labelColor(brightness), // 黑色/白色文字
        disabledForegroundColor: brightness == Brightness.light
            ? AppColors.lightTertiaryLabel
            : AppColors.darkTertiaryLabel,
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.spacingL,
          vertical: AppConstants.spacingM,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        side: BorderSide(
          color: _isEnabled 
              ? AppColors.labelColor(brightness) // 黑色/白色边框
              : (brightness == Brightness.light
                  ? AppColors.lightTertiaryFill
                  : AppColors.darkTertiaryFill),
          width: 1.0, // 1px 而非 1.5px
        ),
        textStyle: const TextStyle(
          fontSize: AppConstants.fontSizeL,
          fontWeight: FontWeight.w500, // Medium
          letterSpacing: -0.3,
        ),
      ).copyWith(
        overlayColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.pressed)) {
            return AppColors.labelColor(brightness).withOpacity(0.1);
          }
          return null;
        }),
      ),
      child: _buildContent(AppColors.labelColor(brightness)),
    );
  }

  Widget _buildOutlineButton(BuildContext context, Brightness brightness) {
    // Outline 与 Secondary 相同（白底黑框）
    return _buildSecondaryButton(context, brightness);
  }

  Widget _buildTextButton(BuildContext context, Brightness brightness) {
    return TextButton(
      onPressed: _isEnabled ? _handlePress : null,
      style: TextButton.styleFrom(
        foregroundColor: AppColors.labelColor(brightness), // 黑色/白色
        disabledForegroundColor: brightness == Brightness.light
            ? AppColors.lightTertiaryLabel
            : AppColors.darkTertiaryLabel,
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.spacingM,
          vertical: AppConstants.spacingS,
        ),
        textStyle: const TextStyle(
          fontSize: AppConstants.fontSizeM,
          fontWeight: FontWeight.w400, // Regular
          letterSpacing: -0.2,
        ),
      ).copyWith(
        overlayColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.pressed)) {
            return AppColors.labelColor(brightness).withOpacity(0.1);
          }
          return null;
        }),
      ),
      child: _buildContent(AppColors.labelColor(brightness)),
    );
  }

  Widget _buildGlassButton(BuildContext context, Brightness brightness) {
    // Glass 改为 Secondary（白底黑框）
    return _buildSecondaryButton(context, brightness);
  }

  Widget _buildContent([Color? textColor]) {
    if (isLoading) {
      return const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconTheme(
            data: IconThemeData(
              color: textColor ?? Colors.white,
              size: 20,
            ),
            child: icon!,
          ),
          const SizedBox(width: 8),
          Text(text),
        ],
      );
    }

    return Text(text);
  }

  void _handlePress() {
    if (enableHapticFeedback) {
      AppTheme.lightImpact();
    }
    onPressed?.call();
  }
}