import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:vantage/core/constants/firestore_fields.dart';
import 'package:vantage/core/constants/query_limits.dart';
import 'package:vantage/core/persistence/firestore_user_scoped_contexts.dart';
import 'package:vantage/features/cart/data/models/cart_line_model.dart';
import 'package:vantage/features/cart/domain/entities/cart_line_entity.dart';

abstract interface class CartRemoteDataSource {
  Stream<List<CartLineEntity>> watchItems(String userId);

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

  Future<void> setLineQuantity(String userId, String lineId, int quantity);

  Future<void> deleteLine(String userId, String lineId);

  Future<void> clearAll(String userId);
}

final class CartRemoteDataSourceImpl implements CartRemoteDataSource {
  CartRemoteDataSourceImpl({FirebaseFirestore? firestore})
      : _db = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _db;

  CollectionReference<Map<String, dynamic>> _itemsRef(String userId) => _db
      .collection(FirestoreUserRoot.collectionId)
      .doc(userId)
      .collection(CartFirestoreContext.collectionId);

  @override
  Stream<List<CartLineEntity>> watchItems(String userId) {
    return _itemsRef(userId).snapshots().map((snapshot) {
      return snapshot.docs
          .map(
            (doc) => cartLineFromFirestoreMap(doc.id, doc.data()),
          )
          .toList();
    });
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
  }) async {
    if (quantityDelta == 0) return;
    final col = _itemsRef(userId);
    final querySnapshot = await col
        .where(OrderLineItemFields.productId, isEqualTo: productId)
        .where(OrderLineItemFields.size, isEqualTo: size)
        .where(OrderLineItemFields.colorLabel, isEqualTo: colorLabel)
        .limit(QueryLimits.singleDocumentMatch)
        .get();
    if (querySnapshot.docs.isEmpty) {
      if (quantityDelta < 0) return;
      await col.add({
        OrderLineItemFields.productId: productId,
        OrderLineItemFields.name: name,
        OrderLineItemFields.imageUrl: imageUrl,
        OrderLineItemFields.unitPrice: unitPrice,
        OrderLineItemFields.quantity: quantityDelta,
        OrderLineItemFields.size: size,
        OrderLineItemFields.colorLabel: colorLabel,
        CartItemFields.updatedAt: FieldValue.serverTimestamp(),
      });
      return;
    }
    final doc = querySnapshot.docs.first;
    final currentQuantity =
        (doc.data()[OrderLineItemFields.quantity] as num?)?.round() ?? 0;
    final nextQuantity = currentQuantity + quantityDelta;
    if (nextQuantity <= 0) {
      await doc.reference.delete();
      return;
    }
    await doc.reference.set(
      {
        OrderLineItemFields.quantity: nextQuantity,
        CartItemFields.updatedAt: FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );
  }

  @override
  Future<void> setLineQuantity(
    String userId,
    String lineId,
    int quantity,
  ) async {
    if (quantity <= 0) {
      await _itemsRef(userId).doc(lineId).delete();
      return;
    }
    await _itemsRef(userId).doc(lineId).set(
      {
        OrderLineItemFields.quantity: quantity,
        CartItemFields.updatedAt: FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );
  }

  @override
  Future<void> deleteLine(String userId, String lineId) {
    return _itemsRef(userId).doc(lineId).delete();
  }

  @override
  Future<void> clearAll(String userId) async {
    final snap = await _itemsRef(userId).get();
    final batch = _db.batch();
    for (final doc in snap.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }
}
