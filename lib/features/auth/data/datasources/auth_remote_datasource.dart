import 'package:injectable/injectable.dart';
import '../../../../core/di/injection_container.dart' as di;
import '../../../../core/network/dio_client.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login({
    required String phone,
    required String smsCode,
  });

  Future<void> sendSmsCode(String phone);

  Future<void> verifySmsCode({
    required String phone,
    required String code,
  });

  Future<UserModel> register({
    required String phone,
    required String smsCode,
    required String nickname,
  });

  Future<void> logout();

  Future<UserModel> getCurrentUser();

  Future<UserModel> updateProfile({
    String? nickname,
    String? avatar,
    String? bio,
  });

  Future<UserModel> refreshToken(String refreshToken);
}

@Injectable(as: AuthRemoteDataSource, env: [di.Environment.prod, di.Environment.dev])
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioClient dioClient;

  AuthRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<UserModel> login({
    required String phone,
    required String smsCode,
  }) async {
    final response = await dioClient.post(
      '/auth/login',
      data: {
        'phone': phone,
        'smsCode': smsCode,
      },
    );
    
    return UserModel.fromJson(response.data['data']);
  }

  @override
  Future<void> sendSmsCode(String phone) async {
    await dioClient.post(
      '/auth/sms/send',
      data: {'phone': phone},
    );
  }

  @override
  Future<void> verifySmsCode({
    required String phone,
    required String code,
  }) async {
    await dioClient.post(
      '/auth/sms/verify',
      data: {
        'phone': phone,
        'code': code,
      },
    );
  }

  @override
  Future<UserModel> register({
    required String phone,
    required String smsCode,
    required String nickname,
  }) async {
    final response = await dioClient.post(
      '/auth/register',
      data: {
        'phone': phone,
        'smsCode': smsCode,
        'nickname': nickname,
      },
    );
    
    return UserModel.fromJson(response.data['data']);
  }

  @override
  Future<void> logout() async {
    await dioClient.post('/auth/logout');
  }

  @override
  Future<UserModel> getCurrentUser() async {
    final response = await dioClient.get('/user/profile');
    return UserModel.fromJson(response.data['data']);
  }

  @override
  Future<UserModel> updateProfile({
    String? nickname,
    String? avatar,
    String? bio,
  }) async {
    final response = await dioClient.put(
      '/user/profile/update',
      data: {
        if (nickname != null) 'nickname': nickname,
        if (avatar != null) 'avatar': avatar,
        if (bio != null) 'bio': bio,
      },
    );
    
    return UserModel.fromJson(response.data['data']);
  }

  @override
  Future<UserModel> refreshToken(String refreshToken) async {
    final response = await dioClient.post(
      '/auth/refresh',
      data: {'refreshToken': refreshToken},
    );
    
    return UserModel.fromJson(response.data['data']);
  }
}