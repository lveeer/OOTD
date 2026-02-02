import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../shared/models/media_file.dart';
import '../../../../shared/models/tag.dart';

part 'post_editor_event.dart';
part 'post_editor_state.dart';

class PostEditorBloc extends Bloc<PostEditorEvent, PostEditorState> {
  PostEditorBloc() : super(PostEditorInitial()) {
    on<AddImages>(_onAddImages);
    on<RemoveImage>(_onRemoveImage);
    on<AddTag>(_onAddTag);
    on<RemoveTag>(_onRemoveTag);
    on<UpdateContent>(_onUpdateContent);
    on<SaveDraft>(_onSaveDraft);
    on<PublishPost>(_onPublishPost);
  }

  Future<void> _onAddImages(
    AddImages event,
    Emitter<PostEditorState> emit,
  ) async {
    if (state is PostEditorLoaded) {
      final currentState = state as PostEditorLoaded;
      final newImages = [...currentState.images, ...event.images];
      
      if (newImages.length > 9) {
        emit(currentState.copyWith(
          error: '最多只能选择9张图片',
        ));
        return;
      }
      
      emit(currentState.copyWith(images: newImages));
    }
  }

  Future<void> _onRemoveImage(
    RemoveImage event,
    Emitter<PostEditorState> emit,
  ) async {
    if (state is PostEditorLoaded) {
      final currentState = state as PostEditorLoaded;
      final newImages = List<MediaFile>.from(currentState.images);
      newImages.removeAt(event.index);
      
      final newTags = currentState.tags
          .where((tag) => tag.imageIndex != event.index)
          .map((tag) => tag.imageIndex > event.index
              ? tag.copyWith(imageIndex: tag.imageIndex - 1)
              : tag)
          .toList();
      
      emit(currentState.copyWith(
        images: newImages,
        tags: newTags,
      ));
    }
  }

  Future<void> _onAddTag(
    AddTag event,
    Emitter<PostEditorState> emit,
  ) async {
    if (state is PostEditorLoaded) {
      final currentState = state as PostEditorLoaded;
      final newTags = [...currentState.tags, event.tag];
      emit(currentState.copyWith(tags: newTags));
    }
  }

  Future<void> _onRemoveTag(
    RemoveTag event,
    Emitter<PostEditorState> emit,
  ) async {
    if (state is PostEditorLoaded) {
      final currentState = state as PostEditorLoaded;
      final newTags = List<Tag>.from(currentState.tags);
      newTags.removeWhere((tag) => tag.id == event.tagId);
      emit(currentState.copyWith(tags: newTags));
    }
  }

  Future<void> _onUpdateContent(
    UpdateContent event,
    Emitter<PostEditorState> emit,
  ) async {
    if (state is PostEditorLoaded) {
      final currentState = state as PostEditorLoaded;
      emit(currentState.copyWith(content: event.content));
    }
  }

  Future<void> _onSaveDraft(
    SaveDraft event,
    Emitter<PostEditorState> emit,
  ) async {
    if (state is PostEditorLoaded) {
      final currentState = state as PostEditorLoaded;
      emit(currentState.copyWith(isSaving: true));
      
      await Future.delayed(const Duration(milliseconds: 500));
      
      emit(currentState.copyWith(
        isSaving: false,
        draftSaved: true,
      ));
    }
  }

  Future<void> _onPublishPost(
    PublishPost event,
    Emitter<PostEditorState> emit,
  ) async {
    if (state is PostEditorLoaded) {
      final currentState = state as PostEditorLoaded;
      
      if (currentState.images.isEmpty) {
        emit(currentState.copyWith(
          error: '请至少选择一张图片',
        ));
        return;
      }
      
      emit(currentState.copyWith(isPublishing: true));
      
      await Future.delayed(const Duration(seconds: 2));
      
      emit(PostEditorPublished());
    }
  }
}