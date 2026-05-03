import 'package:equatable/equatable.dart';
import 'package:vantage/core/domain/entities/product_entity.dart';
import 'package:vantage/core/domain/failures/failure.dart';

sealed class SearchState extends Equatable {
  const SearchState();
}

final class SearchInitial extends SearchState {
  const SearchInitial();

  @override
  List<Object?> get props => [];
}

final class SearchLoading extends SearchState {
  const SearchLoading();

  @override
  List<Object?> get props => [];
}

final class SearchLoaded extends SearchState {
  const SearchLoaded({required this.products});

  final List<ProductEntity> products;

  @override
  List<Object?> get props => [products];
}

final class SearchEmpty extends SearchState {
  const SearchEmpty();

  @override
  List<Object?> get props => [];
}

final class SearchError extends SearchState {
  const SearchError({required this.failure});

  final Failure failure;

  @override
  List<Object?> get props => [failure];
}
