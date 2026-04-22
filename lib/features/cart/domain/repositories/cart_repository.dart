import 'package:vantage/features/cart/domain/entities/cart_line_entity.dart';

abstract interface class CartRepository {
  Stream<List<CartLineEntity>> watchCart(String userId);

  Future<void> addOrUpdateLine(
    String userId, {
    required String productId,
    required String name,
    required String imageUrl,
    required double unitPrice,
    required String size,
    required String colorLabel,
    required int quantityDelta,
  });

  Future<void> setQuantity(String userId, String lineId, int quantity);

  Future<void> removeLine(String userId, String lineId);

  Future<void> clearCart(String userId);

  // Writes the order and clears the cart in one flow; returns the new order id.
  Future<String> placeOrder(
    String userId, {
    required List<CartLineEntity> lines,
    required double subtotal,
    required double shipping,
    required double tax,
    required double total,
    required String addressStreet,
    required String addressCity,
    required String addressState,
    required String addressZip,
    required String? addressId,
    required String paymentLabel,
  });
}
