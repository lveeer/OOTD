import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';

class ChatInputField extends StatefulWidget {
  final ValueChanged<String> onSend;
  final VoidCallback? onImageSelected;

  const ChatInputField({
    super.key,
    required this.onSend,
    this.onImageSelected,
  });

  @override
  State<ChatInputField> createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends State<ChatInputField> {
  final TextEditingController _controller = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();
  bool _isComposing = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTextChanged(String text) {
    setState(() {
      _isComposing = text.trim().isNotEmpty;
    });
  }

  void _handleSend() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    widget.onSend(text);
    _controller.clear();
    setState(() {
      _isComposing = false;
    });
  }

  Future<void> _handlePickImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 1920,
        maxHeight: 1920,
      );

      if (image != null && mounted) {
        widget.onImageSelected?.call();
      }
    } catch (e) {
      // 处理错误
      debugPrint('选择图片失败: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brightness = theme.brightness;
    final labelColor = AppColors.labelColor(brightness);
    final secondaryLabelColor = AppColors.secondaryLabelColor(brightness);
    final fillColor = AppColors.fillColor(brightness);
    final separatorColor = AppColors.separatorColor(brightness);

    return Container(
      padding: EdgeInsets.only(
        left: AppConstants.spacingM,
        right: AppConstants.spacingM,
        top: AppConstants.spacingS,
        bottom: AppConstants.spacingM + MediaQuery.of(context).padding.bottom,
      ),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        border: Border(
          top: BorderSide(
            color: separatorColor,
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            // 图片选择按钮
            _buildIconButton(
              icon: PhosphorIcons.image(),
              onPressed: _handlePickImage,
              color: secondaryLabelColor,
            ),
            const SizedBox(width: AppConstants.spacingS),
            // 输入框
            Expanded(
              child: Container(
                constraints: const BoxConstraints(
                  maxHeight: 120,
                ),
                decoration: BoxDecoration(
                  color: fillColor,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: TextField(
                  controller: _controller,
                  onChanged: _handleTextChanged,
                  maxLines: null,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => _handleSend(),
                  style: TextStyle(
                    fontSize: AppConstants.fontSizeM,
                    color: labelColor,
                  ),
                  decoration: InputDecoration(
                    hintText: '输入消息...',
                    hintStyle: TextStyle(
                      fontSize: AppConstants.fontSizeM,
                      color: secondaryLabelColor,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    isDense: true,
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppConstants.spacingS),
            // 发送按钮
            _buildSendButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required VoidCallback onPressed,
    required Color color,
  }) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: AppColors.fillColor(Theme.of(context).brightness),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(icon, size: 20),
        onPressed: onPressed,
        color: color,
        padding: EdgeInsets.zero,
      ),
    );
  }

  Widget _buildSendButton() {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: _isComposing ? AppColors.accent : AppColors.fillColor(Theme.of(context).brightness),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(PhosphorIcons.paperPlaneRight(), size: 20),
        onPressed: _isComposing ? _handleSend : null,
        color: _isComposing ? Colors.white : AppColors.secondaryLabelColor(Theme.of(context).brightness),
        padding: EdgeInsets.zero,
      ),
    );
  }
}