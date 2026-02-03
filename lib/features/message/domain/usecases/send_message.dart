import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../shared/models/message.dart';
import '../entities/message_entity.dart';
import '../repositories/message_repository.dart';

class SendMessageParams {
  final String conversationId;
  final String content;
  final MessageType type;
  final Map<String, dynamic>? metadata;

  SendMessageParams({
    required this.conversationId,
    required this.content,
    this.type = MessageType.text,
    this.metadata,
  });
}

@injectable
class SendMessage implements UseCase<MessageEntity, SendMessageParams> {
  final MessageRepository repository;

  SendMessage(this.repository);

  @override
  Future<Either<Failure, MessageEntity>> call(
    SendMessageParams params,
  ) async {
    return repository.sendMessage(
      conversationId: params.conversationId,
      content: params.content,
      type: params.type,
      metadata: params.metadata,
    );
  }
}