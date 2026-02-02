import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/models/tag.dart';
import '../../../../shared/models/product.dart';
import '../../../../shared/models/media_file.dart';

class ImageTagEditor extends StatefulWidget {
  final List<MediaFile> images;
  final List<Tag> initialTags;
  final int currentImageIndex;
  final Tag? selectedTag;
  final Function(List<Tag>) onTagsChanged;
  final Function(Tag) onTagTap;

  const ImageTagEditor({
    super.key,
    required this.images,
    required this.initialTags,
    required this.currentImageIndex,
    required this.selectedTag,
    required this.onTagsChanged,
    required this.onTagTap,
  });

  @override
  State<ImageTagEditor> createState() => _ImageTagEditorState();
}

class _ImageTagEditorState extends State<ImageTagEditor> {
  late PageController _pageController;
  late List<Tag> _tags;
  int _currentImageIndex = 0;
  Tag? _selectedTag;
  Tag? _draggingTag;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.currentImageIndex);
    _tags = List.from(widget.initialTags);
    _currentImageIndex = widget.currentImageIndex;
    _selectedTag = widget.selectedTag;
  }

  @override
  void didUpdateWidget(ImageTagEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentImageIndex != widget.currentImageIndex) {
      _currentImageIndex = widget.currentImageIndex;
      _pageController.animateToPage(
        _currentImageIndex,
        duration: AppTheme.normalAnimation,
        curve: Curves.easeInOut,
      );
    }
    if (oldWidget.selectedTag != widget.selectedTag) {
      _selectedTag = widget.selectedTag;
    }
    if (oldWidget.initialTags != widget.initialTags) {
      _tags = List.from(widget.initialTags);
    }
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
    widget.onTagTap(Tag(
      id: '',
      imageIndex: 0,
      relativePosition: Offset.zero,
      product: Product(
        id: '',
        title: '',
        imageUrl: '',
        originalPrice: 0,
        finalPrice: 0,
      ),
      createdAt: DateTime.now(),
    ));
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
      _selectedTag = newTag;
    });

    widget.onTagsChanged(_tags);
    widget.onTagTap(newTag);
    HapticFeedback.mediumImpact();
  }

  void _onTagTap(Tag tag) {
    setState(() {
      _selectedTag = tag;
    });
    widget.onTagTap(tag);
    HapticFeedback.lightImpact();
  }

  void _onTagPanStart(DragStartDetails details, Tag tag, Size containerSize) {
    setState(() {
      _draggingTag = tag;
    });
  }

  void _onTagPanUpdate(DragUpdateDetails details, Tag tag, Size containerSize) {
    if (_draggingTag == null) return;

    final image = widget.images[_currentImageIndex];
    final relativePosition = _calculateRelativePosition(
      details.localPosition,
      containerSize,
      image.aspectRatio,
    );

    final updatedTag = tag.copyWith(relativePosition: relativePosition);
    final index = _tags.indexWhere((t) => t.id == tag.id);
    if (index != -1) {
      setState(() {
        _tags[index] = updatedTag;
      });
      widget.onTagsChanged(_tags);
    }
  }

  void _onTagPanEnd(DragEndDetails details) {
    setState(() {
      _draggingTag = null;
    });
    widget.onTagsChanged(_tags);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.images.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              PhosphorIcons.image(),
              size: 64,
              color: AppColors.tertiaryLabelColor(Theme.of(context).brightness),
            ),
            const SizedBox(height: 16),
            Text(
              '请先选择图片',
              style: TextStyle(
                fontSize: AppConstants.fontSizeM,
                color: AppColors.secondaryLabelColor(Theme.of(context).brightness),
              ),
            ),
          ],
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final containerSize = Size(constraints.maxWidth, constraints.maxHeight);
        return Column(
          children: [
            Expanded(
              child: GestureDetector(
                onLongPressStart: (details) {
                  _onLongPress(details, containerSize);
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
                    ..._buildTags(containerSize),
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
                            width: index == _currentImageIndex ? 20 : 8,
                            height: 8,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: index == _currentImageIndex
                                  ? AppColors.accent
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
            _buildHint(),
          ],
        );
      },
    );
  }

  List<Widget> _buildTags(Size containerSize) {
    return _tags
        .where((tag) => tag.imageIndex == _currentImageIndex)
        .map((tag) {
      final position = tag.relativePosition;
      final image = widget.images[_currentImageIndex];
      final fittedSize = _applyBoxFit(
        BoxFit.contain,
        Size(image.aspectRatio * 100, 100),
        containerSize,
      );

      final horizontalPadding = (containerSize.width - fittedSize.width) / 2;
      final verticalPadding = (containerSize.height - fittedSize.height) / 2;

      final left = horizontalPadding + position.dx * fittedSize.width - 20;
      final top = verticalPadding + position.dy * fittedSize.height - 20;

      return Positioned(
        left: left,
        top: top,
        child: GestureDetector(
          onTap: () => _onTagTap(tag),
          onPanStart: (details) => _onTagPanStart(details, tag, containerSize),
          onPanUpdate: (details) => _onTagPanUpdate(details, tag, containerSize),
          onPanEnd: _onTagPanEnd,
          child: AnimatedScale(
            scale: _draggingTag?.id == tag.id ? 1.2 : 1.0,
            duration: AppTheme.fastAnimation,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _selectedTag?.id == tag.id
                    ? AppColors.accent
                    : AppColors.backgroundColor(Theme.of(context).brightness),
                border: Border.all(
                  color: AppColors.accent,
                  width: 2,
                ),
              ),
              child: Icon(
                PhosphorIcons.tag(),
                color: _selectedTag?.id == tag.id
                    ? Colors.white
                    : AppColors.accent,
                size: 20,
              ),
            ),
          ),
        ),
      );
    }).toList();
  }

  Widget _buildHint() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.fillColor(Theme.of(context).brightness),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            PhosphorIcons.handTap(),
            size: 16,
            color: AppColors.secondaryLabelColor(Theme.of(context).brightness),
          ),
          const SizedBox(width: 6),
          Text(
            '长按图片添加标签，拖拽调整位置',
            style: TextStyle(
              fontSize: AppConstants.fontSizeS,
              color: AppColors.secondaryLabelColor(Theme.of(context).brightness),
            ),
          ),
        ],
      ),
    );
  }
}