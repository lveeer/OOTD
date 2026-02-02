import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/app_constants.dart';

/// 极简白灰风格底部导航栏项
class GlassBottomNavItem {
  final IconData icon;
  final IconData? activeIcon;
  final String label;

  const GlassBottomNavItem({
    required this.icon,
    this.activeIcon,
    required this.label,
  });
}

/// 极简白灰风格底部导航栏
/// 扁平设计，无模糊，线性图标，选中变实心黑
class GlassBottomNavBar extends StatelessWidget {
  final List<GlassBottomNavItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;
  final bool enableHapticFeedback;

  const GlassBottomNavBar({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
    this.enableHapticFeedback = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brightness = theme.brightness;
    final glassColor = AppColors.glassColor(brightness);
    final borderColor = brightness == Brightness.light
        ? AppColors.glassBorderLight
        : AppColors.glassBorderDark;

    return Container(
      decoration: BoxDecoration(
        color: glassColor,
        border: Border(
          top: BorderSide(
            color: borderColor,
            width: 0.5,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Container(
          height: 56 + MediaQuery.of(context).padding.bottom,
          child: Row(
            children: items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isSelected = index == currentIndex;

              return Expanded(
                child: _NavItem(
                  item: item,
                  isSelected: isSelected,
                  onTap: () => _handleTap(index),
                  enableHapticFeedback: enableHapticFeedback,
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  void _handleTap(int index) {
    if (index != currentIndex) {
      if (enableHapticFeedback) {
        AppTheme.selectionClick();
      }
      onTap(index);
    }
  }
}

/// 底部导航栏单个项
class _NavItem extends StatelessWidget {
  final GlassBottomNavItem item;
  final bool isSelected;
  final VoidCallback onTap;
  final bool enableHapticFeedback;

  const _NavItem({
    required this.item,
    required this.isSelected,
    required this.onTap,
    required this.enableHapticFeedback,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brightness = theme.brightness;
    final selectedColor = AppColors.labelColor(brightness); // 黑色/白色
    final unselectedColor = AppColors.tertiaryLabelColor(brightness); // 灰色

    return InkWell(
      onTap: onTap,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 图标（线性，选中变实心）
          AnimatedContainer(
            duration: AppTheme.normalAnimation,
            curve: Curves.easeInOut,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Icon(
              isSelected && item.activeIcon != null
                  ? item.activeIcon!
                  : item.icon,
              size: 24,
              color: isSelected ? selectedColor : unselectedColor,
              // 线性图标：未选中空心，选中实心
              fill: isSelected ? 1.0 : 0.0,
            ),
          ),
          // 标签
          AnimatedDefaultTextStyle(
            duration: AppTheme.normalAnimation,
            curve: Curves.easeInOut,
            style: TextStyle(
              fontSize: AppConstants.fontSizeXS,
              fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
              color: isSelected ? selectedColor : unselectedColor,
              letterSpacing: isSelected ? -0.2 : 0,
            ),
            child: Text(item.label),
          ),
        ],
      ),
    );
  }
}

/// iOS HIG 风格浮动操作按钮（FAB）
/// 使用 Liquid Glass 材质效果
class GlassFloatingActionButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final String? tooltip;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? elevation;
  final bool enableHapticFeedback;

  const GlassFloatingActionButton({
    super.key,
    required this.child,
    this.onPressed,
    this.tooltip,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation,
    this.enableHapticFeedback = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brightness = theme.brightness;
    final bgColor = backgroundColor ?? AppColors.accent; // 黑色
    final fgColor = foregroundColor ?? Colors.white;

    Widget fab = Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: elevation != null
            ? (brightness == Brightness.light
                ? AppColors.lightElevatedShadow
                : AppColors.darkElevatedShadow)
            : AppColors.cardShadow(brightness),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withOpacity(0.2),
                  Colors.transparent,
                  Colors.white.withOpacity(0.1),
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
            child: IconTheme(
              data: IconThemeData(
                color: fgColor,
                size: 24,
              ),
              child: child,
            ),
          ),
        ),
      ),
    );

    if (onPressed != null) {
      fab = Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            if (enableHapticFeedback) {
              AppTheme.mediumImpact();
            }
            onPressed?.call();
          },
          borderRadius: BorderRadius.circular(16),
          splashColor: fgColor.withOpacity(0.2),
          highlightColor: fgColor.withOpacity(0.1),
          child: fab,
        ),
      );
    }

    if (tooltip != null) {
      fab = Tooltip(
        message: tooltip!,
        child: fab,
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: fab,
    );
  }
}