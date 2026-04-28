import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_home_shelves_usecase.dart';
import '../../domain/usecases/get_products_by_category_usecase.dart';
import 'product_state.dart';

final class ProductCubit extends Cubit<ProductState> {
  ProductCubit(
    this._getHomeShelves,
    this._getProductsByCategory,
  ) : super(const ProductInitial()) {
    unawaited(loadProducts());
  }

  final GetHomeShelvesUseCase _getHomeShelves;
  final GetProductsByCategoryUseCase _getProductsByCategory;

  Future<void> loadProducts() async {
    emit(const ProductLoading());
    try {
      final shelves = await _getHomeShelves();
      if (isClosed) return;
      final noNewIn = shelves.newInByCategory.every((s) => s.products.isEmpty);
      if (shelves.topSelling.isEmpty && noNewIn) {
        emit(const ProductEmpty());
      } else {
        emit(ProductLoaded(
          topSelling: shelves.topSelling,
          newInByCategory: shelves.newInByCategory,
        ));
      }
    } catch (e, st) {
      debugPrint('ProductCubit.loadProducts: $e\n$st');
      if (isClosed) return;
      emit(ProductError(e.toString()));
    }
  }

  Future<void> loadProductsByCategory(String categoryId) async {
    emit(const ProductLoading());
    try {
      final products = await _getProductsByCategory(categoryId);
      if (isClosed) return;
      if (products.isEmpty) {
        emit(const ProductEmpty());
      } else {
        emit(ProductLoaded(topSelling: products, newInByCategory: const []));
      }
    } catch (e, st) {
      debugPrint('ProductCubit.loadProductsByCategory: $e\n$st');
      if (isClosed) return;
      emit(ProductError(e.toString()));
    }
  }
}
