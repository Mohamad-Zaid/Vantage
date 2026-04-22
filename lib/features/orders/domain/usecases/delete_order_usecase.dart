import '../repositories/orders_repository.dart';

class DeleteOrderUseCase {
  const DeleteOrderUseCase(this._repository);

  final OrdersRepository _repository;

  Future<void> call(String orderId) => _repository.deleteOrder(orderId);
}
