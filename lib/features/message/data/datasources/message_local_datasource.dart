import '../../domain/entities/message_entity.dart';
import '../../../../shared/models/message.dart';

/// 消息本地数据源接口
abstract class MessageLocalDataSource {
  /// 获取会话列表
  Future<List<ConversationEntity>> getConversations();

  /// 获取系统通知列表
  Future<List<NotificationEntity>> getNotifications();
}

/// 消息本地数据源实现（Mock 数据）
class MessageLocalDataSourceImpl implements MessageLocalDataSource {
  @override
  Future<List<ConversationEntity>> getConversations() async {
    await Future.delayed(const Duration(milliseconds: 300));

    return [
      ConversationEntity(
        id: 'conv_1',
        otherUserId: 'user_2',
        otherUserName: '时尚博主小美',
        otherUserAvatar: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100',
        lastMessage: MessageEntity(
          id: 'msg_1',
          conversationId: 'conv_1',
          senderId: 'user_2',
          content: '今天的穿搭真好看！可以分享一下链接吗？',
          type: MessageType.text,
          createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
          isRead: false,
        ),
        unreadCount: 2,
        updatedAt: DateTime.now().subtract(const Duration(minutes: 5)),
      ),
      ConversationEntity(
        id: 'conv_2',
        otherUserId: 'user_3',
        otherUserName: '穿搭达人',
        otherUserAvatar: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=100',
        lastMessage: MessageEntity(
          id: 'msg_2',
          conversationId: 'conv_2',
          senderId: 'user_3',
          content: '这个外套在哪里买的呀？',
          type: MessageType.text,
          createdAt: DateTime.now().subtract(const Duration(hours: 2)),
          isRead: true,
        ),
        unreadCount: 0,
        updatedAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      ConversationEntity(
        id: 'conv_3',
        otherUserId: 'user_4',
        otherUserName: '服装设计师',
        otherUserAvatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100',
        lastMessage: MessageEntity(
          id: 'msg_3',
          conversationId: 'conv_3',
          senderId: 'user_4',
          content: '期待你的下一个作品！',
          type: MessageType.text,
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
          isRead: true,
        ),
        unreadCount: 0,
        updatedAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ];
  }

  @override
  Future<List<NotificationEntity>> getNotifications() async {
    await Future.delayed(const Duration(milliseconds: 300));

    return [
      NotificationEntity(
        id: 'notif_1',
        type: NotificationType.like,
        title: '赞了你的穿搭',
        content: '时尚博主小美 赞了你的穿搭',
        actorId: 'user_2',
        actorName: '时尚博主小美',
        actorAvatar: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100',
        postId: 'post_1',
        createdAt: DateTime.now().subtract(const Duration(minutes: 10)),
        isRead: false,
      ),
      NotificationEntity(
        id: 'notif_2',
        type: NotificationType.comment,
        title: '评论了你的穿搭',
        content: '穿搭达人：这套搭配太棒了！求链接',
        actorId: 'user_3',
        actorName: '穿搭达人',
        actorAvatar: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=100',
        postId: 'post_1',
        createdAt: DateTime.now().subtract(const Duration(hours: 1)),
        isRead: false,
      ),
      NotificationEntity(
        id: 'notif_3',
        type: NotificationType.follow,
        title: '关注了你',
        content: '服装设计师 关注了你',
        actorId: 'user_4',
        actorName: '服装设计师',
        actorAvatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100',
        createdAt: DateTime.now().subtract(const Duration(hours: 3)),
        isRead: true,
      ),
      NotificationEntity(
        id: 'notif_4',
        type: NotificationType.commission,
        title: '佣金到账',
        content: '您有一笔 ¥12.50 的佣金已到账',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        isRead: true,
      ),
      NotificationEntity(
        id: 'notif_5',
        type: NotificationType.system,
        title: '系统通知',
        content: '您的穿搭《春季搭配指南》已通过审核',
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        isRead: true,
      ),
    ];
  }
}