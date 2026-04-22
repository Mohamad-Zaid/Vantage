import 'package:equatable/equatable.dart';

import 'package:vantage/core/domain/entities/product_entity.dart';

final class NamedProductShelf extends Equatable {
  const NamedProductShelf({
    required this.titleKey,
    required this.products,
  });

  final String titleKey;
  final List<ProductEntity> products;

  @override
  List<Object?> get props => [titleKey, products];
}
