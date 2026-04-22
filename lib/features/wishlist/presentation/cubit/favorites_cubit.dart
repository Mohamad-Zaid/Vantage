import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:vantage/core/domain/entities/product_entity.dart';

import '../../../auth/domain/entities/user_entity.dart';
import '../../../auth/domain/usecases/get_current_user_usecase.dart';
import '../../../auth/domain/usecases/watch_auth_state_usecase.dart';
import '../../domain/usecases/add_favorite_usecase.dart';
import '../../domain/usecases/fetch_favorites_page_usecase.dart';
import '../../domain/usecases/remove_favorite_usecase.dart';
import 'favorites_state.dart';

final class FavoritesCubit extends Cubit<FavoritesState> {
  FavoritesCubit({
    required WatchAuthStateUseCase watchAuth,
    required FetchFavoritesPageUseCase fetchPage,
    required AddFavoriteUseCase addFavorite,
    required RemoveFavoriteUseCase removeFavorite,
    required GetCurrentUserUseCase getCurrentUser,
  })  : _watchAuth = watchAuth,
        _fetchPage = fetchPage,
        _addFavorite = addFavorite,
        _removeFavorite = removeFavorite,
        _getCurrentUser = getCurrentUser,
        super(const FavoritesInitial()) {
    emit(const FavoritesLoading());
    _authSubscription = _watchAuth().listen(_onAuthUserChanged);
  }

  final WatchAuthStateUseCase _watchAuth;
  final FetchFavoritesPageUseCase _fetchPage;
  final AddFavoriteUseCase _addFavorite;
  final RemoveFavoriteUseCase _removeFavorite;
  final GetCurrentUserUseCase _getCurrentUser;

  StreamSubscription<UserEntity?>? _authSubscription;

  FavoritesLoaded? _lastLoaded;
  final List<ProductEntity> _all = [];
  bool _hasMore = false;
  String? _nextCursor;
  bool _loadingMore = false;
  String? _userId;

  void _onAuthUserChanged(UserEntity? userEntity) {
    if (userEntity == null) {
      _userId = null;
      _all.clear();
      _hasMore = false;
      _nextCursor = null;
      _loadingMore = false;
      _lastLoaded = const FavoritesLoaded([], hasMore: false);
      emit(_lastLoaded!);
      return;
    }

    _userId = userEntity.id;
    unawaited(_loadFirstPage());
  }

  Future<void> _loadFirstPage() async {
    if (_userId == null) return;
    emit(const FavoritesLoading());
    try {
      final page = await _fetchPage(_userId!);
      if (isClosed) return;
      _all
        ..clear()
        ..addAll(page.items);
      _hasMore = page.hasMore;
      _nextCursor = page.nextCursorProductId;
      _loadingMore = false;
      _lastLoaded = FavoritesLoaded(
        List<ProductEntity>.unmodifiable(_all),
        hasMore: _hasMore,
        isLoadingMore: false,
      );
      emit(_lastLoaded!);
    } catch (e) {
      if (isClosed) return;
      emit(FavoritesError(e.toString()));
    }
  }

  Future<void> refresh() async {
    if (_userId == null) return;
    try {
      final page = await _fetchPage(_userId!);
      if (isClosed) return;
      _all
        ..clear()
        ..addAll(page.items);
      _hasMore = page.hasMore;
      _nextCursor = page.nextCursorProductId;
      _loadingMore = false;
      _lastLoaded = FavoritesLoaded(
        List<ProductEntity>.unmodifiable(_all),
        hasMore: _hasMore,
        isLoadingMore: false,
      );
      emit(_lastLoaded!);
    } catch (e) {
      if (isClosed) return;
      emit(FavoritesError(e.toString()));
      if (_lastLoaded != null) {
        emit(_lastLoaded!);
      }
    }
  }

  Future<void> loadMore() async {
    if (_userId == null || !_hasMore || _loadingMore || _nextCursor == null) {
      return;
    }
    if (_all.isEmpty) return;
    _loadingMore = true;
    if (state is FavoritesLoaded) {
      final s = state as FavoritesLoaded;
      emit(
        FavoritesLoaded(
          s.products,
          hasMore: s.hasMore,
          isLoadingMore: true,
        ),
      );
    }
    try {
      final page = await _fetchPage(
        _userId!,
        cursor: _nextCursor,
      );
      if (isClosed) return;
      _all.addAll(page.items);
      _hasMore = page.hasMore;
      _nextCursor = page.nextCursorProductId;
    } catch (e) {
      if (isClosed) return;
      emit(FavoritesError(e.toString()));
      if (_lastLoaded != null) {
        emit(_lastLoaded!);
      }
      return;
    }
    _loadingMore = false;
    if (isClosed) return;
    _lastLoaded = FavoritesLoaded(
      List<ProductEntity>.unmodifiable(_all),
      hasMore: _hasMore,
      isLoadingMore: false,
    );
    emit(_lastLoaded!);
  }

  // Guest: brief [FavoritesNeedSignIn] flash, then restore the last loaded list.
  Future<void> toggleFavorite(ProductEntity product) async {
    final user = await _getCurrentUser();
    if (user == null) {
      final prev = _lastLoaded;
      emit(const FavoritesNeedSignIn());
      if (prev != null) {
        emit(prev);
      } else {
        emit(const FavoritesLoaded([], hasMore: false));
      }
      return;
    }

    final loaded = state is FavoritesLoaded
        ? state as FavoritesLoaded
        : _lastLoaded;
    final isFavorite = loaded?.ids.contains(product.id) ?? false;

    try {
      if (isFavorite) {
        await _removeFavorite(user.id, product.id);
      } else {
        await _addFavorite(user.id, product);
      }
      await refresh();
    } catch (e) {
      emit(FavoritesError(e.toString()));
      if (_lastLoaded != null) {
        emit(_lastLoaded!);
      }
    }
  }

  @override
  Future<void> close() async {
    await _authSubscription?.cancel();
    return super.close();
  }
}
