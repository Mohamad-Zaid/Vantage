import 'package:equatable/equatable.dart';

final class CartLineEntity extends Equatable {
  const CartLineEntity({
    required this.id,
    required this.productId,
    required this.name,
    required this.imageUrl,
    required this.unitPrice,
    required this.quantity,
    required this.size,
    required this.colorLabel,
  });

  final String id;
  final String productId;
  final String name;
  final String imageUrl;
  final double unitPrice;
  final int quantity;
  final String size;
  final String colorLabel;

  double get lineTotal => unitPrice * quantity;

  @override
  List<Object?> get props =>
      [id, productId, name, imageUrl, unitPrice, quantity, size, colorLabel];
}
