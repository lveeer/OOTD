import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/message_entity.dart';
import '../repositories/message_repository.dart';

/// 获取会话列表用例
class GetConversations implements UseCase<List<ConversationEntity>, NoParams> {
  final MessageRepository repository;

  GetConversations(this.repository);

  @override
  Future<Either<Failure, List<ConversationEntity>>> call(NoParams params) {
    return repository.getConversations();
  }
}