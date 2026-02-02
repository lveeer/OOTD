import 'mock_config.dart';
import '../../shared/models/user.dart';

/// Mock 用户数据
class MockUserData {
  static const userId = 'mock_user_001';
  static const phone = MockConfig.testPhone;
  static const nickname = MockConfig.testNickname;
  static const avatar = 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=150';
  static const bio = '热爱穿搭，分享生活';
  static const email = 'test@example.com';
  static const token = 'mock_jwt_token_1234567890';
  static const refreshToken = 'mock_refresh_token_0987654321';
  static const isVerified = true;
  static const followersCount = 1256;
  static const followingCount = 89;
  static const postsCount = 42;

  /// 获取当前用户对象
  static User get currentUser => User(
        id: userId,
        nickname: nickname,
        avatar: avatar,
        bio: bio,
        phone: phone,
        email: email,
        followersCount: followersCount,
        followingCount: followingCount,
        postsCount: postsCount,
        isVerified: isVerified,
        createdAt: DateTime(2024, 1, 15),
        updatedAt: DateTime.now(),
      );

  /// 测试用户列表
  static const List<Map<String, dynamic>> testUsers = [
    {
      'id': 'mock_user_001',
      'phone': '13800138000',
      'nickname': '测试用户',
      'avatar': 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=150',
      'bio': '热爱穿搭，分享生活',
      'email': 'test@example.com',
      'followersCount': 1256,
      'followingCount': 89,
      'postsCount': 42,
      'isVerified': true,
    },
    {
      'id': 'mock_user_002',
      'phone': '13900139000',
      'nickname': '时尚达人',
      'avatar': 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150',
      'bio': '穿搭博主 | 坐标上海',
      'email': 'fashion@example.com',
      'followersCount': 5230,
      'followingCount': 156,
      'postsCount': 128,
      'isVerified': true,
    },
    {
      'id': 'mock_user_003',
      'phone': '13700137000',
      'nickname': '简约生活',
      'avatar': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150',
      'bio': '极简主义穿搭爱好者',
      'email': 'simple@example.com',
      'followersCount': 3456,
      'followingCount': 234,
      'postsCount': 89,
      'isVerified': false,
    },
  ];
}