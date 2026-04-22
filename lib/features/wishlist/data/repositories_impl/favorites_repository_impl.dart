import 'package:vantage/core/domain/entities/product_entity.dart';
import 'package:vantage/features/wishlist/domain/entities/favorites_page_result.dart';

import '../../domain/repositories/favorites_repository.dart';
import '../datasources/favorites_remote_datasource.dart';

final class FavoritesRepositoryImpl implements FavoritesRepository {
  FavoritesRepositoryImpl(this._remote);

  final FavoritesRemoteDataSource _remote;

  @override
  Stream<List<ProductEntity>> watchFavoritesForUser(String userId) {
    return _remote.watchFavorites(userId);
  }

  @override
  Future<FavoritesPageResult> getFavoritesPage(
    String userId, {
    String? cursor,
  }) {
    return _remote.getFavoritesPage(
      userId,
      startAfterProductId: cursor,
    );
  }

  @override
  Future<void> addFavorite(String userId, ProductEntity product) {
    return _remote.addFavorite(userId, product);
  }

  @override
  Future<void> removeFavorite(String userId, String productId) {
    return _remote.removeFavorite(userId, productId);
  }
}
