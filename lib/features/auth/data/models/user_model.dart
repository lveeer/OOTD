import 'package:equatable/equatable.dart';
import '../../domain/entities/user_entity.dart';

class UserModel extends Equatable {
  final String id;
  final String nickname;
  final String? avatar;
  final String? phone;
  final String? email;
  final String? token;
  final String? refreshToken;
  final DateTime createdAt;

  const UserModel({
    required this.id,
    required this.nickname,
    this.avatar,
    this.phone,
    this.email,
    this.token,
    this.refreshToken,
    required this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      nickname: json['nickname'] as String,
      avatar: json['avatar'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      token: json['token'] as String?,
      refreshToken: json['refreshToken'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nickname': nickname,
      'avatar': avatar,
      'phone': phone,
      'email': email,
      'token': token,
      'refreshToken': refreshToken,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  UserEntity toEntity() {
    return UserEntity(
      id: id,
      nickname: nickname,
      avatar: avatar,
      phone: phone,
      email: email,
      token: token,
      refreshToken: refreshToken,
      createdAt: createdAt,
    );
  }

  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      nickname: entity.nickname,
      avatar: entity.avatar,
      phone: entity.phone,
      email: entity.email,
      token: entity.token,
      refreshToken: entity.refreshToken,
      createdAt: entity.createdAt,
    );
  }

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
}