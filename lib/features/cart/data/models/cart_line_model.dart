import 'package:vantage/features/cart/domain/entities/cart_line_entity.dart';

// Firestore `cartItems` map → domain line.
CartLineEntity cartLineFromFirestoreMap(String id, Map<String, dynamic> m) {
  return CartLineEntity(
    id: id,
    productId: m['productId'] as String? ?? '',
    name: m['name'] as String? ?? '',
    imageUrl: m['imageUrl'] as String? ?? '',
    unitPrice: (m['unitPrice'] as num?)?.toDouble() ?? 0,
    quantity: (m['quantity'] as num?)?.round() ?? 0,
    size: m['size'] as String? ?? '',
    colorLabel: m['colorLabel'] as String? ?? '',
  );
}
