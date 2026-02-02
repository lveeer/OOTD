import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/message_repository.dart';

/// 标记消息已读用例
class MarkAsRead {
  final MessageRepository repository;

  MarkAsRead(this.repository);

  Future<Either<Failure, void>> call({
    required String conversationId,
  }) {
    return repository.markAsRead(conversationId: conversationId);
  }
}