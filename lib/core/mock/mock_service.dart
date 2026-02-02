/// Mock 服务
/// 统一管理所有 Mock 数据的获取和响应

import 'dart:convert';
import 'mock_config.dart';
import 'mock_data.dart';

/// Mock 服务类
class MockService {
  /// 是否启用 Mock 模式
  static bool get enabled => MockConfig.enabled;

  /// 根据 API 端点获取 Mock 响应
  static Map<String, dynamic> getMockResponse(String endpoint, {
    Map<String, dynamic>? params,
    Map<String, dynamic>? body,
  }) {
    final response = _getMockResponseByEndpoint(endpoint, params: params, body: body);
    return response.toJson();
  }

  /// 根据 API 端点返回对应的 Mock 响应对象
  static MockResponse _getMockResponseByEndpoint(String endpoint, {
    Map<String, dynamic>? params,
    Map<String, dynamic>? body,
  }) {
    switch (endpoint) {
      // ==================== 认证相关 ====================
      case '/auth/login':
        return mockLoginResponse;
      case '/auth/register':
        return mockRegisterResponse;
      case '/auth/sms/send':
        return mockSendSmsResponse;
      case '/auth/sms/verify':
        return MockResponse(code: 200, message: '验证成功', data: true);
      case '/auth/refresh':
        return mockRefreshTokenResponse;
      case '/auth/logout':
        return MockResponse(code: 200, message: '退出成功', data: null);

      // ==================== 用户相关 ====================
      case '/user/profile':
        return mockUserProfileResponse;
      case '/user/profile/update':
        return MockResponse(code: 200, message: '更新成功', data: mockCurrentUser.toJson());
      case '/user/follow':
        return mockFollowResponse;
      case '/user/unfollow':
        return mockUnfollowResponse;
      case '/user/followers':
        return mockFollowersResponse;
      case '/user/following':
        return mockFollowingResponse;

      // ==================== 帖子相关 ====================
      case '/posts/feed':
        return mockFeedResponse;
      case '/posts':
        if (params?['id'] != null || body?['id'] != null) {
          return mockPostDetailResponse;
        }
        return mockCreatePostResponse;
      case '/posts/update':
        return mockUpdatePostResponse;
      case '/posts/delete':
        return mockDeletePostResponse;
      case '/posts/like':
        return mockLikePostResponse;
      case '/posts/unlike':
        return mockUnlikePostResponse;
      case '/posts/collect':
        return mockCollectPostResponse;
      case '/posts/uncollect':
        return mockUncollectPostResponse;
      case '/posts/share':
        return mockSharePostResponse;

      // ==================== 评论相关 ====================
      case '/comments':
        if (body?['action'] == 'create') {
          return mockCreateCommentResponse;
        }
        return mockCommentsResponse;
      case '/comments/delete':
        return mockDeleteCommentResponse;
      case '/comments/like':
        return mockLikeCommentResponse;
      case '/comments/unlike':
        return mockUnlikeCommentResponse;

      // ==================== 商品相关 ====================
      case '/products/search':
        return mockSearchProductResponse;
      case '/products/detail':
        return mockProductDetailResponse;
      case '/products/convert-link':
        return mockConvertLinkResponse;
      case '/products/parse-taobao-password':
        return mockParseTaobaoPasswordResponse;
      case '/products/favorites':
        if (body?['action'] == 'add') {
          return mockAddFavoriteResponse;
        } else if (body?['action'] == 'remove') {
          return mockRemoveFavoriteResponse;
        }
        return mockGetFavoritesResponse;

      // ==================== 上传相关 ====================
      case '/upload/image':
        return mockUploadImageResponse;
      case '/upload/video':
        return mockUploadVideoResponse;

      // ==================== 钱包/佣金相关 ====================
      case '/wallet':
        return mockWalletResponse;
      case '/wallet/commission':
        return mockCommissionHistoryResponse;
      case '/wallet/withdraw':
        return mockWithdrawResponse;
      case '/wallet/withdraw/history':
        return mockWithdrawHistoryResponse;

      // ==================== 数据分析相关 ====================
      case '/analytics':
        return mockAnalyticsResponse;
      case '/analytics/gmv-trend':
        return mockGMVTrendResponse;
      case '/analytics/conversion-funnel':
        return mockConversionFunnelResponse;
      case '/analytics/category-distribution':
        return mockCategoryDistributionResponse;

      // ==================== 草稿箱相关 ====================
      case '/drafts':
        if (body?['action'] == 'save') {
          return mockSaveDraftResponse;
        } else if (body?['action'] == 'delete') {
          return mockDeleteDraftResponse;
        }
        return mockDraftsResponse;

      // ==================== 话题相关 ====================
      case '/topics/hot':
        return mockHotTopicsResponse;

      // ==================== 默认响应 ====================
      default:
        return MockResponse(
          code: 404,
          message: 'Mock数据不存在: $endpoint',
          data: null,
        );
    }
  }

  /// 模拟网络延迟
  static Future<Map<String, dynamic>> getMockResponseAsync(String endpoint, {
    Map<String, dynamic>? params,
    Map<String, dynamic>? body,
    int delayMs = 300,
  }) async {
    await Future.delayed(Duration(milliseconds: delayMs));
    return getMockResponse(endpoint, params: params, body: body);
  }

  /// 模拟错误响应
  static Map<String, dynamic> getErrorResponse(String endpoint) {
    // 根据端点返回特定的错误
    if (endpoint.contains('/auth/')) {
      return mockTokenExpiredResponse.toJson();
    } else if (endpoint.contains('/posts/')) {
      return mockNotFoundResponse.toJson();
    } else {
      return mockServerErrorResponse.toJson();
    }
  }

  /// 模拟网络错误
  static Map<String, dynamic> getNetworkError() {
    return mockNetworkErrorResponse.toJson();
  }

  /// 搜索商品（支持关键词过滤）
  static Map<String, dynamic> searchProducts(String keyword) {
    final allProducts = mockProductList;
    final filteredProducts = allProducts.where((product) {
      return product.title.toLowerCase().contains(keyword.toLowerCase());
    }).toList();

    return MockResponse(
      code: 200,
      message: '搜索成功',
      data: {
        'list': filteredProducts.map((e) => {
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
        }).toList(),
        'hasMore': false,
        'page': 1,
        'pageSize': 20,
        'total': filteredProducts.length,
      },
    ).toJson();
  }

  /// 获取用户草稿
  static Map<String, dynamic> getUserDrafts(String userId) {
    final userDrafts = mockDraftList.where((draft) => draft.userId == userId).toList();
    return MockResponse(
      code: 200,
      message: '获取草稿列表成功',
      data: {
        'list': userDrafts.map((e) => e.toJson()).toList(),
        'hasMore': false,
        'page': 1,
        'pageSize': 20,
        'total': userDrafts.length,
      },
    ).toJson();
  }

  /// 分页获取 Feed 流
  static Map<String, dynamic> getFeedPaginated(int page, int pageSize) {
    final startIndex = (page - 1) * pageSize;
    final endIndex = startIndex + pageSize;
    
    final paginatedPosts = startIndex < mockPostList.length
        ? mockPostList.sublist(
            startIndex,
            endIndex > mockPostList.length ? mockPostList.length : endIndex,
          )
        : <MockPost>[];

    return MockResponse(
      code: 200,
      message: '获取Feed成功',
      data: {
        'list': paginatedPosts.map((e) => e.toJson()).toList(),
        'hasMore': endIndex < mockPostList.length,
        'page': page,
        'pageSize': pageSize,
        'total': mockPostList.length,
      },
    ).toJson();
  }

  /// 分页获取评论
  static Map<String, dynamic> getCommentsPaginated(String postId, int page, int pageSize) {
    final startIndex = (page - 1) * pageSize;
    final endIndex = startIndex + pageSize;
    
    final paginatedComments = startIndex < mockCommentList.length
        ? mockCommentList.sublist(
            startIndex,
            endIndex > mockCommentList.length ? mockCommentList.length : endIndex,
          )
        : <MockComment>[];

    return MockResponse(
      code: 200,
      message: '获取评论列表成功',
      data: {
        'list': paginatedComments.map((e) => e.toJson()).toList(),
        'hasMore': endIndex < mockCommentList.length,
        'page': page,
        'pageSize': pageSize,
        'total': mockCommentList.length,
      },
    ).toJson();
  }

  /// 根据时间范围获取 GMV 趋势
  static Map<String, dynamic> getGMVTrendByPeriod(String period) {
    // 根据不同时间范围返回不同数据
    List<MockGMVTrendItem> trendData;
    switch (period) {
      case '7d':
        trendData = mockGMVTrendData;
        break;
      case '30d':
        // 生成30天的模拟数据
        trendData = List.generate(30, (index) {
          final date = DateTime.now().subtract(Duration(days: 29 - index));
          return MockGMVTrendItem(
            date: '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}',
            amount: 1000 + (index * 50) + (index % 3 * 100),
          );
        });
        break;
      case '90d':
        // 生成90天的模拟数据
        trendData = List.generate(90, (index) {
          final date = DateTime.now().subtract(Duration(days: 89 - index));
          return MockGMVTrendItem(
            date: '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}',
            amount: 800 + (index * 30) + (index % 5 * 80),
          );
        });
        break;
      default:
        trendData = mockGMVTrendData;
    }

    final total = trendData.fold<double>(0, (sum, item) => sum + item.amount);

    return MockResponse(
      code: 200,
      message: '获取GMV趋势成功',
      data: {
        'period': period,
        'total': total,
        'trend': trendData.map((e) => e.toJson()).toList(),
      },
    ).toJson();
  }

  /// 搜索话题
  static Map<String, dynamic> searchTopics(String keyword) {
    final filteredTopics = mockTopicList.where((topic) {
      return topic.toLowerCase().contains(keyword.toLowerCase());
    }).toList();

    return MockResponse(
      code: 200,
      message: '搜索话题成功',
      data: filteredTopics,
    ).toJson();
  }

  /// 获取热门话题
  static Map<String, dynamic> getHotTopics({int limit = 10}) {
    final hotTopics = mockTopicList.take(limit).toList();
    return MockResponse(
      code: 200,
      message: '获取热门话题成功',
      data: hotTopics,
    ).toJson();
  }

  /// 导出所有 Mock 数据（用于测试）
  static Map<String, dynamic> exportAllMockData() {
    return {
      'config': {
        'enabled': MockConfig.enabled,
        'testPhone': MockConfig.testPhone,
        'testSmsCode': MockConfig.testSmsCode,
        'testNickname': MockConfig.testNickname,
      },
      'user': mockCurrentUser.toJson(),
      'userList': mockUserList.map((e) => e.toJson()).toList(),
      'productList': mockProductList.map((e) => {
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
      }).toList(),
      'postList': mockPostList.map((e) => e.toJson()).toList(),
      'commentList': mockCommentList.map((e) => e.toJson()).toList(),
      'draftList': mockDraftList.map((e) => e.toJson()).toList(),
      'topicList': mockTopicList,
      'commissionRecords': mockCommissionRecords.map((e) => e.toJson()).toList(),
      'withdrawRecords': mockWithdrawRecords.map((e) => e.toJson()).toList(),
    };
  }

  /// 打印所有 Mock 数据（用于调试）
  static void printAllMockData() {
    final allData = exportAllMockData();
    print('=== Mock 数据导出 ===');
    print(const JsonEncoder.withIndent('  ').convert(allData));
  }
}