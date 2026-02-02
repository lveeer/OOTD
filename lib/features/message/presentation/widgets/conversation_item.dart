import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/message_entity.dart';

class ConversationItem extends StatelessWidget {
  final ConversationEntity conversation;
  final VoidCallback onTap;

  const ConversationItem({
    super.key,
    required this.conversation,
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
        child: Row(
          children: [
            // 头像
            _buildAvatar(context, brightness),
            const SizedBox(width: AppConstants.spacingM),
            // 内容
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // 用户名
                      Expanded(
                        child: Text(
                          conversation.otherUserName,
                          style: TextStyle(
                            fontSize: AppConstants.fontSizeM,
                            fontWeight: conversation.unreadCount > 0
                                ? FontWeight.w600
                                : FontWeight.w500,
                            color: labelColor,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      // 时间
                      Text(
                        _formatTime(conversation.updatedAt),
                        style: TextStyle(
                          fontSize: AppConstants.fontSizeS,
                          color: tertiaryLabelColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      // 最后一条消息
                      Expanded(
                        child: Text(
                          conversation.lastMessage?.content ?? '',
                          style: TextStyle(
                            fontSize: AppConstants.fontSizeS,
                            color: conversation.unreadCount > 0
                                ? labelColor
                                : secondaryLabelColor,
                            fontWeight: conversation.unreadCount > 0
                                ? FontWeight.w500
                                : FontWeight.w400,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      // 未读数量
                      if (conversation.unreadCount > 0) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.accent,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 18,
                            minHeight: 18,
                          ),
                          child: Text(
                            conversation.unreadCount > 99
                                ? '99+'
                                : conversation.unreadCount.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar(BuildContext context, Brightness brightness) {
    final avatarUrl = conversation.otherUserAvatar;

    return Stack(
      children: [
        Container(
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
                    placeholder: (context, url) => Container(
                      color: AppColors.fillColor(brightness),
                      child: Icon(
                        PhosphorIcons.user(),
                        size: 28,
                        color: AppColors.tertiaryLabelColor(brightness),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: AppColors.fillColor(brightness),
                      child: Icon(
                        PhosphorIcons.user(),
                        size: 28,
                        color: AppColors.tertiaryLabelColor(brightness),
                      ),
                    ),
                  )
                : Icon(
                    PhosphorIcons.user(),
                    size: 28,
                    color: AppColors.tertiaryLabelColor(brightness),
                  ),
          ),
        ),
        // 在线状态指示器（可选）
        // Positioned(
        //   right: 0,
        //   bottom: 0,
        //   child: Container(
        //     width: 14,
        //     height: 14,
        //     decoration: BoxDecoration(
        //       color: Colors.green,
        //       shape: BoxShape.circle,
        //       border: Border.all(
        //         color: brightness == Brightness.light
        //             ? Colors.white
        //             : Colors.black,
        //         width: 2,
        //       ),
        //     ),
        //   ),
        // ),
      ],
    );
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