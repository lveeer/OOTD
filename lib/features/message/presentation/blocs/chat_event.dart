import 'package:equatable/equatable.dart';
import '../../domain/entities/message_entity.dart';

/// 聊天事件基类
abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object?> get props => [];
}

/// 加载聊天消息事件
class ChatLoadMessagesRequested extends ChatEvent {
  final String conversationId;
  final String otherUserId;
  final String otherUserName;
  final String? otherUserAvatar;

  const ChatLoadMessagesRequested({
    required this.conversationId,
    required this.otherUserId,
    required this.otherUserName,
    this.otherUserAvatar,
  });

  @override
  List<Object?> get props => [
        conversationId,
        otherUserId,
        otherUserName,
        otherUserAvatar,
      ];
}

/// 加载更多历史消息事件
class ChatLoadMoreMessagesRequested extends ChatEvent {
  const ChatLoadMoreMessagesRequested();
}

/// 发送文本消息事件
class ChatSendTextMessage extends ChatEvent {
  final String content;

  const ChatSendTextMessage({required this.content});

  @override
  List<Object?> get props => [content];
}

/// 发送图片消息事件
class ChatSendImageMessage extends ChatEvent {
  final String imagePath;

  const ChatSendImageMessage({required this.imagePath});

  @override
  List<Object?> get props => [imagePath];
}

/// 接收新消息事件
class ChatMessageReceived extends ChatEvent {
  final MessageEntity message;

  const ChatMessageReceived({required this.message});

  @override
  List<Object?> get props => [message];
}

/// 消息已读事件
class ChatMessageRead extends ChatEvent {
  final String messageId;

  const ChatMessageRead({required this.messageId});

  @override
  List<Object?> get props => [messageId];
}