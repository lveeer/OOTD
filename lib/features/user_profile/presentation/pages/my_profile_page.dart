import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/models/user.dart';
import '../../../wallet/presentation/pages/wallet_page.dart';

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
    background: 'https://images.unsplash.com/photo-1550684848-fac1c5b4e853?w=800',
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
            child: _buildUserInfoWithBackground(),
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
            child: _buildWalletCard(),
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
        const SizedBox(height: 8),
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
        const SizedBox(height: AppConstants.spacingL),
      ],
    );
  }

  Widget _buildUserInfoWithBackground() {
    return Stack(
      children: [
        // 背景图
        Container(
          height: 180,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.accent.withOpacity(0.3),
                AppColors.accent.withOpacity(0.1),
              ],
            ),
          ),
          child: _currentUser.background != null
              ? CachedNetworkImage(
                  imageUrl: _currentUser.background!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 180,
                )
              : null,
        ),
        // 更换背景图按钮
        Positioned(
          top: 8,
          right: 8,
          child: GestureDetector(
            onTap: () {
              // TODO: 跳转到更换背景图页面
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(AppConstants.radiusM),
              ),
              child: Icon(
                PhosphorIcons.camera(),
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ),
        // 用户信息（头像和昵称）
        Column(
          children: [
            const SizedBox(height: 80),
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
            const SizedBox(height: 8),
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
            const SizedBox(height: 14),
          ],
        ),
      ],
    );
  }

  Widget _buildStats() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.spacingL,
      ),
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

  Widget _buildBackground() {
    return GestureDetector(
      onTap: () {
        // TODO: 跳转到更换背景图页面
      },
      child: Stack(
        children: [
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.accent.withOpacity(0.3),
                  AppColors.accent.withOpacity(0.1),
                ],
              ),
            ),
            child: _currentUser.background != null
                ? CachedNetworkImage(
                    imageUrl: _currentUser.background!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 200,
                  )
                : null,
          ),
          Positioned(
            bottom: 8,
            right: 8,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(AppConstants.radiusM),
              ),
              child: Icon(
                PhosphorIcons.camera(),
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWalletCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.spacingL,
        vertical: AppConstants.spacingM,
      ),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const WalletPage(),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(AppConstants.spacingL),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.accent,
                AppColors.accent.withOpacity(0.8),
              ],
            ),
            borderRadius: BorderRadius.circular(AppConstants.radiusL),
            boxShadow: AppColors.cardShadow(Theme.of(context).brightness),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(AppConstants.radiusM),
                ),
                child: Icon(
                  PhosphorIcons.wallet(),
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: AppConstants.spacingM),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '我的钱包',
                      style: const TextStyle(
                        fontSize: AppConstants.fontSizeM,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '可提现 ¥1,234.56',
                      style: TextStyle(
                        fontSize: AppConstants.fontSizeS,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                PhosphorIcons.caretRight(),
                color: Colors.white.withOpacity(0.8),
                size: 20,
              ),
            ],
          ),
        ),
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
      padding: const EdgeInsets.fromLTRB(
        AppConstants.spacingL,
        AppConstants.spacingM,
        AppConstants.spacingL,
        AppConstants.spacingL,
      ),
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 130,
            child: OutlinedButton.icon(
              onPressed: () {
                // TODO: 跳转到编辑资料页面
              },
              icon: Icon(PhosphorIcons.pencilSimple(), size: 18),
              label: const Text('编辑资料', style: TextStyle(fontSize: 14)),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 10),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          ),
          const SizedBox(width: AppConstants.spacingM),
          SizedBox(
            width: 130,
            child: OutlinedButton.icon(
              onPressed: () {
                // TODO: 分享个人主页
              },
              icon: Icon(PhosphorIcons.shareNetwork(), size: 18),
              label: const Text('分享', style: TextStyle(fontSize: 14)),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 10),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
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