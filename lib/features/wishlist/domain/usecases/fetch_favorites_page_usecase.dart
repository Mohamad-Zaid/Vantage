import 'package:vantage/features/wishlist/domain/entities/favorites_page_result.dart';
import 'package:vantage/features/wishlist/domain/repositories/favorites_repository.dart';

final class FetchFavoritesPageUseCase {
  const FetchFavoritesPageUseCase(this._repository);

  final FavoritesRepository _repository;

  // [cursor] = previous [FavoritesPageResult.nextCursorProductId].
  Future<FavoritesPageResult> call(
    String userId, {
    String? cursor,
  }) {
    return _repository.getFavoritesPage(userId, cursor: cursor);
  }
}
