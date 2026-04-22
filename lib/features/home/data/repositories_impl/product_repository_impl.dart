import '../../domain/entities/home_shelf_result.dart';
import '../../domain/entities/named_product_shelf.dart';
import 'package:vantage/core/domain/entities/product_entity.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/shop_local_datasource.dart';
final class ProductRepositoryImpl implements ProductRepository {
  ProductRepositoryImpl(this._dataSource);

  final ShopLocalDataSource _dataSource;

  @override
  Future<List<ProductEntity>> getProducts() async {
    final models = await _dataSource.getProducts();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<HomeShelfResult> getHomeShelves() async {
    final shelves = await _dataSource.getHomeShelfModels();
    return HomeShelfResult(
      topSelling: shelves.topSelling.map((m) => m.toEntity()).toList(),
      newInByCategory: [
        for (final s in shelves.newInByCategory)
          NamedProductShelf(
            titleKey: s.titleKey,
            products: s.products.map((m) => m.toEntity()).toList(),
          ),
      ],
    );
  }
  @override
  Future<List<ProductEntity>> getProductsByCategory(String categoryId) async {
    final all = await getProducts();
    return all.where((p) => p.categoryId == categoryId).toList();
  }
}
