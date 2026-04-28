import 'package:equatable/equatable.dart';

final class CartTotals extends Equatable {
  const CartTotals({
    required this.subtotal,
    required this.shipping,
    required this.tax,
  });

  final double subtotal;
  final double shipping;
  final double tax;

  double get total => subtotal + shipping + tax;

  @override
  List<Object?> get props => [subtotal, shipping, tax];
}
