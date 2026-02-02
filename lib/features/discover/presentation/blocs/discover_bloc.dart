import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/topic_entity.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/entities/post_entity.dart';

part 'discover_event.dart';
part 'discover_state.dart';

class DiscoverBloc extends Bloc<DiscoverEvent, DiscoverState> {
  DiscoverBloc() : super(DiscoverInitial()) {
    on<DiscoverFetchRequested>(_onDiscoverFetchRequested);
    on<DiscoverRefreshRequested>(_onDiscoverRefreshRequested);
    on<DiscoverSearchRequested>(_onDiscoverSearchRequested);
    on<DiscoverTopicToggled>(_onDiscoverTopicToggled);
    on<DiscoverUserFollowToggled>(_onDiscoverUserFollowToggled);
  }

  Future<void> _onDiscoverFetchRequested(
    DiscoverFetchRequested event,
    Emitter<DiscoverState> emit,
  ) async {
    emit(DiscoverLoading());
    
    await Future.delayed(const Duration(milliseconds: 500));
    
    final topics = _generateMockTopics();
    final recommendedUsers = _generateMockUsers();
    final trendingPosts = _generateMockPosts();
    
    emit(DiscoverLoaded(
      topics: topics,
      recommendedUsers: recommendedUsers,
      trendingPosts: trendingPosts,
      followedTopics: {},
      followedUsers: {},
    ));
  }

  Future<void> _onDiscoverRefreshRequested(
    DiscoverRefreshRequested event,
    Emitter<DiscoverState> emit,
  ) async {
    if (state is! DiscoverLoaded) return;
    
    final currentState = state as DiscoverLoaded;
    emit(DiscoverRefreshing(
      topics: currentState.topics,
      recommendedUsers: currentState.recommendedUsers,
      trendingPosts: currentState.trendingPosts,
      followedTopics: currentState.followedTopics,
      followedUsers: currentState.followedUsers,
    ));
    
    await Future.delayed(const Duration(milliseconds: 500));
    
    final topics = _generateMockTopics();
    final recommendedUsers = _generateMockUsers();
    final trendingPosts = _generateMockPosts();
    
    emit(currentState.copyWith(
      topics: topics,
      recommendedUsers: recommendedUsers,
      trendingPosts: trendingPosts,
    ));
  }

  Future<void> _onDiscoverSearchRequested(
    DiscoverSearchRequested event,
    Emitter<DiscoverState> emit,
  ) async {
    // TODO: 实现搜索功能
    // 目前仅作为占位，实际应该跳转到搜索结果页面
  }

  Future<void> _onDiscoverTopicToggled(
    DiscoverTopicToggled event,
    Emitter<DiscoverState> emit,
  ) async {
    if (state is! DiscoverLoaded) return;
    
    final currentState = state as DiscoverLoaded;
    final updatedFollowedTopics = Set<String>.from(currentState.followedTopics);
    
    if (updatedFollowedTopics.contains(event.topicId)) {
      updatedFollowedTopics.remove(event.topicId);
    } else {
      updatedFollowedTopics.add(event.topicId);
    }
    
    emit(currentState.copyWith(followedTopics: updatedFollowedTopics));
  }

  Future<void> _onDiscoverUserFollowToggled(
    DiscoverUserFollowToggled event,
    Emitter<DiscoverState> emit,
  ) async {
    if (state is! DiscoverLoaded) return;
    
    final currentState = state as DiscoverLoaded;
    final updatedFollowedUsers = Set<String>.from(currentState.followedUsers);
    
    if (updatedFollowedUsers.contains(event.userId)) {
      updatedFollowedUsers.remove(event.userId);
    } else {
      updatedFollowedUsers.add(event.userId);
    }
    
    emit(currentState.copyWith(followedUsers: updatedFollowedUsers));
  }

  List<TopicEntity> _generateMockTopics() {
    return [
      TopicEntity(
        id: 'topic_1',
        name: 'OOTD',
        postCount: 125000,
        isHot: true,
        coverImage: 'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=200',
      ),
      TopicEntity(
        id: 'topic_2',
        name: '春日穿搭',
        postCount: 89000,
        isHot: true,
        coverImage: 'https://images.unsplash.com/photo-1509631179647-0177331693ae?w=200',
      ),
      TopicEntity(
        id: 'topic_3',
        name: '极简风',
        postCount: 67000,
        isHot: false,
        coverImage: 'https://images.unsplash.com/photo-1490481651871-ab68de25d43d?w=200',
      ),
      TopicEntity(
        id: 'topic_4',
        name: '复古风',
        postCount: 45000,
        isHot: false,
        coverImage: 'https://images.unsplash.com/photo-1483985988355-763728e1935b?w=200',
      ),
      TopicEntity(
        id: 'topic_5',
        name: '职场穿搭',
        postCount: 38000,
        isHot: false,
        coverImage: 'https://images.unsplash.com/photo-1487222477894-8943e31ef7b2?w=200',
      ),
      TopicEntity(
        id: 'topic_6',
        name: '运动风',
        postCount: 32000,
        isHot: true,
        coverImage: 'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=200',
      ),
    ];
  }

  List<UserEntity> _generateMockUsers() {
    return [
      UserEntity(
        id: 'user_1',
        nickname: '时尚博主小美',
        avatar: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100',
        bio: '分享日常穿搭，一起变美',
        followersCount: 125000,
        followingCount: 234,
        postsCount: 456,
        isVerified: true,
      ),
      UserEntity(
        id: 'user_2',
        nickname: '穿搭达人',
        avatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100',
        bio: '极简风格爱好者',
        followersCount: 89000,
        followingCount: 156,
        postsCount: 328,
        isVerified: true,
      ),
      UserEntity(
        id: 'user_3',
        nickname: '时尚观察家',
        avatar: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=100',
        bio: '发现美好穿搭',
        followersCount: 67000,
        followingCount: 89,
        postsCount: 267,
        isVerified: false,
      ),
      UserEntity(
        id: 'user_4',
        nickname: '每日穿搭',
        avatar: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=100',
        bio: '记录每一天的穿搭',
        followersCount: 45000,
        followingCount: 123,
        postsCount: 189,
        isVerified: false,
      ),
    ];
  }

  List<PostEntity> _generateMockPosts() {
    return [
      PostEntity(
        id: 'post_1',
        content: '春日穿搭分享，清新自然 #春日穿搭 #OOTD',
        author: UserEntity(
          id: 'user_1',
          nickname: '时尚博主小美',
          avatar: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100',
          bio: '分享日常穿搭，一起变美',
          followersCount: 125000,
          followingCount: 234,
          postsCount: 456,
          isVerified: true,
        ),
        images: [
          'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=400',
        ],
        likesCount: 2340,
        commentsCount: 156,
        sharesCount: 89,
        isLiked: false,
        topics: ['春日穿搭', 'OOTD'],
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      PostEntity(
        id: 'post_2',
        content: '极简风格，简单就是美 #极简风 #穿搭',
        author: UserEntity(
          id: 'user_2',
          nickname: '穿搭达人',
          avatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100',
          bio: '极简风格爱好者',
          followersCount: 89000,
          followingCount: 156,
          postsCount: 328,
          isVerified: true,
        ),
        images: [
          'https://images.unsplash.com/photo-1490481651871-ab68de25d43d?w=400',
        ],
        likesCount: 1890,
        commentsCount: 123,
        sharesCount: 67,
        isLiked: true,
        topics: ['极简风', '穿搭'],
        createdAt: DateTime.now().subtract(const Duration(hours: 5)),
      ),
      PostEntity(
        id: 'post_3',
        content: '复古风穿搭，经典永不过时 #复古风 #时尚',
        author: UserEntity(
          id: 'user_3',
          nickname: '时尚观察家',
          avatar: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=100',
          bio: '发现美好穿搭',
          followersCount: 67000,
          followingCount: 89,
          postsCount: 267,
          isVerified: false,
        ),
        images: [
          'https://images.unsplash.com/photo-1483985988355-763728e1935b?w=400',
        ],
        likesCount: 1567,
        commentsCount: 98,
        sharesCount: 45,
        isLiked: false,
        topics: ['复古风', '时尚'],
        createdAt: DateTime.now().subtract(const Duration(hours: 8)),
      ),
    ];
  }
}