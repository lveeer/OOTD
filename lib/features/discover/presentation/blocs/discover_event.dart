part of 'discover_bloc.dart';

abstract class DiscoverEvent extends Equatable {
  const DiscoverEvent();

  @override
  List<Object?> get props => [];
}

class DiscoverFetchRequested extends DiscoverEvent {}

class DiscoverRefreshRequested extends DiscoverEvent {}

class DiscoverSearchRequested extends DiscoverEvent {
  final String query;

  const DiscoverSearchRequested({required this.query});

  @override
  List<Object?> get props => [query];
}

class DiscoverTopicToggled extends DiscoverEvent {
  final String topicId;

  const DiscoverTopicToggled({required this.topicId});

  @override
  List<Object?> get props => [topicId];
}

class DiscoverUserFollowToggled extends DiscoverEvent {
  final String userId;

  const DiscoverUserFollowToggled({required this.userId});

  @override
  List<Object?> get props => [userId];
}