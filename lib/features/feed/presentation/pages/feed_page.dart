import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../../shared/widgets/empty_widget.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../blocs/feed_bloc.dart';
import '../widgets/post_card.dart';

// 使用项目中的 ErrorWidget，避免与 Flutter 的 ErrorWidget 冲突
import '../../../../shared/widgets/empty_widget.dart' as shared;

class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<FeedBloc>().add(FeedFetchRequested());
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<FeedBloc>().add(FeedLoadMoreRequested());
    }
  }

  void _onRefresh() {
    context.read<FeedBloc>().add(FeedRefreshRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('今日穿搭'),
        actions: [
          IconButton(
            icon: Icon(PhosphorIcons.magnifyingGlass()),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(PhosphorIcons.bell()),
            onPressed: () {},
          ),
        ],
      ),
      body: BlocBuilder<FeedBloc, FeedState>(
        builder: (context, state) {
          if (state is FeedLoading) {
            return const LoadingWidget(message: '加载中...');
          }

          if (state is FeedError) {
            return shared.ErrorWidget(
              message: state.message,
              onRetry: _onRefresh,
            );
          }

          if (state is FeedLoaded || state is FeedRefreshing) {
            final posts = state is FeedLoaded ? state.posts : (state as FeedRefreshing).posts;
            final isLoadingMore = state is FeedLoaded && state.isLoadingMore;

            if (posts.isEmpty) {
              return const EmptyWidget(
                message: '暂无内容',
                subtitle: '快来发布第一条穿搭吧',
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                _onRefresh();
              },
              child: NotificationListener<ScrollNotification>(
                onNotification: (notification) {
                  if (notification is ScrollStartNotification) {
                  } else if (notification is ScrollEndNotification) {
                  }
                  return false;
                },
                child: MasonryGridView.count(
                  controller: _scrollController,
                  crossAxisCount: 2,
                  mainAxisSpacing: AppConstants.spacingS,
                  crossAxisSpacing: AppConstants.spacingS,
                  padding: const EdgeInsets.all(AppConstants.spacingS),
                  itemCount: posts.length + (isLoadingMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index < posts.length) {
                      return PostCard(post: posts[index]);
                    }
                    return const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  },
                ),
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
        },
        child: Icon(PhosphorIcons.plus()),
      ),
    );
  }
}