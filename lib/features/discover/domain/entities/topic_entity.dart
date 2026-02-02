import 'package:equatable/equatable.dart';

class TopicEntity extends Equatable {
  final String id;
  final String name;
  final int postCount;
  final bool isHot;
  final String? coverImage;

  const TopicEntity({
    required this.id,
    required this.name,
    required this.postCount,
    required this.isHot,
    this.coverImage,
  });

  @override
  List<Object?> get props => [id, name, postCount, isHot, coverImage];
}