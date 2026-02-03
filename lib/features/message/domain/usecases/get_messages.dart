import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/message_entity.dart';
import '../repositories/message_repository.dart';

class GetMessagesParams {
  final String conversationId;
  final int page;
  final int pageSize;

  GetMessagesParams({
    required this.conversationId,
    this.page = 1,
    this.pageSize = 20,
  });
}

@injectable
class GetMessages implements UseCase<List<MessageEntity>, GetMessagesParams> {
  final MessageRepository repository;

  GetMessages(this.repository);

  @override
  Future<Either<Failure, List<MessageEntity>>> call(
    GetMessagesParams params,
  ) async {
    return repository.getMessages(
      conversationId: params.conversationId,
      limit: params.pageSize,
    );
  }
}