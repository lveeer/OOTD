import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/post_detail_repository.dart';
import '../../../feed/domain/entities/post_entity.dart';

/// 取消收藏帖子用例
class UncollectPost implements UseCase<PostEntity, String> {
  final PostDetailRepository repository;

  UncollectPost(this.repository);

  @override
  Future<Either<Failure, PostEntity>> call(String postId) {
    return repository.uncollectPost(postId);
  }
}