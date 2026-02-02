import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/empty_widget.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../blocs/message_bloc.dart';
import '../blocs/message_event.dart';
import '../blocs/message_state.dart';
import '../widgets/conversation_item.dart';
import '../widgets/notification_item.dart';

class MessagePage extends StatefulWidget {
  const MessagePage({super.key});

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_onTabChanged);
    // 初始加载会话列表
    context.read<MessageBloc>().add(const MessageFetchConversationsRequested());
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    _refreshController.dispose();
    super.dispose();
  }

  void _onTabChanged() {
    if (_tabController.indexIsChanging) {
      context
          .read<MessageBloc>()
          .add(MessageTabChanged(tabIndex: _tabController.index));
    }
  }

  void _onRefresh() async {
    context.read<MessageBloc>().add(const MessageRefreshRequested());
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brightness = theme.brightness;
    final labelColor = AppColors.labelColor(brightness);
    final secondaryLabelColor = AppColors.secondaryLabelColor(brightness);

    return Scaffold(
      appBar: AppBar(
        title: const Text('消息'),
        actions: [
          BlocBuilder<MessageBloc, MessageState>(
            builder: (context, state) {
              int unreadCount = 0;
              if (state is MessageConversationsLoaded) {
                unreadCount = state.unreadCount;
              } else if (state is MessageNotificationsLoaded) {
                unreadCount = state.unreadCount;
              }

              return Stack(
                children: [
                  IconButton(
                    icon: Icon(PhosphorIcons.bell()),
                    onPressed: () {
                      // TODO: 打开通知设置
                    },
                  ),
                  if (unreadCount > 0)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          color: AppColors.error,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          unreadCount > 99 ? '99+' : unreadCount.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: labelColor,
          unselectedLabelColor: secondaryLabelColor,
          indicatorColor: labelColor,
          indicatorWeight: 2,
          labelStyle: const TextStyle(
            fontSize: AppConstants.fontSizeM,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: AppConstants.fontSizeM,
            fontWeight: FontWeight.w400,
          ),
          tabs: const [
            Tab(text: '私信'),
            Tab(text: '通知'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildConversationsTab(),
          _buildNotificationsTab(),
        ],
      ),
    );
  }

  Widget _buildConversationsTab() {
    return BlocConsumer<MessageBloc, MessageState>(
      listener: (context, state) {
        if (state is MessageConversationsLoaded) {
          _refreshController.refreshCompleted();
        } else if (state is MessageError) {
          _refreshController.refreshFailed();
        }
      },
      builder: (context, state) {
        if (state is MessageLoading) {
          return const LoadingWidget(message: '加载中...');
        }

        if (state is MessageError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const EmptyWidget(
                  message: '加载失败',
                  subtitle: '请检查网络连接后重试',
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: _onRefresh,
                  child: const Text('重试'),
                ),
              ],
            ),
          );
        }

        if (state is MessageConversationsLoaded) {
          final conversations = state.conversations;

          if (conversations.isEmpty) {
            return const EmptyWidget(
              message: '暂无私信',
              subtitle: '快去关注更多达人吧',
            );
          }

          return SmartRefresher(
            controller: _refreshController,
            onRefresh: _onRefresh,
            enablePullUp: false,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: conversations.length,
              separatorBuilder: (context, index) => Divider(
                height: 1,
                indent: 76,
                color: AppColors.separatorColor(Theme.of(context).brightness),
              ),
              itemBuilder: (context, index) {
                return ConversationItem(
                  conversation: conversations[index],
                  onTap: () {
                    context.read<MessageBloc>().add(
                          MessageMarkAsRead(
                            conversationId: conversations[index].id,
                          ),
                        );
                    // TODO: 打开聊天详情页
                  },
                );
              },
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildNotificationsTab() {
    return BlocConsumer<MessageBloc, MessageState>(
      listener: (context, state) {
        if (state is MessageNotificationsLoaded) {
          _refreshController.refreshCompleted();
        } else if (state is MessageError) {
          _refreshController.refreshFailed();
        }
      },
      builder: (context, state) {
        if (state is MessageLoading) {
          return const LoadingWidget(message: '加载中...');
        }

        if (state is MessageError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const EmptyWidget(
                  message: '加载失败',
                  subtitle: '请检查网络连接后重试',
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: _onRefresh,
                  child: const Text('重试'),
                ),
              ],
            ),
          );
        }

        if (state is MessageNotificationsLoaded) {
          final notifications = state.notifications;

          if (notifications.isEmpty) {
            return const EmptyWidget(
              message: '暂无通知',
              subtitle: '有新消息时会在这里显示',
            );
          }

          return SmartRefresher(
            controller: _refreshController,
            onRefresh: _onRefresh,
            enablePullUp: false,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: notifications.length,
              separatorBuilder: (context, index) => Divider(
                height: 1,
                indent: 76,
                color: AppColors.separatorColor(Theme.of(context).brightness),
              ),
              itemBuilder: (context, index) {
                return NotificationItem(
                  notification: notifications[index],
                  onTap: () {
                    context.read<MessageBloc>().add(
                          MessageMarkNotificationAsRead(
                            notificationId: notifications[index].id,
                          ),
                        );
                    // TODO: 根据通知类型跳转到相应页面
                  },
                );
              },
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}