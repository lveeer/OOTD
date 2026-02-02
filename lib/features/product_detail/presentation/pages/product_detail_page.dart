import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/models/product.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/services/deep_link_service.dart';

class ProductDetailPage extends StatefulWidget {
  final Product product;

  const ProductDetailPage({super.key, required this.product});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  final DeepLinkService _deepLinkService = DeepLinkService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('商品详情'),
        actions: [
          IconButton(
            icon: const Icon(PhosphorIcons.shareNetwork()),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProductImage(),
            _buildProductInfo(),
            _buildProductDetails(),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildProductImage() {
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: widget.product.imageUrl,
          width: double.infinity,
          height: 400,
          fit: BoxFit.contain,
          placeholder: (context, url) => Container(
            height: 400,
            color: AppColors.grey100,
            child: const Center(child: CircularProgressIndicator()),
          ),
          errorWidget: (context, url, error) => Container(
            height: 400,
            color: AppColors.grey100,
            child: const Icon(PhosphorIcons.image(), size: 80),
          ),
        ),
        if (widget.product.discountRate > 0)
          Positioned(
            top: 16,
            left: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: AppColors.error,
                borderRadius: BorderRadius.circular(AppConstants.radiusS),
              ),
              child: Text(
                '${widget.product.discountRate.toStringAsFixed(0)}% OFF',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: AppConstants.fontSizeS,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildProductInfo() {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.spacingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.product.title,
            style: const TextStyle(
              fontSize: AppConstants.fontSizeL,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppConstants.spacingM),
          Row(
            children: [
              Text(
                '¥${widget.product.finalPrice.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: AppConstants.fontSizeXXL,
                  color: AppColors.error,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (widget.product.originalPrice > widget.product.finalPrice) ...[
                const SizedBox(width: AppConstants.spacingM),
                Text(
                  '¥${widget.product.originalPrice.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: AppConstants.fontSizeM,
                    color: AppColors.grey500,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: AppConstants.spacingM),
          Row(
            children: [
              const Icon(PhosphorIcons.star(), color: AppColors.warning, size: 16),
              const SizedBox(width: 4),
              Text(
                widget.product.rating.toStringAsFixed(1),
                style: const TextStyle(
                  fontSize: AppConstants.fontSizeM,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: AppConstants.spacingM),
              Text(
                '已售 ${widget.product.salesCount}',
                style: TextStyle(
                  fontSize: AppConstants.fontSizeS,
                  color: AppColors.grey600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProductDetails() {
    return Container(
      margin: const EdgeInsets.all(AppConstants.spacingL),
      padding: const EdgeInsets.all(AppConstants.spacingL),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppConstants.radiusL),
        boxShadow: AppColors.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '商品详情',
            style: TextStyle(
              fontSize: AppConstants.fontSizeL,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppConstants.spacingM),
          if (widget.product.shopName != null)
            _buildDetailRow('店铺', widget.product.shopName!),
          if (widget.product.platform != null)
            _buildDetailRow('平台', widget.product.platform!),
          _buildDetailRow('佣金', '¥${widget.product.commission?.toStringAsFixed(2) ?? '0.00'}'),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppConstants.spacingS),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: TextStyle(
                color: AppColors.grey600,
                fontSize: AppConstants.fontSizeM,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: AppConstants.fontSizeM,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
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
            Expanded(
              child: AppButton(
                text: '加入选品库',
                onPressed: () {},
                type: AppButtonType.outline,
              ),
            ),
            const SizedBox(width: AppConstants.spacingM),
            Expanded(
              flex: 2,
              child: AppButton(
                text: '去购买',
                onPressed: () async {
                  if (widget.product.productUrl != null) {
                    await _deepLinkService.openUrl(widget.product.productUrl!);
                  }
                },
                type: AppButtonType.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}