part of 'feed_bloc.dart';

abstract class FeedState extends Equatable {
  const FeedState();

  @override
  List<Object?> get props => [];
}

class FeedInitial extends FeedState {}

class FeedLoading extends FeedState {}

class FeedRefreshing extends FeedState {
  final List<PostEntity> posts;

  const FeedRefreshing({this.posts = const []});

  @override
  List<Object?> get props => [posts];
}

class FeedLoaded extends FeedState {
  final List<PostEntity> posts;
  final bool hasMore;
  final bool isLoadingMore;

  const FeedLoaded({
    this.posts = const [],
    this.hasMore = true,
    this.isLoadingMore = false,
  });

  @override
  List<Object?> get props => [posts, hasMore, isLoadingMore];

  FeedLoaded copyWith({
    List<PostEntity>? posts,
    bool? hasMore,
    bool? isLoadingMore,
  }) {
    return FeedLoaded(
      posts: posts ?? this.posts,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

class FeedError extends FeedState {
  final String message;

  const FeedError({required this.message});

  @override
  List<Object?> get props => [message];
}