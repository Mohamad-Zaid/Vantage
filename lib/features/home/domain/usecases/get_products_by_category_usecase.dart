import 'package:vantage/core/domain/entities/product_entity.dart';
import '../repositories/product_repository.dart';

final class GetProductsByCategoryUseCase {
  GetProductsByCategoryUseCase(this._repository);

  final ProductRepository _repository;

  Future<List<ProductEntity>> call(String categoryId) =>
      _repository.getProductsByCategory(categoryId);
}
