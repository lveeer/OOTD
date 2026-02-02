import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/post_entity.dart';

class PostCard extends StatelessWidget {
  final PostEntity post;

  const PostCard({
    super.key,
    required this.post,
  });

  @override
  Widget build(BuildContext context) {
    final firstImage = post.images.isNotEmpty ? post.images[0] : null;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.radiusS),
      ),
      child: InkWell(
        onTap: () {
        },
        borderRadius: BorderRadius.circular(AppConstants.radiusS),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (firstImage != null)
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(AppConstants.radiusS),
                    ),
                    child: CachedNetworkImage(
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
                  ),
                  if (post.tags.isNotEmpty)
                    Positioned(
                      bottom: 4,
                      right: 4,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
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
                              size: 10,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              '${post.tags.length}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
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
              padding: const EdgeInsets.all(AppConstants.spacingXS + 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 12,
                        backgroundImage: post.author.avatar != null
                            ? CachedNetworkImageProvider(post.author.avatar!)
                            : null,
                        child: post.author.avatar == null
                            ? Icon(PhosphorIcons.user(), size: 12)
                            : null,
                      ),
                      const SizedBox(width: 6),
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
                  const SizedBox(height: 6),
                  Text(
                    post.content,
                    style: const TextStyle(
                      fontSize: AppConstants.fontSizeS,
                      color: AppColors.grey800,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(
                        PhosphorIcons.heart(),
                        size: 12,
                        color: post.isLiked ? AppColors.primary : AppColors.grey500,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        '${post.likesCount}',
                        style: const TextStyle(fontSize: AppConstants.fontSizeXS),
                      ),
                      const SizedBox(width: 10),
                      Icon(
                        PhosphorIcons.chatCircle(),
                        size: 12,
                        color: AppColors.grey500,
                      ),
                      const SizedBox(width: 2),
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