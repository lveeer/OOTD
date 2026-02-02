import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/models/user.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final User _mockUser = User(
    id: 'user_1',
    nickname: '时尚达人',
    avatar: 'https://via.placeholder.com/100',
    bio: '分享穿搭，发现好物',
    followersCount: 1234,
    followingCount: 567,
    postsCount: 89,
    isVerified: true,
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(
            child: _buildUserInfo(),
          ),
          SliverToBoxAdapter(
            child: _buildStats(),
          ),
          SliverToBoxAdapter(
            child: _buildBio(),
          ),
          SliverToBoxAdapter(
            child: _buildActionButtons(),
          ),
          SliverToBoxAdapter(
            child: _buildTabs(),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(PhosphorIcons.gear()),
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(PhosphorIcons.qrCode()),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildUserInfo() {
    return Transform.translate(
      offset: const Offset(0, -50),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: CachedNetworkImageProvider(_mockUser.avatar ?? ''),
            backgroundColor: AppColors.grey100,
          ),
          const SizedBox(height: AppConstants.spacingM),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _mockUser.nickname,
                style: const TextStyle(
                  fontSize: AppConstants.fontSizeXL,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (_mockUser.isVerified)
                Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: Icon(
                    PhosphorIcons.sealCheck(),
                    color: AppColors.primary,
                    size: 20,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStats() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacingL),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('${_mockUser.postsCount}', '帖子'),
          _buildStatItem('${_mockUser.followersCount}', '粉丝'),
          _buildStatItem('${_mockUser.followingCount}', '关注'),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: AppConstants.fontSizeXL,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: AppConstants.fontSizeS,
            color: AppColors.grey600,
          ),
        ),
      ],
    );
  }

  Widget _buildBio() {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.spacingL),
      child: Text(
        _mockUser.bio ?? '',
        style: TextStyle(
          fontSize: AppConstants.fontSizeM,
          color: AppColors.grey700,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacingL),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: Icon(PhosphorIcons.userPlus()),
              label: const Text('关注'),
            ),
          ),
          const SizedBox(width: AppConstants.spacingM),
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () {},
              icon: Icon(PhosphorIcons.chatCircle()),
              label: const Text('私信'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          const TabBar(
            tabs: [
              Tab(text: '帖子'),
              Tab(text: '喜欢'),
              Tab(text: '收藏'),
            ],
          ),
          SizedBox(
            height: 400,
            child: TabBarView(
              children: [
                _buildPostsTab(),
                _buildLikesTab(),
                _buildCollectionsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostsTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            PhosphorIcons.image(),
            size: 80,
            color: AppColors.grey400,
          ),
          const SizedBox(height: 16),
          Text(
            '暂无帖子',
            style: TextStyle(
              color: AppColors.grey600,
              fontSize: AppConstants.fontSizeM,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLikesTab() {
    return const Center(
      child: Text('喜欢'),
    );
  }

  Widget _buildCollectionsTab() {
    return const Center(
      child: Text('收藏'),
    );
  }
}