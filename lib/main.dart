import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'core/constants/app_constants.dart';
import 'core/di/injection_container.dart' as di;
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/blocs/auth_bloc.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/feed/presentation/blocs/feed_bloc.dart';
import 'features/feed/presentation/pages/feed_page.dart';
import 'features/discover/presentation/blocs/discover_bloc.dart';
import 'features/discover/presentation/pages/discover_page.dart';
import 'features/message/data/datasources/message_local_datasource.dart';
import 'features/message/data/repositories/message_repository_impl.dart';
import 'features/message/domain/repositories/message_repository.dart';
import 'features/message/domain/usecases/get_conversations.dart';
import 'features/message/domain/usecases/get_notifications.dart';
import 'features/message/domain/usecases/mark_as_read.dart';
import 'features/message/domain/usecases/mark_notification_as_read.dart';
import 'features/message/presentation/blocs/message_bloc.dart';
import 'features/message/presentation/pages/message_page.dart';
import 'features/post_editor/presentation/blocs/post_editor_bloc.dart';
import 'features/post_editor/presentation/pages/post_editor_page.dart';
import 'features/post_detail/data/datasources/post_detail_local_datasource.dart';
import 'features/post_detail/data/repositories/post_detail_repository_impl.dart';
import 'features/post_detail/domain/repositories/post_detail_repository.dart';
import 'features/post_detail/domain/usecases/get_post_detail.dart';
import 'features/post_detail/domain/usecases/like_post.dart';
import 'features/post_detail/domain/usecases/unlike_post.dart';
import 'features/post_detail/domain/usecases/collect_post.dart';
import 'features/post_detail/domain/usecases/uncollect_post.dart';
import 'features/post_detail/domain/usecases/follow_user.dart';
import 'features/post_detail/domain/usecases/unfollow_user.dart';
import 'features/user_profile/presentation/pages/user_profile_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.configureDependencies();
  
  // 注册PostDetail相关依赖
  final postDetailLocalDataSource = PostDetailLocalDataSource();
  final postDetailRepository = PostDetailRepositoryImpl(
    localDataSource: postDetailLocalDataSource,
  );
  di.getIt.registerSingleton<PostDetailRepository>(postDetailRepository);
  di.getIt.registerFactory<GetPostDetail>(() => GetPostDetail(di.getIt()));
  di.getIt.registerFactory<LikePost>(() => LikePost(di.getIt()));
  di.getIt.registerFactory<UnlikePost>(() => UnlikePost(di.getIt()));
  di.getIt.registerFactory<CollectPost>(() => CollectPost(di.getIt()));
  di.getIt.registerFactory<UncollectPost>(() => UncollectPost(di.getIt()));
  di.getIt.registerFactory<FollowUser>(() => FollowUser(di.getIt()));
  di.getIt.registerFactory<UnfollowUser>(() => UnfollowUser(di.getIt()));
  
  // 注册Message相关依赖
  final messageLocalDataSource = MessageLocalDataSourceImpl();
  final messageRepository = MessageRepositoryImpl(
    localDataSource: messageLocalDataSource,
  );
  di.getIt.registerSingleton<MessageRepository>(messageRepository);
  di.getIt.registerFactory<GetConversations>(() => GetConversations(di.getIt()));
  di.getIt.registerFactory<GetNotifications>(() => GetNotifications(di.getIt()));
  di.getIt.registerFactory<MarkAsRead>(() => MarkAsRead(di.getIt()));
  di.getIt.registerFactory<MarkNotificationAsRead>(() => MarkNotificationAsRead(di.getIt()));
  
  runApp(const OOTDApp());
}

class OOTDApp extends StatelessWidget {
  const OOTDApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(
            loginUseCase: di.getIt(),
            sendSmsCodeUseCase: di.getIt(),
            authRepository: di.getIt(),
          )..add(AuthCheckRequested()),
        ),
        BlocProvider(
          create: (context) => FeedBloc(),
        ),
        BlocProvider(
          create: (context) => DiscoverBloc(),
        ),
        BlocProvider(
          create: (context) => MessageBloc(
            getConversations: di.getIt(),
            getNotifications: di.getIt(),
            markAsRead: di.getIt(),
            markNotificationAsRead: di.getIt(),
          ),
        ),
      ],
      child: MaterialApp(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        home: const MainScreen(),
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const FeedPage(),
    const DiscoverPage(),
    const MessagePage(),
    const UserProfilePage(),
  ];

  Widget _buildNavItem(
    BuildContext context, {
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required int index,
  }) {
    final isSelected = _currentIndex == index;
    final brightness = Theme.of(context).brightness;
    final selectedColor = brightness == Brightness.light
        ? Colors.black
        : Colors.white;
    final unselectedColor = brightness == Brightness.light
        ? const Color(0xFF8E8E93)
        : const Color(0xFF8E8E93);

    return InkWell(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isSelected ? activeIcon : icon,
            size: 24,
            color: isSelected ? selectedColor : unselectedColor,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
              color: isSelected ? selectedColor : unselectedColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostButton(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isDark = brightness == Brightness.dark;

    return SizedBox(
      width: 86,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => BlocProvider(
                create: (context) => PostEditorBloc(),
                child: const PostEditorPage(),
              ),
            ),
          );
        },
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Center(
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isDark ? Colors.white : Colors.black,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? Colors.white.withOpacity(0.15)
                      : Colors.black.withOpacity(0.15),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              PhosphorIcons.plus(),
              color: isDark ? Colors.black : Colors.white,
              size: 24,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const LoginPage()),
            (route) => false,
          );
        } else if (state is AuthAuthenticated) {
          // 登录成功，清除导航栈并返回主页
          Navigator.of(context).popUntil((route) => route.isFirst);
        }
      },
      child: Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: _pages,
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.light
                ? Colors.white
                : Colors.black,
            border: Border(
              top: BorderSide(
                color: Theme.of(context).brightness == Brightness.light
                    ? const Color(0xFFE5E5E5)
                    : const Color(0xFF2A2A2A),
                width: 0.5,
              ),
            ),
          ),
          child: SafeArea(
            top: false,
            child: SizedBox(
              height: 56 + MediaQuery.of(context).padding.bottom,
              child: Row(
                children: [
                  // 左侧导航项：首页、发现
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildNavItem(
                            context,
                            icon: PhosphorIcons.house(),
                            activeIcon: PhosphorIcons.house(PhosphorIconsStyle.fill),
                            label: '首页',
                            index: 0,
                          ),
                        ),
                        Expanded(
                          child: _buildNavItem(
                            context,
                            icon: PhosphorIcons.magnifyingGlass(),
                            activeIcon: PhosphorIcons.magnifyingGlass(PhosphorIconsStyle.fill),
                            label: '发现',
                            index: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // 中间发布按钮（FAB 样式）
                  _buildPostButton(context),
                  // 右侧导航项：消息、我的
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildNavItem(
                            context,
                            icon: PhosphorIcons.chatCircle(),
                            activeIcon: PhosphorIcons.chatCircle(PhosphorIconsStyle.fill),
                            label: '消息',
                            index: 2,
                          ),
                        ),
                        Expanded(
                          child: _buildNavItem(
                            context,
                            icon: PhosphorIcons.user(),
                            activeIcon: PhosphorIcons.user(PhosphorIconsStyle.fill),
                            label: '我的',
                            index: 3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}