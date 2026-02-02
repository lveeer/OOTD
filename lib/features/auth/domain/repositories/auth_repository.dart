import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> login({
    required String phone,
    required String smsCode,
  });

  Future<Either<Failure, bool>> sendSmsCode(String phone);

  Future<Either<Failure, bool>> verifySmsCode({
    required String phone,
    required String code,
  });

  Future<Either<Failure, UserEntity>> register({
    required String phone,
    required String smsCode,
    required String nickname,
  });

  Future<Either<Failure, bool>> logout();

  Future<Either<Failure, UserEntity?>> getCurrentUser();

  Future<Either<Failure, bool>> isLoggedIn();

  Future<Either<Failure, UserEntity>> updateProfile({
    String? nickname,
    String? avatar,
    String? bio,
  });

  Future<Either<Failure, bool>> refreshToken();
}