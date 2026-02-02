import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/app_constants.dart';
import 'app_button.dart';

/// iOS HIG 风格空状态组件
/// 改进视觉设计、添加 Liquid Glass 材质效果、改进动画和交互反馈
class EmptyWidget extends StatelessWidget {
  final String? message;
  final String? subtitle;
  final VoidCallback? onRefresh;
  final IconData? icon;
  final String? actionText;

  const EmptyWidget({
    super.key,
    this.message,
    this.subtitle,
    this.onRefresh,
    this.icon,
    this.actionText,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brightness = theme.brightness;
    final labelColor = AppColors.labelColor(brightness);
    final secondaryLabelColor = AppColors.secondaryLabelColor(brightness);
    final tertiaryLabelColor = AppColors.tertiaryLabelColor(brightness);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 图标容器，使用 Liquid Glass 效果
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.fillColor(brightness),
                shape: BoxShape.circle,
                boxShadow: AppColors.cardShadow(brightness),
              ),
              child: Icon(
                icon ?? PhosphorIcons.tray(),
                size: 40,
                color: tertiaryLabelColor,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              message ?? '暂无数据',
              style: TextStyle(
                fontSize: AppConstants.fontSizeL,
                color: labelColor,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.3,
              ),
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              Text(
                subtitle!,
                style: TextStyle(
                  fontSize: AppConstants.fontSizeM,
                  color: secondaryLabelColor,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (onRefresh != null) ...[
              const SizedBox(height: 24),
              AppButton(
                text: actionText ?? '刷新',
                onPressed: onRefresh,
                type: AppButtonType.outline,
                icon: Icon(PhosphorIcons.arrowClockwise(), size: 18),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// iOS HIG 风格错误状态组件
/// 提供友好的错误提示和重试选项
class ErrorWidget extends StatelessWidget {
  final String? message;
  final String? subtitle;
  final VoidCallback? onRetry;
  final String? actionText;

  const ErrorWidget({
    super.key,
    this.message,
    this.subtitle,
    this.onRetry,
    this.actionText,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brightness = theme.brightness;
    final labelColor = AppColors.labelColor(brightness);
    final secondaryLabelColor = AppColors.secondaryLabelColor(brightness);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 错误图标容器，使用 Liquid Glass 效果
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.1),
                shape: BoxShape.circle,
                boxShadow: AppColors.cardShadow(brightness),
              ),
              child: Icon(
                PhosphorIcons.warningCircle(),
                size: 40,
                color: AppColors.error,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              message ?? '出错了',
              style: TextStyle(
                fontSize: AppConstants.fontSizeL,
                color: labelColor,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.3,
              ),
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              Text(
                subtitle!,
                style: TextStyle(
                  fontSize: AppConstants.fontSizeM,
                  color: secondaryLabelColor,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              AppButton(
                text: actionText ?? '重试',
                onPressed: onRetry,
                type: AppButtonType.primary,
                icon: Icon(PhosphorIcons.arrowClockwise(), size: 18),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// iOS HIG 风格网络错误组件
/// 专门用于网络连接失败的提示
class NetworkErrorWidget extends StatelessWidget {
  final String? message;
  final VoidCallback? onRetry;

  const NetworkErrorWidget({
    super.key,
    this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brightness = theme.brightness;
    final labelColor = AppColors.labelColor(brightness);
    final secondaryLabelColor = AppColors.secondaryLabelColor(brightness);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.warning.withOpacity(0.1),
                shape: BoxShape.circle,
                boxShadow: AppColors.cardShadow(brightness),
              ),
              child: Icon(
                PhosphorIcons.wifiSlash(),
                size: 40,
                color: AppColors.warning,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              message ?? '网络连接失败',
              style: TextStyle(
                fontSize: AppConstants.fontSizeL,
                color: labelColor,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.3,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              '请检查网络设置后重试',
              style: TextStyle(
                fontSize: AppConstants.fontSizeM,
                color: secondaryLabelColor,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              AppButton(
                text: '重试',
                onPressed: onRetry,
                type: AppButtonType.primary,
                icon: Icon(PhosphorIcons.arrowClockwise(), size: 18),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// iOS HIG 风格搜索无结果组件
/// 专门用于搜索无结果的提示
class SearchEmptyWidget extends StatelessWidget {
  final String? query;
  final VoidCallback? onClear;

  const SearchEmptyWidget({
    super.key,
    this.query,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brightness = theme.brightness;
    final labelColor = AppColors.labelColor(brightness);
    final secondaryLabelColor = AppColors.secondaryLabelColor(brightness);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.fillColor(brightness),
                shape: BoxShape.circle,
                boxShadow: AppColors.cardShadow(brightness),
              ),
              child: Icon(
                PhosphorIcons.magnifyingGlass(),
                size: 40,
                color: AppColors.tertiaryLabelColor(brightness),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              '未找到相关内容',
              style: TextStyle(
                fontSize: AppConstants.fontSizeL,
                color: labelColor,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.3,
              ),
              textAlign: TextAlign.center,
            ),
            if (query != null && query!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                '没有找到"$query"相关的内容',
                style: TextStyle(
                  fontSize: AppConstants.fontSizeM,
                  color: secondaryLabelColor,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (onClear != null) ...[
              const SizedBox(height: 24),
              AppButton(
                text: '清除搜索',
                onPressed: onClear,
                type: AppButtonType.text,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// iOS HIG 风格权限请求组件
/// 用于引导用户开启必要权限
class PermissionRequestWidget extends StatelessWidget {
  final String title;
  final String description;
  final String buttonText;
  final VoidCallback onRequest;

  const PermissionRequestWidget({
    super.key,
    required this.title,
    required this.description,
    required this.buttonText,
    required this.onRequest,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brightness = theme.brightness;
    final labelColor = AppColors.labelColor(brightness);
    final secondaryLabelColor = AppColors.secondaryLabelColor(brightness);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
                boxShadow: AppColors.cardShadow(brightness),
              ),
              child: Icon(
                PhosphorIcons.shieldCheck(),
                size: 40,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: TextStyle(
                fontSize: AppConstants.fontSizeL,
                color: labelColor,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.3,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: TextStyle(
                fontSize: AppConstants.fontSizeM,
                color: secondaryLabelColor,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            AppButton(
              text: buttonText,
              onPressed: onRequest,
              type: AppButtonType.primary,
            ),
          ],
        ),
      ),
    );
  }
}