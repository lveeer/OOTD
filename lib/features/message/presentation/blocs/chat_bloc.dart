import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../shared/models/message.dart';
import '../../domain/entities/message_entity.dart';
import '../../domain/usecases/get_messages.dart';
import '../../domain/usecases/send_message.dart';
import '../../domain/usecases/mark_messages_as_read.dart';
import 'chat_event.dart';
import 'chat_state.dart';

/// 聊天 BLoC
@injectable
class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final GetMessages getMessages;
  final SendMessage sendMessage;
  final MarkMessagesAsRead markMessagesAsRead;

  String? _currentConversationId;
  int _currentPage = 1;
  final int _pageSize = 20;

  ChatBloc({
    required this.getMessages,
    required this.sendMessage,
    required this.markMessagesAsRead,
  }) : super(const ChatInitial()) {
    on<ChatLoadMessagesRequested>(_onLoadMessages);
    on<ChatLoadMoreMessagesRequested>(_onLoadMoreMessages);
    on<ChatSendTextMessage>(_onSendTextMessage);
    on<ChatSendImageMessage>(_onSendImageMessage);
    on<ChatMessageReceived>(_onMessageReceived);
    on<ChatMessageRead>(_onMessageRead);
  }

  Future<void> _onLoadMessages(
    ChatLoadMessagesRequested event,
    Emitter<ChatState> emit,
  ) async {
    emit(const ChatLoading());
    _currentConversationId = event.conversationId;
    _currentPage = 1;

    final result = await getMessages(
      GetMessagesParams(
        conversationId: event.conversationId,
        page: _currentPage,
        pageSize: _pageSize,
      ),
    );

    result.fold(
      (failure) => emit(ChatError(message: failure.message)),
      (messages) {
        // 标记消息为已读
        _markMessagesAsRead(messages);

        emit(ChatMessagesLoaded(
          messages: messages,
          conversationId: event.conversationId,
          otherUserId: event.otherUserId,
          otherUserName: event.otherUserName,
          otherUserAvatar: event.otherUserAvatar,
          hasMore: messages.length >= _pageSize,
        ));
      },
    );
  }

  Future<void> _onLoadMoreMessages(
    ChatLoadMoreMessagesRequested event,
    Emitter<ChatState> emit,
  ) async {
    if (state is! ChatMessagesLoaded) return;

    final currentState = state as ChatMessagesLoaded;
    if (!currentState.hasMore) return;

    _currentPage++;

    final result = await getMessages(
      GetMessagesParams(
        conversationId: currentState.conversationId,
        page: _currentPage,
        pageSize: _pageSize,
      ),
    );

    result.fold(
      (failure) {
        _currentPage--; // 回滚页码
        emit(ChatError(message: failure.message));
      },
      (newMessages) {
        if (newMessages.isEmpty) {
          _currentPage--; // 回滚页码
        }

        final allMessages = [...currentState.messages, ...newMessages];
        emit(currentState.copyWith(
          messages: allMessages,
          hasMore: newMessages.length >= _pageSize,
        ));
      },
    );
  }

  Future<void> _onSendTextMessage(
    ChatSendTextMessage event,
    Emitter<ChatState> emit,
  ) async {
    if (state is! ChatMessagesLoaded) return;

    final currentState = state as ChatMessagesLoaded;
    if (event.content.trim().isEmpty) return;

    // 创建临时消息
    final tempMessage = MessageEntity(
      id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
      conversationId: currentState.conversationId,
      senderId: 'current_user', // TODO: 从当前用户信息获取
      content: event.content,
      type: MessageType.text,
      createdAt: DateTime.now(),
      isRead: false,
    );

    // 立即显示临时消息
    final updatedMessages = [tempMessage, ...currentState.messages];
    emit(ChatSending(
      messages: updatedMessages,
      conversationId: currentState.conversationId,
      otherUserId: currentState.otherUserId,
      otherUserName: currentState.otherUserName,
      otherUserAvatar: currentState.otherUserAvatar,
    ));

    // 发送消息
    final result = await sendMessage(
      SendMessageParams(
        conversationId: currentState.conversationId,
        content: event.content,
        type: MessageType.text,
      ),
    );

    result.fold(
      (failure) {
        // 发送失败，移除临时消息
        emit(ChatError(message: failure.message));
      },
      (sentMessage) {
        // 发送成功，替换临时消息
        final finalMessages = [sentMessage, ...currentState.messages];
        emit(currentState.copyWith(messages: finalMessages));
      },
    );
  }

  Future<void> _onSendImageMessage(
    ChatSendImageMessage event,
    Emitter<ChatState> emit,
  ) async {
    if (state is! ChatMessagesLoaded) return;

    final currentState = state as ChatMessagesLoaded;

    // 创建临时消息
    final tempMessage = MessageEntity(
      id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
      conversationId: currentState.conversationId,
      senderId: 'current_user',
      content: event.imagePath,
      type: MessageType.image,
      createdAt: DateTime.now(),
      isRead: false,
    );

    // 立即显示临时消息
    final updatedMessages = [tempMessage, ...currentState.messages];
    emit(ChatSending(
      messages: updatedMessages,
      conversationId: currentState.conversationId,
      otherUserId: currentState.otherUserId,
      otherUserName: currentState.otherUserName,
      otherUserAvatar: currentState.otherUserAvatar,
    ));

    // 发送消息
    final result = await sendMessage(
      SendMessageParams(
        conversationId: currentState.conversationId,
        content: event.imagePath,
        type: MessageType.image,
      ),
    );

    result.fold(
      (failure) {
        emit(ChatError(message: failure.message));
      },
      (sentMessage) {
        final finalMessages = [sentMessage, ...currentState.messages];
        emit(currentState.copyWith(messages: finalMessages));
      },
    );
  }

  Future<void> _onMessageReceived(
    ChatMessageReceived event,
    Emitter<ChatState> emit,
  ) async {
    if (state is! ChatMessagesLoaded) return;

    final currentState = state as ChatMessagesLoaded;

    // 检查是否是当前会话的消息
    if (event.message.conversationId != currentState.conversationId) {
      return;
    }

    // 标记消息为已读
    await markMessagesAsRead(
      MarkMessagesAsReadParams(
        conversationId: currentState.conversationId,
      ),
    );

    // 添加新消息到列表顶部
    final updatedMessages = [event.message, ...currentState.messages];
    emit(currentState.copyWith(messages: updatedMessages));
  }

  Future<void> _onMessageRead(
    ChatMessageRead event,
    Emitter<ChatState> emit,
  ) async {
    if (state is! ChatMessagesLoaded) return;

    final currentState = state as ChatMessagesLoaded;

    // 更新消息的已读状态
    final updatedMessages = currentState.messages.map((msg) {
      if (msg.id == event.messageId) {
        return msg.copyWith(isRead: true);
      }
      return msg;
    }).toList();

    emit(currentState.copyWith(messages: updatedMessages));
  }

  Future<void> _markMessagesAsRead(List<MessageEntity> messages) async {
    if (_currentConversationId != null) {
      await markMessagesAsRead(
        MarkMessagesAsReadParams(
          conversationId: _currentConversationId!,
        ),
      );
    }
  }
}