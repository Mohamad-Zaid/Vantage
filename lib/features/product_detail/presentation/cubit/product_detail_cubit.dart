import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:vantage/core/domain/entities/product_entity.dart';

import 'product_detail_state.dart';

final class ProductDetailCubit extends Cubit<ProductDetailState> {
  ProductDetailCubit(ProductEntity product)
      : super(
          ProductDetailReady(
            product: product,
            selectedSize: 'S',
            selectedColorIndex: 5,
            quantity: 1,
          ),
        );

  static const List<String> kSizes = ['S', 'M', 'L', 'XL', '2XL'];

  void selectSize(String size) {
    emit((state as ProductDetailReady).copyWith(selectedSize: size));
  }

  void selectColor(int index) {
    emit((state as ProductDetailReady).copyWith(selectedColorIndex: index));
  }

  void incrementQuantity() {
    final ready = state as ProductDetailReady;
    if (ready.quantity >= ready.product.stock) return;
    emit(ready.copyWith(quantity: ready.quantity + 1));
  }

  void decrementQuantity() {
    final ready = state as ProductDetailReady;
    if (ready.quantity <= 1) return;
    emit(ready.copyWith(quantity: ready.quantity - 1));
  }
}
