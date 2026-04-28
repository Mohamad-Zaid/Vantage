import 'package:vantage/features/cart/domain/cart_pricing.dart';
import 'package:vantage/features/cart/domain/entities/cart_line_entity.dart';
import 'package:vantage/features/cart/domain/entities/cart_totals.dart';

final class CartCalculationService {
  const CartCalculationService();

  CartTotals calculate(List<CartLineEntity> lines) {
    var subtotal = 0.0;
    for (final line in lines) {
      subtotal += line.lineTotal;
    }
    return CartTotals(
      subtotal: subtotal,
      shipping: CartPricing.shipping,
      tax: CartPricing.tax,
    );
  }
}
