import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';

class TopicSelector extends StatefulWidget {
  const TopicSelector({super.key});

  @override
  State<TopicSelector> createState() => _TopicSelectorState();
}

class _TopicSelectorState extends State<TopicSelector> {
  final List<String> _availableTopics = [
    'OOTD',
    '今日穿搭',
    '时尚',
    '潮流',
    '日常',
    '通勤',
    '约会',
    '度假',
    '运动',
    '休闲',
  ];
  
  final List<String> _selectedTopics = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '添加话题',
          style: TextStyle(
            fontSize: AppConstants.fontSizeL,
            fontWeight: FontWeight.w600,
            color: AppColors.labelColor(Theme.of(context).brightness),
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _availableTopics.map((topic) {
            final isSelected = _selectedTopics.contains(topic);
            return _buildTopicChip(topic, isSelected);
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildTopicChip(String topic, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            _selectedTopics.remove(topic);
          } else if (_selectedTopics.length < 5) {
            _selectedTopics.add(topic);
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.accent
              : AppColors.fillColor(Theme.of(context).brightness),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? AppColors.accent
                : AppColors.separatorColor(Theme.of(context).brightness),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '#$topic',
              style: TextStyle(
                fontSize: AppConstants.fontSizeS,
                fontWeight: FontWeight.w500,
                color: isSelected
                    ? Colors.white
                    : AppColors.labelColor(Theme.of(context).brightness),
              ),
            ),
            if (isSelected) ...[
              const SizedBox(width: 6),
              Icon(
                PhosphorIcons.x(),
                size: 12,
                color: Colors.white,
              ),
            ],
          ],
        ),
      ),
    );
  }
}