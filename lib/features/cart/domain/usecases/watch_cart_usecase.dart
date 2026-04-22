import 'package:vantage/features/cart/domain/entities/cart_line_entity.dart';
import 'package:vantage/features/cart/domain/repositories/cart_repository.dart';

final class WatchCartUseCase {
  const WatchCartUseCase(this._repo);

  final CartRepository _repo;

  Stream<List<CartLineEntity>> call(String userId) => _repo.watchCart(userId);
}
