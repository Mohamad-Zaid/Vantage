import 'package:vantage/features/cart/domain/repositories/cart_repository.dart';

final class RemoveCartLineUseCase {
  const RemoveCartLineUseCase(this._repo);

  final CartRepository _repo;

  Future<void> call(String userId, String lineId) {
    return _repo.removeLine(userId, lineId);
  }
}
