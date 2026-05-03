import 'package:vantage/core/domain/entities/product_entity.dart';

import '../repositories/favorites_repository.dart';

final class AddFavoriteUseCase {
  const AddFavoriteUseCase(this._repository);

  final FavoritesRepository _repository;

  Future<void> call(String userId, ProductEntity product) =>
      _repository.addFavorite(userId, product);
}
