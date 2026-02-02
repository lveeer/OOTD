import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../shared/models/message.dart';
import '../../domain/entities/message_entity.dart';
import '../../domain/repositories/message_repository.dart';
import '../datasources/message_local_datasource.dart';

/// 消息仓库实现
class MessageRepositoryImpl implements MessageRepository {
  final MessageLocalDataSource localDataSource;

  MessageRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<ConversationEntity>>> getConversations() async {
    try {
      final conversations = await localDataSource.getConversations();
      return Right(conversations);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<MessageEntity>>> getMessages({
    required String conversationId,
    int limit = 20,
    String? lastMessageId,
  }) async {
    try {
      // TODO: 实现获取消息列表逻辑
      return const Right([]);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, MessageEntity>> sendMessage({
    required String conversationId,
    required String content,
    MessageType type = MessageType.text,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      // TODO: 实现发送消息逻辑
      throw UnimplementedError();
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> markAsRead({
    required String conversationId,
  }) async {
    try {
      // TODO: 实现标记已读逻辑
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<NotificationEntity>>> getNotifications({
    int limit = 20,
    String? lastNotificationId,
  }) async {
    try {
      final notifications = await localDataSource.getNotifications();
      return Right(notifications);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> markNotificationAsRead({
    required String notificationId,
  }) async {
    try {
      // TODO: 实现标记通知已读逻辑
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, int>> getUnreadCount() async {
    try {
      final conversations = await localDataSource.getConversations();
      final unreadCount = conversations.fold<int>(
        0,
        (sum, conv) => sum + conv.unreadCount,
      );
      return Right(unreadCount);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, int>> getNotificationUnreadCount() async {
    try {
      final notifications = await localDataSource.getNotifications();
      final unreadCount = notifications.where((n) => !n.isRead).length;
      return Right(unreadCount);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}