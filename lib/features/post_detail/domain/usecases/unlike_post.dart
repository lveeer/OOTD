import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/post_detail_repository.dart';
import '../../../feed/domain/entities/post_entity.dart';

/// 取消点赞帖子用例
class UnlikePost implements UseCase<PostEntity, String> {
  final PostDetailRepository repository;

  UnlikePost(this.repository);

  @override
  Future<Either<Failure, PostEntity>> call(String postId) {
    return repository.unlikePost(postId);
  }
}