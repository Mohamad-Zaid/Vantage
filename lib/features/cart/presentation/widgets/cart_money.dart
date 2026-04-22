import 'package:flutter/foundation.dart';

@immutable
final class CartMoney {
  const CartMoney._();

  static String usd(double v) {
    final frac = v - v.truncateToDouble();
    if (frac.abs() < 0.001) {
      return '\$${v.toStringAsFixed(0)}';
    }
    return '\$${v.toStringAsFixed(2)}';
  }
}
