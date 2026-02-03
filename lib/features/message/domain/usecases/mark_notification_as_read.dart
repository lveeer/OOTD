import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/message_repository.dart';

/// 标记通知已读用例
@injectable
class MarkNotificationAsRead {
  final MessageRepository repository;

  MarkNotificationAsRead(this.repository);

  Future<Either<Failure, void>> call({
    required String notificationId,
  }) {
    return repository.markNotificationAsRead(notificationId: notificationId);
  }
}