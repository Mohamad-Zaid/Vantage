import 'package:vantage/core/domain/entities/product_entity.dart';

// [nextCursorProductId] is the last id in this page (Firestore pagination).
final class FavoritesPageResult {
  const FavoritesPageResult({
    required this.items,
    required this.hasMore,
    this.nextCursorProductId,
  });

  final List<ProductEntity> items;
  final bool hasMore;
  final String? nextCursorProductId;
}
