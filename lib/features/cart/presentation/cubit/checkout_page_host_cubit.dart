import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:vantage/features/cart/presentation/cubit/checkout_cubit.dart';

class CheckoutPageHostState extends Equatable {
  const CheckoutPageHostState([this.checkoutCubit]);

  final CheckoutCubit? checkoutCubit;

  @override
  List<Object?> get props => [checkoutCubit];
}

class CheckoutPageHostCubit extends Cubit<CheckoutPageHostState> {
  CheckoutPageHostCubit() : super(const CheckoutPageHostState());

  void setCheckout(CheckoutCubit? next) {
    state.checkoutCubit?.close();
    emit(CheckoutPageHostState(next));
  }

  @override
  Future<void> close() {
    state.checkoutCubit?.close();
    return super.close();
  }
}
