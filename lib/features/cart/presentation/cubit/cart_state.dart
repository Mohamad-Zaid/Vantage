import 'package:equatable/equatable.dart';

import 'package:vantage/features/cart/domain/cart_pricing.dart';
import 'package:vantage/features/cart/domain/entities/cart_line_entity.dart';

sealed class CartState extends Equatable {
  const CartState();

  @override
  List<Object?> get props => [];
}

final class CartInitial extends CartState {
  const CartInitial();
}

final class CartLoading extends CartState {
  const CartLoading();
}

final class CartLoaded extends CartState {
  const CartLoaded({
    required this.lines,
    required this.subtotal,
    required this.shipping,
    required this.tax,
    required this.total,
    required this.itemCount,
  });

  final List<CartLineEntity> lines;
  final double subtotal;
  final double shipping;
  final double tax;
  final double total;
  final int itemCount;

  CartTotals asTotals() {
    return CartTotals(
      subtotal: subtotal,
      shipping: shipping,
      tax: tax,
      total: total,
      itemCount: itemCount,
    );
  }

  @override
  List<Object?> get props =>
      [lines, subtotal, shipping, tax, total, itemCount];
}

final class CartEmpty extends CartState {
  const CartEmpty();
}

// No Firebase user: cart mutations must route through sign-in.
final class CartNeedSignIn extends CartState {
  const CartNeedSignIn();
}

final class CartError extends CartState {
  const CartError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

// Same math as [CartLoaded] / [PlaceOrderUseCase] for checkout review.
CartTotals cartTotalsForLines(List<CartLineEntity> lines) {
  var sub = 0.0;
  var qty = 0;
  for (final l in lines) {
    sub += l.lineTotal;
    qty += l.quantity;
  }
  return CartTotals(
    subtotal: sub,
    shipping: CartPricing.shipping,
    tax: CartPricing.tax,
    total: sub + CartPricing.shipping + CartPricing.tax,
    itemCount: qty,
  );
}

final class CartTotals {
  const CartTotals({
    required this.subtotal,
    required this.shipping,
    required this.tax,
    required this.total,
    required this.itemCount,
  });

  final double subtotal;
  final double shipping;
  final double tax;
  final double total;
  final int itemCount;
}
