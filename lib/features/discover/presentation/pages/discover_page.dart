import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../shared/models/user.dart';
import '../blocs/discover_bloc.dart';
import '../widgets/topic_card.dart';
import '../widgets/user_card.dart';
import '../widgets/trending_post_card.dart';
import '../../../user_profile/presentation/pages/user_detail_page.dart';
import '../../../post_detail/presentation/pages/post_detail_page.dart';
import '../../../post_detail/presentation/blocs/post_detail_bloc.dart';
import '../../../../core/di/injection_container.dart' as di;

class DiscoverPage extends StatefulWidget {
  const DiscoverPage({super.key});

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<DiscoverBloc>().add(DiscoverFetchRequested());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onRefresh() {
    context.read<DiscoverBloc>().add(DiscoverRefreshRequested());
  }

  void _onSearch(String query) {
    if (query.isNotEmpty) {
      context.read<DiscoverBloc>().add(DiscoverSearchRequested(query: query));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brightness = theme.brightness;
    final labelColor = AppColors.labelColor(brightness);
    final fillColor = AppColors.fillColor(brightness);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildSearchBar(context),
            Expanded(
              child: BlocBuilder<DiscoverBloc, DiscoverState>(
                builder: (context, state) {
                  if (state is DiscoverLoading) {
                    return const LoadingWidget(message: '加载中...');
                  }

                  if (state is DiscoverError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            state.message,
                            style: TextStyle(
                              color: labelColor,
                              fontSize: AppConstants.fontSizeM,
                            ),
                          ),
                          const SizedBox(height: AppConstants.spacingM),
                          ElevatedButton(
                            onPressed: _onRefresh,
                            child: const Text('重试'),
                          ),
                        ],
                      ),
                    );
                  }

                  if (state is DiscoverLoaded || state is DiscoverRefreshing) {
                    final topics = state is DiscoverLoaded
                        ? state.topics
                        : (state as DiscoverRefreshing).topics;
                    final recommendedUsers = state is DiscoverLoaded
                        ? state.recommendedUsers
                        : (state as DiscoverRefreshing).recommendedUsers;
                    final trendingPosts = state is DiscoverLoaded
                        ? state.trendingPosts
                        : (state as DiscoverRefreshing).trendingPosts;
                    final followedTopics = state is DiscoverLoaded
                        ? state.followedTopics
                        : (state as DiscoverRefreshing).followedTopics;
                    final followedUsers = state is DiscoverLoaded
                        ? state.followedUsers
                        : (state as DiscoverRefreshing).followedUsers;

                    return RefreshIndicator(
                      onRefresh: () async {
                        _onRefresh();
                      },
                      child: CustomScrollView(
                        controller: _scrollController,
                        slivers: [
                          SliverToBoxAdapter(
                            child: _buildSectionHeader(
                              context,
                              title: '热门话题',
                              icon: PhosphorIcons.hash(),
                            ),
                          ),
                          SliverToBoxAdapter(
                            child: _buildTopicsGrid(
                              context,
                              topics,
                              followedTopics,
                            ),
                          ),
                          SliverToBoxAdapter(
                            child: _buildSectionHeader(
                              context,
                              title: '推荐达人',
                              icon: PhosphorIcons.users(),
                            ),
                          ),
                          SliverToBoxAdapter(
                            child: _buildUsersList(
                              context,
                              recommendedUsers,
                              followedUsers,
                            ),
                          ),
                          SliverToBoxAdapter(
                            child: _buildSectionHeader(
                              context,
                              title: '热门穿搭',
                              icon: PhosphorIcons.trendUp(),
                            ),
                          ),
                          SliverToBoxAdapter(
                            child: _buildTrendingPosts(
                              context,
                              trendingPosts,
                            ),
                          ),
                          SliverToBoxAdapter(
                            child: SizedBox(
                              height: MediaQuery.of(context).padding.bottom + 80,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    final theme = Theme.of(context);
    final brightness = theme.brightness;
    final labelColor = AppColors.labelColor(brightness);
    final secondaryLabelColor = AppColors.secondaryLabelColor(brightness);

    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingM),
      decoration: BoxDecoration(
        color: brightness == Brightness.light
            ? AppColors.lightBackground
            : AppColors.darkBackground,
        border: Border(
          bottom: BorderSide(
            color: AppColors.separatorColor(brightness),
            width: 0.5,
          ),
        ),
      ),
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.fillColor(brightness),
          borderRadius: BorderRadius.circular(AppConstants.radiusL),
        ),
        child: TextField(
          controller: _searchController,
          onSubmitted: _onSearch,
          decoration: InputDecoration(
            hintText: '搜索穿搭、话题、用户',
            hintStyle: TextStyle(
              color: secondaryLabelColor,
              fontSize: AppConstants.fontSizeM,
            ),
            prefixIcon: Icon(
              PhosphorIcons.magnifyingGlass(),
              color: secondaryLabelColor,
              size: 20,
            ),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: Icon(
                      PhosphorIcons.x(),
                      color: secondaryLabelColor,
                      size: 18,
                    ),
                    onPressed: () {
                      _searchController.clear();
                      setState(() {});
                    },
                  )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppConstants.spacingM,
              vertical: AppConstants.spacingS,
            ),
          ),
          style: TextStyle(
            color: labelColor,
            fontSize: AppConstants.fontSizeM,
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context, {
    required String title,
    required IconData icon,
  }) {
    final theme = Theme.of(context);
    final brightness = theme.brightness;
    final labelColor = AppColors.labelColor(brightness);

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppConstants.spacingM,
        AppConstants.spacingL,
        AppConstants.spacingM,
        AppConstants.spacingM,
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: labelColor,
            size: 20,
          ),
          const SizedBox(width: AppConstants.spacingS),
          Text(
            title,
            style: TextStyle(
              color: labelColor,
              fontSize: AppConstants.fontSizeL,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopicsGrid(
    BuildContext context,
    List topics,
    Set<String> followedTopics,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacingM),
      height: 180,
      child: GridView.builder(
        scrollDirection: Axis.horizontal,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          mainAxisSpacing: AppConstants.spacingS,
          childAspectRatio: 0.8,
        ),
        itemCount: topics.length,
        itemBuilder: (context, index) {
          final topic = topics[index];
          final isFollowed = followedTopics.contains(topic.id);
          return TopicCard(
            topic: topic,
            isFollowed: isFollowed,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => _TopicDetailPage(
                    topicName: topic.name,
                    topicId: topic.id,
                  ),
                ),
              );
            },
            onFollowToggle: () {
              context
                  .read<DiscoverBloc>()
                  .add(DiscoverTopicToggled(topicId: topic.id));
            },
          );
        },
      ),
    );
  }

  Widget _buildUsersList(
    BuildContext context,
    List users,
    Set<String> followedUsers,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacingM),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: users.length,
        separatorBuilder: (context, index) => const SizedBox(
          height: AppConstants.spacingS,
        ),
        itemBuilder: (context, index) {
          final user = users[index];
          final isFollowed = followedUsers.contains(user.id);
          return UserCard(
            user: user,
            isFollowed: isFollowed,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => UserDetailPage(
                    user: User(
                      id: user.id,
                      nickname: user.nickname,
                      avatar: user.avatar,
                      bio: user.bio,
                      followersCount: user.followersCount,
                      followingCount: user.followingCount,
                      postsCount: user.postsCount,
                      isVerified: user.isVerified,
                      createdAt: DateTime.now(),
                      updatedAt: DateTime.now(),
                    ),
                  ),
                ),
              );
            },
            onFollowToggle: () {
              context
                  .read<DiscoverBloc>()
                  .add(DiscoverUserFollowToggled(userId: user.id));
            },
          );
        },
      ),
    );
  }

  Widget _buildTrendingPosts(
    BuildContext context,
    List posts,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacingM),
      height: 280,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: posts.length,
        separatorBuilder: (context, index) => const SizedBox(
          width: AppConstants.spacingS,
        ),
        itemBuilder: (context, index) {
          final post = posts[index];
          return SizedBox(
            width: 140,
            child: TrendingPostCard(
              post: post,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => BlocProvider(
                      create: (context) => PostDetailBloc(
                        getPostDetail: di.getIt(),
                        likePost: di.getIt(),
                        unlikePost: di.getIt(),
                        collectPost: di.getIt(),
                        uncollectPost: di.getIt(),
                        followUser: di.getIt(),
                        unfollowUser: di.getIt(),
                      ),
                      child: PostDetailPage(
                        postId: post.id,
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

/// 话题详情页（占位实现）
class _TopicDetailPage extends StatelessWidget {
  final String topicName;
  final String topicId;

  const _TopicDetailPage({
    required this.topicName,
    required this.topicId,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brightness = theme.brightness;
    final labelColor = AppColors.labelColor(brightness);
    final secondaryLabelColor = AppColors.secondaryLabelColor(brightness);

    return Scaffold(
      appBar: AppBar(
        title: Text(topicName),
        leading: IconButton(
          icon: Icon(
            PhosphorIcons.arrowLeft(),
            color: labelColor,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              PhosphorIcons.hash(),
              size: 64,
              color: secondaryLabelColor,
            ),
            const SizedBox(height: AppConstants.spacingL),
            Text(
              topicName,
              style: TextStyle(
                fontSize: AppConstants.fontSizeXL,
                fontWeight: FontWeight.w600,
                color: labelColor,
              ),
            ),
            const SizedBox(height: AppConstants.spacingS),
            Text(
              '话题详情页功能开发中',
              style: TextStyle(
                fontSize: AppConstants.fontSizeM,
                color: secondaryLabelColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}