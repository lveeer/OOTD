import 'package:equatable/equatable.dart';
import '../../../../shared/models/user.dart';
import '../../../../shared/models/media_file.dart';
import '../../../../shared/models/tag.dart';

class PostEntity extends Equatable {
  final String id;
  final String content;
  final User author;
  final List<MediaFile> images;
  final List<Tag> tags;
  final int likesCount;
  final int commentsCount;
  final int sharesCount;
  final bool isLiked;
  final bool isCollected;
  final List<String> topics;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const PostEntity({
    required this.id,
    required this.content,
    required this.author,
    required this.images,
    required this.tags,
    this.likesCount = 0,
    this.commentsCount = 0,
    this.sharesCount = 0,
    this.isLiked = false,
    this.isCollected = false,
    this.topics = const [],
    required this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        content,
        author,
        images,
        tags,
        likesCount,
        commentsCount,
        sharesCount,
        isLiked,
        isCollected,
        topics,
        createdAt,
        updatedAt,
      ];

  PostEntity copyWith({
    String? id,
    String? content,
    User? author,
    List<MediaFile>? images,
    List<Tag>? tags,
    int? likesCount,
    int? commentsCount,
    int? sharesCount,
    bool? isLiked,
    bool? isCollected,
    List<String>? topics,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PostEntity(
      id: id ?? this.id,
      content: content ?? this.content,
      author: author ?? this.author,
      images: images ?? this.images,
      tags: tags ?? this.tags,
      likesCount: likesCount ?? this.likesCount,
      commentsCount: commentsCount ?? this.commentsCount,
      sharesCount: sharesCount ?? this.sharesCount,
      isLiked: isLiked ?? this.isLiked,
      isCollected: isCollected ?? this.isCollected,
      topics: topics ?? this.topics,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}