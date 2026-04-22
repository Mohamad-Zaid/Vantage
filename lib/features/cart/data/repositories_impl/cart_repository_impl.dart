import 'package:vantage/features/cart/data/datasources/cart_remote_datasource.dart';
import 'package:vantage/features/cart/domain/entities/cart_line_entity.dart';
import 'package:vantage/features/cart/domain/repositories/cart_repository.dart';

final class CartRepositoryImpl implements CartRepository {
  CartRepositoryImpl(this._remote);

  final CartRemoteDataSource _remote;

  @override
  Stream<List<CartLineEntity>> watchCart(String userId) {
    return _remote.watchItems(userId).map((list) => list);
  }

  @override
  Future<void> addOrUpdateLine(
    String userId, {
    required String productId,
    required String name,
    required String imageUrl,
    required double unitPrice,
    required String size,
    required String colorLabel,
    required int quantityDelta,
  }) {
    return _remote.addOrUpdateLine(
      userId,
      productId: productId,
      name: name,
      imageUrl: imageUrl,
      unitPrice: unitPrice,
      size: size,
      colorLabel: colorLabel,
      quantityDelta: quantityDelta,
    );
  }

  @override
  Future<void> setQuantity(String userId, String lineId, int quantity) {
    return _remote.setLineQuantity(userId, lineId, quantity);
  }

  @override
  Future<void> removeLine(String userId, String lineId) {
    return _remote.deleteLine(userId, lineId);
  }

  @override
  Future<void> clearCart(String userId) {
    return _remote.clearAll(userId);
  }

  @override
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
  }) {
    return _remote.createOrder(
      userId,
      lines: lines,
      subtotal: subtotal,
      shipping: shipping,
      tax: tax,
      total: total,
      addressStreet: addressStreet,
      addressCity: addressCity,
      addressState: addressState,
      addressZip: addressZip,
      addressId: addressId,
      paymentLabel: paymentLabel,
    );
  }
}
