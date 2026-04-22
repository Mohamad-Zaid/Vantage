import 'package:equatable/equatable.dart';

import 'package:vantage/core/domain/entities/product_entity.dart';

sealed class CategoryProductsState extends Equatable {
  const CategoryProductsState();

  @override
  List<Object?> get props => [];
}

final class CategoryProductsInitial extends CategoryProductsState {
  const CategoryProductsInitial();
}

final class CategoryProductsLoading extends CategoryProductsState {
  const CategoryProductsLoading();
}

final class CategoryProductsLoaded extends CategoryProductsState {
  const CategoryProductsLoaded(this.products);

  final List<ProductEntity> products;

  @override
  List<Object?> get props => [products];
}

final class CategoryProductsError extends CategoryProductsState {
  const CategoryProductsError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
