import 'package:equatable/equatable.dart';

import 'package:vantage/core/domain/entities/product_entity.dart';

sealed class ProductDetailState extends Equatable {
  const ProductDetailState();

  @override
  List<Object?> get props => [];
}

final class ProductDetailReady extends ProductDetailState {
  const ProductDetailReady({
    required this.product,
    required this.selectedSize,
    required this.selectedColorIndex,
    required this.quantity,
  });

  final ProductEntity product;
  final String selectedSize;
  final int selectedColorIndex;
  final int quantity;

  ProductDetailReady copyWith({
    ProductEntity? product,
    String? selectedSize,
    int? selectedColorIndex,
    int? quantity,
  }) {
    return ProductDetailReady(
      product: product ?? this.product,
      selectedSize: selectedSize ?? this.selectedSize,
      selectedColorIndex: selectedColorIndex ?? this.selectedColorIndex,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  List<Object?> get props =>
      [product, selectedSize, selectedColorIndex, quantity];
}
