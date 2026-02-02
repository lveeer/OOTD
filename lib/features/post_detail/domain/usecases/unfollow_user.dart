import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/post_detail_repository.dart';

/// 取消关注用户用例
class UnfollowUser implements UseCase<void, String> {
  final PostDetailRepository repository;

  UnfollowUser(this.repository);

  @override
  Future<Either<Failure, void>> call(String userId) {
    return repository.unfollowUser(userId);
  }
}