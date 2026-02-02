import 'package:equatable/equatable.dart';

/// 基础Failure类
abstract class Failure extends Equatable {
  final String message;
  final int? code;

  const Failure({
    required this.message,
    this.code,
  });

  @override
  List<Object?> get props => [message, code];
}

/// 服务器错误
class ServerFailure extends Failure {
  const ServerFailure({
    required String message,
    int? code,
  }) : super(message: message, code: code);
}

/// 网络错误
class NetworkFailure extends Failure {
  const NetworkFailure({
    required String message,
  }) : super(message: message);
}

/// 缓存错误
class CacheFailure extends Failure {
  const CacheFailure({
    required String message,
  }) : super(message: message);
}

/// 未授权错误(401)
class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure({
    required String message,
  }) : super(message: message, code: 401);
}

/// 禁止访问错误(403)
class ForbiddenFailure extends Failure {
  const ForbiddenFailure({
    required String message,
  }) : super(message: message, code: 403);
}

/// 未找到错误(404)
class NotFoundFailure extends Failure {
  const NotFoundFailure({
    required String message,
  }) : super(message: message, code: 404);
}

/// 请求过于频繁错误(429)
class TooManyRequestsFailure extends Failure {
  const TooManyRequestsFailure({
    required String message,
  }) : super(message: message, code: 429);
}

/// 验证错误
class ValidationFailure extends Failure {
  const ValidationFailure({
    required String message,
  }) : super(message: message);
}

/// 未知错误
class UnknownFailure extends Failure {
  const UnknownFailure({
    required String message,
  }) : super(message: message);
}

/// 权限被拒绝错误
class PermissionDeniedFailure extends Failure {
  const PermissionDeniedFailure({
    required String message,
  }) : super(message: message);
}