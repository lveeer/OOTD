import 'package:equatable/equatable.dart';

class MediaFile extends Equatable {
  final String id;
  final String path;
  final String? url;
  final MediaType type;
  final int width;
  final int height;
  final int size;
  final DateTime? createdAt;

  const MediaFile({
    required this.id,
    required this.path,
    this.url,
    required this.type,
    required this.width,
    required this.height,
    required this.size,
    this.createdAt,
  });

  double get aspectRatio => height > 0 ? width / height : 1.0;

  @override
  List<Object?> get props => [
        id,
        path,
        url,
        type,
        width,
        height,
        size,
        createdAt,
      ];

  MediaFile copyWith({
    String? id,
    String? path,
    String? url,
    MediaType? type,
    int? width,
    int? height,
    int? size,
    DateTime? createdAt,
  }) {
    return MediaFile(
      id: id ?? this.id,
      path: path ?? this.path,
      url: url ?? this.url,
      type: type ?? this.type,
      width: width ?? this.width,
      height: height ?? this.height,
      size: size ?? this.size,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

enum MediaType {
  image,
  video,
}