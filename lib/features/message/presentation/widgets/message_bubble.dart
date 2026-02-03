import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/models/message.dart';
import '../../domain/entities/message_entity.dart';

class MessageBubble extends StatelessWidget {
  final MessageEntity message;
  final bool isCurrentUser;
  final VoidCallback? onImageTap;

  const MessageBubble({
    super.key,
    required this.message,
    required this.isCurrentUser,
    this.onImageTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brightness = theme.brightness;
    final secondaryLabelColor = AppColors.secondaryLabelColor(brightness);

    return Align(
      alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(
          left: isCurrentUser ? 60 : 12,
          right: isCurrentUser ? 12 : 60,
          top: 4,
          bottom: 4,
        ),
        child: Column(
          crossAxisAlignment: isCurrentUser
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            // 消息内容
            _buildMessageContent(context, brightness),
            const SizedBox(height: 4),
            // 时间和已读状态
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _formatTime(message.createdAt),
                  style: TextStyle(
                    fontSize: AppConstants.fontSizeXS,
                    color: secondaryLabelColor,
                  ),
                ),
                if (isCurrentUser) ...[
                  const SizedBox(width: 4),
                  Icon(
                    message.isRead
                        ? PhosphorIcons.checks()
                        : PhosphorIcons.check(),
                    size: 14,
                    color: secondaryLabelColor,
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageContent(BuildContext context, Brightness brightness) {
    switch (message.type) {
      case MessageType.text:
        return _buildTextBubble(context, brightness);
      case MessageType.image:
        return _buildImageBubble(context, brightness);
      case MessageType.system:
        return _buildSystemMessage(context, brightness);
    }
  }

  Widget _buildTextBubble(BuildContext context, Brightness brightness) {
    final labelColor = AppColors.labelColor(brightness);
    final backgroundColor = isCurrentUser
        ? AppColors.accent
        : AppColors.fillColor(brightness);
    final textColor = isCurrentUser ? Colors.white : labelColor;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      constraints: const BoxConstraints(
        maxWidth: 280,
      ),
      child: Text(
        message.content,
        style: TextStyle(
          fontSize: AppConstants.fontSizeM,
          color: textColor,
          height: 1.4,
        ),
      ),
    );
  }

  Widget _buildImageBubble(BuildContext context, Brightness brightness) {
    return GestureDetector(
      onTap: onImageTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: message.content.startsWith('http')
              ? CachedNetworkImage(
                  imageUrl: message.content,
                  width: 200,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    width: 200,
                    height: 200,
                    color: AppColors.fillColor(brightness),
                    child: const Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.accent,
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    width: 200,
                    height: 200,
                    color: AppColors.fillColor(brightness),
                    child: Icon(
                      PhosphorIcons.imageBroken(),
                      size: 40,
                      color: AppColors.tertiaryLabelColor(brightness),
                    ),
                  ),
                )
              : Image.asset(
                  message.content,
                  width: 200,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 200,
                    height: 200,
                    color: AppColors.fillColor(brightness),
                    child: Icon(
                      PhosphorIcons.imageBroken(),
                      size: 40,
                      color: AppColors.tertiaryLabelColor(brightness),
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildSystemMessage(BuildContext context, Brightness brightness) {
    final tertiaryLabelColor = AppColors.tertiaryLabelColor(brightness);

    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 6,
        ),
        decoration: BoxDecoration(
          color: AppColors.fillColor(brightness),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          message.content,
          style: TextStyle(
            fontSize: AppConstants.fontSizeS,
            color: tertiaryLabelColor,
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final isToday = dateTime.year == now.year &&
        dateTime.month == now.month &&
        dateTime.day == now.day;

    if (isToday) {
      return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    } else {
      return '${dateTime.month}/${dateTime.day} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    }
  }
}