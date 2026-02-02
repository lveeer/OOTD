import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String nickname;
  final String? avatar;
  final String? phone;
  final String? email;
  final String? token;
  final String? refreshToken;
  final DateTime createdAt;

  const UserEntity({
    required this.id,
    required this.nickname,
    this.avatar,
    this.phone,
    this.email,
    this.token,
    this.refreshToken,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        nickname,
        avatar,
        phone,
        email,
        token,
        refreshToken,
        createdAt,
      ];

  UserEntity copyWith({
    String? id,
    String? nickname,
    String? avatar,
    String? phone,
    String? email,
    String? token,
    String? refreshToken,
    DateTime? createdAt,
  }) {
    return UserEntity(
      id: id ?? this.id,
      nickname: nickname ?? this.nickname,
      avatar: avatar ?? this.avatar,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      token: token ?? this.token,
      refreshToken: refreshToken ?? this.refreshToken,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}