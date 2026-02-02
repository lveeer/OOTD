import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/post_entity.dart';

class TrendingPostCard extends StatelessWidget {
  final PostEntity post;
  final VoidCallback onTap;

  const TrendingPostCard({
    super.key,
    required this.post,
    required this.onTap,
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
            ClipRRect(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(AppConstants.radiusM),
              ),
              child: AspectRatio(
                aspectRatio: 3.0 / 4.0,
                child: Image.network(
                  post.images.isNotEmpty ? post.images[0] : '',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: AppColors.secondaryBackgroundColor(brightness),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppConstants.spacingS),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    post.content,
                    style: TextStyle(
                      color: labelColor,
                      fontSize: AppConstants.fontSizeS,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(AppConstants.radiusS),
                        child: Image.network(
                          post.author.avatar,
                          width: 16,
                          height: 16,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 16,
                              height: 16,
                              color: AppColors.secondaryBackgroundColor(brightness),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          post.author.nickname,
                          style: TextStyle(
                            color: secondaryLabelColor,
                            fontSize: AppConstants.fontSizeXS,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Icon(
                        PhosphorIcons.heart(),
                        color: post.isLiked
                            ? AppColors.accent
                            : secondaryLabelColor,
                        size: 12,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        _formatCount(post.likesCount),
                        style: TextStyle(
                          color: secondaryLabelColor,
                          fontSize: AppConstants.fontSizeXS,
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

  String _formatCount(int count) {
    if (count >= 10000) {
      return '${(count / 10000).toStringAsFixed(1)}万';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}k';
    }
    return count.toString();
  }
}