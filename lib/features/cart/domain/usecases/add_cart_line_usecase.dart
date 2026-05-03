import 'package:vantage/features/cart/domain/entities/cart_line_input.dart';
import 'package:vantage/features/cart/domain/repositories/cart_repository.dart';

final class AddCartLineUseCase {
  const AddCartLineUseCase(this._repo);

  final CartRepository _repo;

  Future<void> call(String userId, CartLineInput input) {
    return _repo.addOrUpdateLine(userId, input);
  }
}
