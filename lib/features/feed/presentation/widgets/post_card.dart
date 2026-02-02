import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/di/injection_container.dart' as di;
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/post_entity.dart';
import '../../../post_detail/presentation/blocs/post_detail_bloc.dart';
import '../../../post_detail/presentation/pages/post_detail_page.dart';

/// 极简白灰风格帖子卡片
/// 4-8px 圆角，无边框，扁平设计
class PostCard extends StatelessWidget {
  final PostEntity post;

  const PostCard({
    super.key,
    required this.post,
  });

  @override
  Widget build(BuildContext context) {
    final firstImage = post.images.isNotEmpty ? post.images[0] : null;
    final theme = Theme.of(context);
    final brightness = theme.brightness;
    final labelColor = AppColors.labelColor(brightness);
    final secondaryLabelColor = AppColors.secondaryLabelColor(brightness);

    return Container(
      decoration: BoxDecoration(
        color: brightness == Brightness.light 
            ? AppColors.lightBackground 
            : AppColors.darkBackground,
        borderRadius: BorderRadius.circular(AppConstants.radiusM), // 8px 圆角
        // 移除边框，保持扁平
      ),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return BlocProvider(
                  create: (_) => PostDetailBloc(
                    getPostDetail: di.getIt(),
                    likePost: di.getIt(),
                    unlikePost: di.getIt(),
                    collectPost: di.getIt(),
                    uncollectPost: di.getIt(),
                    followUser: di.getIt(),
                    unfollowUser: di.getIt(),
                  ),
                  child: PostDetailPage(postId: post.id),
                );
              },
            ),
          );
        },
        borderRadius: BorderRadius.circular(AppConstants.radiusM),
        splashColor: labelColor.withOpacity(0.05),
        highlightColor: labelColor.withOpacity(0.02),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (firstImage != null)
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(AppConstants.radiusM), // 8px 圆角
                    ),
                    child: CachedNetworkImage(
                      imageUrl: firstImage.url ?? '',
                      width: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: brightness == Brightness.light 
                            ? AppColors.grey100 
                            : AppColors.grey800,
                        height: 200,
                        child: const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: brightness == Brightness.light 
                            ? AppColors.grey100 
                            : AppColors.grey800,
                        height: 200,
                        child: Icon(PhosphorIcons.image(), color: secondaryLabelColor),
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
                  // 用户名（灰色，弱化存在感）
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 8, // 缩小头像
                        backgroundImage: post.author.avatar != null
                            ? CachedNetworkImageProvider(post.author.avatar!)
                            : null,
                        backgroundColor: secondaryLabelColor.withOpacity(0.3),
                        child: post.author.avatar == null
                            ? Icon(PhosphorIcons.user(), size: 10, color: secondaryLabelColor)
                            : null,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          post.author.nickname,
                          style: TextStyle(
                            fontSize: 11, // 11-12px
                            fontWeight: FontWeight.w400, // Regular
                            color: secondaryLabelColor, // 灰色
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  // 穿搭描述（Medium 字重，最多2行）
                  Text(
                    post.content,
                    style: TextStyle(
                      fontSize: 13, // 13px
                      fontWeight: FontWeight.w500, // Medium
                      color: labelColor, // #333333
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  // 点赞和评论（灰色，低调）
                  Row(
                    children: [
                      Icon(
                        PhosphorIcons.heart(),
                        size: 11, // 11-12px
                        color: post.isLiked 
                            ? AppColors.accent // 黑色
                            : secondaryLabelColor, // 灰色
                        fill: post.isLiked ? 1.0 : 0.0, // 选中实心
                      ),
                      const SizedBox(width: 2),
                      Text(
                        '${post.likesCount}',
                        style: TextStyle(
                          fontSize: 10, // 10px
                          fontWeight: FontWeight.w500, // Medium
                          color: secondaryLabelColor, // 灰色
                        ),
                      ),
                      const SizedBox(width: 10),
                      Icon(
                        PhosphorIcons.chatCircle(),
                        size: 11,
                        color: secondaryLabelColor,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        '${post.commentsCount}',
                        style: TextStyle(
                          fontSize: 10,
                          color: secondaryLabelColor,
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
}