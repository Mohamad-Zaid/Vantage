import 'package:vantage/features/cart/domain/repositories/cart_repository.dart';

final class UpdateCartLineQuantityUseCase {
  const UpdateCartLineQuantityUseCase(this._repo);

  final CartRepository _repo;

  Future<void> call(String userId, String lineId, int quantity) {
    return _repo.setQuantity(userId, lineId, quantity);
  }
}
