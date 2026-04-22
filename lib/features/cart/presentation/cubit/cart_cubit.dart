import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vantage/features/auth/domain/entities/user_entity.dart';
import 'package:vantage/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:vantage/features/auth/domain/usecases/watch_auth_state_usecase.dart';
import 'package:vantage/features/cart/domain/cart_pricing.dart';
import 'package:vantage/features/cart/domain/entities/cart_line_entity.dart';
import 'package:vantage/features/cart/domain/usecases/add_cart_line_usecase.dart';
import 'package:vantage/features/cart/domain/usecases/clear_cart_usecase.dart';
import 'package:vantage/features/cart/domain/usecases/remove_cart_line_usecase.dart';
import 'package:vantage/features/cart/domain/usecases/update_cart_line_quantity_usecase.dart';
import 'package:vantage/features/cart/domain/usecases/watch_cart_usecase.dart';

import 'cart_state.dart';

final class CartCubit extends Cubit<CartState> {
  CartCubit({
    required WatchAuthStateUseCase watchAuth,
    required WatchCartUseCase watchCart,
    required AddCartLineUseCase addLine,
    required UpdateCartLineQuantityUseCase updateQty,
    required RemoveCartLineUseCase removeLine,
    required ClearCartUseCase clearCart,
    required GetCurrentUserUseCase getCurrentUser,
  })  : _watchAuth = watchAuth,
        _watchCart = watchCart,
        _addLine = addLine,
        _updateQty = updateQty,
        _removeLine = removeLine,
        _clearCart = clearCart,
        _getCurrentUser = getCurrentUser,
        super(const CartInitial()) {
    emit(const CartLoading());
    _authSub = _watchAuth().listen(_onAuth);
  }

  final WatchAuthStateUseCase _watchAuth;
  final WatchCartUseCase _watchCart;
  final AddCartLineUseCase _addLine;
  final UpdateCartLineQuantityUseCase _updateQty;
  final RemoveCartLineUseCase _removeLine;
  final ClearCartUseCase _clearCart;
  final GetCurrentUserUseCase _getCurrentUser;

  StreamSubscription<UserEntity?>? _authSub;
  StreamSubscription<List<CartLineEntity>>? _cartSub;

  CartLoaded? _lastLoaded;
  void _setLoaded(CartLoaded s) {
    _lastLoaded = s;
  }

  void _onAuth(UserEntity? u) {
    _cartSub?.cancel();
    _cartSub = null;
    if (u == null) {
      emit(const CartNeedSignIn());
      return;
    }
    _cartSub = _watchCart(u.id).listen(
      _onLines,
      onError: (Object e, StackTrace st) {
        emit(CartError(e.toString()));
        if (_lastLoaded != null) emit(_lastLoaded!);
      },
    );
  }

  void _onLines(List<CartLineEntity> lines) {
    if (lines.isEmpty) {
      _lastLoaded = null;
      emit(const CartEmpty());
      return;
    }
    var sub = 0.0;
    var itemCount = 0;
    for (final l in lines) {
      sub += l.lineTotal;
      itemCount += l.quantity;
    }
    final t = sub + CartPricing.shipping + CartPricing.tax;
    final s = CartLoaded(
      lines: List<CartLineEntity>.unmodifiable(lines),
      subtotal: sub,
      shipping: CartPricing.shipping,
      tax: CartPricing.tax,
      total: t,
      itemCount: itemCount,
    );
    _setLoaded(s);
    emit(s);
  }

  Future<void> addProductLine({
    required String productId,
    required String name,
    required String imageUrl,
    required double unitPrice,
    required String size,
    required String colorLabel,
    int quantity = 1,
  }) async {
    final u = await _getCurrentUser();
    if (u == null) {
      emit(const CartNeedSignIn());
      return;
    }
    try {
      await _addLine(
        u.id,
        productId: productId,
        name: name,
        imageUrl: imageUrl,
        unitPrice: unitPrice,
        size: size,
        colorLabel: colorLabel,
        quantityDelta: quantity,
      );
    } catch (e) {
      emit(CartError(e.toString()));
      if (_lastLoaded != null) emit(_lastLoaded!);
    }
  }

  Future<void> setLineQuantity(String lineId, int quantity) async {
    final u = await _getCurrentUser();
    if (u == null) {
      emit(const CartNeedSignIn());
      return;
    }
    if (isClosed) return;
    try {
      await _updateQty(u.id, lineId, quantity);
    } catch (e) {
      emit(CartError(e.toString()));
      if (_lastLoaded != null) emit(_lastLoaded!);
    }
  }

  Future<void> removeLine(String lineId) async {
    final u = await _getCurrentUser();
    if (u == null) {
      emit(const CartNeedSignIn());
      return;
    }
    if (isClosed) return;
    try {
      await _removeLine(u.id, lineId);
    } catch (e) {
      emit(CartError(e.toString()));
      if (_lastLoaded != null) emit(_lastLoaded!);
    }
  }

  Future<void> clearAll() async {
    final u = await _getCurrentUser();
    if (u == null) {
      emit(const CartNeedSignIn());
      return;
    }
    if (isClosed) return;
    try {
      await _clearCart(u.id);
    } catch (e) {
      emit(CartError(e.toString()));
      if (_lastLoaded != null) emit(_lastLoaded!);
    }
  }

  // Re-subscribe to the Firestore cart stream (pull-to-refresh).
  Future<void> refresh() async {
    final u = await _getCurrentUser();
    if (u == null) return;
    await _cartSub?.cancel();
    _cartSub = _watchCart(u.id).listen(
      _onLines,
      onError: (Object e, StackTrace st) {
        emit(CartError(e.toString()));
        if (_lastLoaded != null) emit(_lastLoaded!);
      },
    );
  }

  @override
  Future<void> close() {
    _authSub?.cancel();
    _cartSub?.cancel();
    return super.close();
  }
}
