// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategoryModel _$CategoryModelFromJson(Map<String, dynamic> json) =>
    CategoryModel(
      id: json['id'] as String,
      title: json['title'] as String,
      slug: json['slug'] as String,
      iconUrl: json['icon_url'] as String,
      backgroundColor: json['background_color'] as String,
    );

Map<String, dynamic> _$CategoryModelToJson(CategoryModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'slug': instance.slug,
      'icon_url': instance.iconUrl,
      'background_color': instance.backgroundColor,
    };
