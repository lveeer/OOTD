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
  final String? selectedTagId;
  final bool isSaving;
  final bool isPublishing;
  final bool draftSaved;
  final bool published;
  final String? error;

  const PostEditorLoaded({
    this.images = const [],
    this.tags = const [],
    this.content = '',
    this.selectedTagId,
    this.isSaving = false,
    this.isPublishing = false,
    this.draftSaved = false,
    this.published = false,
    this.error,
  });

  Tag? get selectedTag {
    if (selectedTagId == null) return null;
    try {
      return tags.firstWhere((tag) => tag.id == selectedTagId);
    } catch (e) {
      return null;
    }
  }

  @override
  List<Object?> get props => [
        images,
        tags,
        content,
        selectedTagId,
        isSaving,
        isPublishing,
        draftSaved,
        published,
        error,
      ];

  PostEditorLoaded copyWith({
    List<MediaFile>? images,
    List<Tag>? tags,
    String? content,
    String? selectedTagId,
    bool? isSaving,
    bool? isPublishing,
    bool? draftSaved,
    bool? published,
    String? error,
  }) {
    return PostEditorLoaded(
      images: images ?? this.images,
      tags: tags ?? this.tags,
      content: content ?? this.content,
      selectedTagId: selectedTagId,
      isSaving: isSaving ?? this.isSaving,
      isPublishing: isPublishing ?? this.isPublishing,
      draftSaved: draftSaved ?? this.draftSaved,
      published: published ?? this.published,
      error: error,
    );
  }
}

class PostEditorPublished extends PostEditorState {}