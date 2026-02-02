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
import '../../../user_profile/presentation/pages/user_detail_page.dart';

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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSecondaryBackground : Colors.white,
        border: Border(
          bottom: BorderSide(
            color: isDark ? AppColors.darkSeparator : AppColors.lightSeparator,
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          // 头像 - 可点击跳转
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => UserDetailPage(user: state.post.author),
                ),
              );
            },
            child: CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(state.post.author.avatar ?? ''),
            ),
          ),
          const SizedBox(width: 10),
          // 用户信息 - 可点击跳转
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => UserDetailPage(user: state.post.author),
                  ),
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        state.post.author.nickname,
                        style: TextStyle(
                          fontSize: AppConstants.fontSizeM,
                          fontWeight: FontWeight.w500,
                          color: isDark ? AppColors.darkLabel : AppColors.lightLabel,
                        ),
                      ),
                      if (state.post.author.isVerified) ...[
                        const SizedBox(width: 4),
                        Icon(
                          PhosphorIcons.sealCheck(),
                          size: 14,
                          color: Colors.blue,
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${state.post.author.followersCount} 粉丝 · ${state.post.author.postsCount} 帖子',
                    style: TextStyle(
                      fontSize: AppConstants.fontSizeXS,
                      color: isDark ? AppColors.darkTertiaryLabel : AppColors.lightTertiaryLabel,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // 关注按钮 - 小红书风格白色底色、红色字体、红色边框
          Container(
            height: 28,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: const Color(0xFFFF2442), // 小红书品牌红
                width: 1,
              ),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  context.read<PostDetailBloc>().add(const PostDetailFollowToggled());
                },
                borderRadius: BorderRadius.circular(4),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Center(
                    child: Text(
                      '关注',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFFFF2442), // 小红书品牌红
                      ),
                    ),
                  ),
                ),
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
          // 评论标题 - 美化样式
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: isDark
                          ? [
                              Colors.purple.withOpacity(0.2),
                              Colors.blue.withOpacity(0.2),
                            ]
                          : [
                              Colors.purple.withOpacity(0.1),
                              Colors.blue.withOpacity(0.1),
                            ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    PhosphorIcons.chatCircle(),
                    size: 20,
                    color: isDark ? AppColors.darkLabel : AppColors.lightLabel,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  '评论',
                  style: TextStyle(
                    fontSize: AppConstants.fontSizeL + 2,
                    fontWeight: FontWeight.w700,
                    color: isDark ? AppColors.darkLabel : AppColors.lightLabel,
                    letterSpacing: 0.3,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isDark
                          ? [
                              Colors.purple.withOpacity(0.15),
                              Colors.blue.withOpacity(0.15),
                            ]
                          : [
                              Colors.purple.withOpacity(0.08),
                              Colors.blue.withOpacity(0.08),
                            ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDark
                          ? Colors.white.withOpacity(0.05)
                          : Colors.black.withOpacity(0.04),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    '${state.post.commentsCount}',
                    style: TextStyle(
                      fontSize: AppConstants.fontSizeS,
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.darkLabel : AppColors.lightLabel,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          if (state.comments.isEmpty)
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: isDark
                        ? [
                            AppColors.darkSecondaryBackground.withOpacity(0.5),
                            AppColors.darkSecondaryBackground.withOpacity(0.3),
                          ]
                        : [
                            AppColors.lightSecondaryBackground.withOpacity(0.5),
                            AppColors.lightSecondaryBackground.withOpacity(0.3),
                          ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isDark
                        ? Colors.white.withOpacity(0.05)
                        : Colors.black.withOpacity(0.04),
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.white.withOpacity(0.05)
                            : Colors.black.withOpacity(0.03),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        PhosphorIcons.chatTeardropText(),
                        size: 32,
                        color: isDark
                            ? AppColors.darkTertiaryLabel.withOpacity(0.6)
                            : AppColors.lightTertiaryLabel.withOpacity(0.6),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '暂无评论',
                      style: TextStyle(
                        fontSize: AppConstants.fontSizeL,
                        fontWeight: FontWeight.w600,
                        color: isDark ? AppColors.darkLabel : AppColors.lightLabel,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '快来抢沙发吧～',
                      style: TextStyle(
                        fontSize: AppConstants.fontSizeS,
                        color: isDark ? AppColors.darkTertiaryLabel : AppColors.lightTertiaryLabel,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: state.comments.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
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
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  AppColors.darkSecondaryBackground.withOpacity(0.6),
                  AppColors.darkSecondaryBackground.withOpacity(0.3),
                ]
              : [
                  AppColors.lightSecondaryBackground.withOpacity(0.6),
                  Colors.white.withOpacity(0.4),
                ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.05)
              : Colors.black.withOpacity(0.04),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 头像 - 添加边框效果
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isDark
                    ? Colors.white.withOpacity(0.1)
                    : Colors.black.withOpacity(0.08),
                width: 2,
              ),
            ),
            child: CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(author['avatar'] ?? ''),
            ),
          ),
          const SizedBox(width: 14),
          // 评论内容
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 用户名和时间
                Row(
                  children: [
                    Text(
                      author['nickname'] ?? '匿名用户',
                      style: TextStyle(
                        fontSize: AppConstants.fontSizeS + 1,
                        fontWeight: FontWeight.w600,
                        color: isDark ? AppColors.darkLabel : AppColors.lightLabel,
                        letterSpacing: 0.2,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.white.withOpacity(0.05)
                            : Colors.black.withOpacity(0.03),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _formatTime(comment['createdAt']),
                        style: TextStyle(
                          fontSize: AppConstants.fontSizeXS,
                          color: isDark ? AppColors.darkTertiaryLabel : AppColors.lightTertiaryLabel,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // 评论内容
                Text(
                  comment['content'] ?? '',
                  style: TextStyle(
                    fontSize: AppConstants.fontSizeM,
                    color: isDark ? AppColors.darkLabel : AppColors.lightLabel,
                    height: 1.5,
                  ),
                ),
                // 回复列表
                if (comment['replies'] != null &&
                    (comment['replies'] as List).isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.white.withOpacity(0.03)
                            : Colors.black.withOpacity(0.02),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isDark
                              ? Colors.white.withOpacity(0.03)
                              : Colors.black.withOpacity(0.02),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: (comment['replies'] as List).map((reply) {
                          final replyAuthor = reply['author'] as Map<String, dynamic>;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  fontSize: AppConstants.fontSizeS,
                                  color: isDark ? AppColors.darkLabel : AppColors.lightLabel,
                                  height: 1.4,
                                ),
                                children: [
                                  TextSpan(
                                    text: '${replyAuthor['nickname']} ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: isDark ? AppColors.darkLabel : AppColors.lightLabel,
                                    ),
                                  ),
                                  TextSpan(text: reply['content'] ?? ''),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                const SizedBox(height: 12),
                // 底部操作栏
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.white.withOpacity(0.03)
                        : Colors.black.withOpacity(0.02),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // 点赞
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
                              size: 16,
                              color: comment['isLiked'] == true
                                  ? Colors.red
                                  : (isDark ? AppColors.darkTertiaryLabel : AppColors.lightTertiaryLabel),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${comment['likesCount'] ?? 0}',
                              style: TextStyle(
                                fontSize: AppConstants.fontSizeXS + 1,
                                color: isDark ? AppColors.darkTertiaryLabel : AppColors.lightTertiaryLabel,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 12),
                        width: 1,
                        height: 14,
                        color: isDark
                            ? Colors.white.withOpacity(0.1)
                            : Colors.black.withOpacity(0.1),
                      ),
                      // 回复
                      GestureDetector(
                        onTap: () {
                          // 回复评论
                        },
                        child: Row(
                          children: [
                            Icon(
                              PhosphorIcons.arrowUUpLeft(),
                              size: 16,
                              color: isDark ? AppColors.darkTertiaryLabel : AppColors.lightTertiaryLabel,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '回复',
                              style: TextStyle(
                                fontSize: AppConstants.fontSizeXS + 1,
                                color: isDark ? AppColors.darkTertiaryLabel : AppColors.lightTertiaryLabel,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
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
        left: 12,
        right: 12,
        top: 8,
        bottom: 8 + MediaQuery.of(context).padding.bottom,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSecondaryBackground : Colors.white,
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.darkSeparator : AppColors.lightSeparator,
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          // 评论输入框 - 高度降低为70%
          Expanded(
            child: Container(
              height: 32, // 原来约46px，现在32px，约为70%
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.darkFill
                    : const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(16),
              ),
              child: TextField(
                controller: _commentController,
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? AppColors.darkLabel : AppColors.lightLabel,
                ),
                decoration: InputDecoration(
                  hintText: '说点什么...',
                  hintStyle: TextStyle(
                    fontSize: 14,
                    color: isDark ? AppColors.darkTertiaryLabel : AppColors.lightTertiaryLabel,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ),
                  border: InputBorder.none,
                  isDense: true,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // 点赞按钮
          _buildActionButton(
            icon: state.post.isLiked
                ? PhosphorIcons.heart(PhosphorIconsStyle.fill)
                : PhosphorIcons.heart(),
            color: state.post.isLiked ? const Color(0xFFFF2442) : (isDark ? AppColors.darkLabel : AppColors.lightLabel),
            onTap: () {
              context.read<PostDetailBloc>().add(const PostDetailLikeToggled());
            },
            isDark: isDark,
          ),
          // 收藏按钮
          _buildActionButton(
            icon: state.post.isCollected
                ? PhosphorIcons.star(PhosphorIconsStyle.fill)
                : PhosphorIcons.star(),
            color: state.post.isCollected ? const Color(0xFFFFB800) : (isDark ? AppColors.darkLabel : AppColors.lightLabel),
            onTap: () {
              context.read<PostDetailBloc>().add(const PostDetailCollectToggled());
            },
            isDark: isDark,
          ),
          // 分享按钮
          _buildActionButton(
            icon: PhosphorIcons.shareNetwork(),
            color: isDark ? AppColors.darkLabel : AppColors.lightLabel,
            onTap: () {
              context.read<PostDetailBloc>().add(const PostDetailShareRequested());
            },
            isDark: isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        alignment: Alignment.center,
        child: Icon(
          icon,
          size: 22,
          color: color,
        ),
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