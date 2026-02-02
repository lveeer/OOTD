import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/models/user.dart';

class UserDetailPage extends StatefulWidget {
  final User user;

  const UserDetailPage({
    super.key,
    required this.user,
  });

  @override
  State<UserDetailPage> createState() => _UserDetailPageState();
}

class _UserDetailPageState extends State<UserDetailPage> {
  bool _isFollowing = false;
  bool _isBlocked = false;

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
      leading: IconButton(
        icon: Icon(PhosphorIcons.arrowLeft()),
        onPressed: () => Navigator.of(context).pop(),
      ),
      actions: [
        IconButton(
          icon: Icon(PhosphorIcons.dotsThree()),
          onPressed: () {
            _showMoreOptions();
          },
        ),
      ],
    );
  }

  Widget _buildUserInfo() {
    return Column(
      children: [
        const SizedBox(height: 20),
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
            backgroundImage: CachedNetworkImageProvider(widget.user.avatar ?? ''),
            backgroundColor: AppColors.grey100,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.user.nickname,
              style: const TextStyle(
                fontSize: AppConstants.fontSizeXL,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (widget.user.isVerified)
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
          child: widget.user.background != null
              ? CachedNetworkImage(
                  imageUrl: widget.user.background!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 180,
                )
              : null,
        ),
        // 用户信息（头像和昵称）
        Column(
          children: [
            const SizedBox(height: 80),
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
                backgroundImage: CachedNetworkImageProvider(widget.user.avatar ?? ''),
                backgroundColor: AppColors.grey100,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.user.nickname,
                  style: const TextStyle(
                    fontSize: AppConstants.fontSizeXL,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (widget.user.isVerified)
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
          _buildStatItem('${widget.user.postsCount}', '帖子'),
          _buildStatItem('${widget.user.followersCount}', '粉丝'),
          _buildStatItem('${widget.user.followingCount}', '关注'),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return Container(
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
      child: widget.user.background != null
          ? CachedNetworkImage(
              imageUrl: widget.user.background!,
              fit: BoxFit.cover,
              width: double.infinity,
              height: 200,
            )
          : null,
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
        widget.user.bio ?? '',
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
            width: 104,
            child: ElevatedButton.icon(
              onPressed: _toggleFollow,
              style: ElevatedButton.styleFrom(
                backgroundColor: _isFollowing ? Colors.grey[300] : AppColors.accent,
                foregroundColor: _isFollowing ? Colors.black : Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 10),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              icon: Icon(
                _isFollowing ? PhosphorIcons.check() : PhosphorIcons.userPlus(),
                size: 18,
              ),
              label: Text(_isFollowing ? '已关注' : '关注', style: const TextStyle(fontSize: 14)),
            ),
          ),
          const SizedBox(width: AppConstants.spacingM),
          SizedBox(
            width: 104,
            child: OutlinedButton.icon(
              onPressed: () {
                // TODO: 跳转到私信页面
              },
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 10),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              icon: Icon(PhosphorIcons.chatCircle(), size: 18),
              label: const Text('私信', style: TextStyle(fontSize: 14)),
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

  void _toggleFollow() {
    setState(() {
      _isFollowing = !_isFollowing;
    });
    // TODO: 调用关注/取消关注API
  }

  void _showMoreOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(PhosphorIcons.shareNetwork()),
              title: const Text('分享用户'),
              onTap: () {
                Navigator.pop(context);
                // TODO: 分享用户
              },
            ),
            ListTile(
              leading: Icon(PhosphorIcons.bellSlash()),
              title: const Text('不再接收通知'),
              onTap: () {
                Navigator.pop(context);
                // TODO: 设置通知
              },
            ),
            ListTile(
              leading: Icon(
                PhosphorIcons.warning(),
                color: Colors.red,
              ),
              title: Text(
                '拉黑',
                style: TextStyle(color: Colors.red),
              ),
              onTap: () {
                Navigator.pop(context);
                _showBlockConfirmDialog();
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  void _showBlockConfirmDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认拉黑'),
        content: Text('确定要拉黑 ${widget.user.nickname} 吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _isBlocked = true;
              });
              // TODO: 调用拉黑API
              Navigator.of(context).pop();
            },
            child: const Text(
              '拉黑',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}