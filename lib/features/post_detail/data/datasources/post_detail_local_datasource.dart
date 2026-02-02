import '../../../../core/mock/mock_data.dart';
import '../../../feed/domain/entities/post_entity.dart';

/// 帖子详情页本地数据源（Mock）
class PostDetailLocalDataSource {
  /// 获取帖子详情
  Future<PostEntity> getPostDetail(String postId) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final mockPost = mockPostList.firstWhere(
      (post) => post.id == postId,
      orElse: () => mockPostList[0],
    );

    return PostEntity(
      id: mockPost.id,
      content: mockPost.content ?? '',
      author: mockPost.author,
      images: mockPost.images,
      tags: mockPost.tags,
      likesCount: mockPost.likesCount,
      commentsCount: mockPost.commentsCount,
      sharesCount: mockPost.sharesCount,
      isLiked: mockPost.isLiked,
      isCollected: mockPost.isCollected,
      topics: mockPost.topics,
      createdAt: mockPost.createdAt,
    );
  }

  /// 点赞帖子
  Future<PostEntity> likePost(String postId) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final mockPost = mockPostList.firstWhere(
      (post) => post.id == postId,
      orElse: () => mockPostList[0],
    );

    return PostEntity(
      id: mockPost.id,
      content: mockPost.content ?? '',
      author: mockPost.author,
      images: mockPost.images,
      tags: mockPost.tags,
      likesCount: mockPost.likesCount + 1,
      commentsCount: mockPost.commentsCount,
      sharesCount: mockPost.sharesCount,
      isLiked: true,
      isCollected: mockPost.isCollected,
      topics: mockPost.topics,
      createdAt: mockPost.createdAt,
    );
  }

  /// 取消点赞帖子
  Future<PostEntity> unlikePost(String postId) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final mockPost = mockPostList.firstWhere(
      (post) => post.id == postId,
      orElse: () => mockPostList[0],
    );

    return PostEntity(
      id: mockPost.id,
      content: mockPost.content ?? '',
      author: mockPost.author,
      images: mockPost.images,
      tags: mockPost.tags,
      likesCount: mockPost.likesCount - 1,
      commentsCount: mockPost.commentsCount,
      sharesCount: mockPost.sharesCount,
      isLiked: false,
      isCollected: mockPost.isCollected,
      topics: mockPost.topics,
      createdAt: mockPost.createdAt,
    );
  }

  /// 收藏帖子
  Future<PostEntity> collectPost(String postId) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final mockPost = mockPostList.firstWhere(
      (post) => post.id == postId,
      orElse: () => mockPostList[0],
    );

    return PostEntity(
      id: mockPost.id,
      content: mockPost.content ?? '',
      author: mockPost.author,
      images: mockPost.images,
      tags: mockPost.tags,
      likesCount: mockPost.likesCount,
      commentsCount: mockPost.commentsCount,
      sharesCount: mockPost.sharesCount,
      isLiked: mockPost.isLiked,
      isCollected: true,
      topics: mockPost.topics,
      createdAt: mockPost.createdAt,
    );
  }

  /// 取消收藏帖子
  Future<PostEntity> uncollectPost(String postId) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final mockPost = mockPostList.firstWhere(
      (post) => post.id == postId,
      orElse: () => mockPostList[0],
    );

    return PostEntity(
      id: mockPost.id,
      content: mockPost.content ?? '',
      author: mockPost.author,
      images: mockPost.images,
      tags: mockPost.tags,
      likesCount: mockPost.likesCount,
      commentsCount: mockPost.commentsCount,
      sharesCount: mockPost.sharesCount,
      isLiked: mockPost.isLiked,
      isCollected: false,
      topics: mockPost.topics,
      createdAt: mockPost.createdAt,
    );
  }

  /// 分享帖子
  Future<Map<String, dynamic>> sharePost(String postId) async {
    await Future.delayed(const Duration(milliseconds: 300));

    return {
      'postId': postId,
      'sharesCount': 13,
      'shareUrl': 'https://app.jinrichuanda.com/post/$postId',
    };
  }

  /// 关注用户
  Future<void> followUser(String userId) async {
    await Future.delayed(const Duration(milliseconds: 300));
  }

  /// 取消关注用户
  Future<void> unfollowUser(String userId) async {
    await Future.delayed(const Duration(milliseconds: 300));
  }

  /// 获取评论列表
  Future<List<Map<String, dynamic>>> getComments(
    String postId, {
    int page = 1,
    int pageSize = 20,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));

    return mockCommentList.map((comment) {
      return {
        'id': comment.id,
        'postId': comment.postId,
        'author': comment.author,
        'content': comment.content,
        'likesCount': comment.likesCount,
        'isLiked': comment.isLiked,
        'replyToUserId': comment.replyToUserId,
        'replyToUserName': comment.replyToUserName,
        'replies': comment.replies?.map((r) => {
          'id': r.id,
          'postId': r.postId,
          'author': r.author,
          'content': r.content,
          'likesCount': r.likesCount,
          'isLiked': r.isLiked,
          'replyToUserId': r.replyToUserId,
          'replyToUserName': r.replyToUserName,
          'createdAt': r.createdAt,
        }).toList(),
        'createdAt': comment.createdAt,
      };
    }).toList();
  }

  /// 创建评论
  Future<Map<String, dynamic>> createComment(
    String postId,
    String content, {
    String? replyToUserId,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));

    return {
      'id': 'comment_new_${DateTime.now().millisecondsSinceEpoch}',
      'postId': postId,
      'author': mockCurrentUser,
      'content': content,
      'likesCount': 0,
      'isLiked': false,
      'replyToUserId': replyToUserId,
      'replyToUserName': replyToUserId != null ? '用户' : null,
      'replies': <Map<String, dynamic>>[],
      'createdAt': DateTime.now(),
    };
  }
}