import '../repositories/favorites_repository.dart';

final class RemoveFavoriteUseCase {
  RemoveFavoriteUseCase(this._repository);

  final FavoritesRepository _repository;

  Future<void> call(String userId, String productId) =>
      _repository.removeFavorite(userId, productId);
}
