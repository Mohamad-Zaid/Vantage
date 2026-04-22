import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:vantage/features/orders/data/mappers/order_firestore_mapper.dart';
import 'package:vantage/features/orders/domain/entities/order_detail_entity.dart';
import 'package:vantage/features/orders/domain/entities/order_summaries_page_result.dart';

// Paged with Firestore [orderBy(createdAt)] + [limit].
const int kOrdersPageSize = 15;

abstract interface class OrdersRemoteDataSource {
  // Newest first; [startAfterOrderId] is the previous page’s last order id.
  Future<OrderSummariesPageResult> listOrdersPage(
    String userId, {
    String? startAfterOrderId,
  });

  Future<OrderDetailEntity> getOrder(String userId, String orderId);

  Future<void> deleteOrder(String userId, String orderId);
}

final class OrdersRemoteDataSourceImpl implements OrdersRemoteDataSource {
  OrdersRemoteDataSourceImpl({FirebaseFirestore? firestore})
    : _db = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _db;

  CollectionReference<Map<String, dynamic>> _ordersRef(String userId) =>
      _db.collection('users').doc(userId).collection('orders');

  @override
  Future<OrderSummariesPageResult> listOrdersPage(
    String userId, {
    String? startAfterOrderId,
  }) async {
    Query<Map<String, dynamic>> q = _ordersRef(userId)
        .orderBy('createdAt', descending: true)
        .limit(kOrdersPageSize);
    if (startAfterOrderId != null) {
      final start = await _ordersRef(userId).doc(startAfterOrderId).get();
      if (start.exists) {
        q = q.startAfterDocument(start);
      }
    }
    final snap = await q.get();
    final items = snap.docs
        .map((d) => orderSummaryFromMap(d.id, d.data()))
        .toList();
    final hasMore = items.length == kOrdersPageSize;
    final next = hasMore && items.isNotEmpty ? items.last.id : null;
    return OrderSummariesPageResult(
      items: items,
      hasMore: hasMore,
      nextCursorOrderId: next,
    );
  }

  @override
  Future<OrderDetailEntity> getOrder(String userId, String orderId) async {
    final doc = await _ordersRef(userId).doc(orderId).get();
    if (!doc.exists) {
      throw StateError('Order not found: $orderId');
    }
    return orderDetailFromMap(doc.id, doc.data()!);
  }

  @override
  Future<void> deleteOrder(String userId, String orderId) {
    return _ordersRef(userId).doc(orderId).delete();
  }
}
