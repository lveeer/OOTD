import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String nickname;
  final String? avatar;
  final String? bio;
  final String? phone;
  final String? email;
  final int followersCount;
  final int followingCount;
  final int postsCount;
  final bool isVerified;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const User({
    required this.id,
    required this.nickname,
    this.avatar,
    this.bio,
    this.phone,
    this.email,
    this.followersCount = 0,
    this.followingCount = 0,
    this.postsCount = 0,
    this.isVerified = false,
    required this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        nickname,
        avatar,
        bio,
        phone,
        email,
        followersCount,
        followingCount,
        postsCount,
        isVerified,
        createdAt,
        updatedAt,
      ];

  User copyWith({
    String? id,
    String? nickname,
    String? avatar,
    String? bio,
    String? phone,
    String? email,
    int? followersCount,
    int? followingCount,
    int? postsCount,
    bool? isVerified,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      nickname: nickname ?? this.nickname,
      avatar: avatar ?? this.avatar,
      bio: bio ?? this.bio,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      followersCount: followersCount ?? this.followersCount,
      followingCount: followingCount ?? this.followingCount,
      postsCount: postsCount ?? this.postsCount,
      isVerified: isVerified ?? this.isVerified,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}