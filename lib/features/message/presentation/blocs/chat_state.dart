import 'package:equatable/equatable.dart';
import '../../domain/entities/message_entity.dart';

/// 聊天状态基类
abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object?> get props => [];
}

/// 初始状态
class ChatInitial extends ChatState {
  const ChatInitial();
}

/// 加载中状态
class ChatLoading extends ChatState {
  const ChatLoading();
}

/// 消息加载完成状态
class ChatMessagesLoaded extends ChatState {
  final List<MessageEntity> messages;
  final String conversationId;
  final String otherUserId;
  final String otherUserName;
  final String? otherUserAvatar;
  final bool hasMore;

  const ChatMessagesLoaded({
    required this.messages,
    required this.conversationId,
    required this.otherUserId,
    required this.otherUserName,
    this.otherUserAvatar,
    this.hasMore = true,
  });

  @override
  List<Object?> get props => [
        messages,
        conversationId,
        otherUserId,
        otherUserName,
        otherUserAvatar,
        hasMore,
      ];

  ChatMessagesLoaded copyWith({
    List<MessageEntity>? messages,
    String? conversationId,
    String? otherUserId,
    String? otherUserName,
    String? otherUserAvatar,
    bool? hasMore,
  }) {
    return ChatMessagesLoaded(
      messages: messages ?? this.messages,
      conversationId: conversationId ?? this.conversationId,
      otherUserId: otherUserId ?? this.otherUserId,
      otherUserName: otherUserName ?? this.otherUserName,
      otherUserAvatar: otherUserAvatar ?? this.otherUserAvatar,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}

/// 发送消息中状态
class ChatSending extends ChatState {
  final List<MessageEntity> messages;
  final String conversationId;
  final String otherUserId;
  final String otherUserName;
  final String? otherUserAvatar;

  const ChatSending({
    required this.messages,
    required this.conversationId,
    required this.otherUserId,
    required this.otherUserName,
    this.otherUserAvatar,
  });

  @override
  List<Object?> get props => [
        messages,
        conversationId,
        otherUserId,
        otherUserName,
        otherUserAvatar,
      ];
}

/// 错误状态
class ChatError extends ChatState {
  final String message;

  const ChatError({required this.message});

  @override
  List<Object?> get props => [message];
}