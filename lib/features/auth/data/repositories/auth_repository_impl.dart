import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/storage/secure_storage_helper.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/user_model.dart';

@Injectable(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final SecureStorageHelper secureStorage;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.secureStorage,
  });

  @override
  Future<Either<Failure, UserEntity>> login({
    required String phone,
    required String smsCode,
  }) async {
    try {
      final userModel = await remoteDataSource.login(
        phone: phone,
        smsCode: smsCode,
      );
      
      await secureStorage.setToken(userModel.token ?? '');
      await secureStorage.setRefreshToken(userModel.refreshToken ?? '');
      
      return Right(userModel.toEntity());
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> sendSmsCode(String phone) async {
    try {
      await remoteDataSource.sendSmsCode(phone);
      return const Right(true);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> verifySmsCode({
    required String phone,
    required String code,
  }) async {
    try {
      await remoteDataSource.verifySmsCode(phone: phone, code: code);
      return const Right(true);
    } on ValidationException catch (e) {
      return Left(ValidationFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> register({
    required String phone,
    required String smsCode,
    required String nickname,
  }) async {
    try {
      final userModel = await remoteDataSource.register(
        phone: phone,
        smsCode: smsCode,
        nickname: nickname,
      );
      
      await secureStorage.setToken(userModel.token ?? '');
      await secureStorage.setRefreshToken(userModel.refreshToken ?? '');
      
      return Right(userModel.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> logout() async {
    try {
      await remoteDataSource.logout();
      await secureStorage.clearAll();
      return const Right(true);
    } catch (e) {
      await secureStorage.clearAll();
      return const Right(true);
    }
  }

  @override
  Future<Either<Failure, UserEntity?>> getCurrentUser() async {
    try {
      final token = await secureStorage.getToken();
      if (token == null || token.isEmpty) {
        return const Right(null);
      }
      
      final userModel = await remoteDataSource.getCurrentUser();
      return Right(userModel.toEntity());
    } on UnauthorizedException {
      await secureStorage.clearAll();
      return const Right(null);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> isLoggedIn() async {
    try {
      final token = await secureStorage.getToken();
      return Right(token != null && token.isNotEmpty);
    } catch (e) {
      return const Right(false);
    }
  }

  @override
  Future<Either<Failure, UserEntity>> updateProfile({
    String? nickname,
    String? avatar,
    String? bio,
  }) async {
    try {
      final userModel = await remoteDataSource.updateProfile(
        nickname: nickname,
        avatar: avatar,
        bio: bio,
      );
      return Right(userModel.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> refreshToken() async {
    try {
      final refreshToken = await secureStorage.getRefreshToken();
      if (refreshToken == null || refreshToken.isEmpty) {
        return const Left(UnauthorizedFailure(message: '未登录'));
      }
      
      final userModel = await remoteDataSource.refreshToken(refreshToken);
      await secureStorage.setToken(userModel.token ?? '');
      await secureStorage.setRefreshToken(userModel.refreshToken ?? '');
      
      return const Right(true);
    } on UnauthorizedException {
      await secureStorage.clearAll();
      return const Left(UnauthorizedFailure(message: '登录已过期'));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }
}