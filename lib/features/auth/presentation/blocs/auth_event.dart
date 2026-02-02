part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthCheckRequested extends AuthEvent {}

class LoginRequested extends AuthEvent {
  final String phone;
  final String smsCode;

  const LoginRequested({
    required this.phone,
    required this.smsCode,
  });

  @override
  List<Object?> get props => [phone, smsCode];
}

class LogoutRequested extends AuthEvent {}

class SendSmsCodeRequested extends AuthEvent {
  final String phone;

  const SendSmsCodeRequested({required this.phone});

  @override
  List<Object?> get props => [phone];
}