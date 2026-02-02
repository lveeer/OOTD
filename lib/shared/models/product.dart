import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final String id;
  final String title;
  final String imageUrl;
  final double originalPrice;
  final double finalPrice;
  final double? commission;
  final String? platform;
  final String? productUrl;
  final String? taobaoPassword;
  final int salesCount;
  final double rating;
  final String? shopName;
  final DateTime? createdAt;

  const Product({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.originalPrice,
    required this.finalPrice,
    this.commission,
    this.platform,
    this.productUrl,
    this.taobaoPassword,
    this.salesCount = 0,
    this.rating = 0.0,
    this.shopName,
    this.createdAt,
  });

  double get discountRate {
    if (originalPrice <= 0) return 0;
    return ((originalPrice - finalPrice) / originalPrice * 100).roundToDouble();
  }

  @override
  List<Object?> get props => [
        id,
        title,
        imageUrl,
        originalPrice,
        finalPrice,
        commission,
        platform,
        productUrl,
        taobaoPassword,
        salesCount,
        rating,
        shopName,
        createdAt,
      ];

  Product copyWith({
    String? id,
    String? title,
    String? imageUrl,
    double? originalPrice,
    double? finalPrice,
    double? commission,
    String? platform,
    String? productUrl,
    String? taobaoPassword,
    int? salesCount,
    double? rating,
    String? shopName,
    DateTime? createdAt,
  }) {
    return Product(
      id: id ?? this.id,
      title: title ?? this.title,
      imageUrl: imageUrl ?? this.imageUrl,
      originalPrice: originalPrice ?? this.originalPrice,
      finalPrice: finalPrice ?? this.finalPrice,
      commission: commission ?? this.commission,
      platform: platform ?? this.platform,
      productUrl: productUrl ?? this.productUrl,
      taobaoPassword: taobaoPassword ?? this.taobaoPassword,
      salesCount: salesCount ?? this.salesCount,
      rating: rating ?? this.rating,
      shopName: shopName ?? this.shopName,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}