import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/send_sms_code_usecase.dart';
import '../../domain/repositories/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final SendSmsCodeUseCase sendSmsCodeUseCase;
  final AuthRepository authRepository;

  AuthBloc({
    required this.loginUseCase,
    required this.sendSmsCodeUseCase,
    required this.authRepository,
  }) : super(AuthInitial()) {
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<LoginRequested>(_onLoginRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<SendSmsCodeRequested>(_onSendSmsCodeRequested);
  }

  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    
    final result = await authRepository.isLoggedIn();
    
    result.fold(
      (failure) => emit(AuthUnauthenticated()),
      (isLoggedIn) async {
        if (isLoggedIn) {
          final userResult = await authRepository.getCurrentUser();
          userResult.fold(
            (failure) => emit(AuthUnauthenticated()),
            (user) => emit(user != null 
                ? AuthAuthenticated(user: user) 
                : AuthUnauthenticated()),
          );
        } else {
          emit(AuthUnauthenticated());
        }
      },
    );
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    
    final result = await loginUseCase(LoginParams(
      phone: event.phone,
      smsCode: event.smsCode,
    ));
    
    result.fold(
      (failure) => emit(AuthError(message: _mapFailureToMessage(failure))),
      (user) => emit(AuthAuthenticated(user: user)),
    );
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    
    await authRepository.logout();
    emit(AuthUnauthenticated());
  }

  Future<void> _onSendSmsCodeRequested(
    SendSmsCodeRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(SmsCodeSending());
    
    final result = await sendSmsCodeUseCase(SendSmsCodeParams(phone: event.phone));
    
    result.fold(
      (failure) => emit(AuthError(message: _mapFailureToMessage(failure))),
      (success) => emit(SmsCodeSent()),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return (failure as ServerFailure).message;
      case NetworkFailure:
        return (failure as NetworkFailure).message;
      case UnauthorizedFailure:
        return (failure as UnauthorizedFailure).message;
      case ValidationFailure:
        return (failure as ValidationFailure).message;
      default:
        return '未知错误';
    }
  }
}