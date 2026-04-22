import 'package:vantage/core/domain/entities/product_entity.dart';

import '../repositories/favorites_repository.dart';

final class WatchUserFavoritesUseCase {
  WatchUserFavoritesUseCase(this._repository);

  final FavoritesRepository _repository;

  Stream<List<ProductEntity>> call(String userId) =>
      _repository.watchFavoritesForUser(userId);
}
