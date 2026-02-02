import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

@injectable
class SendSmsCodeUseCase implements UseCase<bool, SendSmsCodeParams> {
  final AuthRepository repository;

  SendSmsCodeUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(SendSmsCodeParams params) {
    return repository.sendSmsCode(params.phone);
  }
}

class SendSmsCodeParams {
  final String phone;

  SendSmsCodeParams({required this.phone});
}