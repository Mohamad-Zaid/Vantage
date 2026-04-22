import 'package:vantage/core/domain/entities/product_entity.dart';
import 'package:vantage/features/wishlist/domain/entities/favorites_page_result.dart';

// Firestore: users/{uid}/favorites/{productId}.
abstract interface class FavoritesRepository {
  Stream<List<ProductEntity>> watchFavoritesForUser(String userId);

  Future<FavoritesPageResult> getFavoritesPage(
    String userId, {
    String? cursor,
  });

  Future<void> addFavorite(String userId, ProductEntity product);

  Future<void> removeFavorite(String userId, String productId);
}
