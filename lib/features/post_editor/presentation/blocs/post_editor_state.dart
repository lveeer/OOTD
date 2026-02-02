part of 'post_editor_bloc.dart';

abstract class PostEditorState extends Equatable {
  const PostEditorState();

  @override
  List<Object?> get props => [];
}

class PostEditorInitial extends PostEditorState {}

class PostEditorLoaded extends PostEditorState {
  final List<MediaFile> images;
  final List<Tag> tags;
  final String content;
  final bool isSaving;
  final bool isPublishing;
  final bool draftSaved;
  final String? error;

  const PostEditorLoaded({
    this.images = const [],
    this.tags = const [],
    this.content = '',
    this.isSaving = false,
    this.isPublishing = false,
    this.draftSaved = false,
    this.error,
  });

  @override
  List<Object?> get props => [
        images,
        tags,
        content,
        isSaving,
        isPublishing,
        draftSaved,
        error,
      ];

  PostEditorLoaded copyWith({
    List<MediaFile>? images,
    List<Tag>? tags,
    String? content,
    bool? isSaving,
    bool? isPublishing,
    bool? draftSaved,
    String? error,
  }) {
    return PostEditorLoaded(
      images: images ?? this.images,
      tags: tags ?? this.tags,
      content: content ?? this.content,
      isSaving: isSaving ?? this.isSaving,
      isPublishing: isPublishing ?? this.isPublishing,
      draftSaved: draftSaved ?? this.draftSaved,
      error: error,
    );
  }
}

class PostEditorPublished extends PostEditorState {}