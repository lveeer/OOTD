import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/message_repository.dart';

class MarkMessagesAsReadParams {
  final String conversationId;

  MarkMessagesAsReadParams({required this.conversationId});
}

@injectable
class MarkMessagesAsRead implements UseCase<void, MarkMessagesAsReadParams> {
  final MessageRepository repository;

  MarkMessagesAsRead(this.repository);

  @override
  Future<Either<Failure, void>> call(
    MarkMessagesAsReadParams params,
  ) async {
    return repository.markAsRead(
      conversationId: params.conversationId,
    );
  }
}