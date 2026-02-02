import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/post_detail_repository.dart';
import '../../../feed/domain/entities/post_entity.dart';

/// 收藏帖子用例
class CollectPost implements UseCase<PostEntity, String> {
  final PostDetailRepository repository;

  CollectPost(this.repository);

  @override
  Future<Either<Failure, PostEntity>> call(String postId) {
    return repository.collectPost(postId);
  }
}