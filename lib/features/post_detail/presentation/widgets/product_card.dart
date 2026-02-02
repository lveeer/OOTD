import 'package:flutter/material.dart';
import '../../../../shared/models/product.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/constants/app_constants.dart';

/// 商品卡片组件
class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback? onTap;
  final bool showCommission;

  const ProductCard({
    super.key,
    required this.product,
    this.onTap,
    this.showCommission = false,
  });

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isDark = brightness == Brightness.dark;

    return Card(
      elevation: 0,
      color: isDark ? AppColors.darkSecondaryBackground : AppColors.lightSecondaryBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.cardRadius),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.cardRadius),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 商品图
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(AppTheme.cardRadius),
              ),
              child: AspectRatio(
                aspectRatio: 1.0,
                child: Image.network(
                  product.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: isDark ? AppColors.darkFill : AppColors.lightFill,
                      child: Icon(
                        Icons.image_not_supported,
                        color: isDark ? AppColors.darkTertiaryLabel : AppColors.lightTertiaryLabel,
                      ),
                    );
                  },
                ),
              ),
            ),
            // 商品信息
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 标题
                  Text(
                    product.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: AppConstants.fontSizeM,
                      fontWeight: FontWeight.w400,
                      color: isDark ? AppColors.darkLabel : AppColors.lightLabel,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // 价格行
                  Row(
                    children: [
                      // 券后价
                      Text(
                        '¥${product.finalPrice.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: isDark ? Colors.white : Colors.black,
                          fontSize: AppConstants.fontSizeL,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      // 原价
                      if (product.originalPrice > product.finalPrice) ...[
                        const SizedBox(width: 8),
                        Text(
                          '¥${product.originalPrice.toStringAsFixed(2)}',
                          style: TextStyle(
                            color: isDark ? AppColors.darkTertiaryLabel : AppColors.lightTertiaryLabel,
                            fontSize: AppConstants.fontSizeS,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                      const Spacer(),
                      // 佣金标签（仅达人自己可见）
                      if (showCommission && product.commission != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppColors.darkFill
                                : AppColors.lightFill,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            '赚¥${product.commission!.toStringAsFixed(2)}',
                            style: TextStyle(
                              color: isDark ? AppColors.darkLabel : AppColors.lightLabel,
                              fontSize: AppConstants.fontSizeXS,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // 销量和评分
                  Row(
                    children: [
                      Icon(
                        Icons.shopping_bag_outlined,
                        size: 12,
                        color: isDark ? AppColors.darkTertiaryLabel : AppColors.lightTertiaryLabel,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '已售${_formatSalesCount(product.salesCount)}',
                        style: TextStyle(
                          fontSize: AppConstants.fontSizeXS,
                          color: isDark ? AppColors.darkTertiaryLabel : AppColors.lightTertiaryLabel,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Icon(
                        Icons.star,
                        size: 12,
                        color: isDark ? AppColors.darkTertiaryLabel : AppColors.lightTertiaryLabel,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        product.rating.toStringAsFixed(1),
                        style: TextStyle(
                          fontSize: AppConstants.fontSizeXS,
                          color: isDark ? AppColors.darkTertiaryLabel : AppColors.lightTertiaryLabel,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatSalesCount(int count) {
    if (count >= 10000) {
      return '${(count / 10000).toStringAsFixed(1)}万';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}k';
    }
    return count.toString();
  }
}