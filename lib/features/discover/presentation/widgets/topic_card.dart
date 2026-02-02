import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/topic_entity.dart';

class TopicCard extends StatelessWidget {
  final TopicEntity topic;
  final bool isFollowed;
  final VoidCallback onTap;
  final VoidCallback onFollowToggle;

  const TopicCard({
    super.key,
    required this.topic,
    required this.isFollowed,
    required this.onTap,
    required this.onFollowToggle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brightness = theme.brightness;
    final labelColor = AppColors.labelColor(brightness);
    final secondaryLabelColor = AppColors.secondaryLabelColor(brightness);
    final fillColor = AppColors.fillColor(brightness);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppConstants.radiusM),
      child: Container(
        decoration: BoxDecoration(
          color: fillColor,
          borderRadius: BorderRadius.circular(AppConstants.radiusM),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (topic.coverImage != null)
                    ClipRRect(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(AppConstants.radiusM),
                      ),
                      child: Image.network(
                        topic.coverImage!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: AppColors.secondaryBackgroundColor(brightness),
                          );
                        },
                      ),
                    )
                  else
                    Container(
                      color: AppColors.secondaryBackgroundColor(brightness),
                    ),
                  if (topic.isHot)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.accent,
                          borderRadius: BorderRadius.circular(AppConstants.radiusS),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              PhosphorIcons.fire(),
                              color: AppColors.white,
                              size: 12,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '热门',
                              style: TextStyle(
                                color: AppColors.white,
                                fontSize: AppConstants.fontSizeXS,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppConstants.spacingS),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          topic.name,
                          style: TextStyle(
                            color: labelColor,
                            fontSize: AppConstants.fontSizeM,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        _formatPostCount(topic.postCount),
                        style: TextStyle(
                          color: secondaryLabelColor,
                          fontSize: AppConstants.fontSizeS,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '帖子',
                        style: TextStyle(
                          color: secondaryLabelColor,
                          fontSize: AppConstants.fontSizeS,
                        ),
                      ),
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

  String _formatPostCount(int count) {
    if (count >= 10000) {
      return '${(count / 10000).toStringAsFixed(1)}万';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}k';
    }
    return count.toString();
  }
}