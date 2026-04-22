// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductModel _$ProductModelFromJson(Map<String, dynamic> json) => ProductModel(
  id: json['id'] as String,
  categoryId: json['category_id'] as String,
  name: json['name'] as String,
  description: json['description'] as String,
  imageUrl: json['image_url'] as String,
  price: (json['price'] as num).toDouble(),
  compareAtPrice: (json['compare_at_price'] as num?)?.toDouble(),
  rating: (json['rating'] as num).toDouble(),
  stock: (json['stock'] as num).toInt(),
);

Map<String, dynamic> _$ProductModelToJson(ProductModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'category_id': instance.categoryId,
      'name': instance.name,
      'description': instance.description,
      'image_url': instance.imageUrl,
      'price': instance.price,
      'compare_at_price': instance.compareAtPrice,
      'rating': instance.rating,
      'stock': instance.stock,
    };
