import 'package:equatable/equatable.dart';

final class CartLineInput extends Equatable {
  const CartLineInput({
    required this.productId,
    required this.name,
    required this.imageUrl,
    required this.unitPrice,
    required this.size,
    required this.colorLabel,
    this.quantityDelta = 1,
  });

  final String productId;
  final String name;
  final String imageUrl;
  final double unitPrice;
  final String size;
  final String colorLabel;
  final int quantityDelta;

  @override
  List<Object?> get props => [
        productId,
        name,
        imageUrl,
        unitPrice,
        size,
        colorLabel,
        quantityDelta,
      ];
}
