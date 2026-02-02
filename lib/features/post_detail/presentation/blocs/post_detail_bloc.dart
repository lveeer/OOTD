import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/usecases/get_post_detail.dart';
import '../../domain/usecases/like_post.dart';
import '../../domain/usecases/unlike_post.dart';
import '../../domain/usecases/collect_post.dart';
import '../../domain/usecases/uncollect_post.dart';
import '../../domain/usecases/follow_user.dart';
import '../../domain/usecases/unfollow_user.dart';
import 'post_detail_event.dart';
import 'post_detail_state.dart';

/// 帖子详情页 Bloc
class PostDetailBloc extends Bloc<PostDetailEvent, PostDetailState> {
  final GetPostDetail getPostDetail;
  final LikePost likePost;
  final UnlikePost unlikePost;
  final CollectPost collectPost;
  final UncollectPost uncollectPost;
  final FollowUser followUser;
  final UnfollowUser unfollowUser;

  PostDetailBloc({
    required this.getPostDetail,
    required this.likePost,
    required this.unlikePost,
    required this.collectPost,
    required this.uncollectPost,
    required this.followUser,
    required this.unfollowUser,
  }) : super(const PostDetailInitial()) {
    on<PostDetailLoadRequested>(_onLoadRequested);
    on<PostDetailLikeToggled>(_onLikeToggled);
    on<PostDetailCollectToggled>(_onCollectToggled);
    on<PostDetailFollowToggled>(_onFollowToggled);
    on<PostDetailShareRequested>(_onShareRequested);
    on<PostDetailCommentsLoadRequested>(_onCommentsLoadRequested);
    on<PostDetailCommentSubmitted>(_onCommentSubmitted);
  }

  Future<void> _onLoadRequested(
    PostDetailLoadRequested event,
    Emitter<PostDetailState> emit,
  ) async {
    emit(const PostDetailLoading());

    final result = await getPostDetail(event.postId);

    result.fold(
      (failure) => emit(PostDetailError(message: _mapFailureToMessage(failure))),
      (post) => emit(PostDetailLoaded(post: post)),
    );
  }

  Future<void> _onLikeToggled(
    PostDetailLikeToggled event,
    Emitter<PostDetailState> emit,
  ) async {
    if (state is! PostDetailLoaded) return;

    final currentState = state as PostDetailLoaded;
    final post = currentState.post;

    final result = post.isLiked
        ? await unlikePost(post.id)
        : await likePost(post.id);

    result.fold(
      (failure) => emit(PostDetailError(message: _mapFailureToMessage(failure))),
      (updatedPost) => emit(currentState.copyWith(post: updatedPost)),
    );
  }

  Future<void> _onCollectToggled(
    PostDetailCollectToggled event,
    Emitter<PostDetailState> emit,
  ) async {
    if (state is! PostDetailLoaded) return;

    final currentState = state as PostDetailLoaded;
    final post = currentState.post;

    final result = post.isCollected
        ? await uncollectPost(post.id)
        : await collectPost(post.id);

    result.fold(
      (failure) => emit(PostDetailError(message: _mapFailureToMessage(failure))),
      (updatedPost) => emit(currentState.copyWith(post: updatedPost)),
    );
  }

  Future<void> _onFollowToggled(
    PostDetailFollowToggled event,
    Emitter<PostDetailState> emit,
  ) async {
    if (state is! PostDetailLoaded) return;

    final currentState = state as PostDetailLoaded;
    final post = currentState.post;

    // 这里需要判断当前用户是否已关注该用户
    // 暂时简化处理，直接调用关注接口
    final result = await followUser(post.author.id);

    result.fold(
      (failure) => emit(PostDetailError(message: _mapFailureToMessage(failure))),
      (_) => emit(currentState),
    );
  }

  Future<void> _onShareRequested(
    PostDetailShareRequested event,
    Emitter<PostDetailState> emit,
  ) async {
    if (state is! PostDetailLoaded) return;

    // 分享功能暂时只显示提示
    // 实际项目中应该调用分享接口
  }

  Future<void> _onCommentsLoadRequested(
    PostDetailCommentsLoadRequested event,
    Emitter<PostDetailState> emit,
  ) async {
    if (state is! PostDetailLoaded) return;

    final currentState = state as PostDetailLoaded;
    emit(currentState.copyWith(isLoadingComments: true));

    // 暂时使用Mock数据
    // 实际项目中应该调用获取评论列表的UseCase
    await Future.delayed(const Duration(milliseconds: 500));

    emit(currentState.copyWith(
      isLoadingComments: false,
    ));
  }

  Future<void> _onCommentSubmitted(
    PostDetailCommentSubmitted event,
    Emitter<PostDetailState> emit,
  ) async {
    if (state is! PostDetailLoaded) return;

    final currentState = state as PostDetailLoaded;
    emit(currentState.copyWith(isSubmittingComment: true));

    // 暂时使用Mock数据
    await Future.delayed(const Duration(milliseconds: 500));

    final newComment = {
      'id': 'comment_new_${DateTime.now().millisecondsSinceEpoch}',
      'postId': currentState.post.id,
      'author': {
        'id': 'current_user',
        'nickname': '我',
        'avatar': 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=150',
      },
      'content': event.content,
      'likesCount': 0,
      'isLiked': false,
      'createdAt': DateTime.now(),
    };

    final updatedComments = [newComment, ...currentState.comments];

    emit(currentState.copyWith(
      comments: updatedComments,
      isSubmittingComment: false,
    ));
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return '服务器错误，请稍后重试';
      case NetworkFailure:
        return '网络连接失败，请检查网络设置';
      default:
        return '发生未知错误';
    }
  }
}