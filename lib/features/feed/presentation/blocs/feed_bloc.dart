import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/post_entity.dart';
import '../../../../shared/models/user.dart';
import '../../../../shared/models/media_file.dart';
import '../../../../shared/models/media_file.dart' show MediaType;

part 'feed_event.dart';
part 'feed_state.dart';

class FeedBloc extends Bloc<FeedEvent, FeedState> {
  FeedBloc() : super(FeedInitial()) {
    on<FeedFetchRequested>(_onFeedFetchRequested);
    on<FeedRefreshRequested>(_onFeedRefreshRequested);
    on<FeedLoadMoreRequested>(_onFeedLoadMoreRequested);
    on<FeedLikeToggled>(_onFeedLikeToggled);
  }

  Future<void> _onFeedFetchRequested(
    FeedFetchRequested event,
    Emitter<FeedState> emit,
  ) async {
    emit(FeedLoading());
    
    await Future.delayed(const Duration(milliseconds: 500));
    
    final posts = _generateMockPosts(10);
    emit(FeedLoaded(posts: posts, hasMore: true));
  }

  Future<void> _onFeedRefreshRequested(
    FeedRefreshRequested event,
    Emitter<FeedState> emit,
  ) async {
    List<PostEntity> currentPosts = [];
    if (state is FeedLoaded) {
      currentPosts = (state as FeedLoaded).posts;
    } else if (state is FeedRefreshing) {
      currentPosts = (state as FeedRefreshing).posts;
    }
    
    emit(FeedRefreshing(posts: currentPosts));
    
    await Future.delayed(const Duration(milliseconds: 500));
    
    final posts = _generateMockPosts(10);
    emit(FeedLoaded(posts: posts, hasMore: true));
  }

  Future<void> _onFeedLoadMoreRequested(
    FeedLoadMoreRequested event,
    Emitter<FeedState> emit,
  ) async {
    if (state is! FeedLoaded) return;
    
    final currentState = state as FeedLoaded;
    if (currentState.isLoadingMore || !currentState.hasMore) return;
    
    emit(currentState.copyWith(isLoadingMore: true));
    
    await Future.delayed(const Duration(milliseconds: 500));
    
    final newPosts = _generateMockPosts(5);
    emit(currentState.copyWith(
      posts: [...currentState.posts, ...newPosts],
      isLoadingMore: false,
      hasMore: newPosts.isNotEmpty,
    ));
  }

  Future<void> _onFeedLikeToggled(
    FeedLikeToggled event,
    Emitter<FeedState> emit,
  ) async {
    if (state is! FeedLoaded) return;
    
    final currentState = state as FeedLoaded;
    final updatedPosts = currentState.posts.map((post) {
      if (post.id == event.postId) {
        return post.copyWith(
          isLiked: !post.isLiked,
          likesCount: post.isLiked ? post.likesCount - 1 : post.likesCount + 1,
        );
      }
      return post;
    }).toList();
    
    emit(currentState.copyWith(posts: updatedPosts));
  }

  List<PostEntity> _generateMockPosts(int count) {
    return List.generate(count, (index) {
      return PostEntity(
        id: 'post_$index',
        content: '今日穿搭分享 ${index + 1} #OOTD #时尚',
        author: User(
          id: 'user_1',
          nickname: '时尚达人',
          avatar: 'https://via.placeholder.com/100',
          createdAt: DateTime.now(),
        ),
        images: [
          MediaFile(
            id: 'img_${index}_0',
            path: 'https://via.placeholder.com/400x533',
            url: 'https://via.placeholder.com/400x533',
            type: MediaType.image,
            width: 400,
            height: 533,
            size: 100000,
            createdAt: DateTime.now(),
          ),
        ],
        tags: [],
        likesCount: (index + 1) * 10,
        commentsCount: (index + 1) * 5,
        sharesCount: index + 1,
        isLiked: index % 2 == 0,
        topics: ['OOTD', '时尚'],
        createdAt: DateTime.now().subtract(Duration(days: index)),
      );
    });
  }
}