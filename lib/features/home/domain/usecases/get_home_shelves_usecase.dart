import '../entities/home_shelf_result.dart';
import '../repositories/product_repository.dart';

final class GetHomeShelvesUseCase {
  GetHomeShelvesUseCase(this._repository);

  final ProductRepository _repository;

  Future<HomeShelfResult> call() => _repository.getHomeShelves();
}
