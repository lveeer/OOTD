import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../errors/failures.dart';

/// 基础UseCase类
/// Type: 返回数据类型
/// Params: 参数类型
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

/// 无参数UseCase
class NoParams extends Equatable {
  @override
  List<Object?> get props => [];
}