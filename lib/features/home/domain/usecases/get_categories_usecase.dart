import '../entities/category_entity.dart';
import '../repositories/category_repository.dart';

final class GetCategoriesUseCase {
  GetCategoriesUseCase(this._repository);

  final CategoryRepository _repository;

  Future<List<CategoryEntity>> call() => _repository.getCategories();
}
