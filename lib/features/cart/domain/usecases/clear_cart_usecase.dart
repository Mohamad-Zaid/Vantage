import 'package:vantage/features/cart/domain/repositories/cart_repository.dart';

final class ClearCartUseCase {
  const ClearCartUseCase(this._repo);

  final CartRepository _repo;

  Future<void> call(String userId) => _repo.clearCart(userId);
}
