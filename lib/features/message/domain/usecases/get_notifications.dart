import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/message_entity.dart';
import '../repositories/message_repository.dart';

/// 获取系统通知列表用例
class GetNotifications implements UseCase<List<NotificationEntity>, NoParams> {
  final MessageRepository repository;

  GetNotifications(this.repository);

  @override
  Future<Either<Failure, List<NotificationEntity>>> call(NoParams params) {
    return repository.getNotifications();
  }
}