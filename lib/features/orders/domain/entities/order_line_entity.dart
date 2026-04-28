import 'package:equatable/equatable.dart';

/// Line item snapshot for the Orders bounded context (decoupled from [CartLineEntity]).
final class OrderLineEntity extends Equatable {
  const OrderLineEntity({
    required this.productId,
    required this.name,
    required this.imageUrl,
    required this.unitPrice,
    required this.quantity,
    required this.size,
    required this.colorLabel,
  });

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
      [productId, name, imageUrl, unitPrice, quantity, size, colorLabel];
}
