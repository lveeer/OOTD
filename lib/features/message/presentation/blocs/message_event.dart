import 'package:equatable/equatable.dart';

abstract class MessageEvent extends Equatable {
  const MessageEvent();

  @override
  List<Object?> get props => [];
}

/// 获取会话列表事件
class MessageFetchConversationsRequested extends MessageEvent {
  const MessageFetchConversationsRequested();
}

/// 获取通知列表事件
class MessageFetchNotificationsRequested extends MessageEvent {
  const MessageFetchNotificationsRequested();
}

/// 切换标签页事件
class MessageTabChanged extends MessageEvent {
  final int tabIndex;

  const MessageTabChanged({required this.tabIndex});

  @override
  List<Object?> get props => [tabIndex];
}

/// 标记会话已读事件
class MessageMarkAsRead extends MessageEvent {
  final String conversationId;

  const MessageMarkAsRead({required this.conversationId});

  @override
  List<Object?> get props => [conversationId];
}

/// 标记通知已读事件
class MessageMarkNotificationAsRead extends MessageEvent {
  final String notificationId;

  const MessageMarkNotificationAsRead({required this.notificationId});

  @override
  List<Object?> get props => [notificationId];
}

/// 刷新事件
class MessageRefreshRequested extends MessageEvent {
  const MessageRefreshRequested();
}