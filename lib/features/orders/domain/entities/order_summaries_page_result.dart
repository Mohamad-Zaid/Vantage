import 'order_summary_entity.dart';

// [nextCursorOrderId] is the last order id in this page (pagination).
class OrderSummariesPageResult {
  const OrderSummariesPageResult({
    required this.items,
    required this.hasMore,
    this.nextCursorOrderId,
  });

  final List<OrderSummaryEntity> items;
  final bool hasMore;
  final String? nextCursorOrderId;
}
