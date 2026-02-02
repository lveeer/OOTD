import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/post_detail_repository.dart';
import '../../../feed/domain/entities/post_entity.dart';

/// 获取帖子详情用例
class GetPostDetail implements UseCase<PostEntity, String> {
  final PostDetailRepository repository;

  GetPostDetail(this.repository);

  @override
  Future<Either<Failure, PostEntity>> call(String postId) {
    return repository.getPostDetail(postId);
  }
}