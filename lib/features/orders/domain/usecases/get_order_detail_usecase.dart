import '../entities/order_detail_entity.dart';
import '../repositories/orders_repository.dart';

final class GetOrderDetailUseCase {
  const GetOrderDetailUseCase(this._repository);

  final OrdersRepository _repository;

  Future<OrderDetailEntity> call(String orderId) =>
      _repository.getOrderDetail(orderId);
}
