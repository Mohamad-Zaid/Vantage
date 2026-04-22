import 'package:vantage/features/cart/domain/repositories/cart_repository.dart';

final class AddCartLineUseCase {
  const AddCartLineUseCase(this._repo);

  final CartRepository _repo;

  Future<void> call(
    String userId, {
    required String productId,
    required String name,
    required String imageUrl,
    required double unitPrice,
    required String size,
    required String colorLabel,
    int quantityDelta = 1,
  }) {
    return _repo.addOrUpdateLine(
      userId,
      productId: productId,
      name: name,
      imageUrl: imageUrl,
      unitPrice: unitPrice,
      size: size,
      colorLabel: colorLabel,
      quantityDelta: quantityDelta,
    );
  }
}
