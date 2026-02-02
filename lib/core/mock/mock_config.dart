/// Mock 数据配置
class MockConfig {
  /// 是否启用 Mock 模式
  static const bool enabled = true;

  /// 测试账号配置
  static const testPhone = '13800138000';
  static const testSmsCode = '123456';
  static const testNickname = '测试用户';
}

/// Mock 用户数据
class MockUserData {
  static const userId = 'mock_user_001';
  static const phone = MockConfig.testPhone;
  static const nickname = MockConfig.testNickname;
  static const avatar = 'https://via.placeholder.com/150';
  static const bio = '这是一个测试账号';
  static const token = 'mock_jwt_token_1234567890';
  static const refreshToken = 'mock_refresh_token_0987654321';
  static const isVerified = true;
  static const postsCount = 42;
  static const followersCount = 128;
  static const followingCount = 56;
}