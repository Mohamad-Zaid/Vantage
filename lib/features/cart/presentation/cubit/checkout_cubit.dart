import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vantage/core/constants/app_constants.dart';
import 'package:vantage/features/addresses/domain/entities/address_entity.dart';
import 'package:vantage/features/addresses/domain/usecases/watch_user_addresses_usecase.dart';
import 'package:vantage/features/cart/domain/entities/cart_line_entity.dart';
import 'package:vantage/features/cart/domain/entities/cart_totals.dart';
import 'package:vantage/features/cart/domain/services/cart_calculation_service.dart';
import 'package:vantage/features/orders/domain/usecases/place_order_usecase.dart';

import 'checkout_state.dart';

String? _resolveCheckoutSelectedAddressId({
  required List<AddressEntity> addresses,
  required String? userPickedAddressId,
}) {
  if (addresses.isEmpty) return null;
  if (userPickedAddressId != null &&
      addresses.any((address) => address.id == userPickedAddressId)) {
    return userPickedAddressId;
  }
  return addresses.first.id;
}

String _checkoutPaymentLabel(CheckoutState previousState) =>
    previousState is CheckoutReady
        ? previousState.paymentLabel
        : CheckoutUiConstants.defaultPaymentMask;

bool _checkoutIsPlacing(CheckoutState previousState) =>
    previousState is CheckoutReady ? previousState.isPlacing : false;

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
    _totals = const CartCalculationService().calculate(_lines);
    emit(const CheckoutLoading());
    _sub = _watchAddresses(userId).listen(
      _onAddresses,
      onError: (Object error, StackTrace stackTrace) {
        if (isClosed) return;
        debugPrint(
          'CheckoutCubit._watchAddresses subscription failed: $error\n$stackTrace',
        );
        emit(CheckoutError(error.toString()));
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

  void _onAddresses(List<AddressEntity> addresses) {
    if (isClosed) return;
    if (state is CheckoutPlaced) return;
    final previousState = state;
    emit(
      CheckoutReady(
        lines: _lines,
        totals: _totals,
        addresses: addresses,
        selectedAddressId: _resolveCheckoutSelectedAddressId(
          addresses: addresses,
          userPickedAddressId: _userPickedAddressId,
        ),
        paymentLabel: _checkoutPaymentLabel(previousState),
        isPlacing: _checkoutIsPlacing(previousState),
      ),
    );
  }

  void selectAddress(String addressId) {
    if (isClosed) return;
    _userPickedAddressId = addressId;
    final currentState = state;
    if (currentState is! CheckoutReady) return;
    emit(currentState.copyWith(selectedAddressId: addressId));
  }

  void onPaymentSectionTap() {
    throw UnimplementedError(
      'onPaymentSectionTap: payment method picker not yet implemented',
    );
  }

  Future<void> submitOrder() async {
    if (isClosed) return;
    final readyState = state;
    if (readyState is! CheckoutReady) return;
    final addr = readyState.selectedAddress;
    if (addr == null) return;
    emit(readyState.copyWith(isPlacing: true));
    if (isClosed) return;
    try {
      final orderId = await _placeOrder(
        userId: _userId,
        lines: readyState.lines,
        address: addr,
        paymentLabel: readyState.paymentLabel,
      );
      if (isClosed) return;
      emit(CheckoutPlaced(orderId));
    } catch (error, stackTrace) {
      debugPrint('CheckoutCubit.submitOrder failed: $error\n$stackTrace');
      if (isClosed) return;
      emit(CheckoutError(error.toString()));
      if (isClosed) return;
      emit(readyState.copyWith(isPlacing: false));
    }
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}
