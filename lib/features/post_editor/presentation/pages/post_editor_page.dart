import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/services/image_picker_service.dart';
import '../../../../shared/widgets/app_button.dart';
import '../blocs/post_editor_bloc.dart';
import '../widgets/image_tag_editor.dart';

class PostEditorPage extends StatefulWidget {
  const PostEditorPage({super.key});

  @override
  State<PostEditorPage> createState() => _PostEditorPageState();
}

class _PostEditorPageState extends State<PostEditorPage> {
  final ImagePickerService _imagePickerService = ImagePickerService();
  final TextEditingController _contentController = TextEditingController();
  int _currentStep = 0;

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    try {
      final images = await _imagePickerService.pickImages();
      if (images.isNotEmpty) {
        if (!mounted) return;
        context.read<PostEditorBloc>().add(AddImages(images));
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('选择图片失败: $e')),
      );
    }
  }

  void _nextStep() {
    if (_currentStep < 2) {
      setState(() {
        _currentStep++;
      });
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    }
  }

  void _saveDraft() {
    context.read<PostEditorBloc>().add(SaveDraft());
  }

  void _publishPost() {
    context.read<PostEditorBloc>().add(PublishPost());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(PhosphorIcons.x()),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('放弃编辑'),
                content: const Text('确定要放弃当前编辑吗？'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('取消'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: const Text('确定'),
                  ),
                ],
              ),
            );
          },
        ),
        title: Text(
          '发布穿搭 ${_currentStep + 1}/3',
          style: const TextStyle(fontSize: AppConstants.fontSizeM),
        ),
        actions: [
          TextButton(
            onPressed: _saveDraft,
            child: const Text('保存草稿'),
          ),
        ],
      ),
      body: BlocConsumer<PostEditorBloc, PostEditorState>(
        listener: (context, state) {
          if (state is PostEditorLoaded) {
            if (state.error != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error!)),
              );
            }
            if (state.draftSaved) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('草稿已保存')),
              );
            }
          }
          if (state is PostEditorPublished) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('发布成功')),
            );
          }
        },
        builder: (context, state) {
          if (state is! PostEditorLoaded) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              Expanded(
                child: _buildStepContent(state),
              ),
              _buildBottomBar(state),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStepContent(PostEditorLoaded state) {
    switch (_currentStep) {
      case 0:
        return _buildImageSelectionStep(state);
      case 1:
        return _buildTagEditingStep(state);
      case 2:
        return _buildContentEditingStep(state);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildImageSelectionStep(PostEditorLoaded state) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            PhosphorIcons.image(),
            size: 80,
            color: AppColors.grey400,
          ),
          const SizedBox(height: 16),
          Text(
            '选择穿搭图片',
            style: TextStyle(
              fontSize: AppConstants.fontSizeL,
              color: AppColors.grey600,
            ),
          ),
          const SizedBox(height: 24),
          AppButton(
            text: '选择图片',
            onPressed: _pickImages,
            icon: const Icon(PhosphorIcons.image()),
          ),
          const SizedBox(height: 8),
          Text(
            '最多选择9张图片',
            style: TextStyle(
              fontSize: AppConstants.fontSizeS,
              color: AppColors.grey500,
            ),
          ),
          if (state.images.isNotEmpty) ...[
            const SizedBox(height: 24),
            Container(
              height: 200,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.builder(
                scrollDirection: Axis.horizontal,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  mainAxisSpacing: 8,
                  childAspectRatio: 3 / 4,
                ),
                itemCount: state.images.length,
                itemBuilder: (context, index) {
                  final image = state.images[index];
                  return Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          File(image.path),
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 4,
                        right: 4,
                        child: GestureDetector(
                          onTap: () {
                            context.read<PostEditorBloc>().add(RemoveImage(index));
                          },
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              PhosphorIcons.x(),
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTagEditingStep(PostEditorLoaded state) {
    if (state.images.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              PhosphorIcons.warning(),
              size: 80,
              color: AppColors.warning,
            ),
            const SizedBox(height: 16),
            Text(
              '请先选择图片',
              style: TextStyle(
                fontSize: AppConstants.fontSizeL,
                color: AppColors.grey600,
              ),
            ),
          ],
        ),
      );
    }

    return ImageTagEditor(
      images: state.images,
      initialTags: state.tags,
      onTagsChanged: (tags) {
      },
    );
  }

  Widget _buildContentEditingStep(PostEditorLoaded state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.spacingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '添加文案',
            style: TextStyle(
              fontSize: AppConstants.fontSizeL,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppConstants.spacingM),
          TextField(
            controller: _contentController,
            maxLines: 10,
            maxLength: 500,
            decoration: InputDecoration(
              hintText: '分享你的穿搭心得...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppConstants.radiusM),
              ),
            ),
            onChanged: (value) {
              context.read<PostEditorBloc>().add(UpdateContent(value));
            },
          ),
          const SizedBox(height: AppConstants.spacingL),
          const Text(
            '添加话题',
            style: TextStyle(
              fontSize: AppConstants.fontSizeL,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppConstants.spacingM),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildTopicChip('OOTD'),
              _buildTopicChip('今日穿搭'),
              _buildTopicChip('时尚'),
              _buildTopicChip('潮流'),
              _buildTopicChip('日常'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTopicChip(String topic) {
    return Chip(
      label: Text(topic),
      onDeleted: () {},
    );
  }

  Widget _buildBottomBar(PostEditorLoaded state) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingM),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            if (_currentStep > 0)
              Expanded(
                child: AppButton(
                  text: '上一步',
                  onPressed: _previousStep,
                  type: AppButtonType.outline,
                ),
              ),
            if (_currentStep > 0) const SizedBox(width: AppConstants.spacingM),
            Expanded(
              flex: _currentStep == 2 ? 2 : 1,
              child: AppButton(
                text: _currentStep == 2 ? '发布' : '下一步',
                onPressed: _currentStep == 2 ? _publishPost : _nextStep,
                type: AppButtonType.primary,
                isLoading: state.isPublishing,
                isDisabled: _currentStep == 0 && state.images.isEmpty,
              ),
            ),
          ],
        ),
      ),
    );
  }
}