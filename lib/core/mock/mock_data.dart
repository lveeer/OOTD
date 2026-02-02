/// Mock 数据完整集合
/// 包含所有 API 接口的模拟响应数据

import '../mock/mock_config.dart';
import '../../shared/models/user.dart';
import '../../shared/models/product.dart';
import '../../shared/models/tag.dart';
import '../../shared/models/media_file.dart';

/// Mock 响应基类
class MockResponse<T> {
  final int code;
  final String message;
  final T? data;
  final int timestamp;

  MockResponse({
    this.code = 200,
    this.message = 'success',
    this.data,
    int? timestamp,
  }) : timestamp = timestamp ?? DateTime.now().millisecondsSinceEpoch;

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'message': message,
      'data': data,
      'timestamp': timestamp,
    };
  }
}

// ==================== 认证相关 Mock 数据 ====================

/// 登录响应
MockResponse<Map<String, dynamic>> get mockLoginResponse => MockResponse(
      code: 200,
      message: '登录成功',
      data: {
        'user': mockCurrentUser.toJson(),
        'token': MockUserData.token,
        'refreshToken': MockUserData.refreshToken,
        'expiresIn': 7200,
      },
    );

/// 注册响应
MockResponse<Map<String, dynamic>> get mockRegisterResponse => MockResponse(
      code: 200,
      message: '注册成功',
      data: {
        'user': mockCurrentUser.toJson(),
        'token': MockUserData.token,
        'refreshToken': MockUserData.refreshToken,
      },
    );

/// 发送短信验证码响应
MockResponse<String> get mockSendSmsResponse => MockResponse(
      code: 200,
      message: '验证码已发送',
      data: MockConfig.testSmsCode,
    );

/// Token 刷新响应
MockResponse<Map<String, dynamic>> get mockRefreshTokenResponse => MockResponse(
      code: 200,
      message: 'Token刷新成功',
      data: {
        'token': 'mock_new_jwt_token_${DateTime.now().millisecondsSinceEpoch}',
        'refreshToken': 'mock_new_refresh_token_${DateTime.now().millisecondsSinceEpoch}',
        'expiresIn': 7200,
      },
    );

// ==================== 用户相关 Mock 数据 ====================

/// 当前用户
User get mockCurrentUser => User(
      id: MockUserData.userId,
      nickname: MockUserData.nickname,
      avatar: MockUserData.avatar,
      bio: '热爱穿搭，分享生活',
      phone: MockUserData.phone,
      email: 'test@example.com',
      followersCount: 1256,
      followingCount: 89,
      postsCount: 42,
      isVerified: true,
      createdAt: DateTime(2024, 1, 15),
      updatedAt: DateTime.now(),
    );

/// 用户资料响应
MockResponse<User> get mockUserProfileResponse => MockResponse(
      code: 200,
      message: '获取用户资料成功',
      data: mockCurrentUser,
    );

/// 用户列表（用于粉丝/关注）
List<User> get mockUserList => [
      User(
        id: 'user_001',
        nickname: '时尚达人小美',
        avatar: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150',
        bio: '穿搭博主 | 坐标上海',
        followersCount: 5230,
        followingCount: 156,
        postsCount: 128,
        isVerified: true,
        createdAt: DateTime(2023, 6, 10),
      ),
      User(
        id: 'user_002',
        nickname: '简约生活',
        avatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150',
        bio: '极简主义穿搭爱好者',
        followersCount: 3456,
        followingCount: 234,
        postsCount: 89,
        isVerified: false,
        createdAt: DateTime(2023, 8, 20),
      ),
      User(
        id: 'user_003',
        nickname: '潮流前线',
        avatar: 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=150',
        bio: '街头风 | 运动穿搭',
        followersCount: 8923,
        followingCount: 56,
        postsCount: 256,
        isVerified: true,
        createdAt: DateTime(2023, 3, 5),
      ),
      User(
        id: 'user_004',
        nickname: '日系穿搭日记',
        avatar: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=150',
        bio: '温柔日系风',
        followersCount: 4567,
        followingCount: 189,
        postsCount: 167,
        isVerified: true,
        createdAt: DateTime(2023, 5, 15),
      ),
      User(
        id: 'user_005',
        nickname: '复古时光',
        avatar: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150',
        bio: 'Vintage爱好者',
        followersCount: 2345,
        followingCount: 312,
        postsCount: 78,
        isVerified: false,
        createdAt: DateTime(2023, 9, 1),
      ),
    ];

/// 粉丝列表响应
MockResponse<List<User>> get mockFollowersResponse => MockResponse(
      code: 200,
      message: '获取粉丝列表成功',
      data: mockUserList,
    );

/// 关注列表响应
MockResponse<List<User>> get mockFollowingResponse => MockResponse(
      code: 200,
      message: '获取关注列表成功',
      data: mockUserList,
    );

/// 关注操作响应
MockResponse<String> get mockFollowResponse => MockResponse(
      code: 200,
      message: '关注成功',
      data: 'user_001',
    );

/// 取消关注响应
MockResponse<String> get mockUnfollowResponse => MockResponse(
      code: 200,
      message: '取消关注成功',
      data: 'user_001',
    );

// ==================== 帖子相关 Mock 数据 ====================

/// 帖子模型（临时定义，实际项目中应创建 Post 模型）
class MockPost {
  final String id;
  final User author;
  final List<MediaFile> images;
  final List<Tag> tags;
  final String? content;
  final int likesCount;
  final int commentsCount;
  final int sharesCount;
  final int viewsCount;
  final bool isLiked;
  final bool isCollected;
  final List<String> topics;
  final DateTime createdAt;

  MockPost({
    required this.id,
    required this.author,
    required this.images,
    required this.tags,
    this.content,
    this.likesCount = 0,
    this.commentsCount = 0,
    this.sharesCount = 0,
    this.viewsCount = 0,
    this.isLiked = false,
    this.isCollected = false,
    this.topics = const [],
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'author': author.toJson(),
      'images': images.map((e) => _mediaFileToJson(e)).toList(),
      'tags': tags.map((e) => e.toJson()).toList(),
      'content': content,
      'likesCount': likesCount,
      'commentsCount': commentsCount,
      'sharesCount': sharesCount,
      'viewsCount': viewsCount,
      'isLiked': isLiked,
      'isCollected': isCollected,
      'topics': topics,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  Map<String, dynamic> _mediaFileToJson(MediaFile media) {
    return {
      'id': media.id,
      'path': media.path,
      'url': media.url,
      'type': media.type.name,
      'width': media.width,
      'height': media.height,
      'size': media.size,
      'createdAt': media.createdAt?.toIso8601String(),
    };
  }
}

/// Mock 商品列表
List<Product> get mockProductList => [
      Product(
        id: 'product_001',
        title: '2024新款宽松卫衣男女同款ins潮牌',
        imageUrl: 'https://images.unsplash.com/photo-1576566588028-4147f3842f27?w=400',
        originalPrice: 299.0,
        finalPrice: 159.0,
        commission: 15.9,
        platform: 'taobao',
        productUrl: 'https://item.taobao.com/item.htm?id=123456',
        taobaoPassword: '￥ABcdEF￥',
        salesCount: 5234,
        rating: 4.8,
        shopName: '潮流服饰旗舰店',
        createdAt: DateTime(2024, 1, 10),
      ),
      Product(
        id: 'product_002',
        title: '法式复古高腰阔腿裤女显瘦长裤',
        imageUrl: 'https://images.unsplash.com/photo-1541099649105-f69ad21f3246?w=400',
        originalPrice: 189.0,
        finalPrice: 89.0,
        commission: 8.9,
        platform: 'taobao',
        productUrl: 'https://item.taobao.com/item.htm?id=234567',
        salesCount: 8923,
        rating: 4.9,
        shopName: '优雅女装',
        createdAt: DateTime(2024, 1, 12),
      ),
      Product(
        id: 'product_003',
        title: '简约纯棉T恤男女同款基础款',
        imageUrl: 'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=400',
        originalPrice: 129.0,
        finalPrice: 49.0,
        commission: 4.9,
        platform: 'taobao',
        productUrl: 'https://item.taobao.com/item.htm?id=345678',
        salesCount: 15678,
        rating: 4.7,
        shopName: '基础款工厂店',
        createdAt: DateTime(2024, 1, 8),
      ),
      Product(
        id: 'product_004',
        title: '小香风毛呢外套女2024新款',
        imageUrl: 'https://images.unsplash.com/photo-1591047139829-d91aecb6caea?w=400',
        originalPrice: 599.0,
        finalPrice: 299.0,
        commission: 29.9,
        platform: 'jd',
        productUrl: 'https://item.jd.com/123456.html',
        salesCount: 2345,
        rating: 4.9,
        shopName: '高端女装',
        createdAt: DateTime(2024, 1, 5),
      ),
      Product(
        id: 'product_005',
        title: '运动休闲鞋男女同款跑步鞋',
        imageUrl: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=400',
        originalPrice: 459.0,
        finalPrice: 259.0,
        commission: 25.9,
        platform: 'taobao',
        productUrl: 'https://item.taobao.com/item.htm?id=456789',
        salesCount: 7890,
        rating: 4.6,
        shopName: '运动装备馆',
        createdAt: DateTime(2024, 1, 3),
      ),
    ];

/// Mock 帖子列表
List<MockPost> get mockPostList => [
      MockPost(
        id: 'post_001',
        author: mockUserList[0],
        images: [
          MediaFile(
            id: 'media_001',
            path: '/path/to/image1.jpg',
            url: 'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=800',
            type: MediaType.image,
            width: 1080,
            height: 1440,
            size: 1024000,
            createdAt: DateTime(2024, 1, 20),
          ),
        ],
        tags: [
          Tag(
            id: 'tag_001',
            imageIndex: 0,
            relativePosition: const Offset(0.3, 0.4),
            product: mockProductList[0],
            createdAt: DateTime(2024, 1, 20),
          ),
          Tag(
            id: 'tag_002',
            imageIndex: 0,
            relativePosition: const Offset(0.7, 0.6),
            product: mockProductList[1],
            createdAt: DateTime(2024, 1, 20),
          ),
        ],
        content: '今天的穿搭分享，卫衣配阔腿裤，舒适又时尚～',
        likesCount: 234,
        commentsCount: 45,
        sharesCount: 12,
        viewsCount: 1523,
        isLiked: false,
        isCollected: false,
        topics: ['日常穿搭', '舒适风'],
        createdAt: DateTime(2024, 1, 20, 14, 30),
      ),
      MockPost(
        id: 'post_002',
        author: mockUserList[1],
        images: [
          MediaFile(
            id: 'media_002',
            path: '/path/to/image2.jpg',
            url: 'https://images.unsplash.com/photo-1483985988355-763728e1935b?w=800',
            type: MediaType.image,
            width: 1080,
            height: 1080,
            size: 980000,
            createdAt: DateTime(2024, 1, 19),
          ),
        ],
        tags: [
          Tag(
            id: 'tag_003',
            imageIndex: 0,
            relativePosition: const Offset(0.5, 0.5),
            product: mockProductList[2],
            createdAt: DateTime(2024, 1, 19),
          ),
        ],
        content: '极简主义，一件白T恤就能穿出高级感',
        likesCount: 567,
        commentsCount: 89,
        sharesCount: 34,
        viewsCount: 3456,
        isLiked: true,
        isCollected: false,
        topics: ['极简', '基础款'],
        createdAt: DateTime(2024, 1, 19, 10, 15),
      ),
      MockPost(
        id: 'post_003',
        author: mockUserList[2],
        images: [
          MediaFile(
            id: 'media_003',
            path: '/path/to/image3.jpg',
            url: 'https://images.unsplash.com/photo-1509631179647-0177331693ae?w=800',
            type: MediaType.image,
            width: 1080,
            height: 1350,
            size: 1100000,
            createdAt: DateTime(2024, 1, 18),
          ),
        ],
        tags: [
          Tag(
            id: 'tag_004',
            imageIndex: 0,
            relativePosition: const Offset(0.4, 0.3),
            product: mockProductList[3],
            createdAt: DateTime(2024, 1, 18),
          ),
          Tag(
            id: 'tag_005',
            imageIndex: 0,
            relativePosition: const Offset(0.6, 0.7),
            product: mockProductList[4],
            createdAt: DateTime(2024, 1, 18),
          ),
        ],
        content: '街头风穿搭，运动鞋是灵魂！',
        likesCount: 892,
        commentsCount: 156,
        sharesCount: 67,
        viewsCount: 5678,
        isLiked: false,
        isCollected: true,
        topics: ['街头风', '运动风'],
        createdAt: DateTime(2024, 1, 18, 16, 45),
      ),
    ];

/// Feed 流响应
MockResponse<Map<String, dynamic>> get mockFeedResponse => MockResponse(
      code: 200,
      message: '获取Feed成功',
      data: {
        'list': mockPostList.map((e) => e.toJson()).toList(),
        'hasMore': true,
        'page': 1,
        'pageSize': 10,
        'total': 156,
      },
    );

/// 帖子详情响应
MockResponse<MockPost> get mockPostDetailResponse => MockResponse(
      code: 200,
      message: '获取帖子详情成功',
      data: mockPostList[0],
    );

/// 创建帖子响应
MockResponse<Map<String, dynamic>> get mockCreatePostResponse => MockResponse(
      code: 200,
      message: '发布成功',
      data: {
        'postId': 'post_new_001',
        'status': 'published',
        'createdAt': DateTime.now().toIso8601String(),
      },
    );

/// 更新帖子响应
MockResponse<String> get mockUpdatePostResponse => MockResponse(
      code: 200,
      message: '更新成功',
      data: 'post_001',
    );

/// 删除帖子响应
MockResponse<String> get mockDeletePostResponse => MockResponse(
      code: 200,
      message: '删除成功',
      data: 'post_001',
    );

/// 点赞响应
MockResponse<Map<String, dynamic>> get mockLikePostResponse => MockResponse(
      code: 200,
      message: '点赞成功',
      data: {
        'postId': 'post_001',
        'likesCount': 235,
        'isLiked': true,
      },
    );

/// 取消点赞响应
MockResponse<Map<String, dynamic>> get mockUnlikePostResponse => MockResponse(
      code: 200,
      message: '取消点赞成功',
      data: {
        'postId': 'post_001',
        'likesCount': 234,
        'isLiked': false,
      },
    );

/// 收藏响应
MockResponse<Map<String, dynamic>> get mockCollectPostResponse => MockResponse(
      code: 200,
      message: '收藏成功',
      data: {
        'postId': 'post_001',
        'isCollected': true,
      },
    );

/// 取消收藏响应
MockResponse<Map<String, dynamic>> get mockUncollectPostResponse => MockResponse(
      code: 200,
      message: '取消收藏成功',
      data: {
        'postId': 'post_001',
        'isCollected': false,
      },
    );

/// 分享响应
MockResponse<Map<String, dynamic>> get mockSharePostResponse => MockResponse(
      code: 200,
      message: '分享成功',
      data: {
        'postId': 'post_001',
        'sharesCount': 13,
        'shareUrl': 'https://app.jinrichuanda.com/post/001',
      },
    );

// ==================== 评论相关 Mock 数据 ====================

/// 评论模型
class MockComment {
  final String id;
  final String postId;
  final User author;
  final String content;
  final int likesCount;
  final bool isLiked;
  final String? replyToUserId;
  final String? replyToUserName;
  final List<MockComment>? replies;
  final DateTime createdAt;

  MockComment({
    required this.id,
    required this.postId,
    required this.author,
    required this.content,
    this.likesCount = 0,
    this.isLiked = false,
    this.replyToUserId,
    this.replyToUserName,
    this.replies,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'postId': postId,
      'author': author.toJson(),
      'content': content,
      'likesCount': likesCount,
      'isLiked': isLiked,
      'replyToUserId': replyToUserId,
      'replyToUserName': replyToUserName,
      'replies': replies?.map((e) => e.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

/// Mock 评论列表
List<MockComment> get mockCommentList => [
      MockComment(
        id: 'comment_001',
        postId: 'post_001',
        author: mockUserList[1],
        content: '这套穿搭太好看了！求链接～',
        likesCount: 45,
        isLiked: false,
        createdAt: DateTime(2024, 1, 20, 15, 30),
        replies: [
          MockComment(
            id: 'comment_001_1',
            postId: 'post_001',
            author: mockUserList[0],
            content: '点击图片上的标签就可以看到商品链接啦～',
            likesCount: 12,
            isLiked: false,
            replyToUserId: mockUserList[1].id,
            replyToUserName: mockUserList[1].nickname,
            createdAt: DateTime(2024, 1, 20, 15, 45),
          ),
        ],
      ),
      MockComment(
        id: 'comment_002',
        postId: 'post_001',
        author: mockUserList[2],
        content: '卫衣链接在哪里？',
        likesCount: 23,
        isLiked: true,
        createdAt: DateTime(2024, 1, 20, 16, 00),
      ),
      MockComment(
        id: 'comment_003',
        postId: 'post_001',
        author: mockUserList[3],
        content: '博主身材好好！',
        likesCount: 67,
        isLiked: false,
        createdAt: DateTime(2024, 1, 20, 16, 30),
      ),
    ];

/// 评论列表响应
MockResponse<Map<String, dynamic>> get mockCommentsResponse => MockResponse(
      code: 200,
      message: '获取评论列表成功',
      data: {
        'list': mockCommentList.map((e) => e.toJson()).toList(),
        'hasMore': true,
        'page': 1,
        'pageSize': 20,
        'total': 45,
      },
    );

/// 创建评论响应
MockResponse<MockComment> get mockCreateCommentResponse => MockResponse(
      code: 200,
      message: '评论成功',
      data: MockComment(
        id: 'comment_new_001',
        postId: 'post_001',
        author: mockCurrentUser,
        content: '好看！',
        likesCount: 0,
        isLiked: false,
        createdAt: DateTime.now(),
      ),
    );

/// 删除评论响应
MockResponse<String> get mockDeleteCommentResponse => MockResponse(
      code: 200,
      message: '删除评论成功',
      data: 'comment_001',
    );

/// 点赞评论响应
MockResponse<Map<String, dynamic>> get mockLikeCommentResponse => MockResponse(
      code: 200,
      message: '点赞成功',
      data: {
        'commentId': 'comment_001',
        'likesCount': 46,
        'isLiked': true,
      },
    );

/// 取消点赞评论响应
MockResponse<Map<String, dynamic>> get mockUnlikeCommentResponse => MockResponse(
      code: 200,
      message: '取消点赞成功',
      data: {
        'commentId': 'comment_001',
        'likesCount': 45,
        'isLiked': false,
      },
    );

// ==================== 商品相关 Mock 数据 ====================

/// 商品搜索响应
MockResponse<Map<String, dynamic>> get mockSearchProductResponse => MockResponse(
      code: 200,
      message: '搜索成功',
      data: {
        'list': mockProductList.map((e) {
          final json = {
            'id': e.id,
            'title': e.title,
            'imageUrl': e.imageUrl,
            'originalPrice': e.originalPrice,
            'finalPrice': e.finalPrice,
            'commission': e.commission,
            'platform': e.platform,
            'productUrl': e.productUrl,
            'taobaoPassword': e.taobaoPassword,
            'salesCount': e.salesCount,
            'rating': e.rating,
            'shopName': e.shopName,
            'createdAt': e.createdAt?.toIso8601String(),
          };
          return json;
        }).toList(),
        'hasMore': true,
        'page': 1,
        'pageSize': 20,
        'total': 156,
      },
    );

/// 商品详情响应
MockResponse<Product> get mockProductDetailResponse => MockResponse(
      code: 200,
      message: '获取商品详情成功',
      data: mockProductList[0],
    );

/// 转链响应
MockResponse<Map<String, dynamic>> get mockConvertLinkResponse => MockResponse(
      code: 200,
      message: '转链成功',
      data: {
        'productId': 'product_001',
        'originalUrl': 'https://item.taobao.com/item.htm?id=123456',
        'convertedUrl': 'https://s.click.taobao.com/xxx',
        'taobaoPassword': '￥ABcdEF￥',
        'commission': 15.9,
        'platform': 'taobao',
      },
    );

/// 解析淘口令响应
MockResponse<Map<String, dynamic>> get mockParseTaobaoPasswordResponse => MockResponse(
      code: 200,
      message: '解析成功',
      data: {
        'productId': 'product_001',
        'title': '2024新款宽松卫衣男女同款ins潮牌',
        'imageUrl': 'https://images.unsplash.com/photo-1576566588028-4147f3842f27?w=400',
        'originalPrice': 299.0,
        'finalPrice': 159.0,
        'commission': 15.9,
        'shopName': '潮流服饰旗舰店',
      },
    );

/// 收藏商品列表响应
MockResponse<Map<String, dynamic>> get mockGetFavoritesResponse => MockResponse(
      code: 200,
      message: '获取收藏列表成功',
      data: {
        'list': mockProductList.take(3).map((e) {
          final json = {
            'id': e.id,
            'title': e.title,
            'imageUrl': e.imageUrl,
            'originalPrice': e.originalPrice,
            'finalPrice': e.finalPrice,
            'commission': e.commission,
            'platform': e.platform,
            'productUrl': e.productUrl,
            'taobaoPassword': e.taobaoPassword,
            'salesCount': e.salesCount,
            'rating': e.rating,
            'shopName': e.shopName,
            'createdAt': e.createdAt?.toIso8601String(),
          };
          return json;
        }).toList(),
        'hasMore': false,
        'page': 1,
        'pageSize': 20,
        'total': 3,
      },
    );

/// 添加收藏响应
MockResponse<String> get mockAddFavoriteResponse => MockResponse(
      code: 200,
      message: '收藏成功',
      data: 'product_001',
    );

/// 取消收藏响应
MockResponse<String> get mockRemoveFavoriteResponse => MockResponse(
      code: 200,
      message: '取消收藏成功',
      data: 'product_001',
    );

// ==================== 上传相关 Mock 数据 ====================

/// 图片上传响应
MockResponse<Map<String, dynamic>> get mockUploadImageResponse => MockResponse(
      code: 200,
      message: '上传成功',
      data: {
        'url': 'https://cdn.example.com/images/upload_001.jpg',
        'path': '/images/upload_001.jpg',
        'width': 1080,
        'height': 1440,
        'size': 1024000,
      },
    );

/// 视频上传响应
MockResponse<Map<String, dynamic>> get mockUploadVideoResponse => MockResponse(
      code: 200,
      message: '上传成功',
      data: {
        'url': 'https://cdn.example.com/videos/upload_001.mp4',
        'path': '/videos/upload_001.mp4',
        'width': 1080,
        'height': 1920,
        'size': 15728640,
        'duration': 30,
        'thumbnail': 'https://cdn.example.com/videos/upload_001_thumb.jpg',
      },
    );

// ==================== 钱包/佣金相关 Mock 数据 ====================

/// 钱包信息
class MockWallet {
  final String userId;
  final double totalCommission;
  final double availableBalance;
  final double pendingBalance;
  final double withdrawnAmount;
  final int withdrawCount;

  MockWallet({
    required this.userId,
    required this.totalCommission,
    required this.availableBalance,
    required this.pendingBalance,
    required this.withdrawnAmount,
    required this.withdrawCount,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'totalCommission': totalCommission,
      'availableBalance': availableBalance,
      'pendingBalance': pendingBalance,
      'withdrawnAmount': withdrawnAmount,
      'withdrawCount': withdrawCount,
    };
  }
}

/// 钱包信息响应
MockResponse<MockWallet> get mockWalletResponse => MockResponse(
      code: 200,
      message: '获取钱包信息成功',
      data: MockWallet(
        userId: MockUserData.userId,
        totalCommission: 1234.56,
        availableBalance: 856.78,
        pendingBalance: 377.78,
        withdrawnAmount: 800.0,
        withdrawCount: 5,
      ),
    );

/// 佣金记录
class MockCommissionRecord {
  final String id;
  final String orderId;
  final String productName;
  final double amount;
  final double commission;
  final String status; // pending, settled, cancelled
  final DateTime createdAt;
  final DateTime? settledAt;

  MockCommissionRecord({
    required this.id,
    required this.orderId,
    required this.productName,
    required this.amount,
    required this.commission,
    required this.status,
    required this.createdAt,
    this.settledAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'orderId': orderId,
      'productName': productName,
      'amount': amount,
      'commission': commission,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'settledAt': settledAt?.toIso8601String(),
    };
  }
}

/// 佣金记录列表
List<MockCommissionRecord> get mockCommissionRecords => [
      MockCommissionRecord(
        id: 'commission_001',
        orderId: 'order_001',
        productName: '2024新款宽松卫衣男女同款ins潮牌',
        amount: 159.0,
        commission: 15.9,
        status: 'settled',
        createdAt: DateTime(2024, 1, 15),
        settledAt: DateTime(2024, 1, 18),
      ),
      MockCommissionRecord(
        id: 'commission_002',
        orderId: 'order_002',
        productName: '法式复古高腰阔腿裤女显瘦长裤',
        amount: 89.0,
        commission: 8.9,
        status: 'settled',
        createdAt: DateTime(2024, 1, 16),
        settledAt: DateTime(2024, 1, 19),
      ),
      MockCommissionRecord(
        id: 'commission_003',
        orderId: 'order_003',
        productName: '运动休闲鞋男女同款跑步鞋',
        amount: 259.0,
        commission: 25.9,
        status: 'pending',
        createdAt: DateTime(2024, 1, 20),
      ),
      MockCommissionRecord(
        id: 'commission_004',
        orderId: 'order_004',
        productName: '小香风毛呢外套女2024新款',
        amount: 299.0,
        commission: 29.9,
        status: 'pending',
        createdAt: DateTime(2024, 1, 21),
      ),
    ];

/// 佣金记录响应
MockResponse<Map<String, dynamic>> get mockCommissionHistoryResponse => MockResponse(
      code: 200,
      message: '获取佣金记录成功',
      data: {
        'list': mockCommissionRecords.map((e) => e.toJson()).toList(),
        'hasMore': true,
        'page': 1,
        'pageSize': 20,
        'total': 45,
      },
    );

/// 提现记录
class MockWithdrawRecord {
  final String id;
  final double amount;
  final String status; // pending, processing, completed, failed
  final String? account;
  final DateTime createdAt;
  final DateTime? completedAt;
  final String? remark;

  MockWithdrawRecord({
    required this.id,
    required this.amount,
    required this.status,
    this.account,
    required this.createdAt,
    this.completedAt,
    this.remark,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'status': status,
      'account': account,
      'createdAt': createdAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'remark': remark,
    };
  }
}

/// 提现记录列表
List<MockWithdrawRecord> get mockWithdrawRecords => [
      MockWithdrawRecord(
        id: 'withdraw_001',
        amount: 200.0,
        status: 'completed',
        account: '支付宝: 138****8000',
        createdAt: DateTime(2024, 1, 10),
        completedAt: DateTime(2024, 1, 12),
      ),
      MockWithdrawRecord(
        id: 'withdraw_002',
        amount: 300.0,
        status: 'completed',
        account: '支付宝: 138****8000',
        createdAt: DateTime(2024, 1, 15),
        completedAt: DateTime(2024, 1, 17),
      ),
      MockWithdrawRecord(
        id: 'withdraw_003',
        amount: 300.0,
        status: 'processing',
        account: '支付宝: 138****8000',
        createdAt: DateTime(2024, 1, 20),
      ),
    ];

/// 提现响应
MockResponse<Map<String, dynamic>> get mockWithdrawResponse => MockResponse(
      code: 200,
      message: '提现申请成功',
      data: {
        'withdrawId': 'withdraw_new_001',
        'amount': 100.0,
        'status': 'pending',
        'account': '支付宝: 138****8000',
        'createdAt': DateTime.now().toIso8601String(),
      },
    );

/// 提现记录响应
MockResponse<Map<String, dynamic>> get mockWithdrawHistoryResponse => MockResponse(
      code: 200,
      message: '获取提现记录成功',
      data: {
        'list': mockWithdrawRecords.map((e) => e.toJson()).toList(),
        'hasMore': false,
        'page': 1,
        'pageSize': 20,
        'total': 3,
      },
    );

// ==================== 数据分析相关 Mock 数据 ====================

/// GMV 趋势数据
class MockGMVTrendItem {
  final String date;
  final double amount;

  MockGMVTrendItem({required this.date, required this.amount});

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'amount': amount,
    };
  }
}

/// GMV 趋势数据列表
List<MockGMVTrendItem> get mockGMVTrendData => [
      MockGMVTrendItem(date: '2024-01-15', amount: 1234.5),
      MockGMVTrendItem(date: '2024-01-16', amount: 2345.6),
      MockGMVTrendItem(date: '2024-01-17', amount: 1876.3),
      MockGMVTrendItem(date: '2024-01-18', amount: 3456.7),
      MockGMVTrendItem(date: '2024-01-19', amount: 2890.4),
      MockGMVTrendItem(date: '2024-01-20', amount: 4123.8),
      MockGMVTrendItem(date: '2024-01-21', amount: 3678.9),
];

/// GMV 趋势响应
MockResponse<Map<String, dynamic>> get mockGMVTrendResponse => MockResponse(
      code: 200,
      message: '获取GMV趋势成功',
      data: {
        'period': '7d',
        'total': 19606.2,
        'trend': mockGMVTrendData.map((e) => e.toJson()).toList(),
      },
    );

/// 转化漏斗数据
class MockConversionFunnel {
  final String stage;
  final int count;
  final double rate;

  MockConversionFunnel({
    required this.stage,
    required this.count,
    required this.rate,
  });

  Map<String, dynamic> toJson() {
    return {
      'stage': stage,
      'count': count,
      'rate': rate,
    };
  }
}

/// 转化漏斗数据列表
List<MockConversionFunnel> get mockConversionFunnelData => [
      MockConversionFunnel(stage: '曝光', count: 10000, rate: 100.0),
      MockConversionFunnel(stage: '点击', count: 2500, rate: 25.0),
      MockConversionFunnel(stage: '加购', count: 500, rate: 20.0),
      MockConversionFunnel(stage: '成交', count: 100, rate: 20.0),
];

/// 转化漏斗响应
MockResponse<Map<String, dynamic>> get mockConversionFunnelResponse => MockResponse(
      code: 200,
      message: '获取转化漏斗成功',
      data: {
        'funnel': mockConversionFunnelData.map((e) => e.toJson()).toList(),
      },
    );

/// 类目分布数据
class MockCategoryDistribution {
  final String category;
  final int count;
  final double percentage;

  MockCategoryDistribution({
    required this.category,
    required this.count,
    required this.percentage,
  });

  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'count': count,
      'percentage': percentage,
    };
  }
}

/// 类目分布数据列表
List<MockCategoryDistribution> get mockCategoryDistributionData => [
      MockCategoryDistribution(category: '上衣', count: 45, percentage: 35.0),
      MockCategoryDistribution(category: '裤装', count: 28, percentage: 22.0),
      MockCategoryDistribution(category: '裙装', count: 20, percentage: 15.5),
      MockCategoryDistribution(category: '鞋履', count: 18, percentage: 14.0),
      MockCategoryDistribution(category: '配饰', count: 17, percentage: 13.5),
];

/// 类目分布响应
MockResponse<Map<String, dynamic>> get mockCategoryDistributionResponse => MockResponse(
      code: 200,
      message: '获取类目分布成功',
      data: {
        'distribution': mockCategoryDistributionData.map((e) => e.toJson()).toList(),
      },
    );

/// 数据分析汇总响应
MockResponse<Map<String, dynamic>> get mockAnalyticsResponse => MockResponse(
      code: 200,
      message: '获取数据分析成功',
      data: {
        'totalGMV': 19606.2,
        'totalOrders': 156,
        'totalCommission': 1234.56,
        'conversionRate': 20.0,
        'averageOrderValue': 125.68,
        'todayGMV': 3678.9,
        'todayOrders': 23,
        'todayCommission': 234.5,
      },
    );

// ==================== 草稿箱相关 Mock 数据 ====================

/// 草稿模型
class MockDraft {
  final String id;
  final String userId;
  final List<String> imagePaths;
  final List<Map<String, dynamic>> tags;
  final String? content;
  final List<String> topics;
  final DateTime createdAt;
  final DateTime? updatedAt;

  MockDraft({
    required this.id,
    required this.userId,
    required this.imagePaths,
    required this.tags,
    this.content,
    this.topics = const [],
    required this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'imagePaths': imagePaths,
      'tags': tags,
      'content': content,
      'topics': topics,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}

/// 草稿列表
List<MockDraft> get mockDraftList => [
      MockDraft(
        id: 'draft_001',
        userId: MockUserData.userId,
        imagePaths: ['/path/to/draft_image1.jpg', '/path/to/draft_image2.jpg'],
        tags: [
          {
            'id': 'tag_draft_001',
            'imageIndex': 0,
            'relativePosition': {'dx': 0.5, 'dy': 0.5},
            'productId': 'product_001',
          },
        ],
        content: '今日穿搭草稿',
        topics: ['日常', '舒适'],
        createdAt: DateTime(2024, 1, 21, 10, 30),
        updatedAt: DateTime(2024, 1, 21, 14, 45),
      ),
      MockDraft(
        id: 'draft_002',
        userId: MockUserData.userId,
        imagePaths: ['/path/to/draft_image3.jpg'],
        tags: [],
        content: '明天要发布的穿搭',
        topics: ['时尚', '街头风'],
        createdAt: DateTime(2024, 1, 20, 16, 20),
        updatedAt: DateTime(2024, 1, 20, 18, 30),
      ),
    ];

/// 草稿列表响应
MockResponse<Map<String, dynamic>> get mockDraftsResponse => MockResponse(
      code: 200,
      message: '获取草稿列表成功',
      data: {
        'list': mockDraftList.map((e) => e.toJson()).toList(),
        'hasMore': false,
        'page': 1,
        'pageSize': 20,
        'total': 2,
      },
    );

/// 保存草稿响应
MockResponse<Map<String, dynamic>> get mockSaveDraftResponse => MockResponse(
      code: 200,
      message: '保存草稿成功',
      data: {
        'draftId': 'draft_new_001',
        'createdAt': DateTime.now().toIso8601String(),
      },
    );

/// 删除草稿响应
MockResponse<String> get mockDeleteDraftResponse => MockResponse(
      code: 200,
      message: '删除草稿成功',
      data: 'draft_001',
    );

// ==================== 话题相关 Mock 数据 ====================

/// 话题列表
List<String> get mockTopicList => [
      '日常穿搭',
      '职场通勤',
      '约会穿搭',
      '运动风',
      '街头风',
      '极简风',
      '复古风',
      '日系',
      '韩系',
  '欧美风',
  '甜美风',
  '酷飒风',
  '休闲风',
  '正式场合',
  '度假风',
  '春秋穿搭',
  '夏季穿搭',
  '冬季穿搭',
];

/// 热门话题响应
MockResponse<List<String>> get mockHotTopicsResponse => MockResponse(
      code: 200,
      message: '获取热门话题成功',
      data: mockTopicList,
);

// ==================== 错误响应 Mock 数据 ====================

/// Token 过期错误响应
MockResponse<String> get mockTokenExpiredResponse => MockResponse(
      code: 401,
      message: 'Token已过期，请重新登录',
      data: null,
    );

/// 权限不足错误响应
MockResponse<String> get mockForbiddenResponse => MockResponse(
      code: 403,
      message: '权限不足',
      data: null,
    );

/// 资源不存在错误响应
MockResponse<String> get mockNotFoundResponse => MockResponse(
      code: 404,
      message: '资源不存在',
      data: null,
    );

/// 限流错误响应
MockResponse<String> get mockRateLimitResponse => MockResponse(
      code: 429,
      message: '操作太频繁，请稍后再试',
      data: null,
    );

/// 服务器错误响应
MockResponse<String> get mockServerErrorResponse => MockResponse(
      code: 500,
      message: '服务器繁忙，请稍后重试',
      data: null,
    );

/// 网络错误响应
MockResponse<String> get mockNetworkErrorResponse => MockResponse(
      code: -1,
      message: '网络连接失败，请检查网络设置',
      data: null,
);