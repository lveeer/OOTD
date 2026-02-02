/// 应用常量定义
class AppConstants {
  // 应用信息
  static const String appName = '今日穿搭';
  static const String appVersion = '1.0.0';

  // API端点
  static const String baseUrlDev = 'https://dev-api.jinrichuanda.com';
  static const String baseUrlStaging = 'https://staging-api.jinrichuanda.com';
  static const String baseUrlProd = 'https://api.jinrichuanda.com';

  // 连接超时
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);

  // 分页配置
  static const int defaultPageSize = 20;
  static const int feedPageSize = 20;

  // 图片配置
  static const int maxImageCount = 9;
  static const int imageMaxWidth = 1080;
  static const int imageMaxHeight = 1440;
  static const int imageCompressQuality = 85;

  // Hive存储Key
  static const String hiveBoxName = 'ootd_app';
  static const String hiveDraftsBoxName = 'post_drafts';
  static const String hiveUserBoxName = 'user_data';
  static const String hiveCacheBoxName = 'app_cache';

  // SecureStorage Key
  static const String secureTokenKey = 'auth_token';
  static const String secureRefreshTokenKey = 'refresh_token';
  static const String securePidKey = 'pid';

  // 主题色
  static const int primaryColorValue = 0xFFFF6B9D;
  static const int secondaryColorValue = 0xFF4ECDC4;
  static const int backgroundColorValue = 0xFFFAFAFA;
  static const int surfaceColorValue = 0xFFFFFFFF;
  static const int errorColorValue = 0xFFFF5252;
  static const int warningColorValue = 0xFFFFB74D;
  static const int successColorValue = 0xFF4CAF50;

  // 间距
  static const double spacingXS = 4.0;
  static const double spacingS = 8.0;
  static const double spacingM = 16.0;
  static const double spacingL = 24.0;
  static const double spacingXL = 32.0;

  // 圆角
  static const double radiusS = 4.0;
  static const double radiusM = 8.0;
  static const double radiusL = 16.0;
  static const double radiusXL = 24.0;

  // 字体大小
  static const double fontSizeXS = 10.0;
  static const double fontSizeS = 12.0;
  static const double fontSizeM = 14.0;
  static const double fontSizeL = 16.0;
  static const double fontSizeXL = 18.0;
  static const double fontSizeXXL = 24.0;
  static const double fontSizeXXXL = 32.0;

  // 布局
  static const double maxWidth = 600.0;
  static const double bottomSheetHeight = 400.0;
  static const double imageAspectRatio = 3.0 / 4.0;

  // 标签配置
  static const double tagMinDistance = 30.0; // 标签间最小距离(px)
  static const double tagLongPressDuration = 600; // 长按触发时长(ms)
  static const double tagScaleFactor = 1.2; // 拖拽时缩放倍数

  // 淘宝配置
  static const String taobaoScheme = 'taobao://';
  static const String jdScheme = 'openApp.jdMobile://';
  static const String tmallScheme = 'tmall://';
  static final RegExp taobaoPasswordRegex = RegExp(r'[￥$¢€£]([a-zA-Z0-9]{11})[￥$¢€£]');

  // 通知渠道
  static const String notificationChannelId = 'ootd_notifications';
  static const String notificationChannelName = '今日穿搭通知';
  static const String notificationChannelDescription = '佣金到账、审核结果等通知';
}