import '../entities/order_summaries_page_result.dart';
import '../repositories/orders_repository.dart';

class GetOrderSummariesUseCase {
  const GetOrderSummariesUseCase(this._repository);

  final OrdersRepository _repository;

  Future<OrderSummariesPageResult> call({String? cursor}) =>
      _repository.getOrderSummariesPage(cursor: cursor);
}
