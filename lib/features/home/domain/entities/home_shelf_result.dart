import 'named_product_shelf.dart';
import 'package:vantage/core/domain/entities/product_entity.dart';

final class HomeShelfResult {
  const HomeShelfResult({
    required this.topSelling,
    required this.newInByCategory,
  });

  final List<ProductEntity> topSelling;
  final List<NamedProductShelf> newInByCategory;
}