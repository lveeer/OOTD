import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import '../constants/app_constants.dart';
import '../mock/mock_config.dart';
import 'injection_container.config.dart';

final getIt = GetIt.instance;

// 定义环境常量
class Environment {
  static const String prod = 'prod';
  static const String dev = 'dev';
  static const String mock = 'mock';
}

@injectableInit
Future<void> configureDependencies({String environment = Environment.prod}) async {
  // 注册常量依赖
  getIt.registerSingleton<String>(
    AppConstants.baseUrlDev,
    instanceName: 'baseUrl',
  );
  getIt.registerSingleton<String>(
    '',
    instanceName: 'authToken',
  );

  // 根据 Mock 配置决定使用哪个环境
  final env = MockConfig.enabled ? Environment.mock : environment;

  getIt.init(environment: env);
}