part of 'feed_bloc.dart';

abstract class FeedEvent extends Equatable {
  const FeedEvent();

  @override
  List<Object?> get props => [];
}

class FeedFetchRequested extends FeedEvent {}

class FeedRefreshRequested extends FeedEvent {}

class FeedLoadMoreRequested extends FeedEvent {}

class FeedLikeToggled extends FeedEvent {
  final String postId;

  const FeedLikeToggled({required this.postId});

  @override
  List<Object?> get props => [postId];
}