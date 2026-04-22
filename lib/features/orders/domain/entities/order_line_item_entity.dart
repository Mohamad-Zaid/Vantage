import 'package:equatable/equatable.dart';

class OrderLineItemEntity extends Equatable {
  const OrderLineItemEntity({
    required this.name,
    required this.imageUrl,
    required this.unitPrice,
    required this.quantity,
    required this.size,
    required this.colorLabel,
  });

  final String name;
  final String imageUrl;
  final double unitPrice;
  final int quantity;
  final String size;
  final String colorLabel;

  double get lineTotal => unitPrice * quantity;

  @override
  List<Object?> get props => [
    name,
    imageUrl,
    unitPrice,
    quantity,
    size,
    colorLabel,
  ];
}
