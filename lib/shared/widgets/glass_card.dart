import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/app_constants.dart';

/// 极简白灰风格卡片组件
/// 扁平设计，无阴影，纯色背景，4-8px 圆角
class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final double borderRadius;
  final VoidCallback? onTap;
  final bool enableHapticFeedback;
  final Color? color;
  final double? elevation;
  final Border? border;

  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.margin = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    this.borderRadius = AppTheme.cardRadius,
    this.onTap,
    this.enableHapticFeedback = true,
    this.color,
    this.elevation,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brightness = theme.brightness;
    final cardColor = color ?? AppColors.glassColor(brightness);

    final card = Container(
      margin: margin,
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(borderRadius),
        border: border ??
            Border.all(
              color: brightness == Brightness.light
                  ? AppColors.glassBorderLight
                  : AppColors.glassBorderDark,
              width: 0.5,
            ),
        // 移除阴影，保持扁平
        boxShadow: [],
      ),
      padding: padding,
      child: child,
    );

    if (onTap != null) {
      return InkWell(
        onTap: () {
          if (enableHapticFeedback) {
            AppTheme.lightImpact();
          }
          onTap?.call();
        },
        borderRadius: BorderRadius.circular(borderRadius),
        splashColor: AppColors.lightLabel.withOpacity(0.05), // 使用黑色而非品牌色
        highlightColor: AppColors.lightLabel.withOpacity(0.02),
        child: card,
      );
    }

    return card;
  }
}

/// iOS HIG 风格列表项组件
/// 用于列表中的可点击项
class GlassListTile extends StatelessWidget {
  final Widget? leading;
  final Widget? title;
  final Widget? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool enableHapticFeedback;
  final EdgeInsetsGeometry? contentPadding;

  const GlassListTile({
    super.key,
    this.leading,
    this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.enableHapticFeedback = true,
    this.contentPadding,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brightness = theme.brightness;
    final labelColor = AppColors.labelColor(brightness);
    final secondaryLabelColor = AppColors.secondaryLabelColor(brightness);

    return GlassCard(
      padding: contentPadding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      borderRadius: AppTheme.buttonRadius,
      onTap: onTap,
      enableHapticFeedback: enableHapticFeedback,
      child: Row(
        children: [
          if (leading != null) ...[
            leading!,
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (title != null)
                  DefaultTextStyle(
                    style: TextStyle(
                      color: labelColor,
                      fontSize: AppConstants.fontSizeM,
                      fontWeight: FontWeight.w500,
                      letterSpacing: -0.2,
                    ),
                    child: title!,
                  ),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  DefaultTextStyle(
                    style: TextStyle(
                      color: secondaryLabelColor,
                      fontSize: AppConstants.fontSizeS,
                      height: 1.4,
                    ),
                    child: subtitle!,
                  ),
                ],
              ],
            ),
          ),
          if (trailing != null) ...[
            const SizedBox(width: 8),
            trailing!,
          ],
        ],
      ),
    );
  }
}

/// iOS HIG 风格分割线
class GlassDivider extends StatelessWidget {
  final double height;
  final double thickness;
  final Color? color;
  final EdgeInsetsGeometry? indent;

  const GlassDivider({
    super.key,
    this.height = 1,
    this.thickness = 0.5,
    this.color,
    this.indent,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brightness = theme.brightness;
    final dividerColor = color ?? AppColors.separatorColor(brightness);

    return Container(
      height: height,
      margin: indent,
      color: dividerColor.withOpacity(0.5),
      child: Center(
        child: Container(
          height: thickness,
          color: dividerColor,
        ),
      ),
    );
  }
}

/// iOS HIG 风格分组标题
class GlassSectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? action;
  final EdgeInsetsGeometry padding;

  const GlassSectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.action,
    this.padding = const EdgeInsets.fromLTRB(16, 24, 16, 8),
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brightness = theme.brightness;
    final labelColor = AppColors.labelColor(brightness);
    final secondaryLabelColor = AppColors.secondaryLabelColor(brightness);

    return Padding(
      padding: padding,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: labelColor,
                    fontSize: AppConstants.fontSizeL,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.3,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle!,
                    style: TextStyle(
                      color: secondaryLabelColor,
                      fontSize: AppConstants.fontSizeS,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (action != null) action!,
        ],
      ),
    );
  }
}