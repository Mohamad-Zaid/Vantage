import 'package:cloud_firestore/cloud_firestore.dart';

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

  Future<String> createOrder(
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

final class CartRemoteDataSourceImpl implements CartRemoteDataSource {
  CartRemoteDataSourceImpl({FirebaseFirestore? firestore})
      : _db = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _db;

  CollectionReference<Map<String, dynamic>> _itemsRef(String userId) =>
      _db.collection('users').doc(userId).collection('cartItems');

  CollectionReference<Map<String, dynamic>> _ordersRef(String userId) =>
      _db.collection('users').doc(userId).collection('orders');

  @override
  Stream<List<CartLineEntity>> watchItems(String userId) {
    return _itemsRef(userId).snapshots().map((s) {
      return s.docs
          .map(
            (d) => cartLineFromFirestoreMap(d.id, d.data()),
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
    final q = await col
        .where('productId', isEqualTo: productId)
        .where('size', isEqualTo: size)
        .where('colorLabel', isEqualTo: colorLabel)
        .limit(1)
        .get();
    if (q.docs.isEmpty) {
      if (quantityDelta < 0) return;
      await col.add({
        'productId': productId,
        'name': name,
        'imageUrl': imageUrl,
        'unitPrice': unitPrice,
        'quantity': quantityDelta,
        'size': size,
        'colorLabel': colorLabel,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      return;
    }
    final doc = q.docs.first;
    final cur = (doc.data()['quantity'] as num?)?.round() ?? 0;
    final next = cur + quantityDelta;
    if (next <= 0) {
      await doc.reference.delete();
      return;
    }
    await doc.reference.set(
      {
        'quantity': next,
        'updatedAt': FieldValue.serverTimestamp(),
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
        'quantity': quantity,
        'updatedAt': FieldValue.serverTimestamp(),
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
    final b = _db.batch();
    for (final d in snap.docs) {
      b.delete(d.reference);
    }
    await b.commit();
  }

  @override
  Future<String> createOrder(
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
  }) async {
    final orderRef = _ordersRef(userId).doc();
    final itemSnap = await _itemsRef(userId).get();
    final b = _db.batch();
    b.set(orderRef, {
      'status': 'processing',
      'createdAt': FieldValue.serverTimestamp(),
      'subtotal': subtotal,
      'shipping': shipping,
      'tax': tax,
      'total': total,
      'addressId': addressId,
      'address': {
        'street': addressStreet,
        'city': addressCity,
        'state': addressState,
        'zipCode': addressZip,
      },
      'paymentLabel': paymentLabel,
      'items': lines
          .map(
            (e) => {
              'productId': e.productId,
              'name': e.name,
              'imageUrl': e.imageUrl,
              'unitPrice': e.unitPrice,
              'quantity': e.quantity,
              'size': e.size,
              'colorLabel': e.colorLabel,
            },
          )
          .toList(),
    });
    for (final d in itemSnap.docs) {
      b.delete(d.reference);
    }
    await b.commit();
    return orderRef.id;
  }
}
