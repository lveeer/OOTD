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
import 'features/post_editor/presentation/blocs/post_editor_bloc.dart';
import 'features/user_profile/presentation/pages/user_profile_page.dart';
import 'features/wallet/presentation/pages/wallet_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.configureDependencies();
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
          create: (context) => PostEditorBloc(),
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
    const PostEditorPlaceholder(),
    const MessagePage(),
    const UserProfilePage(),
  ];

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
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: Icon(PhosphorIcons.house()),
              activeIcon: Icon(PhosphorIcons.house(PhosphorIconsStyle.fill)),
              label: '首页',
            ),
            BottomNavigationBarItem(
              icon: Icon(PhosphorIcons.magnifyingGlass()),
              activeIcon: Icon(PhosphorIcons.magnifyingGlass(PhosphorIconsStyle.fill)),
              label: '发现',
            ),
            BottomNavigationBarItem(
              icon: Icon(PhosphorIcons.plusCircle()),
              activeIcon: Icon(PhosphorIcons.plusCircle(PhosphorIconsStyle.fill)),
              label: '发布',
            ),
            BottomNavigationBarItem(
              icon: Icon(PhosphorIcons.chatCircle()),
              activeIcon: Icon(PhosphorIcons.chatCircle(PhosphorIconsStyle.fill)),
              label: '消息',
            ),
            BottomNavigationBarItem(
              icon: Icon(PhosphorIcons.user()),
              activeIcon: Icon(PhosphorIcons.user(PhosphorIconsStyle.fill)),
              label: '我的',
            ),
          ],
        ),
      ),
    );
  }
}

class DiscoverPage extends StatelessWidget {
  const DiscoverPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('发现'),
      ),
      body: const Center(
        child: Text('发现页面'),
      ),
    );
  }
}

class PostEditorPlaceholder extends StatelessWidget {
  const PostEditorPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('发布'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const PostEditorPage(),
              ),
            );
          },
          child: const Text('开始发布'),
        ),
      ),
    );
  }
}

class MessagePage extends StatelessWidget {
  const MessagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('消息'),
      ),
      body: const Center(
        child: Text('消息页面'),
      ),
    );
  }
}

class PostEditorPage extends StatelessWidget {
  const PostEditorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PostEditorBloc(),
      child: const PostEditorView(),
    );
  }
}

class PostEditorView extends StatelessWidget {
  const PostEditorView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('发布穿搭'),
      ),
      body: const Center(
        child: Text('发布编辑器'),
      ),
    );
  }
}