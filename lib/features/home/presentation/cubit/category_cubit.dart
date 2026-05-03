import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vantage/core/domain/failures/failure.dart';

import '../../domain/usecases/get_categories_usecase.dart';
import 'category_state.dart';

final class CategoryCubit extends Cubit<CategoryState> {
  CategoryCubit(this._getCategories) : super(const CategoryInitial()) {
    unawaited(loadCategories());
  }

  final GetCategoriesUseCase _getCategories;

  Future<void> loadCategories() async {
    emit(const CategoryLoading());
    try {
      final categories = await _getCategories();
      if (isClosed) return;
      if (categories.isEmpty) {
        emit(const CategoryEmpty());
      } else {
        emit(CategoryLoaded(categories));
      }
    } catch (e) {
      if (isClosed) return;
      emit(CategoryError(UnknownFailure(e.toString())));
    }
  }
}
