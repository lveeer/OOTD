import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/user_entity.dart';

class UserCard extends StatelessWidget {
  final UserEntity user;
  final bool isFollowed;
  final VoidCallback onTap;
  final VoidCallback onFollowToggle;

  const UserCard({
    super.key,
    required this.user,
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
        padding: const EdgeInsets.all(AppConstants.spacingM),
        decoration: BoxDecoration(
          color: fillColor,
          borderRadius: BorderRadius.circular(AppConstants.radiusM),
        ),
        child: Row(
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppConstants.radiusL),
                  child: Image.network(
                    user.avatar,
                    width: 52,
                    height: 52,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 52,
                        height: 52,
                        color: AppColors.secondaryBackgroundColor(brightness),
                        child: Icon(
                          PhosphorIcons.user(),
                          color: secondaryLabelColor,
                          size: 24,
                        ),
                      );
                    },
                  ),
                ),
                if (user.isVerified)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: AppColors.accent,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        PhosphorIcons.checkCircle(),
                        color: AppColors.white,
                        size: 14,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: AppConstants.spacingM),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        user.nickname,
                        style: TextStyle(
                          color: labelColor,
                          fontSize: AppConstants.fontSizeM,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user.bio,
                    style: TextStyle(
                      color: secondaryLabelColor,
                      fontSize: AppConstants.fontSizeS,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        _formatCount(user.followersCount),
                        style: TextStyle(
                          color: labelColor,
                          fontSize: AppConstants.fontSizeXS,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        ' 粉丝',
                        style: TextStyle(
                          color: secondaryLabelColor,
                          fontSize: AppConstants.fontSizeXS,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        _formatCount(user.postsCount),
                        style: TextStyle(
                          color: labelColor,
                          fontSize: AppConstants.fontSizeXS,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        ' 帖子',
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
            const SizedBox(width: AppConstants.spacingM),
            _buildFollowButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildFollowButton(BuildContext context) {
    final theme = Theme.of(context);
    final brightness = theme.brightness;
    final labelColor = AppColors.labelColor(brightness);

    if (isFollowed) {
      return OutlinedButton(
        onPressed: onFollowToggle,
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          side: BorderSide(
            color: AppColors.separatorColor(brightness),
            width: 0.5,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusM),
          ),
        ),
        child: Text(
          '已关注',
          style: TextStyle(
            color: labelColor,
            fontSize: AppConstants.fontSizeS,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    }

    return ElevatedButton(
      onPressed: onFollowToggle,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.accent,
        foregroundColor: AppColors.white,
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusM),
        ),
        elevation: 0,
      ),
      child: Text(
        '关注',
        style: TextStyle(
          fontSize: AppConstants.fontSizeS,
          fontWeight: FontWeight.w600,
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