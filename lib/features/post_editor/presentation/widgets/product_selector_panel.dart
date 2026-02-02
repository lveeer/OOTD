import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/models/product.dart';
import '../../../../shared/widgets/app_button.dart';

class ProductSelectorPanel extends StatefulWidget {
  final Product product;
  final Function(Product) onProductChanged;
  final VoidCallback onClose;

  const ProductSelectorPanel({
    super.key,
    required this.product,
    required this.onProductChanged,
    required this.onClose,
  });

  @override
  State<ProductSelectorPanel> createState() => _ProductSelectorPanelState();
}

class _ProductSelectorPanelState extends State<ProductSelectorPanel> {
  late TextEditingController _titleController;
  late TextEditingController _priceController;
  late TextEditingController _commissionController;
  late TextEditingController _linkController;
  int _selectedTab = 0;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.product.title);
    _priceController = TextEditingController(
      text: widget.product.finalPrice > 0
          ? widget.product.finalPrice.toStringAsFixed(2)
          : '',
    );
    _commissionController = TextEditingController(
      text: widget.product.commission != null && widget.product.commission! > 0
          ? widget.product.commission!.toStringAsFixed(2)
          : '',
    );
    _linkController = TextEditingController(text: widget.product.productUrl ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _commissionController.dispose();
    _linkController.dispose();
    super.dispose();
  }

  void _saveProduct() {
    final updatedProduct = widget.product.copyWith(
      title: _titleController.text.trim(),
      finalPrice: double.tryParse(_priceController.text) ?? 0,
      commission: double.tryParse(_commissionController.text),
      productUrl: _linkController.text.trim(),
    );
    widget.onProductChanged(updatedProduct);
    widget.onClose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: BoxDecoration(
        color: AppColors.secondaryBackgroundColor(Theme.of(context).brightness),
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          _buildHeader(),
          _buildTabs(),
          Expanded(
            child: _buildTabContent(),
          ),
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppColors.separatorColor(Theme.of(context).brightness),
          ),
        ),
      ),
      child: Row(
        children: [
          Text(
            '编辑商品',
            style: TextStyle(
              fontSize: AppConstants.fontSizeL,
              fontWeight: FontWeight.w600,
              color: AppColors.labelColor(Theme.of(context).brightness),
            ),
          ),
          Spacer(),
          IconButton(
            icon: Icon(PhosphorIcons.x()),
            onPressed: widget.onClose,
            color: AppColors.secondaryLabelColor(Theme.of(context).brightness),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppColors.separatorColor(Theme.of(context).brightness),
          ),
        ),
      ),
      child: Row(
        children: [
          _buildTab('搜索', 0),
          _buildTab('粘贴链接', 1),
        ],
      ),
    );
  }

  Widget _buildTab(String label, int index) {
    final isSelected = _selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedTab = index;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected
                    ? AppColors.accent
                    : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: AppConstants.fontSizeM,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              color: isSelected
                  ? AppColors.accent
                  : AppColors.secondaryLabelColor(Theme.of(context).brightness),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent() {
    switch (_selectedTab) {
      case 0:
        return _buildSearchContent();
      case 1:
        return _buildPasteLinkContent();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildSearchContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: '搜索商品',
              prefixIcon: Icon(PhosphorIcons.magnifyingGlass()),
              filled: true,
              fillColor: AppColors.fillColor(Theme.of(context).brightness),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppTheme.inputRadius),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          SizedBox(height: 16),
          _buildProductGrid(),
        ],
      ),
    );
  }

  Widget _buildProductGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.75,
      ),
      itemCount: 4,
      itemBuilder: (context, index) => _buildProductCard(),
    );
  }

  Widget _buildProductCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.backgroundColor(Theme.of(context).brightness),
        borderRadius: BorderRadius.circular(AppTheme.cardRadius),
        border: Border.all(
          color: AppColors.separatorColor(Theme.of(context).brightness),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.fillColor(Theme.of(context).brightness),
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(AppTheme.cardRadius),
                              ),
                            ),child: Center(
                  child: Icon(
                    PhosphorIcons.image(),
                    size: 32,
                    color: AppColors.tertiaryLabelColor(Theme.of(context).brightness),
                  ),
                ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '示例商品名称',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: AppConstants.fontSizeS,
                    color: AppColors.labelColor(Theme.of(context).brightness),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      '¥99.00',
                      style: TextStyle(
                        fontSize: AppConstants.fontSizeM,
                        fontWeight: FontWeight.w600,
                        color: AppColors.labelColor(Theme.of(context).brightness),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '赚¥5.00',
                      style: TextStyle(
                        fontSize: AppConstants.fontSizeXS,
                        color: AppColors.secondaryLabelColor(Theme.of(context).brightness),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasteLinkContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '粘贴商品链接',
            style: TextStyle(
              fontSize: AppConstants.fontSizeM,
              fontWeight: FontWeight.w500,
              color: AppColors.labelColor(Theme.of(context).brightness),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _linkController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: '粘贴淘宝/京东商品链接',
              filled: true,
              fillColor: AppColors.fillColor(Theme.of(context).brightness),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppTheme.inputRadius),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 16),
          AppButton(
            text: '解析链接',
            onPressed: () {
              HapticFeedback.lightImpact();
            },
            isFullWidth: true,
          ),
          const SizedBox(height: 24),
          _buildManualInput(),
        ],
      ),
    );
  }

  Widget _buildManualInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '手动输入',
          style: TextStyle(
            fontSize: AppConstants.fontSizeM,
            fontWeight: FontWeight.w500,
            color: AppColors.labelColor(Theme.of(context).brightness),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _titleController,
          decoration: InputDecoration(
            labelText: '商品名称',
            filled: true,
            fillColor: AppColors.fillColor(Theme.of(context).brightness),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppTheme.inputRadius),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _priceController,
                decoration: InputDecoration(
                  labelText: '价格',
                  prefixText: '¥',
                  filled: true,
                  fillColor: AppColors.fillColor(Theme.of(context).brightness),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppTheme.inputRadius),
                    borderSide: BorderSide.none,
                  ),
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: _commissionController,
                decoration: InputDecoration(
                  labelText: '佣金',
                  prefixText: '¥',
                  filled: true,
                  fillColor: AppColors.fillColor(Theme.of(context).brightness),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppTheme.inputRadius),
                    borderSide: BorderSide.none,
                  ),
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: AppColors.separatorColor(Theme.of(context).brightness),
          ),
        ),
      ),
      child: SafeArea(
        child: AppButton(
          text: '确定',
          onPressed: _saveProduct,
          isFullWidth: true,
        ),
      ),
    );
  }
}