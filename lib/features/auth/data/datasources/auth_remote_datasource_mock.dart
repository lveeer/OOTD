import 'package:injectable/injectable.dart';
import '../../../../core/di/injection_container.dart' as di;
import '../../../../core/mock/mock_config.dart';
import '../../../../core/mock/mock_user_data.dart' as mock_data;
import '../models/user_model.dart';
import 'auth_remote_datasource.dart';

/// Mock 认证数据源
@Injectable(as: AuthRemoteDataSource, env: [di.Environment.mock])
class AuthRemoteDataSourceMock implements AuthRemoteDataSource {
  @override
  Future<UserModel> login({
    required String phone,
    required String smsCode,
  }) async {
    // 模拟网络延迟
    await Future.delayed(const Duration(milliseconds: 500));

    // 验证测试账号
    if (phone == MockConfig.testPhone && smsCode == MockConfig.testSmsCode) {
      return UserModel(
        id: mock_data.MockUserData.userId,
        phone: mock_data.MockUserData.phone,
        nickname: mock_data.MockUserData.nickname,
        avatar: mock_data.MockUserData.avatar,
        token: mock_data.MockUserData.token,
        refreshToken: mock_data.MockUserData.refreshToken,
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
      );
    }

    throw Exception('手机号或验证码错误');
  }

  @override
  Future<void> sendSmsCode(String phone) async {
    // 模拟网络延迟
    await Future.delayed(const Duration(milliseconds: 300));

    if (phone != MockConfig.testPhone) {
      throw Exception('手机号不存在');
    }
  }

  @override
  Future<void> verifySmsCode({
    required String phone,
    required String code,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));

    if (phone != MockConfig.testPhone || code != MockConfig.testSmsCode) {
      throw Exception('验证码错误');
    }
  }

  @override
  Future<UserModel> register({
    required String phone,
    required String smsCode,
    required String nickname,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));

    if (phone == MockConfig.testPhone && smsCode == MockConfig.testSmsCode) {
      return UserModel(
        id: mock_data.MockUserData.userId,
        phone: mock_data.MockUserData.phone,
        nickname: nickname,
        avatar: mock_data.MockUserData.avatar,
        token: mock_data.MockUserData.token,
        refreshToken: mock_data.MockUserData.refreshToken,
        createdAt: DateTime.now(),
      );
    }

    throw Exception('注册失败');
  }

  @override
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 300));
  }

  @override
  Future<UserModel> getCurrentUser() async {
    await Future.delayed(const Duration(milliseconds: 300));

    return UserModel(
      id: mock_data.MockUserData.userId,
      phone: mock_data.MockUserData.phone,
      nickname: mock_data.MockUserData.nickname,
      avatar: mock_data.MockUserData.avatar,
      token: mock_data.MockUserData.token,
      refreshToken: mock_data.MockUserData.refreshToken,
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
    );
  }

  @override
  Future<UserModel> updateProfile({
    String? nickname,
    String? avatar,
    String? bio,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));

    return UserModel(
      id: mock_data.MockUserData.userId,
      phone: mock_data.MockUserData.phone,
      nickname: nickname ?? mock_data.MockUserData.nickname,
      avatar: avatar ?? mock_data.MockUserData.avatar,
      token: mock_data.MockUserData.token,
      refreshToken: mock_data.MockUserData.refreshToken,
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
    );
  }

  @override
  Future<UserModel> refreshToken(String refreshToken) async {
    await Future.delayed(const Duration(milliseconds: 300));

    if (refreshToken != mock_data.MockUserData.refreshToken) {
      throw Exception('Refresh Token 无效');
    }

    return UserModel(
      id: mock_data.MockUserData.userId,
      phone: mock_data.MockUserData.phone,
      nickname: mock_data.MockUserData.nickname,
      avatar: mock_data.MockUserData.avatar,
      token: mock_data.MockUserData.token,
      refreshToken: mock_data.MockUserData.refreshToken,
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
    );
  }
}