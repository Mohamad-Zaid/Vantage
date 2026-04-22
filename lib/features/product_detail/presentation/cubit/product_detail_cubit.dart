import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:vantage/core/domain/entities/product_entity.dart';

import 'product_detail_state.dart';

final class ProductDetailCubit extends Cubit<ProductDetailState> {
  ProductDetailCubit(ProductEntity product)
      : super(
          ProductDetailState(
            product: product,
            selectedSize: 'S',
            selectedColorIndex: 5,
            quantity: 1,
          ),
        );

  static const List<String> kSizes = ['S', 'M', 'L', 'XL', '2XL'];

  void selectSize(String size) {
    emit(state.copyWith(selectedSize: size));
  }

  void selectColor(int index) {
    emit(state.copyWith(selectedColorIndex: index));
  }

  void incrementQuantity() {
    final maxQty = state.product.stock;
    if (state.quantity >= maxQty) return;
    emit(state.copyWith(quantity: state.quantity + 1));
  }

  void decrementQuantity() {
    if (state.quantity <= 1) return;
    emit(state.copyWith(quantity: state.quantity - 1));
  }
}
