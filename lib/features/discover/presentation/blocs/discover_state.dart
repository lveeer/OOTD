part of 'discover_bloc.dart';

abstract class DiscoverState extends Equatable {
  const DiscoverState();

  @override
  List<Object?> get props => [];
}

class DiscoverInitial extends DiscoverState {}

class DiscoverLoading extends DiscoverState {}

class DiscoverRefreshing extends DiscoverState {
  final List<TopicEntity> topics;
  final List<UserEntity> recommendedUsers;
  final List<PostEntity> trendingPosts;
  final Set<String> followedTopics;
  final Set<String> followedUsers;

  const DiscoverRefreshing({
    this.topics = const [],
    this.recommendedUsers = const [],
    this.trendingPosts = const [],
    this.followedTopics = const {},
    this.followedUsers = const {},
  });

  @override
  List<Object?> get props => [topics, recommendedUsers, trendingPosts, followedTopics, followedUsers];
}

class DiscoverLoaded extends DiscoverState {
  final List<TopicEntity> topics;
  final List<UserEntity> recommendedUsers;
  final List<PostEntity> trendingPosts;
  final Set<String> followedTopics;
  final Set<String> followedUsers;

  const DiscoverLoaded({
    this.topics = const [],
    this.recommendedUsers = const [],
    this.trendingPosts = const [],
    this.followedTopics = const {},
    this.followedUsers = const {},
  });

  @override
  List<Object?> get props => [topics, recommendedUsers, trendingPosts, followedTopics, followedUsers];

  DiscoverLoaded copyWith({
    List<TopicEntity>? topics,
    List<UserEntity>? recommendedUsers,
    List<PostEntity>? trendingPosts,
    Set<String>? followedTopics,
    Set<String>? followedUsers,
  }) {
    return DiscoverLoaded(
      topics: topics ?? this.topics,
      recommendedUsers: recommendedUsers ?? this.recommendedUsers,
      trendingPosts: trendingPosts ?? this.trendingPosts,
      followedTopics: followedTopics ?? this.followedTopics,
      followedUsers: followedUsers ?? this.followedUsers,
    );
  }
}

class DiscoverError extends DiscoverState {
  final String message;

  const DiscoverError({required this.message});

  @override
  List<Object?> get props => [message];
}