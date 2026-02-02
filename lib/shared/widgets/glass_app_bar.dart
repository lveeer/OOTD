import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/app_constants.dart';

/// iOS HIG Liquid Glass 应用栏
/// 使用背景模糊、半透明效果、支持大标题模式
class GlassAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? titleWidget;
  final List<Widget>? actions;
  final Widget? leading;
  final bool automaticallyImplyLeading;
  final bool centerTitle;
  final bool largeTitle;
  final PreferredSizeWidget? bottom;
  final double? elevation;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final VoidCallback? onLeadingTap;
  final bool enableHapticFeedback;

  const GlassAppBar({
    super.key,
    this.title,
    this.titleWidget,
    this.actions,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.centerTitle = true,
    this.largeTitle = false,
    this.bottom,
    this.elevation,
    this.backgroundColor,
    this.foregroundColor,
    this.onLeadingTap,
    this.enableHapticFeedback = true,
  });

  @override
  Size get preferredSize {
    double height = largeTitle ? 96 : 56;
    if (bottom != null) {
      height += bottom!.preferredSize.height;
    }
    return Size.fromHeight(height);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brightness = theme.brightness;
    final glassColor = backgroundColor ?? AppColors.glassColor(brightness);
    final fgColor = foregroundColor ?? AppColors.labelColor(brightness);
    final borderColor = brightness == Brightness.light
        ? AppColors.glassBorderLight
        : AppColors.glassBorderDark;

    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: borderColor,
            width: 0.5,
          ),
        ),
        boxShadow: elevation != null && elevation! > 0
            ? (brightness == Brightness.light
                ? AppColors.lightElevatedShadow
                : AppColors.darkElevatedShadow)
            : null,
      ),
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            decoration: BoxDecoration(
              color: glassColor,
              gradient: brightness == Brightness.light
                  ? AppColors.glassGradientLight
                  : AppColors.glassGradientDark,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 主应用栏
                _buildAppBar(context, fgColor),
                // 底部组件（如 TabBar）
                if (bottom != null) bottom!,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, Color fgColor) {
    final theme = Theme.of(context);
    final hasBack = Navigator.of(context).canPop();

    return SafeArea(
      bottom: false,
      child: Container(
        height: largeTitle ? 96 : 56,
        padding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: largeTitle ? 12 : 8,
        ),
        child: Row(
          children: [
            // 左侧按钮
            if (leading != null)
              leading!
            else if (automaticallyImplyLeading && hasBack)
              _buildBackButton(fgColor),
            // 标题
            Expanded(
              child: titleWidget ??
                  (title != null
                      ? Text(
                          title!,
                          style: TextStyle(
                            color: fgColor,
                            fontSize: largeTitle
                                ? AppConstants.fontSizeXXL
                                : AppConstants.fontSizeL,
                            fontWeight: FontWeight.w600,
                            letterSpacing: largeTitle ? -0.8 : -0.3,
                          ),
                          textAlign: centerTitle ? TextAlign.center : TextAlign.start,
                        )
                      : null),
            ),
            // 右侧操作按钮
            if (actions != null) ...[
              const SizedBox(width: 8),
              ...actions!,
            ] else
              const SizedBox(width: 48), // 平衡布局
          ],
        ),
      ),
    );
  }

  Widget _buildBackButton(Color fgColor) {
    return IconButton(
      icon: const Icon(Icons.arrow_back_ios_rounded, size: 20),
      color: fgColor,
      onPressed: () {
        if (enableHapticFeedback) {
          AppTheme.lightImpact();
        }
        if (onLeadingTap != null) {
          onLeadingTap!();
        } else {
          Navigator.of(context).pop();
        }
      },
      splashColor: fgColor.withOpacity(0.1),
      highlightColor: fgColor.withOpacity(0.05),
      padding: const EdgeInsets.all(8),
      constraints: const BoxConstraints(
        minWidth: 48,
        minHeight: 48,
      ),
    );
  }
}

/// iOS HIG 风格大标题应用栏
/// 用于页面顶部的大标题展示
class GlassLargeTitleAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget? titleWidget;
  final List<Widget>? actions;
  final Widget? leading;
  final bool automaticallyImplyLeading;
  final PreferredSizeWidget? bottom;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final VoidCallback? onLeadingTap;

  const GlassLargeTitleAppBar({
    super.key,
    required this.title,
    this.titleWidget,
    this.actions,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.bottom,
    this.backgroundColor,
    this.foregroundColor,
    this.onLeadingTap,
  });

  @override
  Size get preferredSize {
    double height = 96;
    if (bottom != null) {
      height += bottom!.preferredSize.height;
    }
    return Size.fromHeight(height);
  }

  @override
  Widget build(BuildContext context) {
    return GlassAppBar(
      title: title,
      titleWidget: titleWidget,
      actions: actions,
      leading: leading,
      automaticallyImplyLeading: automaticallyImplyLeading,
      largeTitle: true,
      bottom: bottom,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      onLeadingTap: onLeadingTap,
    );
  }
}

/// iOS HIG 风格透明应用栏
/// 用于需要完全透明的场景（如图片详情页）
class GlassTransparentAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? titleWidget;
  final List<Widget>? actions;
  final Widget? leading;
  final bool automaticallyImplyLeading;
  final bool centerTitle;
  final Color? foregroundColor;
  final VoidCallback? onLeadingTap;

  const GlassTransparentAppBar({
    super.key,
    this.title,
    this.titleWidget,
    this.actions,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.centerTitle = true,
    this.foregroundColor,
    this.onLeadingTap,
  });

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fgColor = foregroundColor ??
        (theme.brightness == Brightness.light ? Colors.black87 : Colors.white);

    return AppBar(
      title: titleWidget ??
          (title != null
              ? Text(
                  title!,
                  style: TextStyle(
                    color: fgColor,
                    fontSize: AppConstants.fontSizeL,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.3,
                  ),
                )
              : null),
      centerTitle: centerTitle,
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: leading ??
          (automaticallyImplyLeading && Navigator.of(context).canPop()
              ? _buildBackButton(fgColor)
              : null),
      actions: actions,
      iconTheme: IconThemeData(color: fgColor),
      systemOverlayStyle: theme.brightness == Brightness.light
          ? SystemUiOverlayStyle.dark
          : SystemUiOverlayStyle.light,
    );
  }

  Widget _buildBackButton(Color fgColor) {
    return IconButton(
      icon: const Icon(Icons.arrow_back_ios_rounded, size: 20),
      color: fgColor,
      onPressed: () {
        AppTheme.lightImpact();
        if (onLeadingTap != null) {
          onLeadingTap!();
        } else {
          Navigator.of(context).pop();
        }
      },
      splashColor: fgColor.withOpacity(0.1),
      highlightColor: fgColor.withOpacity(0.05),
    );
  }
}