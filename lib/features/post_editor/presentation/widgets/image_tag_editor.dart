import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/models/tag.dart';
import '../../../../shared/models/product.dart';
import '../../../../shared/models/media_file.dart';

class ImageTagEditor extends StatefulWidget {
  final List<MediaFile> images;
  final List<Tag> initialTags;
  final Function(List<Tag>) onTagsChanged;

  const ImageTagEditor({
    super.key,
    required this.images,
    required this.initialTags,
    required this.onTagsChanged,
  });

  @override
  State<ImageTagEditor> createState() => _ImageTagEditorState();
}

class _ImageTagEditorState extends State<ImageTagEditor> {
  late PageController _pageController;
  late List<Tag> _tags;
  late List<Offset> _tagPositions;
  int _currentImageIndex = 0;
  Tag? _selectedTag;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _tags = List.from(widget.initialTags);
    _tagPositions = _tags.map((tag) => tag.relativePosition).toList();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentImageIndex = index;
      _selectedTag = null;
    });
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

  void _onLongPress(LongPressStartDetails details, Size containerSize) {
    final image = widget.images[_currentImageIndex];
    final relativePosition = _calculateRelativePosition(
      details.localPosition,
      containerSize,
      image.aspectRatio,
    );

    final newTag = Tag(
      id: const Uuid().v4(),
      imageIndex: _currentImageIndex,
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

    setState(() {
      _tags.add(newTag);
      _tagPositions.add(relativePosition);
      _selectedTag = newTag;
    });

    widget.onTagsChanged(_tags);
    HapticFeedback.mediumImpact();
  }

  void _onTagTap(Tag tag) {
    setState(() {
      _selectedTag = tag;
    });
  }

  void _deleteTag(Tag tag) {
    setState(() {
      _tags.remove(tag);
      _tagPositions.remove(tag.relativePosition);
      _selectedTag = null;
    });
    widget.onTagsChanged(_tags);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.images.isEmpty) {
      return const Center(
        child: Text('请先选择图片'),
      );
    }

    return Column(
      children: [
        Expanded(
          child: GestureDetector(
            onLongPressStart: (details) {
              final box = context.findRenderObject() as RenderBox?;
              if (box != null) {
                _onLongPress(details, box.size);
              }
            },
            child: Stack(
              children: [
                PageView.builder(
                  controller: _pageController,
                  onPageChanged: _onPageChanged,
                  itemCount: widget.images.length,
                  itemBuilder: (context, index) {
                    final image = widget.images[index];
                    return Center(
                      child: AspectRatio(
                        aspectRatio: image.aspectRatio,
                        child: Image.file(
                          File(image.path),
                          fit: BoxFit.contain,
                        ),
                      ),
                    );
                  },
                ),
                ..._buildTags(),
                Positioned(
                  bottom: 16,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      widget.images.length,
                      (index) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: index == _currentImageIndex
                              ? AppColors.accent // 黑色
                              : AppColors.grey400,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (_selectedTag != null)
          _buildTagEditorPanel(),
      ],
    );
  }

  List<Widget> _buildTags() {
    return _tags
        .where((tag) => tag.imageIndex == _currentImageIndex)
        .map((tag) {
      final position = tag.relativePosition;
      return Positioned(
        left: position.dx * MediaQuery.of(context).size.width - 20,
        top: position.dy * (MediaQuery.of(context).size.width / 3 * 4) - 20,
        child: GestureDetector(
          onTap: () => _onTagTap(tag),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _selectedTag?.id == tag.id
                  ? AppColors.accent // 黑色
                  : Colors.white,
              border: Border.all(
                color: AppColors.accent, // 黑色
                width: 2,
              ),
              boxShadow: [], // 移除阴影
            ),
            child: Icon(
              PhosphorIcons.tag(),
              color: _selectedTag?.id == tag.id
                  ? Colors.white
                  : AppColors.accent, // 黑色
              size: 20,
            ),
          ),
        ),
      );
    }).toList();
  }

  Widget _buildTagEditorPanel() {
    return Container(
      height: 300,
      decoration: BoxDecoration(
        color: AppColors.secondaryBackgroundColor(Theme.of(context).brightness),
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppConstants.radiusL),
        ),
        boxShadow: AppColors.elevatedShadow(Theme.of(context).brightness),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(AppConstants.spacingM),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: AppColors.grey200),
              ),
            ),
            child: Row(
              children: [
                const Text(
                  '编辑标签',
                  style: TextStyle(
                    fontSize: AppConstants.fontSizeL,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(PhosphorIcons.trash()),
                  onPressed: () => _deleteTag(_selectedTag!),
                  color: AppColors.error,
                ),
                IconButton(
                  icon: const Icon(PhosphorIcons.x()),
                  onPressed: () {
                    setState(() {
                      _selectedTag = null;
                    });
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.spacingM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '商品信息',
                    style: TextStyle(
                      fontSize: AppConstants.fontSizeM,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: AppConstants.spacingM),
                  TextField(
                    decoration: const InputDecoration(
                      labelText: '商品名称',
                      hintText: '输入商品名称',
                    ),
                    controller: TextEditingController(
                      text: _selectedTag?.product.title ?? '',
                    ),
                  ),
                  const SizedBox(height: AppConstants.spacingM),
                  TextField(
                    decoration: const InputDecoration(
                      labelText: '商品链接',
                      hintText: '输入商品链接',
                    ),
                  ),
                  const SizedBox(height: AppConstants.spacingM),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: const InputDecoration(
                            labelText: '价格',
                            hintText: '¥',
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: AppConstants.spacingM),
                      Expanded(
                        child: TextField(
                          decoration: const InputDecoration(
                            labelText: '佣金',
                            hintText: '¥',
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}