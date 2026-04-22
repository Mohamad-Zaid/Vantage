import 'package:equatable/equatable.dart';

import '../../domain/entities/named_product_shelf.dart';
import 'package:vantage/core/domain/entities/product_entity.dart';

sealed class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object?> get props => [];
}

final class ProductInitial extends ProductState {
  const ProductInitial();
}

final class ProductLoading extends ProductState {
  const ProductLoading();
}

final class ProductLoaded extends ProductState {
  const ProductLoaded({
    required this.topSelling,
    required this.newInByCategory,
  });

  final List<ProductEntity> topSelling;
  final List<NamedProductShelf> newInByCategory;

  @override
  List<Object?> get props => [topSelling, newInByCategory];
}

final class ProductEmpty extends ProductState {
  const ProductEmpty();
}

final class ProductError extends ProductState {
  const ProductError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
