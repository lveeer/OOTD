import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/date_utils.dart';
import '../../domain/entities/post_entity.dart';
import '../../../../shared/models/media_file.dart';

class PostCard extends StatelessWidget {
  final PostEntity post;

  const PostCard({
    super.key,
    required this.post,
  });

  @override
  Widget build(BuildContext context) {
    final firstImage = post.images.isNotEmpty ? post.images[0] : null;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (firstImage != null)
              Stack(
                children: [
                  CachedNetworkImage(
                    imageUrl: firstImage.url ?? '',
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: AppColors.grey100,
                      height: 200,
                      child: const Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: AppColors.grey100,
                      height: 200,
                      child: Icon(PhosphorIcons.image()),
                    ),
                  ),
                  if (post.tags.isNotEmpty)
                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(AppConstants.radiusS),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              PhosphorIcons.tag(),
                              color: Colors.white,
                              size: 12,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${post.tags.length}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            Padding(
              padding: const EdgeInsets.all(AppConstants.spacingS),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundImage: post.author.avatar != null
                            ? CachedNetworkImageProvider(post.author.avatar!)
                            : null,
                        child: post.author.avatar == null
                            ? Icon(PhosphorIcons.user(), size: 16)
                            : null,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          post.author.nickname,
                          style: const TextStyle(
                            fontSize: AppConstants.fontSizeS,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    post.content,
                    style: const TextStyle(
                      fontSize: AppConstants.fontSizeS,
                      color: AppColors.grey800,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        PhosphorIcons.heart(),
                        size: 14,
                        color: post.isLiked ? AppColors.primary : AppColors.grey500,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${post.likesCount}',
                        style: const TextStyle(fontSize: AppConstants.fontSizeXS),
                      ),
                      const SizedBox(width: 12),
                      Icon(
                        PhosphorIcons.chatCircle(),
                        size: 14,
                        color: AppColors.grey500,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${post.commentsCount}',
                        style: const TextStyle(fontSize: AppConstants.fontSizeXS),
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
}