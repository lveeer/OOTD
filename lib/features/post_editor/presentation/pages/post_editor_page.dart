import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/models/media_file.dart';
import '../../../../shared/models/product.dart';
import '../../../../shared/services/image_picker_service.dart';
import '../../../../shared/widgets/app_button.dart';
import '../blocs/post_editor_bloc.dart';
import '../widgets/image_tag_editor.dart';
import '../widgets/product_selector_panel.dart';
import '../widgets/topic_selector.dart';

class PostEditorPage extends StatefulWidget {
  const PostEditorPage({super.key});

  @override
  State<PostEditorPage> createState() => _PostEditorPageState();
}

class _PostEditorPageState extends State<PostEditorPage> {
  final ImagePickerService _imagePickerService = ImagePickerService();
  final TextEditingController _contentController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<PostEditorBloc>().add(ChangeStep(1));
      }
    });
  }

  @override
  void dispose() {
    _contentController.dispose();
    _scrollController.dispose();
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

  void _showExitDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('放弃编辑'),
        content: const Text('确定要放弃当前编辑吗？'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.cardRadius),
        ),
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
  }

  void _saveDraft() {
    context.read<PostEditorBloc>().add(SaveDraft());
  }

  void _publishPost() {
    context.read<PostEditorBloc>().add(PublishPost());
  }

  void _nextStep() {
    if (context.read<PostEditorBloc>().state is PostEditorLoaded) {
      final state = context.read<PostEditorBloc>().state as PostEditorLoaded;
      if (state.currentStep < 3) {
        if (state.currentStep == 1 && state.images.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('请至少选择一张图片')),
          );
          return;
        }
        context.read<PostEditorBloc>().add(ChangeStep(state.currentStep + 1));
      }
    }
  }

  void _previousStep() {
    if (context.read<PostEditorBloc>().state is PostEditorLoaded) {
      final state = context.read<PostEditorBloc>().state as PostEditorLoaded;
      if (state.currentStep > 1) {
        context.read<PostEditorBloc>().add(ChangeStep(state.currentStep - 1));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PostEditorBloc, PostEditorState>(
      listener: (context, state) {
        if (state is PostEditorLoaded) {
          if (state.error != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error!),
                action: SnackBarAction(
                  label: '确定',
                  onPressed: () {
                    context.read<PostEditorBloc>().add(ClearError());
                  },
                ),
              ),
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
        return PopScope(
              canPop: false,
              onPopInvokedWithResult: (didPop, result) {
                if (!didPop) {
                  _showExitDialog();
                }
              },
              child: Scaffold(            appBar: _buildAppBar(state),
            body: state is PostEditorLoaded
                ? _buildBody(state)
                : const Center(child: CircularProgressIndicator()),
            bottomNavigationBar: state is PostEditorLoaded
                ? _buildBottomBar(state)
                : null,
          ),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(PostEditorState state) {
    int currentStep = 0;
    if (state is PostEditorLoaded) {
      currentStep = state.currentStep;
    }

    return AppBar(
      leading: IconButton(
        icon: Icon(PhosphorIcons.x()),
        onPressed: _showExitDialog,
      ),
      title: Row(
        children: [
          Text(
            '发布穿搭',
            style: TextStyle(fontSize: AppConstants.fontSizeM),
          ),
          SizedBox(width: 8),
          ...List.generate(3, (index) {
            final isActive = index < currentStep;
            return Padding(
              padding: const EdgeInsets.only(left: 4),
              child: Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isActive
                      ? AppColors.accent
                      : AppColors.grey300,
                ),
              ),
            );
          }),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _saveDraft,
          child: Text(
            '保存草稿',
            style: TextStyle(
              fontSize: AppConstants.fontSizeM,
              color: AppColors.labelColor(Theme.of(context).brightness),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBody(PostEditorLoaded state) {
    switch (state.currentStep) {
      case 1:
        return _buildImageSelectionStep(state);
      case 2:
        return _buildTagEditingStep(state);
      case 3:
        return _buildContentEditingStep(state);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildImageSelectionStep(PostEditorLoaded state) {
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: state.images.isEmpty
                ? _buildEmptyImageSelection()
                : _buildImagePreview(state),
          ),
          _buildImageActionButtons(state),
        ],
      ),
    );
  }

  Widget _buildEmptyImageSelection() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: AppColors.fillColor(Theme.of(context).brightness),
              borderRadius: BorderRadius.circular(60),
            ),
            child: Icon(
              PhosphorIcons.image(),
              size: 48,
              color: AppColors.secondaryLabelColor(Theme.of(context).brightness),
            ),
          ),
          SizedBox(height: 24),
          Text(
            '选择穿搭图片',
            style: TextStyle(
              fontSize: AppConstants.fontSizeL,
              fontWeight: FontWeight.w600,
              color: AppColors.labelColor(Theme.of(context).brightness),
            ),
          ),
          SizedBox(height: 8),
          Text(
            '最多选择9张图片',
            style: TextStyle(
              fontSize: AppConstants.fontSizeS,
              color: AppColors.secondaryLabelColor(Theme.of(context).brightness),
            ),
          ),
          SizedBox(height: 32),
          AppButton(
            text: '选择图片',
            onPressed: _pickImages,
            icon: Icon(PhosphorIcons.image()),
          ),
        ],
      ),
    );
  }

  Widget _buildImagePreview(PostEditorLoaded state) {
    return Column(
      children: [
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 3 / 4,
            ),
            itemCount: state.images.length + (state.images.length < 9 ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == state.images.length) {
                return _buildAddImageButton();
              }
              return _buildImageItem(state.images[index], index);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAddImageButton() {
    return GestureDetector(
      onTap: _pickImages,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.fillColor(Theme.of(context).brightness),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: AppColors.separatorColor(Theme.of(context).brightness),
            width: 1,
          ),
        ),
        child: Icon(
          PhosphorIcons.plus(),
          size: 32,
          color: AppColors.secondaryLabelColor(Theme.of(context).brightness),
        ),
      ),
    );
  }

  Widget _buildImageItem(MediaFile image, int index) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.file(
            File(image.path),
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
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
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                shape: BoxShape.circle,
              ),
              child: Icon(
                PhosphorIcons.x(),
                color: Colors.white,
                size: 14,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 4,
          left: 4,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.6),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              '${index + 1}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImageActionButtons(PostEditorLoaded state) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.secondaryBackgroundColor(Theme.of(context).brightness),
        border: Border(
          top: BorderSide(
            color: AppColors.separatorColor(Theme.of(context).brightness),
          ),
        ),
      ),
      child: SafeArea(
        child: AppButton(
          text: '下一步',
          onPressed: state.images.isNotEmpty ? _nextStep : null,
          isFullWidth: true,
          isDisabled: state.images.isEmpty,
        ),
      ),
    );
  }

  Widget _buildTagEditingStep(PostEditorLoaded state) {
    return Column(
      children: [
        Expanded(
          child: ImageTagEditor(
            images: state.images,
            initialTags: state.tags,
            currentImageIndex: state.currentStep - 1,
            selectedTag: state.selectedTag,
            onTagsChanged: (tags) {
              for (final tag in tags) {
                context.read<PostEditorBloc>().add(UpdateTag(tag));
              }
            },
            onTagTap: (tag) {
              context.read<PostEditorBloc>().add(SelectTag(tag.id));
            },
          ),
        ),
        if (state.selectedTag != null)
          ProductSelectorPanel(
            product: state.selectedTag!.product,
            onProductChanged: (product) {
              final updatedTag = state.selectedTag!.copyWith(product: product);
              context.read<PostEditorBloc>().add(UpdateTag(updatedTag));
            },
            onClose: () {
              context.read<PostEditorBloc>().add(const SelectTag(null));
            },
          ),
      ],
    );
  }

  Widget _buildContentEditingStep(PostEditorLoaded state) {
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '添加文案',
                    style: TextStyle(
                      fontSize: AppConstants.fontSizeL,
                      fontWeight: FontWeight.w600,
                      color: AppColors.labelColor(Theme.of(context).brightness),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _contentController,
                    maxLines: 8,
                    maxLength: 500,
                    decoration: InputDecoration(
                      hintText: '分享你的穿搭心得...',
                      filled: true,
                      fillColor: AppColors.fillColor(Theme.of(context).brightness),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppTheme.inputRadius),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onChanged: (value) {
                      context.read<PostEditorBloc>().add(UpdateContent(value));
                    },
                  ),
                  const SizedBox(height: 24),
                  const TopicSelector(),
                  const SizedBox(height: 24),
                  _buildProductSummary(state),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductSummary(PostEditorLoaded state) {
    if (state.tags.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '已添加商品 (${state.tags.length})',
          style: TextStyle(
            fontSize: AppConstants.fontSizeL,
            fontWeight: FontWeight.w600,
            color: AppColors.labelColor(Theme.of(context).brightness),
          ),
        ),
        const SizedBox(height: 12),
        ...state.tags.map((tag) => _buildProductSummaryItem(tag.product)),
      ],
    );
  }

  Widget _buildProductSummaryItem(Product product) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.fillColor(Theme.of(context).brightness),
        borderRadius: BorderRadius.circular(AppTheme.cardRadius),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: product.imageUrl.isNotEmpty
                ? Image.network(
                    product.imageUrl,
                    width: 48,
                    height: 48,
                    fit: BoxFit.cover,
                  )
                : Container(
                    width: 48,
                    height: 48,
                    color: AppColors.fillColor(Theme.of(context).brightness),
                    child: Icon(
                      PhosphorIcons.image(),
                      color: AppColors.secondaryLabelColor(Theme.of(context).brightness),
                    ),
                  ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: AppConstants.fontSizeM,
                    fontWeight: FontWeight.w500,
                    color: AppColors.labelColor(Theme.of(context).brightness),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      '¥${product.finalPrice.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: AppConstants.fontSizeM,
                        fontWeight: FontWeight.w600,
                        color: AppColors.labelColor(Theme.of(context).brightness),
                      ),
                    ),
                    if (product.commission != null && product.commission! > 0) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.fillColor(Theme.of(context).brightness),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '赚¥${product.commission!.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: AppConstants.fontSizeXS,
                            color: AppColors.secondaryLabelColor(Theme.of(context).brightness),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(PostEditorLoaded state) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.secondaryBackgroundColor(Theme.of(context).brightness),
        border: Border(
          top: BorderSide(
            color: AppColors.separatorColor(Theme.of(context).brightness),
          ),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            if (state.currentStep > 1)
              Expanded(
                child: AppButton(
                  text: '上一步',
                  onPressed: _previousStep,
                  type: AppButtonType.outline,
                ),
              ),
            if (state.currentStep > 1) const SizedBox(width: 12),
            Expanded(
              child: AppButton(
                text: state.currentStep == 3 ? '发布' : '下一步',
                onPressed: state.currentStep == 3 ? _publishPost : _nextStep,
                isLoading: state.isPublishing,
                isDisabled: state.currentStep == 1 && state.images.isEmpty,
              ),
            ),
          ],
        ),
      ),
    );
  }
}