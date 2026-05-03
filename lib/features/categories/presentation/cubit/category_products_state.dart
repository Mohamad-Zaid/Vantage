import 'package:equatable/equatable.dart';
import 'package:vantage/core/domain/entities/product_entity.dart';
import 'package:vantage/core/domain/failures/failure.dart';

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
  const CategoryProductsError(this.failure);

  final Failure failure;

  @override
  List<Object?> get props => [failure];
}
