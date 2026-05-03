import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vantage/core/domain/failures/failure.dart';

import '../../domain/usecases/get_order_detail_usecase.dart';
import 'order_detail_state.dart';

final class OrderDetailCubit extends Cubit<OrderDetailState> {
  OrderDetailCubit(this._getOrderDetail, this.orderId)
    : super(const OrderDetailInitial()) {
    unawaited(load());
  }

  final GetOrderDetailUseCase _getOrderDetail;
  final String orderId;

  Future<void> load() async {
    emit(const OrderDetailLoading());
    try {
      final detail = await _getOrderDetail(orderId);
      if (isClosed) return;
      emit(OrderDetailLoaded(detail));
    } catch (e) {
      if (isClosed) return;
      emit(OrderDetailError(UnknownFailure(e.toString())));
    }
  }

  Future<void> refresh() => load();
}
