import '../../domain/entities/order_detail_entity.dart';
import '../../domain/entities/order_line_item_entity.dart';
import '../../domain/entities/order_status_filter.dart';
import '../../domain/entities/order_summary_entity.dart';
import '../../domain/entities/order_timeline_step_entity.dart';

abstract class OrdersLocalDataSource {
  Future<List<OrderSummaryEntity>> readSummaries();

  Future<OrderDetailEntity?> findDetail(String orderId);

  Future<void> deleteOrder(String orderId);

  // Stashes the just-placed order so detail can open before remote data lands.
  void registerPlacedOrder({
    required OrderDetailEntity detail,
    required OrderSummaryEntity summary,
  });
}

final class OrdersLocalDataSourceImpl implements OrdersLocalDataSource {
  OrdersLocalDataSourceImpl() : _orders = List<OrderSummaryEntity>.of(_seed);

  final List<OrderSummaryEntity> _orders;

  final Map<String, OrderDetailEntity> _placedOrderDetails = {};

  static const List<OrderSummaryEntity> _seed = [
    OrderSummaryEntity(
      id: '456765',
      displayNumber: '456765',
      itemCount: 4,
      status: OrderStatusFilter.processing,
    ),
    OrderSummaryEntity(
      id: '454569',
      displayNumber: '454569',
      itemCount: 2,
      status: OrderStatusFilter.processing,
    ),
    OrderSummaryEntity(
      id: '454809',
      displayNumber: '454809',
      itemCount: 1,
      status: OrderStatusFilter.processing,
    ),
    OrderSummaryEntity(
      id: '400001',
      displayNumber: '400001',
      itemCount: 3,
      status: OrderStatusFilter.shipped,
    ),
  ];

  static const String _kAddress = '2715 Ash Dr. San Jose, South Dakota 83475';
  static const String _kPhone = '121-224-7890';
  static const String _kDate = '28 May';

  static const List<OrderTimelineStepEntity> _kTimeline = [
    OrderTimelineStepEntity(
      titleKey: 'orderDetail.timelineDelivered',
      dateText: _kDate,
      isComplete: false,
    ),
    OrderTimelineStepEntity(
      titleKey: 'orderDetail.timelineShipped',
      dateText: _kDate,
      isComplete: true,
    ),
    OrderTimelineStepEntity(
      titleKey: 'orderDetail.timelineOrderConfirmed',
      dateText: _kDate,
      isComplete: true,
    ),
    OrderTimelineStepEntity(
      titleKey: 'orderDetail.timelineOrderPlaced',
      dateText: _kDate,
      isComplete: true,
    ),
  ];

  OrderDetailEntity _buildDetail(OrderSummaryEntity s) {
    return OrderDetailEntity(
      id: s.id,
      displayNumber: s.displayNumber,
      itemCount: s.itemCount,
      lineItems: const <OrderLineItemEntity>[],
      address: _kAddress,
      phone: _kPhone,
      timeline: List<OrderTimelineStepEntity>.unmodifiable(_kTimeline),
    );
  }

  @override
  Future<List<OrderSummaryEntity>> readSummaries() async =>
      List<OrderSummaryEntity>.unmodifiable(_orders);

  @override
  Future<OrderDetailEntity?> findDetail(String orderId) async {
    final placed = _placedOrderDetails[orderId];
    if (placed != null) return placed;
    for (final o in _orders) {
      if (o.id == orderId) return _buildDetail(o);
    }
    return null;
  }

  @override
  void registerPlacedOrder({
    required OrderDetailEntity detail,
    required OrderSummaryEntity summary,
  }) {
    _placedOrderDetails[detail.id] = detail;
    _orders.removeWhere((o) => o.id == detail.id);
    _orders.insert(0, summary);
  }

  @override
  Future<void> deleteOrder(String orderId) async {
    _placedOrderDetails.remove(orderId);
    _orders.removeWhere((o) => o.id == orderId);
  }
}
