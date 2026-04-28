import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:vantage/core/constants/app_constants.dart';
import 'package:vantage/core/constants/firestore_fields.dart';
import 'package:vantage/core/persistence/firestore_user_scoped_contexts.dart';
import 'package:vantage/core/errors/domain_exceptions.dart';
import 'package:vantage/features/orders/data/mappers/order_firestore_mapper.dart';
import 'package:vantage/features/orders/domain/entities/order_line_entity.dart';
import 'package:vantage/features/orders/domain/entities/order_detail_entity.dart';
import 'package:vantage/features/orders/domain/entities/order_summaries_page_result.dart';

abstract interface class OrdersRemoteDataSource {
  // Newest first; [startAfterOrderId] is the previous page’s last order id.
  Future<OrderSummariesPageResult> listOrdersPage(
    String userId, {
    String? startAfterOrderId,
  });

  Future<OrderDetailEntity> getOrder(String userId, String orderId);

  Future<void> deleteOrder(String userId, String orderId);

  /// Persists a new order document under the Orders bounded context only.
  Future<String> createOrderDocument(
    String userId, {
    required List<OrderLineEntity> lines,
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

final class OrdersRemoteDataSourceImpl implements OrdersRemoteDataSource {
  OrdersRemoteDataSourceImpl({FirebaseFirestore? firestore})
    : _db = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _db;

  CollectionReference<Map<String, dynamic>> _ordersRef(String userId) => _db
      .collection(FirestoreUserRoot.collectionId)
      .doc(userId)
      .collection(OrdersFirestoreContext.collectionId);

  @override
  Future<OrderSummariesPageResult> listOrdersPage(
    String userId, {
    String? startAfterOrderId,
  }) async {
    Query<Map<String, dynamic>> q = _ordersRef(userId)
        .orderBy(OrderDocFields.createdAt, descending: true)
        .limit(PaginationConstants.defaultPageSize);
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
    final hasMore = items.length == PaginationConstants.defaultPageSize;
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
      throw OrderNotFoundException(orderId);
    }
    return orderDetailFromMap(doc.id, doc.data()!);
  }

  @override
  Future<void> deleteOrder(String userId, String orderId) {
    return _ordersRef(userId).doc(orderId).delete();
  }

  @override
  Future<String> createOrderDocument(
    String userId, {
    required List<OrderLineEntity> lines,
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
    await orderRef.set({
      OrderDocFields.status: OrderConstants.firestoreStatusProcessing,
      OrderDocFields.createdAt: FieldValue.serverTimestamp(),
      OrderDocFields.subtotal: subtotal,
      OrderDocFields.shipping: shipping,
      OrderDocFields.tax: tax,
      OrderDocFields.total: total,
      OrderDocFields.addressId: addressId,
      OrderDocFields.address: {
        AddressFields.street: addressStreet,
        AddressFields.city: addressCity,
        AddressFields.state: addressState,
        AddressFields.zipCode: addressZip,
      },
      OrderDocFields.paymentLabel: paymentLabel,
      OrderDocFields.items: lines
          .map(
            (line) => {
              OrderLineItemFields.productId: line.productId,
              OrderLineItemFields.name: line.name,
              OrderLineItemFields.imageUrl: line.imageUrl,
              OrderLineItemFields.unitPrice: line.unitPrice,
              OrderLineItemFields.quantity: line.quantity,
              OrderLineItemFields.size: line.size,
              OrderLineItemFields.colorLabel: line.colorLabel,
            },
          )
          .toList(),
    });
    return orderRef.id;
  }
}
