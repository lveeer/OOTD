import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'product.dart';

class Tag extends Equatable {
  final String id;
  final int imageIndex;
  final Offset relativePosition;
  final Product product;
  final DateTime createdAt;

  const Tag({
    required this.id,
    required this.imageIndex,
    required this.relativePosition,
    required this.product,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        imageIndex,
        relativePosition,
        product,
        createdAt,
      ];

  Tag copyWith({
    String? id,
    int? imageIndex,
    Offset? relativePosition,
    Product? product,
    DateTime? createdAt,
  }) {
    return Tag(
      id: id ?? this.id,
      imageIndex: imageIndex ?? this.imageIndex,
      relativePosition: relativePosition ?? this.relativePosition,
      product: product ?? this.product,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'imageIndex': imageIndex,
      'relativePosition': {'dx': relativePosition.dx, 'dy': relativePosition.dy},
      'product': product,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Tag.fromJson(Map<String, dynamic> json) {
    final position = json['relativePosition'] as Map<String, dynamic>;
    return Tag(
      id: json['id'] as String,
      imageIndex: json['imageIndex'] as int,
      relativePosition: Offset(
        (position['dx'] as num).toDouble(),
        (position['dy'] as num).toDouble(),
      ),
      product: json['product'] as Product,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}