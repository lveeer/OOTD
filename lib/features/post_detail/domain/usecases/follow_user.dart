import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/post_detail_repository.dart';

/// 关注用户用例
class FollowUser implements UseCase<void, String> {
  final PostDetailRepository repository;

  FollowUser(this.repository);

  @override
  Future<Either<Failure, void>> call(String userId) {
    return repository.followUser(userId);
  }
}