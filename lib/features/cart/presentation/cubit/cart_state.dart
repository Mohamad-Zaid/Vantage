import 'package:equatable/equatable.dart';

import 'package:vantage/core/domain/failures/failure.dart';
import 'package:vantage/features/cart/domain/entities/cart_line_entity.dart';
import 'package:vantage/features/cart/domain/entities/cart_totals.dart';

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
    required this.totals,
    required this.itemCount,
  });

  final List<CartLineEntity> lines;
  final CartTotals totals;
  final int itemCount;

  @override
  List<Object?> get props => [lines, totals, itemCount];
}

final class CartEmpty extends CartState {
  const CartEmpty();
}

// No Firebase user: cart mutations must route through sign-in.
final class CartNeedSignIn extends CartState {
  const CartNeedSignIn();
}

final class CartError extends CartState {
  const CartError(this.failure);

  final Failure failure;

  @override
  List<Object?> get props => [failure];
}
