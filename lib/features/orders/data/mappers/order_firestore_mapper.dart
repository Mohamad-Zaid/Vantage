import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:vantage/core/constants/app_constants.dart';
import 'package:vantage/core/constants/firestore_fields.dart';
import 'package:vantage/features/orders/domain/entities/order_detail_entity.dart';
import 'package:vantage/features/orders/domain/entities/order_line_item_entity.dart';
import 'package:vantage/features/orders/domain/entities/order_status_filter.dart';
import 'package:vantage/features/orders/domain/entities/order_summary_entity.dart';
import 'package:vantage/features/orders/domain/entities/order_timeline_step_entity.dart';

const _kTimelineKeys = <String>[
  'orderDetail.timelineDelivered',
  'orderDetail.timelineShipped',
  'orderDetail.timelineOrderConfirmed',
  'orderDetail.timelineOrderPlaced',
];

OrderStatusFilter orderStatusFromFirestore(String? raw) {
  switch (raw?.toLowerCase()) {
    case 'shipped':
      return OrderStatusFilter.shipped;
    case 'delivered':
      return OrderStatusFilter.delivered;
    case 'returned':
      return OrderStatusFilter.returned;
    case 'canceled':
    case 'cancelled':
      return OrderStatusFilter.canceled;
    case 'processing':
    default:
      return OrderStatusFilter.processing;
  }
}

String _oneLineAddress(Map<String, dynamic>? a) {
  if (a == null) return '—';
  final street = a[AddressFields.street] as String? ?? '';
  final city = a[AddressFields.city] as String? ?? '';
  final state = a[AddressFields.state] as String? ?? '';
  final zip = a[AddressFields.zipCode] as String? ?? '';
  final parts = <String>[];
  if (street.isNotEmpty) parts.add(street);
  final cityState = <String>[];
  if (city.isNotEmpty) cityState.add(city);
  if (state.isNotEmpty) cityState.add(state);
  if (cityState.isNotEmpty) parts.add(cityState.join(', '));
  if (zip.isNotEmpty) parts.add(zip);
  if (parts.isEmpty) return '—';
  return parts.join(', ');
}

int _lineItemCount(List<dynamic>? items) {
  if (items == null) return 0;
  var count = 0;
  for (final e in items) {
    if (e is! Map) continue;
    count += (e[OrderLineItemFields.quantity] as num?)?.round() ?? 0;
  }
  return count;
}

List<OrderLineItemEntity> _lineItemsFrom(List<dynamic>? raw) {
  if (raw == null) return const [];
  final result = <OrderLineItemEntity>[];
  for (final e in raw) {
    if (e is! Map) continue;
    final m = Map<String, dynamic>.from(e);
    result.add(
      OrderLineItemEntity(
        name: m[OrderLineItemFields.name] as String? ?? '',
        imageUrl: m[OrderLineItemFields.imageUrl] as String? ?? '',
        unitPrice: (m[OrderLineItemFields.unitPrice] as num?)?.toDouble() ?? 0,
        quantity: (m[OrderLineItemFields.quantity] as num?)?.round() ?? 0,
        size: m[OrderLineItemFields.size] as String? ?? '',
        colorLabel: m[OrderLineItemFields.colorLabel] as String? ?? '',
      ),
    );
  }
  return result;
}

DateTime? _asDateTime(dynamic t) {
  if (t is Timestamp) return t.toDate();
  if (t is DateTime) return t;
  return null;
}

const _monthsShort = <String>[
  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
  'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
];

String _dateLabel(DateTime? d) {
  if (d == null) return '—';
  return '${d.day} ${_monthsShort[d.month - 1]}';
}

// [completeFlags] index order: Delivered, Shipped, Confirmed, Placed.
List<OrderTimelineStepEntity> buildOrderTimeline(
  String dateLabel,
  List<bool> completeFlags,
) {
  assert(completeFlags.length == _kTimelineKeys.length, 'timeline len');
  return List<OrderTimelineStepEntity>.generate(
    _kTimelineKeys.length,
    (i) => OrderTimelineStepEntity(
      titleKey: _kTimelineKeys[i],
      dateText: completeFlags[i] ? dateLabel : '—',
      isComplete: completeFlags[i],
    ),
  );
}

List<bool> _flagsForStatus(String? status) {
  switch (status?.toLowerCase()) {
    case 'delivered':
      return [true, true, true, true];
    case 'shipped':
      return [false, true, true, true];
    case 'canceled':
    case 'cancelled':
    case 'returned':
      return [false, false, false, true];
    case 'processing':
    default:
      return [false, false, true, true];
  }
}

String _displayId(String id) {
  return id.length <= OrderConstants.displayIdLength
      ? id
      : id.substring(0, OrderConstants.displayIdLength);
}

OrderDetailEntity orderDetailFromMap(String id, Map<String, dynamic> m) {
  final created = _asDateTime(m[OrderDocFields.createdAt]);
  final dateLabel = _dateLabel(created);
  final status = m[OrderDocFields.status] as String?;
  final flags = _flagsForStatus(status);
  final items = m[OrderDocFields.items] as List<dynamic>?;
  return OrderDetailEntity(
    id: id,
    displayNumber: _displayId(id),
    itemCount: _lineItemCount(items),
    lineItems: List<OrderLineItemEntity>.unmodifiable(_lineItemsFrom(items)),
    address: _oneLineAddress(m[OrderDocFields.address] as Map<String, dynamic>?),
    phone: '—',
    timeline: List<OrderTimelineStepEntity>.unmodifiable(
      buildOrderTimeline(dateLabel, flags),
    ),
  );
}

OrderSummaryEntity orderSummaryFromMap(String id, Map<String, dynamic> m) {
  return OrderSummaryEntity(
    id: id,
    displayNumber: _displayId(id),
    itemCount: _lineItemCount(m[OrderDocFields.items] as List<dynamic>?),
    status: orderStatusFromFirestore(m[OrderDocFields.status] as String?),
  );
}
