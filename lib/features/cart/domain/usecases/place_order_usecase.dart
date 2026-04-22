import 'package:vantage/features/addresses/domain/entities/address_entity.dart';
import 'package:vantage/features/cart/domain/cart_pricing.dart';
import 'package:vantage/features/cart/domain/entities/cart_line_entity.dart';
import 'package:vantage/features/cart/domain/repositories/cart_repository.dart';

final class PlaceOrderUseCase {
  const PlaceOrderUseCase(this._cart);

  final CartRepository _cart;

  Future<String> call({
    required String userId,
    required List<CartLineEntity> lines,
    required AddressEntity address,
    required String paymentLabel,
  }) async {
    if (lines.isEmpty) {
      throw StateError('Cart is empty');
    }
    var subtotal = 0.0;
    for (final l in lines) {
      subtotal += l.lineTotal;
    }
    final total = subtotal + CartPricing.shipping + CartPricing.tax;

    return _cart.placeOrder(
      userId,
      lines: lines,
      subtotal: subtotal,
      shipping: CartPricing.shipping,
      tax: CartPricing.tax,
      total: total,
      addressStreet: address.street,
      addressCity: address.city,
      addressState: address.state,
      addressZip: address.zipCode,
      addressId: address.id.isEmpty ? null : address.id,
      paymentLabel: paymentLabel,
    );
  }
}
