import '../entities/order_detail_entity.dart';
import '../entities/order_summaries_page_result.dart';

abstract class OrdersRepository {
  // [cursor] = previous page’s [OrderSummariesPageResult.nextCursorOrderId].
  Future<OrderSummariesPageResult> getOrderSummariesPage({String? cursor});

  Future<OrderDetailEntity> getOrderDetail(String orderId);

  Future<void> deleteOrder(String orderId);
}
