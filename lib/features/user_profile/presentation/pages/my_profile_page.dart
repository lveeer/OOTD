import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/models/user.dart';

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({super.key});

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  final User _currentUser = User(
    id: 'user_1',
    nickname: '时尚达人',
    avatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100',
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
      pinned: true,
      backgroundColor: Colors.white,
      title: const Text('我的'),
      actions: [
        IconButton(
          icon: Icon(PhosphorIcons.gear()),
          onPressed: () {
            // TODO: 跳转到设置页面
          },
        ),
        IconButton(
          icon: Icon(PhosphorIcons.qrCode()),
          onPressed: () {
            // TODO: 显示二维码
          },
        ),
      ],
    );
  }

  Widget _buildUserInfo() {
    return Column(
      children: [
        const SizedBox(height: 20),
        GestureDetector(
          onTap: () {
            // TODO: 跳转到编辑资料页面
          },
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 4,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: CachedNetworkImageProvider(_currentUser.avatar ?? ''),
                  backgroundColor: AppColors.grey100,
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.accent,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: Icon(
                    PhosphorIcons.pencilSimple(),
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppConstants.spacingM),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _currentUser.nickname,
              style: const TextStyle(
                fontSize: AppConstants.fontSizeXL,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (_currentUser.isVerified)
              Padding(
                padding: const EdgeInsets.only(left: 4),
                child: Icon(
                  PhosphorIcons.sealCheck(),
                  color: AppColors.accent,
                  size: 20,
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildStats() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacingL),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('${_currentUser.postsCount}', '帖子'),
          _buildStatItem('${_currentUser.followersCount}', '粉丝'),
          _buildStatItem('${_currentUser.followingCount}', '关注'),
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
        _currentUser.bio ?? '',
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
            child: OutlinedButton.icon(
              onPressed: () {
                // TODO: 跳转到编辑资料页面
              },
              icon: Icon(PhosphorIcons.pencilSimple()),
              label: const Text('编辑资料'),
            ),
          ),
          const SizedBox(width: AppConstants.spacingM),
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () {
                // TODO: 分享个人主页
              },
              icon: Icon(PhosphorIcons.shareNetwork()),
              label: const Text('分享'),
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
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            PhosphorIcons.heart(),
            size: 80,
            color: AppColors.grey400,
          ),
          const SizedBox(height: 16),
          Text(
            '暂无喜欢',
            style: TextStyle(
              color: AppColors.grey600,
              fontSize: AppConstants.fontSizeM,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCollectionsTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            PhosphorIcons.bookmark(),
            size: 80,
            color: AppColors.grey400,
          ),
          const SizedBox(height: 16),
          Text(
            '暂无收藏',
            style: TextStyle(
              color: AppColors.grey600,
              fontSize: AppConstants.fontSizeM,
            ),
          ),
        ],
      ),
    );
  }
}