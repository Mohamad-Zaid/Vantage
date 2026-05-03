import 'package:vantage/features/cart/domain/entities/cart_line_entity.dart';
import 'package:vantage/features/cart/domain/entities/cart_line_input.dart';

abstract interface class CartRepository {
  Stream<List<CartLineEntity>> watchCart(String userId);

  Future<void> addOrUpdateLine(String userId, CartLineInput input);

  Future<void> setQuantity(String userId, String lineId, int quantity);

  Future<void> removeLine(String userId, String lineId);

  Future<void> clearCart(String userId);
}
