import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../shared/models/tag.dart';
import '../../../feed/domain/entities/post_entity.dart';

/// 帖子详情页仓库接口
abstract class PostDetailRepository {
  /// 获取帖子详情
  Future<Either<Failure, PostEntity>> getPostDetail(String postId);

  /// 点赞帖子
  Future<Either<Failure, PostEntity>> likePost(String postId);

  /// 取消点赞帖子
  Future<Either<Failure, PostEntity>> unlikePost(String postId);

  /// 收藏帖子
  Future<Either<Failure, PostEntity>> collectPost(String postId);

  /// 取消收藏帖子
  Future<Either<Failure, PostEntity>> uncollectPost(String postId);

  /// 分享帖子
  Future<Either<Failure, Map<String, dynamic>>> sharePost(String postId);

  /// 关注用户
  Future<Either<Failure, void>> followUser(String userId);

  /// 取消关注用户
  Future<Either<Failure, void>> unfollowUser(String userId);

  /// 获取评论列表
  Future<Either<Failure, List<Map<String, dynamic>>>> getComments(
    String postId, {
    int page = 1,
    int pageSize = 20,
  });

  /// 创建评论
  Future<Either<Failure, Map<String, dynamic>>> createComment(
    String postId,
    String content, {
    String? replyToUserId,
  });
}