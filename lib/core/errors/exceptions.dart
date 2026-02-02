/// 基础Exception类
abstract class AppException implements Exception {
  final String message;
  final int? code;

  AppException({
    required this.message,
    this.code,
  });

  @override
  String toString() => message;
}

/// 服务器异常
class ServerException extends AppException {
  ServerException({
    required String message,
    int? code,
  }) : super(message: message, code: code);
}

/// 网络异常
class NetworkException extends AppException {
  NetworkException({
    required String message,
  }) : super(message: message);
}

/// 缓存异常
class CacheException extends AppException {
  CacheException({
    required String message,
  }) : super(message: message);
}

/// 未授权异常
class UnauthorizedException extends AppException {
  UnauthorizedException({
    required String message,
  }) : super(message: message, code: 401);
}

/// 禁止访问异常
class ForbiddenException extends AppException {
  ForbiddenException({
    required String message,
  }) : super(message: message, code: 403);
}

/// 未找到异常
class NotFoundException extends AppException {
  NotFoundException({
    required String message,
  }) : super(message: message, code: 404);
}

/// 请求过于频繁异常
class TooManyRequestsException extends AppException {
  TooManyRequestsException({
    required String message,
  }) : super(message: message, code: 429);
}

/// 验证异常
class ValidationException extends AppException {
  ValidationException({
    required String message,
  }) : super(message: message);
}

/// 权限被拒绝异常
class PermissionDeniedException extends AppException {
  PermissionDeniedException({
    required String message,
  }) : super(message: message);
}

/// 未知异常
class UnknownException extends AppException {
  UnknownException({
    required String message,
  }) : super(message: message);
}