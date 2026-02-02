import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/app_constants.dart';

/// iOS HIG 风格按钮组件
/// 支持触觉反馈、Liquid Glass 材质效果、流畅动画
enum AppButtonType {
  primary,
  secondary,
  outline,
  text,
  glass,
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
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
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
      child: _buildContent(),
    );
  }

  Widget _buildSecondaryButton(BuildContext context, Brightness brightness) {
    return ElevatedButton(
      onPressed: _isEnabled ? _handlePress : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.secondary,
        foregroundColor: Colors.white,
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
          fontWeight: FontWeight.w600,
          letterSpacing: -0.3,
        ),
      ).copyWith(
        overlayColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.pressed)) {
            return AppColors.secondary.withOpacity(0.2);
          }
          if (states.contains(WidgetState.hovered)) {
            return AppColors.secondary.withOpacity(0.1);
          }
          return null;
        }),
      ),
      child: _buildContent(),
    );
  }

  Widget _buildOutlineButton(BuildContext context, Brightness brightness) {
    return OutlinedButton(
      onPressed: _isEnabled ? _handlePress : null,
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
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
          color: _isEnabled ? AppColors.primary : (brightness == Brightness.light
              ? AppColors.lightTertiaryFill
              : AppColors.darkTertiaryFill),
          width: 1.5,
        ),
        textStyle: const TextStyle(
          fontSize: AppConstants.fontSizeL,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.3,
        ),
      ).copyWith(
        overlayColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.pressed)) {
            return AppColors.primary.withOpacity(0.1);
          }
          return null;
        }),
      ),
      child: _buildContent(),
    );
  }

  Widget _buildTextButton(BuildContext context, Brightness brightness) {
    return TextButton(
      onPressed: _isEnabled ? _handlePress : null,
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
        disabledForegroundColor: brightness == Brightness.light
            ? AppColors.lightTertiaryLabel
            : AppColors.darkTertiaryLabel,
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.spacingM,
          vertical: AppConstants.spacingS,
        ),
        textStyle: const TextStyle(
          fontSize: AppConstants.fontSizeM,
          fontWeight: FontWeight.w500,
          letterSpacing: -0.2,
        ),
      ).copyWith(
        overlayColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.pressed)) {
            return AppColors.primary.withOpacity(0.1);
          }
          return null;
        }),
      ),
      child: _buildContent(),
    );
  }

  Widget _buildGlassButton(BuildContext context, Brightness brightness) {
    final glassColor = AppColors.glassColor(brightness);
    final textColor = AppColors.labelColor(brightness);

    return Container(
      decoration: BoxDecoration(
        color: glassColor,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: brightness == Brightness.light
              ? AppColors.glassBorderLight
              : AppColors.glassBorderDark,
          width: 1,
        ),
        boxShadow: AppColors.cardShadow(brightness),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _isEnabled ? _handlePress : null,
          borderRadius: BorderRadius.circular(borderRadius),
          splashColor: AppColors.primary.withOpacity(0.1),
          highlightColor: AppColors.primary.withOpacity(0.05),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.spacingL,
              vertical: AppConstants.spacingM,
            ),
            child: Center(
              child: DefaultTextStyle(
                style: TextStyle(
                  fontSize: AppConstants.fontSizeL,
                  fontWeight: FontWeight.w600,
                  color: _isEnabled ? textColor : (brightness == Brightness.light
                      ? AppColors.lightTertiaryLabel
                      : AppColors.darkTertiaryLabel),
                  letterSpacing: -0.3,
                ),
                child: _buildContent(textColor),
              ),
            ),
          ),
        ),
      ),
    );
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