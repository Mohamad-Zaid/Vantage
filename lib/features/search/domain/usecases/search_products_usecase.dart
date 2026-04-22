import 'package:vantage/core/domain/entities/product_entity.dart';
import 'package:vantage/features/home/domain/repositories/product_repository.dart';
import 'package:vantage/features/search/domain/entities/search_filter.dart';

class SearchProductsUseCase {
  const SearchProductsUseCase(this._repository);

  final ProductRepository _repository;

  Future<List<ProductEntity>> call({
    required String query,
    SearchFilter filter = const SearchFilter(),
  }) async {
    var products = await _repository.getProducts();

    if (query.isNotEmpty) {
      final lq = query.toLowerCase();
      products = products
          .where((p) =>
              p.name.toLowerCase().contains(lq) ||
              p.description.toLowerCase().contains(lq))
          .toList();
    }

    switch (filter.deal) {
      case DealFilter.onSale:
        products = products
            .where((p) => p.compareAtPrice != null && p.compareAtPrice! > p.price)
            .toList();
      case DealFilter.freeShipping:
        // No per-product shipping: approximate with a price floor in catalog JSON.
        products = products.where((p) => p.price >= 50).toList();
      case null:
        break;
    }

    if (filter.minPrice != null) {
      products = products.where((p) => p.price >= filter.minPrice!).toList();
    }
    if (filter.maxPrice != null) {
      products = products.where((p) => p.price <= filter.maxPrice!).toList();
    }

    switch (filter.sortBy) {
      case SortBy.recommended:
        products.sort((a, b) => b.rating.compareTo(a.rating));
      case SortBy.newest:
        products = products.reversed.toList();
      case SortBy.lowestHighest:
        products.sort((a, b) => a.price.compareTo(b.price));
      case SortBy.highestLowest:
        products.sort((a, b) => b.price.compareTo(a.price));
    }

    return products;
  }
}
