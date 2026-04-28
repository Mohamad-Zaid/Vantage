import 'package:vantage/core/constants/firestore_fields.dart';
import 'package:vantage/features/cart/domain/entities/cart_line_entity.dart';

CartLineEntity cartLineFromFirestoreMap(String id, Map<String, dynamic> map) {
  return CartLineEntity(
    id: id,
    productId: map[OrderLineItemFields.productId] as String? ?? '',
    name: map[OrderLineItemFields.name] as String? ?? '',
    imageUrl: map[OrderLineItemFields.imageUrl] as String? ?? '',
    unitPrice: (map[OrderLineItemFields.unitPrice] as num?)?.toDouble() ?? 0,
    quantity: (map[OrderLineItemFields.quantity] as num?)?.round() ?? 0,
    size: map[OrderLineItemFields.size] as String? ?? '',
    colorLabel: map[OrderLineItemFields.colorLabel] as String? ?? '',
  );
}
