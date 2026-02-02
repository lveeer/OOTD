import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/get_conversations.dart';
import '../../domain/usecases/get_notifications.dart';
import '../../domain/usecases/mark_as_read.dart';
import '../../domain/usecases/mark_notification_as_read.dart';
import 'message_event.dart';
import 'message_state.dart';

/// 消息 BLoC
class MessageBloc extends Bloc<MessageEvent, MessageState> {
  final GetConversations getConversations;
  final GetNotifications getNotifications;
  final MarkAsRead markAsRead;
  final MarkNotificationAsRead markNotificationAsRead;

  int _currentTabIndex = 0; // 0: 会话列表, 1: 通知列表

  MessageBloc({
    required this.getConversations,
    required this.getNotifications,
    required this.markAsRead,
    required this.markNotificationAsRead,
  }) : super(const MessageInitial()) {
    on<MessageFetchConversationsRequested>(_onFetchConversations);
    on<MessageFetchNotificationsRequested>(_onFetchNotifications);
    on<MessageTabChanged>(_onTabChanged);
    on<MessageMarkAsRead>(_onMarkAsRead);
    on<MessageMarkNotificationAsRead>(_onMarkNotificationAsRead);
    on<MessageRefreshRequested>(_onRefresh);
  }

  Future<void> _onFetchConversations(
    MessageFetchConversationsRequested event,
    Emitter<MessageState> emit,
  ) async {
    emit(const MessageLoading());

    final result = await getConversations(NoParams());

    result.fold(
      (failure) => emit(MessageError(message: failure.message)),
      (conversations) {
        // 计算未读数量
        final unreadCount = conversations.fold<int>(
          0,
          (sum, conv) => sum + conv.unreadCount,
        );
        emit(MessageConversationsLoaded(
          conversations: conversations,
          unreadCount: unreadCount,
        ));
      },
    );
  }

  Future<void> _onFetchNotifications(
    MessageFetchNotificationsRequested event,
    Emitter<MessageState> emit,
  ) async {
    emit(const MessageLoading());

    final result = await getNotifications(NoParams());

    result.fold(
      (failure) => emit(MessageError(message: failure.message)),
      (notifications) {
        // 计算未读数量
        final unreadCount = notifications.where((n) => !n.isRead).length;
        emit(MessageNotificationsLoaded(
          notifications: notifications,
          unreadCount: unreadCount,
        ));
      },
    );
  }

  Future<void> _onTabChanged(
    MessageTabChanged event,
    Emitter<MessageState> emit,
  ) async {
    _currentTabIndex = event.tabIndex;

    if (event.tabIndex == 0) {
      // 切换到会话列表
      add(const MessageFetchConversationsRequested());
    } else {
      // 切换到通知列表
      add(const MessageFetchNotificationsRequested());
    }
  }

  Future<void> _onMarkAsRead(
    MessageMarkAsRead event,
    Emitter<MessageState> emit,
  ) async {
    if (state is MessageConversationsLoaded) {
      final currentState = state as MessageConversationsLoaded;
      final updatedConversations = currentState.conversations.map((conv) {
        if (conv.id == event.conversationId) {
          return conv.copyWith(unreadCount: 0);
        }
        return conv;
      }).toList();

      final newUnreadCount = updatedConversations.fold<int>(
        0,
        (sum, conv) => sum + conv.unreadCount,
      );

      emit(currentState.copyWith(
        conversations: updatedConversations,
        unreadCount: newUnreadCount,
      ));

      // 调用标记已读接口
      await markAsRead(conversationId: event.conversationId);
    }
  }

  Future<void> _onMarkNotificationAsRead(
    MessageMarkNotificationAsRead event,
    Emitter<MessageState> emit,
  ) async {
    if (state is MessageNotificationsLoaded) {
      final currentState = state as MessageNotificationsLoaded;
      final updatedNotifications = currentState.notifications.map((notif) {
        if (notif.id == event.notificationId) {
          return notif.copyWith(isRead: true);
        }
        return notif;
      }).toList();

      final newUnreadCount = updatedNotifications.where((n) => !n.isRead).length;

      emit(currentState.copyWith(
        notifications: updatedNotifications,
        unreadCount: newUnreadCount,
      ));

      // 调用标记已读接口
      await markNotificationAsRead(notificationId: event.notificationId);
    }
  }

  Future<void> _onRefresh(
    MessageRefreshRequested event,
    Emitter<MessageState> emit,
  ) async {
    if (_currentTabIndex == 0) {
      add(const MessageFetchConversationsRequested());
    } else {
      add(const MessageFetchNotificationsRequested());
    }
  }
}