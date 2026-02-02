import 'package:equatable/equatable.dart';
import 'user.dart';

/// 消息类型枚举
enum MessageType {
  text,
  image,
  system,
}

/// 消息实体
class Message extends Equatable {
  final String id;
  final String conversationId;
  final String senderId;
  final String content;
  final MessageType type;
  final DateTime createdAt;
  final bool isRead;
  final Map<String, dynamic>? metadata;

  const Message({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.content,
    required this.type,
    required this.createdAt,
    this.isRead = false,
    this.metadata,
  });

  @override
  List<Object?> get props => [
        id,
        conversationId,
        senderId,
        content,
        type,
        createdAt,
        isRead,
        metadata,
      ];

  Message copyWith({
    String? id,
    String? conversationId,
    String? senderId,
    String? content,
    MessageType? type,
    DateTime? createdAt,
    bool? isRead,
    Map<String, dynamic>? metadata,
  }) {
    return Message(
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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'conversationId': conversationId,
      'senderId': senderId,
      'content': content,
      'type': type.name,
      'createdAt': createdAt.toIso8601String(),
      'isRead': isRead,
      'metadata': metadata,
    };
  }
}

/// 会话实体
class Conversation extends Equatable {
  final String id;
  final User otherUser;
  final Message? lastMessage;
  final int unreadCount;
  final DateTime updatedAt;
  final bool isPinned;

  const Conversation({
    required this.id,
    required this.otherUser,
    this.lastMessage,
    this.unreadCount = 0,
    required this.updatedAt,
    this.isPinned = false,
  });

  @override
  List<Object?> get props => [
        id,
        otherUser,
        lastMessage,
        unreadCount,
        updatedAt,
        isPinned,
      ];

  Conversation copyWith({
    String? id,
    User? otherUser,
    Message? lastMessage,
    int? unreadCount,
    DateTime? updatedAt,
    bool? isPinned,
  }) {
    return Conversation(
      id: id ?? this.id,
      otherUser: otherUser ?? this.otherUser,
      lastMessage: lastMessage ?? this.lastMessage,
      unreadCount: unreadCount ?? this.unreadCount,
      updatedAt: updatedAt ?? this.updatedAt,
      isPinned: isPinned ?? this.isPinned,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'otherUser': otherUser.toJson(),
      'lastMessage': lastMessage?.toJson(),
      'unreadCount': unreadCount,
      'updatedAt': updatedAt.toIso8601String(),
      'isPinned': isPinned,
    };
  }
}

/// 系统通知类型
enum NotificationType {
  like,
  comment,
  follow,
  system,
  commission,
}

/// 系统通知实体
class SystemNotification extends Equatable {
  final String id;
  final NotificationType type;
  final String title;
  final String content;
  final User? actor;
  final String? postId;
  final DateTime createdAt;
  final bool isRead;

  const SystemNotification({
    required this.id,
    required this.type,
    required this.title,
    required this.content,
    this.actor,
    this.postId,
    required this.createdAt,
    this.isRead = false,
  });

  @override
  List<Object?> get props => [
        id,
        type,
        title,
        content,
        actor,
        postId,
        createdAt,
        isRead,
      ];

  SystemNotification copyWith({
    String? id,
    NotificationType? type,
    String? title,
    String? content,
    User? actor,
    String? postId,
    DateTime? createdAt,
    bool? isRead,
  }) {
    return SystemNotification(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      content: content ?? this.content,
      actor: actor ?? this.actor,
      postId: postId ?? this.postId,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name,
      'title': title,
      'content': content,
      'actor': actor?.toJson(),
      'postId': postId,
      'createdAt': createdAt.toIso8601String(),
      'isRead': isRead,
    };
  }
}