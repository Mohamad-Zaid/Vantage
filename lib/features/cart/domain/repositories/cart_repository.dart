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
}
