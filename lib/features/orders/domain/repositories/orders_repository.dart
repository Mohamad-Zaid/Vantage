import '../entities/order_detail_entity.dart';
import '../entities/order_line_entity.dart';
import '../entities/order_summaries_page_result.dart';

abstract class OrdersRepository {
  // [cursor] = previous page’s [OrderSummariesPageResult.nextCursorOrderId].
  Future<OrderSummariesPageResult> getOrderSummariesPage({String? cursor});

  Future<OrderDetailEntity> getOrderDetail(String orderId);

  Future<void> deleteOrder(String orderId);

  Future<String> createOrder(
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
