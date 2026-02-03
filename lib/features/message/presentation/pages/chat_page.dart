import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/models/message.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../blocs/chat_bloc.dart';
import '../blocs/chat_event.dart';
import '../blocs/chat_state.dart';
import '../widgets/message_bubble.dart';
import '../widgets/chat_input_field.dart';

class ChatPage extends StatefulWidget {
  final String conversationId;
  final String otherUserId;
  final String otherUserName;
  final String? otherUserAvatar;

  const ChatPage({
    super.key,
    required this.conversationId,
    required this.otherUserId,
    required this.otherUserName,
    this.otherUserAvatar,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final ScrollController _scrollController = ScrollController();
  final RefreshController _refreshController = RefreshController(initialRefresh: false);
  late ChatBloc _chatBloc;

  @override
  void initState() {
    super.initState();
    _chatBloc = context.read<ChatBloc>();
    _chatBloc.add(
      ChatLoadMessagesRequested(
        conversationId: widget.conversationId,
        otherUserId: widget.otherUserId,
        otherUserName: widget.otherUserName,
        otherUserAvatar: widget.otherUserAvatar,
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _refreshController.dispose();
    super.dispose();
  }

  void _onRefresh() async {
    _chatBloc.add(const ChatLoadMoreMessagesRequested());
    _refreshController.refreshCompleted();
  }

  void _handleSendText(String content) {
    _chatBloc.add(ChatSendTextMessage(content: content));
  }

  void _handleImageTap(String imageUrl) {
    // TODO: 实现图片预览功能
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => _ImagePreviewPage(imageUrl: imageUrl),
      ),
    );
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brightness = theme.brightness;
    final labelColor = AppColors.labelColor(brightness);
    final secondaryLabelColor = AppColors.secondaryLabelColor(brightness);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(PhosphorIcons.arrowLeft(), color: labelColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(
          children: [
            // 头像
            _buildAvatar(context, brightness),
            const SizedBox(width: 12),
            // 用户名
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.otherUserName,
                    style: TextStyle(
                      fontSize: AppConstants.fontSizeM,
                      fontWeight: FontWeight.w600,
                      color: labelColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '在线',
                    style: TextStyle(
                      fontSize: AppConstants.fontSizeS,
                      color: secondaryLabelColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(PhosphorIcons.dotsThree(), color: labelColor),
            onPressed: () {
              // TODO: 打开更多选项菜单
            },
          ),
        ],
      ),
      body: BlocConsumer<ChatBloc, ChatState>(
        bloc: _chatBloc,
        listener: (context, state) {
          if (state is ChatMessagesLoaded) {
            // 滚动到底部
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _scrollToBottom();
            });
          }
        },
        builder: (context, state) {
          if (state is ChatLoading) {
            return const LoadingWidget(message: '加载中...');
          }

          if (state is ChatError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    PhosphorIcons.warningCircle(),
                    size: 64,
                    color: AppColors.tertiaryLabelColor(brightness),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    state.message,
                    style: TextStyle(
                      fontSize: AppConstants.fontSizeM,
                      color: labelColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      _chatBloc.add(
                        ChatLoadMessagesRequested(
                          conversationId: widget.conversationId,
                          otherUserId: widget.otherUserId,
                          otherUserName: widget.otherUserName,
                          otherUserAvatar: widget.otherUserAvatar,
                        ),
                      );
                    },
                    child: const Text('重试'),
                  ),
                ],
              ),
            );
          }

          if (state is ChatMessagesLoaded || state is ChatSending) {
            final messages = state is ChatSending
                ? state.messages
                : (state as ChatMessagesLoaded).messages;
            final hasMore = state is ChatMessagesLoaded
                ? state.hasMore
                : true;

            return Column(
              children: [
                // 消息列表
                Expanded(
                  child: SmartRefresher(
                    controller: _refreshController,
                    onRefresh: _onRefresh,
                    enablePullUp: false,
                    enablePullDown: hasMore,
                    reverse: true,
                    child: ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final message = messages[index];
                        final isCurrentUser = message.senderId == 'current_user';

                        return MessageBubble(
                          message: message,
                          isCurrentUser: isCurrentUser,
                          onImageTap: message.type == MessageType.image
                              ? () => _handleImageTap(message.content)
                              : null,
                        );
                      },
                    ),
                  ),
                ),
                // 输入框
                ChatInputField(
                  onSend: _handleSendText,
                ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildAvatar(BuildContext context, Brightness brightness) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: AppColors.fillColor(brightness),
        shape: BoxShape.circle,
      ),
      child: ClipOval(
        child: widget.otherUserAvatar != null
            ? CachedNetworkImage(
                imageUrl: widget.otherUserAvatar!,
                fit: BoxFit.cover,
                placeholder: (context, url) => Icon(
                  PhosphorIcons.user(),
                  size: 20,
                  color: AppColors.tertiaryLabelColor(brightness),
                ),
                errorWidget: (context, url, error) => Icon(
                  PhosphorIcons.user(),
                  size: 20,
                  color: AppColors.tertiaryLabelColor(brightness),
                ),
              )
            : Icon(
                PhosphorIcons.user(),
                size: 20,
                color: AppColors.tertiaryLabelColor(brightness),
              ),
      ),
    );
  }
}

/// 图片预览页面
class _ImagePreviewPage extends StatelessWidget {
  final String imageUrl;

  const _ImagePreviewPage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(PhosphorIcons.x(), color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Center(
        child: InteractiveViewer(
          minScale: 0.5,
          maxScale: 4.0,
          child: imageUrl.startsWith('http')
              ? CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.contain,
                )
              : Image.asset(
                  imageUrl,
                  fit: BoxFit.contain,
                ),
        ),
      ),
    );
  }
}