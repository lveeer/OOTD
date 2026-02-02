import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../shared/widgets/empty_widget.dart';
import '../blocs/post_detail_bloc.dart';
import '../blocs/post_detail_event.dart';
import '../blocs/post_detail_state.dart';
import '../widgets/product_card.dart';

/// 帖子详情页
class PostDetailPage extends StatefulWidget {
  final String postId;

  const PostDetailPage({
    super.key,
    required this.postId,
  });

  @override
  State<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _commentController = TextEditingController();
  bool _isExpanded = false;
  dynamic _selectedTag;

  @override
  void initState() {
    super.initState();
    context.read<PostDetailBloc>().add(PostDetailLoadRequested(postId: widget.postId));
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isDark = brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        title: const Text('帖子详情'),
        leading: IconButton(
                    icon: Icon(PhosphorIcons.arrowLeft()),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  actions: [
                    IconButton(
                      icon: Icon(PhosphorIcons.dotsThree()),
                      onPressed: () {
                        // 更多选项
                      },
                    ),
                  ],      ),
      body: BlocBuilder<PostDetailBloc, PostDetailState>(
        builder: (context, state) {
          if (state is PostDetailLoading) {
            return const LoadingWidget();
          }

          if (state is PostDetailError) {
            return EmptyWidget(
              message: state.message,
              onRefresh: () {
                context.read<PostDetailBloc>().add(
                  PostDetailLoadRequested(postId: widget.postId),
                );
              },
            );
          }

          if (state is PostDetailLoaded) {
            return Column(
              children: [
                Expanded(
                  child: ListView(
                    controller: _scrollController,
                    children: [
                      // Hero动画图片头图
                      _buildImageHero(state, isDark),
                      // 用户信息栏
                      _buildUserInfo(state, isDark),
                      // 文案区域
                      _buildContent(state, isDark),
                      // 话题标签
                      if (state.post.topics.isNotEmpty)
                        _buildTopics(state, isDark),
                      // 商品列表
                      if (state.post.tags.isNotEmpty)
                        _buildProductList(state, isDark),
                      // 评论区域
                      _buildCommentsSection(state, isDark),
                      const SizedBox(height: 80), // 为底部操作栏留出空间
                    ],
                  ),
                ),
                // 底部固定操作栏
                _buildBottomActionBar(state, isDark),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildImageHero(PostDetailLoaded state, bool isDark) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.6,
      ),
      child: PageView.builder(
        itemCount: state.post.images.length,
        itemBuilder: (context, index) {
          final image = state.post.images[index];
          return Stack(
            children: [
              // 图片
              Image.network(
                image.url ?? image.path,
                fit: BoxFit.contain,
                width: double.infinity,
              ),
              // 标签叠加层
              ...state.post.tags
                  .where((tag) => tag.imageIndex == index)
                  .map((tag) => _buildTag(tag, isDark, state)),
              // 图片指示器
              if (state.post.images.length > 1)
                Positioned(
                  bottom: 16,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      state.post.images.length,
                      (i) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: i == index ? 8 : 6,
                        height: i == index ? 8 : 6,
                        decoration: BoxDecoration(
                          color: i == index
                              ? Colors.white
                              : Colors.white.withOpacity(0.5),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTag(tag, bool isDark, PostDetailLoaded state) {
    return Positioned(
      left: tag.relativePosition.dx * MediaQuery.of(context).size.width,
      top: tag.relativePosition.dy *
          (MediaQuery.of(context).size.height * 0.6),
      child: GestureDetector(
        onTap: () {
          // 点击标签显示商品弹窗
          _showProductDialog(tag, isDark);
        },
        child: Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: Icon(
              PhosphorIcons.tag(),
              size: 14,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  void _showProductDialog(tag, bool isDark) {
    setState(() {
      _selectedTag = tag;
    });

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSecondaryBackground : AppColors.lightSecondaryBackground,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 顶部拖动指示器
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkTertiaryLabel : AppColors.lightTertiaryLabel,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                // 商品卡片
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: ProductCard(
                    product: tag.product,
                    showCommission: true,
                  ),
                ),
                // 关闭按钮
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      setState(() {
                        _selectedTag = null;
                      });
                    },
                    child: Text(
                      '关闭',
                      style: TextStyle(
                        color: isDark ? AppColors.darkLabel : AppColors.lightLabel,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ).then((_) {
      setState(() {
        _selectedTag = null;
      });
    });
  }

  Widget _buildUserInfo(PostDetailLoaded state, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSecondaryBackground : AppColors.lightSecondaryBackground,
      ),
      child: Row(
        children: [
          // 头像
          CircleAvatar(
            radius: 24,
            backgroundImage: NetworkImage(state.post.author.avatar ?? ''),
          ),
          const SizedBox(width: 12),
          // 用户信息
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      state.post.author.nickname,
                      style: TextStyle(
                        fontSize: AppConstants.fontSizeL,
                        fontWeight: FontWeight.w600,
                        color: isDark ? AppColors.darkLabel : AppColors.lightLabel,
                      ),
                    ),
                    if (state.post.author.isVerified) ...[
                      const SizedBox(width: 4),
                      Icon(
                        PhosphorIcons.sealCheck(),
                        size: 16,
                        color: isDark ? Colors.blue : Colors.blue,
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '${state.post.author.followersCount} 粉丝 · ${state.post.author.postsCount} 帖子',
                  style: TextStyle(
                    fontSize: AppConstants.fontSizeS,
                    color: isDark ? AppColors.darkTertiaryLabel : AppColors.lightTertiaryLabel,
                  ),
                ),
              ],
            ),
          ),
          // 关注按钮
          OutlinedButton(
            onPressed: () {
              context.read<PostDetailBloc>().add(const PostDetailFollowToggled());
            },
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(80, 32),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              side: BorderSide(
                color: isDark ? AppColors.darkLabel : AppColors.lightLabel,
              ),
            ),
            child: Text(
              '关注',
              style: TextStyle(
                fontSize: AppConstants.fontSizeS,
                color: isDark ? AppColors.darkLabel : AppColors.lightLabel,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(PostDetailLoaded state, bool isDark) {
    final content = state.post.content;
    if (content.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            content,
            maxLines: _isExpanded ? null : 3,
            overflow: _isExpanded ? null : TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: AppConstants.fontSizeM,
              color: isDark ? AppColors.darkLabel : AppColors.lightLabel,
              height: 1.6,
            ),
          ),
          if (content.length > 100)
            GestureDetector(
              onTap: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  _isExpanded ? '收起' : '展开全文',
                  style: TextStyle(
                    fontSize: AppConstants.fontSizeS,
                    color: isDark ? AppColors.darkTertiaryLabel : AppColors.lightTertiaryLabel,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTopics(PostDetailLoaded state, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: state.post.topics.map((topic) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkFill : AppColors.lightFill,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              '#$topic',
              style: TextStyle(
                fontSize: AppConstants.fontSizeS,
                color: isDark ? AppColors.darkLabel : AppColors.lightLabel,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildProductList(PostDetailLoaded state, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                PhosphorIcons.shoppingBag(),
                size: 20,
                color: isDark ? AppColors.darkLabel : AppColors.lightLabel,
              ),
              const SizedBox(width: 8),
              Text(
                '商品推荐',
                style: TextStyle(
                  fontSize: AppConstants.fontSizeL,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.darkLabel : AppColors.lightLabel,
                ),
              ),
              const Spacer(),
              Text(
                '${state.post.tags.length}件',
                style: TextStyle(
                  fontSize: AppConstants.fontSizeS,
                  color: isDark ? AppColors.darkTertiaryLabel : AppColors.lightTertiaryLabel,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.75,
            ),
            itemCount: state.post.tags.length,
            itemBuilder: (context, index) {
              final tag = state.post.tags[index];
              return ProductCard(
                product: tag.product,
                showCommission: true,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCommentsSection(PostDetailLoaded state, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                PhosphorIcons.chatCircle(),
                size: 20,
                color: isDark ? AppColors.darkLabel : AppColors.lightLabel,
              ),
              const SizedBox(width: 8),
              Text(
                '评论',
                style: TextStyle(
                  fontSize: AppConstants.fontSizeL,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.darkLabel : AppColors.lightLabel,
                ),
              ),
              const Spacer(),
              Text(
                '${state.post.commentsCount}',
                style: TextStyle(
                  fontSize: AppConstants.fontSizeS,
                  color: isDark ? AppColors.darkTertiaryLabel : AppColors.lightTertiaryLabel,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (state.comments.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 32),
                child: Text(
                  '暂无评论，快来抢沙发吧～',
                  style: TextStyle(
                    fontSize: AppConstants.fontSizeM,
                    color: isDark ? AppColors.darkTertiaryLabel : AppColors.lightTertiaryLabel,
                  ),
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: state.comments.length,
              separatorBuilder: (context, index) => Divider(
                color: isDark ? AppColors.darkSeparator : AppColors.lightSeparator,
                height: 1,
              ),
              itemBuilder: (context, index) {
                final comment = state.comments[index];
                return _buildCommentItem(comment, isDark);
              },
            ),
        ],
      ),
    );
  }

  Widget _buildCommentItem(Map<String, dynamic> comment, bool isDark) {
    final author = comment['author'] as Map<String, dynamic>;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 头像
          CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage(author['avatar'] ?? ''),
          ),
          const SizedBox(width: 12),
          // 评论内容
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 用户名
                Text(
                  author['nickname'] ?? '匿名用户',
                  style: TextStyle(
                    fontSize: AppConstants.fontSizeS,
                    fontWeight: FontWeight.w500,
                    color: isDark ? AppColors.darkLabel : AppColors.lightLabel,
                  ),
                ),
                const SizedBox(height: 4),
                // 评论内容
                Text(
                  comment['content'] ?? '',
                  style: TextStyle(
                    fontSize: AppConstants.fontSizeM,
                    color: isDark ? AppColors.darkLabel : AppColors.lightLabel,
                  ),
                ),
                // 回复列表
                if (comment['replies'] != null &&
                    (comment['replies'] as List).isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: (comment['replies'] as List).map((reply) {
                        final replyAuthor = reply['author'] as Map<String, dynamic>;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: RichText(
                            text: TextSpan(
                              style: TextStyle(
                                fontSize: AppConstants.fontSizeS,
                                color: isDark ? AppColors.darkLabel : AppColors.lightLabel,
                              ),
                              children: [
                                TextSpan(
                                  text: '${replyAuthor['nickname']} ',
                                  style: const TextStyle(fontWeight: FontWeight.w500),
                                ),
                                TextSpan(text: reply['content'] ?? ''),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                const SizedBox(height: 8),
                // 底部操作
                Row(
                  children: [
                    Text(
                      _formatTime(comment['createdAt']),
                      style: TextStyle(
                        fontSize: AppConstants.fontSizeXS,
                        color: isDark ? AppColors.darkTertiaryLabel : AppColors.lightTertiaryLabel,
                      ),
                    ),
                    const SizedBox(width: 16),
                    GestureDetector(
                      onTap: () {
                        // 点赞评论
                      },
                      child: Row(
                        children: [
                          Icon(
                            comment['isLiked'] == true
                                ? PhosphorIcons.heart(PhosphorIconsStyle.fill)
                                : PhosphorIcons.heart(),
                            size: 14,
                            color: isDark ? AppColors.darkTertiaryLabel : AppColors.lightTertiaryLabel,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${comment['likesCount'] ?? 0}',
                            style: TextStyle(
                              fontSize: AppConstants.fontSizeXS,
                              color: isDark ? AppColors.darkTertiaryLabel : AppColors.lightTertiaryLabel,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    GestureDetector(
                      onTap: () {
                        // 回复评论
                      },
                      child: Text(
                        '回复',
                        style: TextStyle(
                          fontSize: AppConstants.fontSizeXS,
                          color: isDark ? AppColors.darkTertiaryLabel : AppColors.lightTertiaryLabel,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActionBar(PostDetailLoaded state, bool isDark) {
    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 8,
        bottom: 8 + MediaQuery.of(context).padding.bottom,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSecondaryBackground : AppColors.lightSecondaryBackground,
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.darkSeparator : AppColors.lightSeparator,
          ),
        ),
      ),
      child: Row(
        children: [
          // 评论输入框
          Expanded(
            child: TextField(
              controller: _commentController,
              decoration: InputDecoration(
                hintText: '说点什么...',
                hintStyle: TextStyle(
                  color: isDark ? AppColors.darkTertiaryLabel : AppColors.lightTertiaryLabel,
                ),
                filled: true,
                fillColor: isDark ? AppColors.darkFill : AppColors.lightFill,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // 点赞按钮
          IconButton(
            onPressed: () {
              context.read<PostDetailBloc>().add(const PostDetailLikeToggled());
            },
            icon: Icon(
              state.post.isLiked
                  ? PhosphorIcons.heart(PhosphorIconsStyle.fill)
                  : PhosphorIcons.heart(),
              color: state.post.isLiked
                  ? Colors.red
                  : (isDark ? AppColors.darkLabel : AppColors.lightLabel),
            ),
          ),
          // 收藏按钮
          IconButton(
            onPressed: () {
              context.read<PostDetailBloc>().add(const PostDetailCollectToggled());
            },
            icon: Icon(
              state.post.isCollected
                  ? PhosphorIcons.bookmarkSimple(PhosphorIconsStyle.fill)
                  : PhosphorIcons.bookmarkSimple(),
              color: isDark ? AppColors.darkLabel : AppColors.lightLabel,
            ),
          ),
          // 分享按钮
          IconButton(
            onPressed: () {
              context.read<PostDetailBloc>().add(const PostDetailShareRequested());
            },
            icon: Icon(
              PhosphorIcons.shareNetwork(),
              color: isDark ? AppColors.darkLabel : AppColors.lightLabel,
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(dynamic time) {
    if (time is DateTime) {
      final now = DateTime.now();
      final difference = now.difference(time);

      if (difference.inMinutes < 1) {
        return '刚刚';
      } else if (difference.inMinutes < 60) {
        return '${difference.inMinutes}分钟前';
      } else if (difference.inHours < 24) {
        return '${difference.inHours}小时前';
      } else if (difference.inDays < 7) {
        return '${difference.inDays}天前';
      } else {
        return '${time.month}月${time.day}日';
      }
    }
    return '';
  }
}