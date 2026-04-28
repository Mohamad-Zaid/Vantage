import 'dart:async';

import 'package:vantage/core/auth/auth_aware_cubit.dart';
import 'package:vantage/core/auth/current_user_provider.dart';
import 'package:vantage/core/cubits/cubit_error_handler.dart';
import 'package:vantage/core/domain/entities/product_entity.dart';
import 'package:vantage/core/domain/entities/user_entity.dart';
import 'package:vantage/features/wishlist/domain/usecases/add_favorite_usecase.dart';
import 'package:vantage/features/wishlist/domain/usecases/fetch_favorites_page_usecase.dart';
import 'package:vantage/features/wishlist/domain/usecases/remove_favorite_usecase.dart';

import 'favorites_state.dart';

final class FavoritesCubit extends AuthAwareCubit<FavoritesState>
    with CubitErrorHandler<FavoritesState> {
  FavoritesCubit({
    required CurrentUserProvider authProvider,
    required FetchFavoritesPageUseCase fetchPage,
    required AddFavoriteUseCase addFavorite,
    required RemoveFavoriteUseCase removeFavorite,
  })  : _fetchPage = fetchPage,
        _addFavorite = addFavorite,
        _removeFavorite = removeFavorite,
        super(const FavoritesInitial(), authProvider) {
    emit(const FavoritesLoading());
  }

  final FetchFavoritesPageUseCase _fetchPage;
  final AddFavoriteUseCase _addFavorite;
  final RemoveFavoriteUseCase _removeFavorite;

  FavoritesLoaded? _lastLoaded;
  final List<ProductEntity> _loadedFavorites = [];
  bool _hasMore = false;
  String? _nextCursor;
  bool _loadingMore = false;
  String? _userId;

  @override
  void onAuthStateChanged(UserEntity? user) {
    if (user == null) {
      _userId = null;
      _loadedFavorites.clear();
      _hasMore = false;
      _nextCursor = null;
      _loadingMore = false;
      _lastLoaded = const FavoritesLoaded([], hasMore: false);
      emit(_lastLoaded!);
      return;
    }
    _userId = user.id;
    unawaited(_loadFirstPage());
  }

  Future<void> _loadFirstPage() async {
    if (_userId == null) return;
    emit(const FavoritesLoading());
    await runGuardedMutation(
      'FavoritesCubit._loadFirstPage',
      () async {
        final page = await _fetchPage(_userId!);
        if (isClosed) return;
        _loadedFavorites
          ..clear()
          ..addAll(page.items);
        _hasMore = page.hasMore;
        _nextCursor = page.nextCursorProductId;
        _loadingMore = false;
        _lastLoaded = FavoritesLoaded(
          List<ProductEntity>.unmodifiable(_loadedFavorites),
          hasMore: _hasMore,
          isLoadingMore: false,
        );
        emit(_lastLoaded!);
      },
      onError: (error) {
        if (isClosed) return;
        emit(FavoritesError(error.toString()));
      },
    );
  }

  Future<void> refresh() async {
    if (_userId == null) return;
    await runGuardedMutation(
      'FavoritesCubit.refresh',
      () async {
        final page = await _fetchPage(_userId!);
        if (isClosed) return;
        _loadedFavorites
          ..clear()
          ..addAll(page.items);
        _hasMore = page.hasMore;
        _nextCursor = page.nextCursorProductId;
        _loadingMore = false;
        _lastLoaded = FavoritesLoaded(
          List<ProductEntity>.unmodifiable(_loadedFavorites),
          hasMore: _hasMore,
          isLoadingMore: false,
        );
        emit(_lastLoaded!);
      },
      onError: (error) {
        if (isClosed) return;
        emit(FavoritesError(error.toString()));
        final previous = _lastLoaded;
        if (previous != null) emit(previous);
      },
    );
  }

  Future<void> loadMore() async {
    if (_userId == null || !_hasMore || _loadingMore || _nextCursor == null) return;
    if (_loadedFavorites.isEmpty) return;
    _loadingMore = true;
    final currentState = state;
    if (currentState is FavoritesLoaded) {
      emit(FavoritesLoaded(
        currentState.products,
        hasMore: currentState.hasMore,
        isLoadingMore: true,
      ));
    }
    final loadSucceeded = await runGuardedMutation(
      'FavoritesCubit.loadMore',
      () async {
        final page = await _fetchPage(_userId!, cursor: _nextCursor);
        if (isClosed) return;
        _loadedFavorites.addAll(page.items);
        _hasMore = page.hasMore;
        _nextCursor = page.nextCursorProductId;
      },
      onError: (error) {
        if (isClosed) return;
        emit(FavoritesError(error.toString()));
        final previous = _lastLoaded;
        if (previous != null) emit(previous);
      },
    );
    _loadingMore = false;
    if (!loadSucceeded || isClosed) return;
    _lastLoaded = FavoritesLoaded(
      List<ProductEntity>.unmodifiable(_loadedFavorites),
      hasMore: _hasMore,
      isLoadingMore: false,
    );
    emit(_lastLoaded!);
  }

  Future<void> toggleFavorite(ProductEntity product) async {
    final user = currentUser;
    if (user == null) {
      final previous = _lastLoaded;
      emit(const FavoritesNeedSignIn());
      emit(previous ?? const FavoritesLoaded([], hasMore: false));
      return;
    }

    final loaded =
        state is FavoritesLoaded ? state as FavoritesLoaded : _lastLoaded;
    final isFavorite = loaded?.ids.contains(product.id) ?? false;

    await runGuardedMutation(
      'FavoritesCubit.toggleFavorite',
      () async {
        if (isFavorite) {
          await _removeFavorite(user.id, product.id);
        } else {
          await _addFavorite(user.id, product);
        }
        await refresh();
      },
      onError: (error) {
        emit(FavoritesError(error.toString()));
        final previous = _lastLoaded;
        if (previous != null) emit(previous);
      },
    );
  }
}
