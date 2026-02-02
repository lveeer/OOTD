import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../core/theme/app_colors.dart';

class EmptyWidget extends StatelessWidget {
  final String? message;
  final String? subtitle;
  final VoidCallback? onRefresh;
  final IconData? icon;

  const EmptyWidget({
    super.key,
    this.message,
    this.subtitle,
    this.onRefresh,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon is IconData ? icon : PhosphorIcons.tray(),
              size: 64,
              color: AppColors.grey400,
            ),
            const SizedBox(height: 16),
            Text(
              message ?? '暂无数据',
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.grey600,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              Text(
                subtitle!,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.grey400,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (onRefresh != null) ...[
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: onRefresh,
                icon: Icon(PhosphorIcons.arrowClockwise()),
                label: const Text('刷新'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class ErrorWidget extends StatelessWidget {
  final String? message;
  final VoidCallback? onRetry;

  const ErrorWidget({
    super.key,
    this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              PhosphorIcons.warningCircle(),
              size: 64,
              color: AppColors.error,
            ),
            const SizedBox(height: 16),
            Text(
              message ?? '出错了',
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.grey600,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: Icon(PhosphorIcons.arrowClockwise()),
                label: const Text('重试'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}