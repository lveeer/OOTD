part of 'post_editor_bloc.dart';

abstract class PostEditorEvent extends Equatable {
  const PostEditorEvent();

  @override
  List<Object?> get props => [];
}

class AddImages extends PostEditorEvent {
  final List<MediaFile> images;

  const AddImages(this.images);

  @override
  List<Object?> get props => [images];
}

class RemoveImage extends PostEditorEvent {
  final int index;

  const RemoveImage(this.index);

  @override
  List<Object?> get props => [index];
}

class AddTag extends PostEditorEvent {
  final Tag tag;

  const AddTag(this.tag);

  @override
  List<Object?> get props => [tag];
}

class RemoveTag extends PostEditorEvent {
  final String tagId;

  const RemoveTag(this.tagId);

  @override
  List<Object?> get props => [tagId];
}

class UpdateTag extends PostEditorEvent {
  final Tag tag;

  const UpdateTag(this.tag);

  @override
  List<Object?> get props => [tag];
}

class SelectTag extends PostEditorEvent {
  final String? tagId;

  const SelectTag(this.tagId);

  @override
  List<Object?> get props => [tagId];
}

class UpdateContent extends PostEditorEvent {
  final String content;

  const UpdateContent(this.content);

  @override
  List<Object?> get props => [content];
}

class ChangeStep extends PostEditorEvent {
  final int step;

  const ChangeStep(this.step);

  @override
  List<Object?> get props => [step];
}

class SaveDraft extends PostEditorEvent {}

class PublishPost extends PostEditorEvent {}

class ClearError extends PostEditorEvent {}