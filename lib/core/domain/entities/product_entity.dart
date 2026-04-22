import 'package:equatable/equatable.dart';

class ProductEntity extends Equatable {
  const ProductEntity({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.price,
    this.compareAtPrice,
    required this.rating,
    required this.stock,
  });

  final String id;
  final String categoryId;
  final String name;
  final String description;
  final String imageUrl;
  final double price;

  // “Was” price for sale/strike treatment vs [price].
  final double? compareAtPrice;
  final double rating;
  final int stock;

  @override
  List<Object?> get props => [
        id,
        categoryId,
        name,
        description,
        imageUrl,
        price,
        compareAtPrice,
        rating,
        stock,
      ];
}
