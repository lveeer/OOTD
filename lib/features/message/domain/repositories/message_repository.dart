import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../shared/models/message.dart';
import '../entities/message_entity.dart';

/// 消息仓库接口
abstract class MessageRepository {
  /// 获取会话列表
  Future<Either<Failure, List<ConversationEntity>>> getConversations();

  /// 获取会话消息列表
  Future<Either<Failure, List<MessageEntity>>> getMessages({
    required String conversationId,
    int limit = 20,
    String? lastMessageId,
  });

  /// 发送消息
  Future<Either<Failure, MessageEntity>> sendMessage({
    required String conversationId,
    required String content,
    MessageType type = MessageType.text,
    Map<String, dynamic>? metadata,
  });

  /// 标记消息已读
  Future<Either<Failure, void>> markAsRead({
    required String conversationId,
  });

  /// 获取系统通知列表
  Future<Either<Failure, List<NotificationEntity>>> getNotifications({
    int limit = 20,
    String? lastNotificationId,
  });

  /// 标记通知已读
  Future<Either<Failure, void>> markNotificationAsRead({
    required String notificationId,
  });

  /// 获取未读消息总数
  Future<Either<Failure, int>> getUnreadCount();

  /// 获取未读通知总数
  Future<Either<Failure, int>> getNotificationUnreadCount();
}