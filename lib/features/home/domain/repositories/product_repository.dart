import '../entities/home_shelf_result.dart';
import 'package:vantage/core/domain/entities/product_entity.dart';

abstract interface class ProductRepository {
  Future<List<ProductEntity>> getProducts();

  Future<HomeShelfResult> getHomeShelves();

  Future<List<ProductEntity>> getProductsByCategory(String categoryId);
}
