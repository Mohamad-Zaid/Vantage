import '../../domain/entities/category_entity.dart';
import '../../domain/repositories/category_repository.dart';
import '../datasources/shop_local_datasource.dart';

final class CategoryRepositoryImpl implements CategoryRepository {
  CategoryRepositoryImpl(this._dataSource);

  final ShopLocalDataSource _dataSource;

  @override
  Future<List<CategoryEntity>> getCategories() async {
    final models = await _dataSource.getCategories();
    return models.map((m) => m.toEntity()).toList();
  }
}
