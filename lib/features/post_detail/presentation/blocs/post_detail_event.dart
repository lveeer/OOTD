import 'package:equatable/equatable.dart';

abstract class PostDetailEvent extends Equatable {
  const PostDetailEvent();

  @override
  List<Object?> get props => [];
}

/// 加载帖子详情
class PostDetailLoadRequested extends PostDetailEvent {
  final String postId;

  const PostDetailLoadRequested({required this.postId});

  @override
  List<Object?> get props => [postId];
}

/// 点赞帖子
class PostDetailLikeToggled extends PostDetailEvent {
  const PostDetailLikeToggled();
}

/// 收藏帖子
class PostDetailCollectToggled extends PostDetailEvent {
  const PostDetailCollectToggled();
}

/// 关注用户
class PostDetailFollowToggled extends PostDetailEvent {
  const PostDetailFollowToggled();
}

/// 分享帖子
class PostDetailShareRequested extends PostDetailEvent {
  const PostDetailShareRequested();
}

/// 加载评论列表
class PostDetailCommentsLoadRequested extends PostDetailEvent {
  final String postId;

  const PostDetailCommentsLoadRequested({required this.postId});

  @override
  List<Object?> get props => [postId];
}

/// 发送评论
class PostDetailCommentSubmitted extends PostDetailEvent {
  final String content;
  final String? replyToUserId;

  const PostDetailCommentSubmitted({
    required this.content,
    this.replyToUserId,
  });

  @override
  List<Object?> get props => [content, replyToUserId];
}