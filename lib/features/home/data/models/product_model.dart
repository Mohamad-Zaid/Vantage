import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:vantage/core/domain/entities/product_entity.dart';

part 'product_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ProductModel extends ProductEntity with EquatableMixin {
  const ProductModel({
    required super.id,
    required super.categoryId,
    required super.name,
    required super.description,
    required super.imageUrl,
    required super.price,
    super.compareAtPrice,
    required super.rating,
    required super.stock,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductModelToJson(this);

  // ProductModel IS-A ProductEntity via inheritance — upcast directly to avoid copying fields.
  ProductEntity toEntity() => this;
}
