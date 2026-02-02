import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/models/product.dart';
import '../../../../shared/models/tag.dart';
import '../../../../shared/services/image_picker_service.dart';
import '../../../../shared/widgets/app_button.dart';
import '../blocs/post_editor_bloc.dart';
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
  final PageController _imagePageController = PageController();
  bool _isEditMode = false;

  @override
  void dispose() {
    _contentController.dispose();
    _scrollController.dispose();
    _imagePageController.dispose();
    super.dispose();
  }

  void _onLongPressImage(LongPressStartDetails details, PostEditorLoaded state, int imageIndex) {
    final containerSize = Size(
      MediaQuery.of(context).size.width,
      MediaQuery.of(context).size.width * 0.72,
    );
    final relativePosition = _calculateRelativePosition(
      details.localPosition,
      containerSize,
      state.images[imageIndex].aspectRatio,
    );

    final newTag = Tag(
      id: const Uuid().v4(),
      imageIndex: imageIndex,
      relativePosition: relativePosition,
      product: const Product(
        id: '',
        title: '商品名称',
        imageUrl: '',
        originalPrice: 0,
        finalPrice: 0,
      ),
      createdAt: DateTime.now(),
    );

    context.read<PostEditorBloc>().add(AddTag(newTag));
    context.read<PostEditorBloc>().add(SelectTag(newTag.id));
    HapticFeedback.mediumImpact();
  }

  Offset _calculateRelativePosition(
    Offset localPosition,
    Size containerSize,
    double imageAspectRatio,
  ) {
    final fittedSize = _applyBoxFit(
      BoxFit.contain,
      Size(imageAspectRatio * 100, 100),
      containerSize,
    );

    final horizontalPadding = (containerSize.width - fittedSize.width) / 2;
    final verticalPadding = (containerSize.height - fittedSize.height) / 2;

    final x = (localPosition.dx - horizontalPadding) / fittedSize.width;
    final y = (localPosition.dy - verticalPadding) / fittedSize.height;

    return Offset(
      x.clamp(0.0, 1.0),
      y.clamp(0.0, 1.0),
    );
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
          if (state.published) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('发布成功')),
            );
          }
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
          child: Scaffold(
            appBar: _buildAppBar(),
            body: state is PostEditorLoaded
                ? Stack(
                    children: [
                      _buildBody(state),
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
                  )
                : const Center(child: CircularProgressIndicator()),
            bottomNavigationBar: state is PostEditorLoaded
                ? _buildBottomBar(state)
                : null,
          ),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      leading: IconButton(
        icon: Icon(PhosphorIcons.x()),
        onPressed: _showExitDialog,
      ),
      title: const Text(
        '发布穿搭',
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
    return SingleChildScrollView(
      controller: _scrollController,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildImageSection(state),
          _buildContentSection(state),
          _buildTopicSection(),
          _buildProductSummary(state),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildImageSection(PostEditorLoaded state) {
    if (state.images.isEmpty) {
      return _buildEmptyImageSelection();
    }

    return Container(
      height: MediaQuery.of(context).size.width * 0.72,
      color: AppColors.fillColor(Theme.of(context).brightness),
      child: Stack(
        children: [
          PageView.builder(
            controller: _imagePageController,
            itemCount: state.images.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  if (!_isEditMode) {
                    setState(() {
                      _isEditMode = true;
                    });
                  }
                },
                onLongPressStart: _isEditMode
                    ? (details) {
                        _onLongPressImage(details, state, index);
                      }
                    : null,
                child: Stack(
                  children: [
                    Center(
                      child: AspectRatio(
                        aspectRatio: state.images[index].aspectRatio,
                        child: Image.file(
                          File(state.images[index].path),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    _buildTagOverlay(state, index),
                    if (_isEditMode)
                      _buildEditModeOverlay(index),
                  ],
                ),
              );
            },
          ),
          Positioned(
            top: 16,
            right: 16,
            child: GestureDetector(
              onTap: _pickImages,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      PhosphorIcons.image(),
                      color: Colors.white,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${state.images.length}/9',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                state.images.length,
                (index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.accent.withOpacity(0.5),
                  ),
                ),
              ),
            ),
          ),
          if (_isEditMode)
            Positioned(
              top: 16,
              left: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.accent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      PhosphorIcons.tag(),
                      color: Colors.white,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      '编辑模式',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEditModeOverlay(int imageIndex) {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.1),
        ),
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              '长按添加标签',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTagOverlay(PostEditorLoaded state, int imageIndex) {
    final imageTags = state.tags.where((tag) => tag.imageIndex == imageIndex).toList();
    if (imageTags.isEmpty) return const SizedBox.shrink();

    return LayoutBuilder(
      builder: (context, constraints) {
        final containerSize = Size(constraints.maxWidth, constraints.maxHeight);
        final image = state.images[imageIndex];
        final fittedSize = _applyBoxFit(
          BoxFit.contain,
          Size(image.aspectRatio * 100, 100),
          containerSize,
        );

        final horizontalPadding = (containerSize.width - fittedSize.width) / 2;
        final verticalPadding = (containerSize.height - fittedSize.height) / 2;

        return Stack(
          children: imageTags.map((tag) {
            final position = tag.relativePosition;
            final left = horizontalPadding + position.dx * fittedSize.width - 20;
            final top = verticalPadding + position.dy * fittedSize.height - 20;

            return Positioned(
              left: left,
              top: top,
              child: GestureDetector(
                onTap: () {
                  context.read<PostEditorBloc>().add(SelectTag(tag.id));
                },
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: state.selectedTagId == tag.id
                        ? AppColors.accent
                        : AppColors.backgroundColor(Theme.of(context).brightness),
                    border: Border.all(
                      color: AppColors.accent,
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    PhosphorIcons.tag(),
                    color: state.selectedTagId == tag.id
                        ? Colors.white
                        : AppColors.accent,
                    size: 20,
                  ),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Size _applyBoxFit(BoxFit fit, Size source, Size destination) {
    final sourceRatio = source.width / source.height;
    final destinationRatio = destination.width / destination.height;

    Size size;
    if (sourceRatio > destinationRatio) {
      size = Size(destination.width, destination.width / sourceRatio);
    } else {
      size = Size(destination.height * sourceRatio, destination.height);
    }

    return size;
  }

  Widget _buildEmptyImageSelection() {
    return Container(
      height: MediaQuery.of(context).size.width * 0.72,
      color: AppColors.fillColor(Theme.of(context).brightness),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.backgroundColor(Theme.of(context).brightness),
                borderRadius: BorderRadius.circular(40),
              ),
              child: Icon(
                PhosphorIcons.image(),
                size: 32,
                color: AppColors.secondaryLabelColor(Theme.of(context).brightness),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '选择穿搭图片',
              style: TextStyle(
                fontSize: AppConstants.fontSizeM,
                fontWeight: FontWeight.w500,
                color: AppColors.labelColor(Theme.of(context).brightness),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '最多选择9张图片',
              style: TextStyle(
                fontSize: AppConstants.fontSizeS,
                color: AppColors.secondaryLabelColor(Theme.of(context).brightness),
              ),
            ),
            const SizedBox(height: 24),
            AppButton(
              text: '选择图片',
              onPressed: _pickImages,
              icon: Icon(PhosphorIcons.image()),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContentSection(PostEditorLoaded state) {
    return Padding(
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
            maxLines: 6,
            maxLength: 500,
            decoration: InputDecoration(
              hintText: '分享你的穿搭心得...',
              filled: true,
              fillColor: AppColors.fillColor(Theme.of(context).brightness),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppTheme.inputRadius),
                borderSide: BorderSide.none,
              ),
              counterText: '',
            ),
            onChanged: (value) {
              context.read<PostEditorBloc>().add(UpdateContent(value));
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTopicSection() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: TopicSelector(),
    );
  }

  Widget _buildProductSummary(PostEditorLoaded state) {
    if (state.tags.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
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
      ),
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
                    color: AppColors.backgroundColor(Theme.of(context).brightness),
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
                          color: AppColors.accent.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '赚¥${product.commission!.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: AppConstants.fontSizeXS,
                            color: AppColors.accent,
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
      child: SafeArea(
        child: AppButton(
          text: '发布',
          onPressed: _publishPost,
          isLoading: state.isPublishing,
          isDisabled: state.images.isEmpty,
          isFullWidth: true,
        ),
      ),
    );
  }
}