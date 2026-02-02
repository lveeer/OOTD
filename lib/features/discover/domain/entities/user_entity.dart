import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String nickname;
  final String avatar;
  final String bio;
  final int followersCount;
  final int followingCount;
  final int postsCount;
  final bool isVerified;

  const UserEntity({
    required this.id,
    required this.nickname,
    required this.avatar,
    required this.bio,
    required this.followersCount,
    required this.followingCount,
    required this.postsCount,
    required this.isVerified,
  });

  @override
  List<Object?> get props => [
        id,
        nickname,
        avatar,
        bio,
        followersCount,
        followingCount,
        postsCount,
        isVerified,
      ];
}