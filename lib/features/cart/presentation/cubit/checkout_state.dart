import 'package:equatable/equatable.dart';

import 'package:vantage/core/constants/app_constants.dart';
import 'package:vantage/features/addresses/domain/entities/address_entity.dart';
import 'package:vantage/features/cart/domain/entities/cart_line_entity.dart';
import 'package:vantage/features/cart/domain/entities/cart_totals.dart';

sealed class CheckoutState extends Equatable {
  const CheckoutState();

  @override
  List<Object?> get props => [];
}

final class CheckoutInitial extends CheckoutState {
  const CheckoutInitial();
}

final class CheckoutLoading extends CheckoutState {
  const CheckoutLoading();
}

// Cart no longer loadable (empty/invalid) mid-flow.
final class CheckoutInvalid extends CheckoutState {
  const CheckoutInvalid();
}

final class CheckoutReady extends CheckoutState {
  const CheckoutReady({
    required this.lines,
    required this.totals,
    required this.addresses,
    this.selectedAddressId,
    this.paymentLabel = CheckoutUiConstants.defaultPaymentMask,
    this.isPlacing = false,
  });

  final List<CartLineEntity> lines;
  final CartTotals totals;
  final List<AddressEntity> addresses;
  final String? selectedAddressId;
  final String paymentLabel;
  final bool isPlacing;

  AddressEntity? get selectedAddress {
    final id = selectedAddressId;
    if (id == null) return null;
    for (final address in addresses) {
      if (address.id == id) return address;
    }
    return null;
  }

  bool get hasAddress => selectedAddress != null;
  bool get canPlaceOrder => hasAddress && !isPlacing;

  CheckoutReady copyWith({
    List<CartLineEntity>? lines,
    CartTotals? totals,
    List<AddressEntity>? addresses,
    String? selectedAddressId,
    bool clearSelectedAddress = false,
    String? paymentLabel,
    bool? isPlacing,
  }) {
    return CheckoutReady(
      lines: lines ?? this.lines,
      totals: totals ?? this.totals,
      addresses: addresses ?? this.addresses,
      selectedAddressId: clearSelectedAddress
          ? null
          : (selectedAddressId ?? this.selectedAddressId),
      paymentLabel: paymentLabel ?? this.paymentLabel,
      isPlacing: isPlacing ?? this.isPlacing,
    );
  }

  @override
  List<Object?> get props => [
        lines,
        totals,
        addresses,
        selectedAddressId,
        paymentLabel,
        isPlacing,
      ];
}

final class CheckoutError extends CheckoutState {
  const CheckoutError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

final class CheckoutPlaced extends CheckoutState {
  const CheckoutPlaced(this.orderId);

  final String orderId;

  @override
  List<Object?> get props => [orderId];
}
