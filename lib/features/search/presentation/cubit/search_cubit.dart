import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vantage/features/search/domain/entities/search_filter.dart';
import 'package:vantage/features/search/domain/usecases/search_products_usecase.dart';
import 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit(this._searchProducts) : super(const SearchInitial());

  final SearchProductsUseCase _searchProducts;

  String _query = '';
  SearchFilter _filter = const SearchFilter();

  String get query => _query;
  SearchFilter get filter => _filter;

  Future<void> search(String query) async {
    _query = query;
    await _runSearch();
  }

  Future<void> applyFilter(SearchFilter filter) async {
    _filter = filter;
    await _runSearch();
  }

  Future<void> _runSearch() async {
    if (_query.isEmpty) {
      emit(const SearchInitial());
      return;
    }
    emit(const SearchLoading());
    try {
      final products = await _searchProducts(query: _query, filter: _filter);
      if (isClosed) return;
      if (products.isEmpty) {
        emit(const SearchEmpty());
      } else {
        emit(SearchLoaded(products: products));
      }
    } catch (e) {
      if (isClosed) return;
      emit(SearchError(message: e.toString()));
    }
  }
}
