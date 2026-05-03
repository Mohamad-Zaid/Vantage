import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vantage/core/domain/failures/failure.dart';
import 'package:vantage/features/home/domain/usecases/get_products_by_category_usecase.dart';

import 'category_products_state.dart';

final class CategoryProductsCubit extends Cubit<CategoryProductsState> {
  CategoryProductsCubit(this._getProductsByCategory)
      : super(const CategoryProductsInitial());

  final GetProductsByCategoryUseCase _getProductsByCategory;

  Future<void> load(String categoryId) async {
    emit(const CategoryProductsLoading());
    try {
      final products = await _getProductsByCategory(categoryId);
      if (isClosed) return;
      emit(CategoryProductsLoaded(products));
    } catch (e) {
      if (isClosed) return;
      emit(CategoryProductsError(UnknownFailure(e.toString())));
    }
  }
}
