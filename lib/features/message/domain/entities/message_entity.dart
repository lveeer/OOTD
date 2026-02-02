import '../../../../shared/models/message.dart';

/// 消息领域实体
class MessageEntity {
  final String id;
  final String conversationId;
  final String senderId;
  final String content;
  final MessageType type;
  final DateTime createdAt;
  final bool isRead;
  final Map<String, dynamic>? metadata;

  const MessageEntity({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.content,
    required this.type,
    required this.createdAt,
    this.isRead = false,
    this.metadata,
  });

  MessageEntity copyWith({
    String? id,
    String? conversationId,
    String? senderId,
    String? content,
    MessageType? type,
    DateTime? createdAt,
    bool? isRead,
    Map<String, dynamic>? metadata,
  }) {
    return MessageEntity(
      id: id ?? this.id,
      conversationId: conversationId ?? this.conversationId,
      senderId: senderId ?? this.senderId,
      content: content ?? this.content,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
      metadata: metadata ?? this.metadata,
    );
  }
}

/// 会话领域实体
class ConversationEntity {
  final String id;
  final String otherUserId;
  final String otherUserName;
  final String? otherUserAvatar;
  final MessageEntity? lastMessage;
  final int unreadCount;
  final DateTime updatedAt;
  final bool isPinned;

  const ConversationEntity({
    required this.id,
    required this.otherUserId,
    required this.otherUserName,
    this.otherUserAvatar,
    this.lastMessage,
    this.unreadCount = 0,
    required this.updatedAt,
    this.isPinned = false,
  });

  ConversationEntity copyWith({
    String? id,
    String? otherUserId,
    String? otherUserName,
    String? otherUserAvatar,
    MessageEntity? lastMessage,
    int? unreadCount,
    DateTime? updatedAt,
    bool? isPinned,
  }) {
    return ConversationEntity(
      id: id ?? this.id,
      otherUserId: otherUserId ?? this.otherUserId,
      otherUserName: otherUserName ?? this.otherUserName,
      otherUserAvatar: otherUserAvatar ?? this.otherUserAvatar,
      lastMessage: lastMessage ?? this.lastMessage,
      unreadCount: unreadCount ?? this.unreadCount,
      updatedAt: updatedAt ?? this.updatedAt,
      isPinned: isPinned ?? this.isPinned,
    );
  }
}

/// 系统通知领域实体
class NotificationEntity {
  final String id;
  final NotificationType type;
  final String title;
  final String content;
  final String? actorId;
  final String? actorName;
  final String? actorAvatar;
  final String? postId;
  final DateTime createdAt;
  final bool isRead;

  const NotificationEntity({
    required this.id,
    required this.type,
    required this.title,
    required this.content,
    this.actorId,
    this.actorName,
    this.actorAvatar,
    this.postId,
    required this.createdAt,
    this.isRead = false,
  });

  NotificationEntity copyWith({
    String? id,
    NotificationType? type,
    String? title,
    String? content,
    String? actorId,
    String? actorName,
    String? actorAvatar,
    String? postId,
    DateTime? createdAt,
    bool? isRead,
  }) {
    return NotificationEntity(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      content: content ?? this.content,
      actorId: actorId ?? this.actorId,
      actorName: actorName ?? this.actorName,
      actorAvatar: actorAvatar ?? this.actorAvatar,
      postId: postId ?? this.postId,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
    );
  }
}