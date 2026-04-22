import 'package:cloud_firestore/cloud_firestore.dart';

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
  final street = a['street'] as String? ?? '';
  final city = a['city'] as String? ?? '';
  final state = a['state'] as String? ?? '';
  final zip = a['zipCode'] as String? ?? '';
  final parts = <String>[];
  if (street.isNotEmpty) parts.add(street);
  final cityState = <String>[];
  if (city.isNotEmpty) cityState.add(city);
  if (state.isNotEmpty) cityState.add(state);
  if (cityState.isNotEmpty) {
    parts.add(cityState.join(', '));
  }
  if (zip.isNotEmpty) parts.add(zip);
  if (parts.isEmpty) return '—';
  return parts.join(', ');
}

int _lineItemCount(List<dynamic>? items) {
  if (items == null) return 0;
  var n = 0;
  for (final e in items) {
    if (e is! Map) continue;
    n += (e['quantity'] as num?)?.round() ?? 0;
  }
  return n;
}

List<OrderLineItemEntity> _lineItemsFrom(List<dynamic>? raw) {
  if (raw == null) return const [];
  final out = <OrderLineItemEntity>[];
  for (final e in raw) {
    if (e is! Map) continue;
    final m = Map<String, dynamic>.from(e);
    out.add(
      OrderLineItemEntity(
        name: m['name'] as String? ?? '',
        imageUrl: m['imageUrl'] as String? ?? '',
        unitPrice: (m['unitPrice'] as num?)?.toDouble() ?? 0,
        quantity: (m['quantity'] as num?)?.round() ?? 0,
        size: m['size'] as String? ?? '',
        colorLabel: m['colorLabel'] as String? ?? '',
      ),
    );
  }
  return out;
}

DateTime? _asDateTime(dynamic t) {
  if (t is Timestamp) return t.toDate();
  if (t is DateTime) return t;
  return null;
}

const _monthsShort = <String>[
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec',
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

OrderDetailEntity orderDetailFromMap(String id, Map<String, dynamic> m) {
  final display = id.length <= 6 ? id : id.substring(0, 6);
  final created = _asDateTime(m['createdAt']);
  final dateLabel = _dateLabel(created);
  final status = m['status'] as String?;
  final flags = _flagsForStatus(status);
  return OrderDetailEntity(
    id: id,
    displayNumber: display,
    itemCount: _lineItemCount(m['items'] as List<dynamic>?),
    lineItems: List<OrderLineItemEntity>.unmodifiable(
      _lineItemsFrom(m['items'] as List<dynamic>?),
    ),
    address: _oneLineAddress(m['address'] as Map<String, dynamic>?),
    phone: '—',
    timeline: List<OrderTimelineStepEntity>.unmodifiable(
      buildOrderTimeline(dateLabel, flags),
    ),
  );
}

OrderSummaryEntity orderSummaryFromMap(String id, Map<String, dynamic> m) {
  final display = id.length <= 6 ? id : id.substring(0, 6);
  return OrderSummaryEntity(
    id: id,
    displayNumber: display,
    itemCount: _lineItemCount(m['items'] as List<dynamic>?),
    status: orderStatusFromFirestore(m['status'] as String?),
  );
}
