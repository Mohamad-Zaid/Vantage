import 'package:equatable/equatable.dart';

class CategoryEntity extends Equatable {
  const CategoryEntity({
    required this.id,
    required this.title,
    required this.slug,
    required this.iconUrl,
    required this.backgroundColor,
  });

  final String id;
  final String title;
  final String slug;
  final String iconUrl;
  final String backgroundColor;

  @override
  List<Object?> get props => [id, title, slug, iconUrl, backgroundColor];
}
