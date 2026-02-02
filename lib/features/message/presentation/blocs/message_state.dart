import 'package:equatable/equatable.dart';
import '../../domain/entities/message_entity.dart';

/// 消息状态基类
abstract class MessageState extends Equatable {
  const MessageState();

  @override
  List<Object?> get props => [];
}

/// 初始状态
class MessageInitial extends MessageState {
  const MessageInitial();
}

/// 加载中状态
class MessageLoading extends MessageState {
  const MessageLoading();
}

/// 加载完成状态（会话列表）
class MessageConversationsLoaded extends MessageState {
  final List<ConversationEntity> conversations;
  final int unreadCount;

  const MessageConversationsLoaded({
    required this.conversations,
    required this.unreadCount,
  });

  @override
  List<Object?> get props => [conversations, unreadCount];

  MessageConversationsLoaded copyWith({
    List<ConversationEntity>? conversations,
    int? unreadCount,
  }) {
    return MessageConversationsLoaded(
      conversations: conversations ?? this.conversations,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }
}

/// 加载完成状态（通知列表）
class MessageNotificationsLoaded extends MessageState {
  final List<NotificationEntity> notifications;
  final int unreadCount;

  const MessageNotificationsLoaded({
    required this.notifications,
    required this.unreadCount,
  });

  @override
  List<Object?> get props => [notifications, unreadCount];

  MessageNotificationsLoaded copyWith({
    List<NotificationEntity>? notifications,
    int? unreadCount,
  }) {
    return MessageNotificationsLoaded(
      notifications: notifications ?? this.notifications,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }
}

/// 错误状态
class MessageError extends MessageState {
  final String message;

  const MessageError({required this.message});

  @override
  List<Object?> get props => [message];
}