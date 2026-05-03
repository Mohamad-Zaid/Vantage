import 'package:equatable/equatable.dart';

import 'package:vantage/core/domain/entities/product_entity.dart';
import 'package:vantage/core/domain/failures/failure.dart';

sealed class FavoritesState extends Equatable {
  const FavoritesState();

  @override
  List<Object?> get props => [];
}

final class FavoritesInitial extends FavoritesState {
  const FavoritesInitial();
}

final class FavoritesLoading extends FavoritesState {
  const FavoritesLoading();
}

final class FavoritesLoaded extends FavoritesState {
  const FavoritesLoaded(
    this.products, {
    this.hasMore = false,
    this.isLoadingMore = false,
  });

  final List<ProductEntity> products;
  final bool hasMore;
  final bool isLoadingMore;

  Set<String> get ids => {for (final p in products) p.id};

  @override
  List<Object?> get props => [products, hasMore, isLoadingMore];
}

// Short-lived so a guest can see the “sign in” affordance before stream restore.
final class FavoritesNeedSignIn extends FavoritesState {
  const FavoritesNeedSignIn();
}

final class FavoritesError extends FavoritesState {
  const FavoritesError(this.failure);

  final Failure failure;

  @override
  List<Object?> get props => [failure];
}
