import 'package:equatable/equatable.dart';
import 'user_entity.dart';

class PostEntity extends Equatable {
  final String id;
  final String content;
  final UserEntity author;
  final List<String> images;
  final int likesCount;
  final int commentsCount;
  final int sharesCount;
  final bool isLiked;
  final List<String> topics;
  final DateTime createdAt;

  const PostEntity({
    required this.id,
    required this.content,
    required this.author,
    required this.images,
    required this.likesCount,
    required this.commentsCount,
    required this.sharesCount,
    required this.isLiked,
    required this.topics,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        content,
        author,
        images,
        likesCount,
        commentsCount,
        sharesCount,
        isLiked,
        topics,
        createdAt,
      ];
}