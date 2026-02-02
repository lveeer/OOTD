import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/app_constants.dart';
import 'app_button.dart';

/// iOS HIG Liquid Glass 对话框
/// 使用背景模糊、半透明效果、流畅的动画
class GlassDialog extends StatelessWidget {
  final String? title;
  final String? message;
  final Widget? content;
  final List<Widget>? actions;
  final EdgeInsetsGeometry? contentPadding;
  final bool enableHapticFeedback;

  const GlassDialog({
    super.key,
    this.title,
    this.message,
    this.content,
    this.actions,
    this.contentPadding,
    this.enableHapticFeedback = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brightness = theme.brightness;
    final glassColor = AppColors.glassColor(brightness);
    final labelColor = AppColors.labelColor(brightness);
    final secondaryLabelColor = AppColors.secondaryLabelColor(brightness);

    return Dialog(
      elevation: 0,
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
      child: Container(
        decoration: BoxDecoration(
          color: glassColor,
          borderRadius: BorderRadius.circular(14),
          boxShadow: AppColors.elevatedShadow(brightness),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                gradient: brightness == Brightness.light
                    ? AppColors.glassGradientLight
                    : AppColors.glassGradientDark,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (title != null)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
                      child: Text(
                        title!,
                        style: TextStyle(
                          color: labelColor,
                          fontSize: AppConstants.fontSizeL,
                          fontWeight: FontWeight.w600,
                          letterSpacing: -0.3,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  if (message != null)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
                      child: Text(
                        message!,
                        style: TextStyle(
                          color: secondaryLabelColor,
                          fontSize: AppConstants.fontSizeM,
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  if (content != null)
                    Padding(
                      padding: contentPadding ??
                          const EdgeInsets.fromLTRB(24, 8, 24, 20),
                      child: content!,
                    ),
                  if (actions != null && actions!.isNotEmpty)
                    _buildActions(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: AppColors.separatorColor(Theme.of(context).brightness),
            width: 0.5,
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (int i = 0; i < actions!.length; i++) ...[
            if (i > 0)
              Container(
                height: 0.5,
                color: AppColors.separatorColor(Theme.of(context).brightness),
              ),
            InkWell(
              onTap: () {
                if (enableHapticFeedback) {
                  AppTheme.lightImpact();
                }
              },
              child: Container(
                height: 44,
                alignment: Alignment.center,
                child: DefaultTextStyle(
                  style: TextStyle(
                    color: i == actions!.length - 1
                        ? AppColors.primary
                        : AppColors.labelColor(Theme.of(context).brightness),
                    fontSize: AppConstants.fontSizeL,
                    fontWeight: i == actions!.length - 1
                        ? FontWeight.w600
                        : FontWeight.w400,
                    letterSpacing: -0.3,
                  ),
                  child: actions![i],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// 显示确认对话框
  static Future<bool?> showConfirmDialog(
    BuildContext context, {
    String? title,
    required String message,
    String confirmText = '确认',
    String cancelText = '取消',
    bool enableHapticFeedback = true,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => GlassDialog(
        title: title,
        message: message,
        actions: [
          TextButton(
            onPressed: () {
              if (enableHapticFeedback) {
                AppTheme.lightImpact();
              }
              Navigator.of(context).pop(false);
            },
            child: Text(cancelText),
          ),
          TextButton(
            onPressed: () {
              if (enableHapticFeedback) {
                AppTheme.mediumImpact();
              }
              Navigator.of(context).pop(true);
            },
            child: Text(confirmText),
          ),
        ],
      ),
    );
  }

  /// 显示警告对话框
  static Future<void> showWarningDialog(
    BuildContext context, {
    required String title,
    required String message,
    String buttonText = '确定',
    bool enableHapticFeedback = true,
  }) {
    return showDialog<void>(
      context: context,
      builder: (context) => GlassDialog(
        title: title,
        message: message,
        actions: [
          TextButton(
            onPressed: () {
              if (enableHapticFeedback) {
                AppTheme.lightImpact();
              }
              Navigator.of(context).pop();
            },
            child: Text(buttonText),
          ),
        ],
      ),
    );
  }
}

/// iOS HIG Liquid Glass 底部弹窗
/// 使用背景模糊、半透明效果、流畅的滑入动画
class GlassBottomSheet extends StatelessWidget {
  final Widget child;
  final double? height;
  final bool isScrollControlled;
  final bool enableDrag;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;

  const GlassBottomSheet({
    super.key,
    required this.child,
    this.height,
    this.isScrollControlled = true,
    this.enableDrag = true,
    this.padding,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brightness = theme.brightness;
    final glassColor = backgroundColor ?? AppColors.glassColor(brightness);

    return Container(
      decoration: BoxDecoration(
        color: glassColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: AppColors.elevatedShadow(brightness),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              gradient: brightness == Brightness.light
                  ? AppColors.glassGradientLight
                  : AppColors.glassGradientDark,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 拖动指示器
                if (enableDrag)
                  Container(
                    margin: const EdgeInsets.only(top: 12, bottom: 8),
                    width: 36,
                    height: 5,
                    decoration: BoxDecoration(
                      color: AppColors.fillColor(brightness),
                      borderRadius: BorderRadius.circular(2.5),
                    ),
                  ),
                // 内容
                Flexible(
                  child: Padding(
                    padding: padding ?? const EdgeInsets.all(16),
                    child: child,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 显示底部弹窗
  static Future<T?> show<T>({
    required BuildContext context,
    required WidgetBuilder builder,
    double? height,
    bool isScrollControlled = true,
    bool enableDrag = true,
    EdgeInsetsGeometry? padding,
    Color? backgroundColor,
    bool isDismissible = true,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: isScrollControlled,
      enableDrag: enableDrag,
      isDismissible: isDismissible,
      builder: (context) => GlassBottomSheet(
        height: height,
        isScrollControlled: isScrollControlled,
        enableDrag: enableDrag,
        padding: padding,
        backgroundColor: backgroundColor,
        child: Builder(builder: builder),
      ),
    );
  }
}

/// iOS HIG 风格操作菜单（Action Sheet）
class GlassActionSheet extends StatelessWidget {
  final String? title;
  final String? message;
  final List<GlassActionSheetItem> actions;
  final String? cancelText;
  final VoidCallback? onCancel;

  const GlassActionSheet({
    super.key,
    this.title,
    this.message,
    required this.actions,
    this.cancelText,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brightness = theme.brightness;
    final glassColor = AppColors.glassColor(brightness);
    final labelColor = AppColors.labelColor(brightness);
    const borderRadius = 14.0;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: glassColor,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: AppColors.elevatedShadow(brightness),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius),
              gradient: brightness == Brightness.light
                  ? AppColors.glassGradientLight
                  : AppColors.glassGradientDark,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (title != null || message != null)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Column(
                      children: [
                        if (title != null)
                          Text(
                            title!,
                            style: TextStyle(
                              color: labelColor,
                              fontSize: AppConstants.fontSizeL,
                              fontWeight: FontWeight.w600,
                              letterSpacing: -0.3,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        if (message != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              message!,
                              style: TextStyle(
                                color: AppColors.secondaryLabelColor(brightness),
                                fontSize: AppConstants.fontSizeM,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                      ],
                    ),
                  ),
                ...actions.asMap().entries.map((entry) {
                  final index = entry.key;
                  final action = entry.value;
                  final isLast = index == actions.length - 1;

                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (index > 0)
                        Container(
                          height: 0.5,
                          margin: const EdgeInsets.only(left: 16),
                          color: AppColors.separatorColor(brightness),
                        ),
                      InkWell(
                        onTap: () {
                          AppTheme.lightImpact();
                          Navigator.of(context).pop();
                          action.onTap();
                        },
                        child: Container(
                          height: 56,
                          alignment: Alignment.center,
                          child: Text(
                            action.title,
                            style: TextStyle(
                              color: action.isDestructive
                                  ? AppColors.error
                                  : (action.isDefault
                                      ? AppColors.primary
                                      : labelColor),
                              fontSize: AppConstants.fontSizeL,
                              fontWeight:
                                  action.isDefault ? FontWeight.w600 : FontWeight.w400,
                              letterSpacing: -0.3,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 显示操作菜单
  static Future<void> show({
    required BuildContext context,
    String? title,
    String? message,
    required List<GlassActionSheetItem> actions,
    String? cancelText,
    VoidCallback? onCancel,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GlassActionSheet(
              title: title,
              message: message,
              actions: actions,
              cancelText: cancelText,
              onCancel: onCancel,
            ),
            if (cancelText != null || onCancel != null)
              Padding(
                padding: const EdgeInsets.all(8),
                child: _CancelButton(
                  text: cancelText ?? '取消',
                  onTap: () {
                    AppTheme.lightImpact();
                    Navigator.of(context).pop();
                    onCancel?.call();
                  },
                ),
              ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

/// 操作菜单项
class GlassActionSheetItem {
  final String title;
  final VoidCallback onTap;
  final bool isDestructive;
  final bool isDefault;

  const GlassActionSheetItem({
    required this.title,
    required this.onTap,
    this.isDestructive = false,
    this.isDefault = false,
  });
}

/// 取消按钮
class _CancelButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const _CancelButton({
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brightness = theme.brightness;
    final glassColor = AppColors.glassColor(brightness);
    final labelColor = AppColors.labelColor(brightness);
    const borderRadius = 14.0;

    return Container(
      decoration: BoxDecoration(
        color: glassColor,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: AppColors.elevatedShadow(brightness),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius),
              gradient: brightness == Brightness.light
                  ? AppColors.glassGradientLight
                  : AppColors.glassGradientDark,
            ),
            child: InkWell(
              onTap: onTap,
              child: Container(
                height: 56,
                alignment: Alignment.center,
                child: Text(
                  text,
                  style: TextStyle(
                    color: labelColor,
                    fontSize: AppConstants.fontSizeL,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.3,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}