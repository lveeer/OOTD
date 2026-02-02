import 'package:equatable/equatable.dart';
import '../../../../shared/models/user.dart';
import '../../../feed/domain/entities/post_entity.dart';

abstract class PostDetailState extends Equatable {
  const PostDetailState();

  @override
  List<Object?> get props => [];
}

/// 初始状态
class PostDetailInitial extends PostDetailState {
  const PostDetailInitial();
}

/// 加载中
class PostDetailLoading extends PostDetailState {
  const PostDetailLoading();
}

/// 加载成功
class PostDetailLoaded extends PostDetailState {
  final PostEntity post;
  final List<Map<String, dynamic>> comments;
  final bool isLoadingComments;
  final bool isSubmittingComment;

  const PostDetailLoaded({
    required this.post,
    this.comments = const [],
    this.isLoadingComments = false,
    this.isSubmittingComment = false,
  });

  @override
  List<Object?> get props => [
        post,
        comments,
        isLoadingComments,
        isSubmittingComment,
      ];

  PostDetailLoaded copyWith({
    PostEntity? post,
    List<Map<String, dynamic>>? comments,
    bool? isLoadingComments,
    bool? isSubmittingComment,
  }) {
    return PostDetailLoaded(
      post: post ?? this.post,
      comments: comments ?? this.comments,
      isLoadingComments: isLoadingComments ?? this.isLoadingComments,
      isSubmittingComment: isSubmittingComment ?? this.isSubmittingComment,
    );
  }
}

/// 加载失败
class PostDetailError extends PostDetailState {
  final String message;

  const PostDetailError({required this.message});

  @override
  List<Object?> get props => [message];
}