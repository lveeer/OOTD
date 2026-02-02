import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/models/message.dart';
import '../../domain/entities/message_entity.dart';

class NotificationItem extends StatelessWidget {
  final NotificationEntity notification;
  final VoidCallback onTap;

  const NotificationItem({
    super.key,
    required this.notification,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brightness = theme.brightness;
    final labelColor = AppColors.labelColor(brightness);
    final secondaryLabelColor = AppColors.secondaryLabelColor(brightness);
    final tertiaryLabelColor = AppColors.tertiaryLabelColor(brightness);

    return InkWell(
      onTap: () {
        AppTheme.mediumImpact();
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.spacingM,
          vertical: AppConstants.spacingS,
        ),
        color: notification.isRead
            ? Colors.transparent
            : AppColors.fillColor(brightness),
        child: Row(
          children: [
            // 图标/头像
            _buildIcon(context, brightness),
            const SizedBox(width: AppConstants.spacingM),
            // 内容
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // 标题
                      Expanded(
                        child: Text(
                          notification.title,
                          style: TextStyle(
                            fontSize: AppConstants.fontSizeM,
                            fontWeight: notification.isRead
                                ? FontWeight.w500
                                : FontWeight.w600,
                            color: labelColor,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      // 时间
                      Text(
                        _formatTime(notification.createdAt),
                        style: TextStyle(
                          fontSize: AppConstants.fontSizeS,
                          color: tertiaryLabelColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  // 内容
                  Text(
                    notification.content,
                    style: TextStyle(
                      fontSize: AppConstants.fontSizeS,
                      color: notification.isRead
                          ? secondaryLabelColor
                          : labelColor,
                      ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            // 未读标记
            if (!notification.isRead) ...[
              const SizedBox(width: 8),
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppColors.accent,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildIcon(BuildContext context, Brightness brightness) {
    final avatarUrl = notification.actorAvatar;

    switch (notification.type) {
      case NotificationType.like:
      case NotificationType.comment:
      case NotificationType.follow:
        // 显示用户头像
        return Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: AppColors.fillColor(brightness),
            shape: BoxShape.circle,
          ),
          child: ClipOval(
            child: avatarUrl != null
                ? CachedNetworkImage(
                    imageUrl: avatarUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Icon(
                      PhosphorIcons.user(),
                      size: 28,
                      color: AppColors.tertiaryLabelColor(brightness),
                    ),
                    errorWidget: (context, url, error) => Icon(
                      PhosphorIcons.user(),
                      size: 28,
                      color: AppColors.tertiaryLabelColor(brightness),
                    ),
                  )
                : Icon(
                    PhosphorIcons.user(),
                    size: 28,
                    color: AppColors.tertiaryLabelColor(brightness),
                  ),
          ),
        );
      case NotificationType.commission:
        // 佣金图标
        return Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: AppColors.accent.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            PhosphorIcons.currencyCny(),
            size: 28,
            color: AppColors.accent,
          ),
        );
      case NotificationType.system:
        // 系统图标
        return Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: AppColors.fillColor(brightness),
            shape: BoxShape.circle,
          ),
          child: Icon(
            PhosphorIcons.bell(),
            size: 28,
            color: AppColors.tertiaryLabelColor(brightness),
          ),
        );
    }
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return '刚刚';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}分钟前';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}小时前';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}天前';
    } else {
      return '${dateTime.month}月${dateTime.day}日';
    }
  }
}