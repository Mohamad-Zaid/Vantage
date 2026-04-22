import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vantage/features/addresses/domain/entities/address_entity.dart';
import 'package:vantage/features/addresses/domain/usecases/watch_user_addresses_usecase.dart';
import 'package:vantage/features/cart/domain/entities/cart_line_entity.dart';
import 'package:vantage/features/cart/domain/usecases/place_order_usecase.dart';
import 'package:vantage/features/cart/presentation/cubit/cart_state.dart';

import 'checkout_state.dart';

final class CheckoutCubit extends Cubit<CheckoutState> {
  CheckoutCubit({
    required List<CartLineEntity> initialLines,
    required String userId,
    required WatchUserAddressesUseCase watchAddresses,
    required PlaceOrderUseCase placeOrder,
  })  : _userId = userId,
        _watchAddresses = watchAddresses,
        _placeOrder = placeOrder,
        super(const CheckoutInitial()) {
    if (initialLines.isEmpty) {
      emit(const CheckoutInvalid());
      return;
    }
    _lines = List<CartLineEntity>.unmodifiable(initialLines);
    _totals = cartTotalsForLines(_lines);
    emit(const CheckoutLoading());
    _sub = _watchAddresses(userId).listen(
      _onAddresses,
      onError: (Object e, StackTrace st) {
        if (isClosed) return;
        emit(CheckoutError(e.toString()));
      },
    );
  }

  final String _userId;
  final WatchUserAddressesUseCase _watchAddresses;
  final PlaceOrderUseCase _placeOrder;

  StreamSubscription<List<AddressEntity>>? _sub;
  late final List<CartLineEntity> _lines;
  late final CartTotals _totals;
  String? _userPickedAddressId;

  void _onAddresses(List<AddressEntity> list) {
    if (isClosed) return;
    if (state is CheckoutPlaced) return;
    String? nextId;
    if (list.isEmpty) {
      nextId = null;
    } else {
      if (_userPickedAddressId != null &&
          list.any((a) => a.id == _userPickedAddressId)) {
        nextId = _userPickedAddressId;
      } else {
        nextId = list.first.id;
      }
    }
    final prev = state;
    final paymentLabel = prev is CheckoutReady
        ? prev.paymentLabel
        : '**** 4187';
    final isPlacing = prev is CheckoutReady ? prev.isPlacing : false;
    emit(
      CheckoutReady(
        lines: _lines,
        totals: _totals,
        addresses: list,
        selectedAddressId: nextId,
        paymentLabel: paymentLabel,
        isPlacing: isPlacing,
      ),
    );
  }

  void selectAddress(String addressId) {
    if (isClosed) return;
    _userPickedAddressId = addressId;
    final s = state;
    if (s is! CheckoutReady) return;
    emit(s.copyWith(selectedAddressId: addressId));
  }

  // ignore: use_setters_to_change_properties
  void onPaymentSectionTap() {
    // TODO(shop): real payment method picker.
  }

  Future<void> submitOrder() async {
    if (isClosed) return;
    final s = state;
    if (s is! CheckoutReady) return;
    final addr = s.selectedAddress;
    if (addr == null) return;
    emit(s.copyWith(isPlacing: true));
    if (isClosed) return;
    try {
      final orderId = await _placeOrder(
        userId: _userId,
        lines: s.lines,
        address: addr,
        paymentLabel: s.paymentLabel,
      );
      if (isClosed) return;
      emit(CheckoutPlaced(orderId));
    } catch (e) {
      if (isClosed) return;
      emit(CheckoutError(e.toString()));
      if (isClosed) return;
      emit(s.copyWith(isPlacing: false));
    }
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}
