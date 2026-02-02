import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../feed/domain/entities/post_entity.dart';
import '../datasources/post_detail_local_datasource.dart';
import '../../domain/repositories/post_detail_repository.dart';

/// 帖子详情页仓库实现
class PostDetailRepositoryImpl implements PostDetailRepository {
  final PostDetailLocalDataSource localDataSource;

  PostDetailRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, PostEntity>> getPostDetail(String postId) async {
    try {
      final post = await localDataSource.getPostDetail(postId);
      return Right(post);
    } on ServerException {
      return Left(const ServerFailure(message: '服务器错误'));
    }
  }

  @override
  Future<Either<Failure, PostEntity>> likePost(String postId) async {
    try {
      final post = await localDataSource.likePost(postId);
      return Right(post);
    } on ServerException {
      return Left(const ServerFailure(message: '服务器错误'));
    }
  }

  @override
  Future<Either<Failure, PostEntity>> unlikePost(String postId) async {
    try {
      final post = await localDataSource.unlikePost(postId);
      return Right(post);
    } on ServerException {
      return Left(const ServerFailure(message: '服务器错误'));
    }
  }

  @override
  Future<Either<Failure, PostEntity>> collectPost(String postId) async {
    try {
      final post = await localDataSource.collectPost(postId);
      return Right(post);
    } on ServerException {
      return Left(const ServerFailure(message: '服务器错误'));
    }
  }

  @override
  Future<Either<Failure, PostEntity>> uncollectPost(String postId) async {
    try {
      final post = await localDataSource.uncollectPost(postId);
      return Right(post);
    } on ServerException {
      return Left(const ServerFailure(message: '服务器错误'));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> sharePost(String postId) async {
    try {
      final result = await localDataSource.sharePost(postId);
      return Right(result);
    } on ServerException {
      return Left(const ServerFailure(message: '服务器错误'));
    }
  }

  @override
  Future<Either<Failure, void>> followUser(String userId) async {
    try {
      await localDataSource.followUser(userId);
      return const Right(null);
    } on ServerException {
      return Left(const ServerFailure(message: '服务器错误'));
    }
  }

  @override
  Future<Either<Failure, void>> unfollowUser(String userId) async {
    try {
      await localDataSource.unfollowUser(userId);
      return const Right(null);
    } on ServerException {
      return Left(const ServerFailure(message: '服务器错误'));
    }
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> getComments(
    String postId, {
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final comments = await localDataSource.getComments(
        postId,
        page: page,
        pageSize: pageSize,
      );
      return Right(comments);
    } on ServerException {
      return Left(const ServerFailure(message: '服务器错误'));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> createComment(
    String postId,
    String content, {
    String? replyToUserId,
  }) async {
    try {
      final comment = await localDataSource.createComment(
        postId,
        content,
        replyToUserId: replyToUserId,
      );
      return Right(comment);
    } on ServerException {
      return Left(const ServerFailure(message: '服务器错误'));
    }
  }
}