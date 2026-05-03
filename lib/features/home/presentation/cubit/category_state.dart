import 'package:equatable/equatable.dart';
import 'package:vantage/core/domain/failures/failure.dart';

import '../../domain/entities/category_entity.dart';

sealed class CategoryState extends Equatable {
  const CategoryState();

  @override
  List<Object?> get props => [];
}

final class CategoryInitial extends CategoryState {
  const CategoryInitial();
}

final class CategoryLoading extends CategoryState {
  const CategoryLoading();
}

final class CategoryLoaded extends CategoryState {
  const CategoryLoaded(this.categories);

  final List<CategoryEntity> categories;

  @override
  List<Object?> get props => [categories];
}

final class CategoryEmpty extends CategoryState {
  const CategoryEmpty();
}

final class CategoryError extends CategoryState {
  const CategoryError(this.failure);

  final Failure failure;

  @override
  List<Object?> get props => [failure];
}
