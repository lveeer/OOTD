import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

enum AppButtonType {
  primary,
  secondary,
  outline,
  text,
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
    this.borderRadius = 8.0,
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
    switch (type) {
      case AppButtonType.primary:
        return ElevatedButton(
          onPressed: _isEnabled ? onPressed : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            disabledBackgroundColor: AppColors.grey300,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
          ),
          child: _buildContent(),
        );

      case AppButtonType.secondary:
        return ElevatedButton(
          onPressed: _isEnabled ? onPressed : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.secondary,
            foregroundColor: Colors.white,
            disabledBackgroundColor: AppColors.grey300,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
          ),
          child: _buildContent(),
        );

      case AppButtonType.outline:
        return OutlinedButton(
          onPressed: _isEnabled ? onPressed : null,
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primary,
            side: BorderSide(
              color: _isEnabled ? AppColors.primary : AppColors.grey300,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
          ),
          child: _buildContent(),
        );

      case AppButtonType.text:
        return TextButton(
          onPressed: _isEnabled ? onPressed : null,
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primary,
            disabledForegroundColor: AppColors.grey400,
          ),
          child: _buildContent(),
        );
    }
  }

  Widget _buildContent() {
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
          icon!,
          const SizedBox(width: 8),
          Text(text),
        ],
      );
    }

    return Text(text);
  }
}