import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../shared/models/media_file.dart';
import '../../../../shared/models/tag.dart';

part 'post_editor_event.dart';
part 'post_editor_state.dart';

class PostEditorBloc extends Bloc<PostEditorEvent, PostEditorState> {
  PostEditorBloc() : super(const PostEditorLoaded()) {
    on<AddImages>(_onAddImages);
    on<RemoveImage>(_onRemoveImage);
    on<AddTag>(_onAddTag);
    on<RemoveTag>(_onRemoveTag);
    on<UpdateTag>(_onUpdateTag);
    on<SelectTag>(_onSelectTag);
    on<UpdateContent>(_onUpdateContent);
    on<SaveDraft>(_onSaveDraft);
    on<PublishPost>(_onPublishPost);
    on<ClearError>(_onClearError);
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
      emit(currentState.copyWith(
        tags: newTags,
        selectedTagId: currentState.selectedTagId == event.tagId ? null : currentState.selectedTagId,
      ));
    }
  }

  Future<void> _onUpdateTag(
    UpdateTag event,
    Emitter<PostEditorState> emit,
  ) async {
    if (state is PostEditorLoaded) {
      final currentState = state as PostEditorLoaded;
      final newTags = currentState.tags.map((tag) {
        return tag.id == event.tag.id ? event.tag : tag;
      }).toList();
      emit(currentState.copyWith(tags: newTags));
    }
  }

  Future<void> _onSelectTag(
    SelectTag event,
    Emitter<PostEditorState> emit,
  ) async {
    if (state is PostEditorLoaded) {
      final currentState = state as PostEditorLoaded;
      emit(currentState.copyWith(selectedTagId: event.tagId));
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

  Future<void> _onClearError(
    ClearError event,
    Emitter<PostEditorState> emit,
  ) async {
    if (state is PostEditorLoaded) {
      final currentState = state as PostEditorLoaded;
      emit(currentState.copyWith(error: null));
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

      // 模拟网络请求
      await Future.delayed(const Duration(seconds: 2));

      // 保持 PostEditorLoaded 状态，添加 published 标志
      emit(currentState.copyWith(
        isPublishing: false,
        draftSaved: false,
      ));
    }
  }
}