import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:vantage/core/auth/auth_aware_cubit.dart';
import 'package:vantage/core/domain/failures/failure.dart';
import 'package:vantage/core/cubits/cubit_error_handler.dart';
import 'package:vantage/core/auth/current_user_provider.dart';
import 'package:vantage/core/domain/entities/user_entity.dart';
import 'package:vantage/core/events/domain_event_bus.dart';
import 'package:vantage/features/cart/domain/entities/cart_line_entity.dart';
import 'package:vantage/features/cart/domain/entities/cart_line_input.dart';
import 'package:vantage/features/cart/domain/services/cart_calculation_service.dart';
import 'package:vantage/features/cart/domain/usecases/add_cart_line_usecase.dart';
import 'package:vantage/features/cart/domain/usecases/clear_cart_usecase.dart';
import 'package:vantage/features/cart/domain/usecases/remove_cart_line_usecase.dart';
import 'package:vantage/features/cart/domain/usecases/update_cart_line_quantity_usecase.dart';
import 'package:vantage/features/cart/domain/usecases/watch_cart_usecase.dart';
import 'package:vantage/features/orders/domain/events/order_placed_event.dart';

import 'cart_state.dart';

final class CartCubit extends AuthAwareCubit<CartState>
    with CubitErrorHandler<CartState> {
  CartCubit({
    required CurrentUserProvider authProvider,
    required DomainEventBus domainEvents,
    required WatchCartUseCase watchCart,
    required AddCartLineUseCase addLine,
    required UpdateCartLineQuantityUseCase updateQty,
    required RemoveCartLineUseCase removeLine,
    required ClearCartUseCase clearCart,
  })  : _domainEvents = domainEvents,
        _watchCart = watchCart,
        _addLine = addLine,
        _updateQty = updateQty,
        _removeLine = removeLine,
        _clearCart = clearCart,
        super(const CartInitial(), authProvider) {
    emit(const CartLoading());
    _orderPlacedSub = _domainEvents.events
        .where((event) => event is OrderPlacedEvent)
        .cast<OrderPlacedEvent>()
        .listen(_onOrderPlaced);
  }

  final DomainEventBus _domainEvents;
  final WatchCartUseCase _watchCart;
  final AddCartLineUseCase _addLine;
  final UpdateCartLineQuantityUseCase _updateQty;
  final RemoveCartLineUseCase _removeLine;
  final ClearCartUseCase _clearCart;
  final _calculationService = const CartCalculationService();

  StreamSubscription<List<CartLineEntity>>? _cartSub;
  late final StreamSubscription<OrderPlacedEvent> _orderPlacedSub;
  CartLoaded? _lastLoaded;
  void _setLoaded(CartLoaded loadedState) => _lastLoaded = loadedState;

  void _onOrderPlaced(OrderPlacedEvent event) {
    if (isClosed) return;
    final user = currentUser;
    if (user == null || user.id != event.userId) return;
    unawaited(_clearCartAfterOrder(event.userId));
  }

  Future<void> _clearCartAfterOrder(String userId) async {
    try {
      await _clearCart(userId);
    } catch (error, stackTrace) {
      debugPrint('CartCubit._clearCartAfterOrder failed: $error\n$stackTrace');
    }
  }

  @override
  void onAuthStateChanged(UserEntity? user) {
    _cartSub?.cancel();
    _cartSub = null;
    if (user == null) {
      emit(const CartNeedSignIn());
      return;
    }
    _cartSub = _watchCart(user.id).listen(
      _onLines,
      onError: (Object error, StackTrace stackTrace) {
        debugPrint(
          'CartCubit._watchCart subscription failed: $error\n$stackTrace',
        );
        emit(CartError(UnknownFailure(error.toString())));
        final previousLoaded = _lastLoaded;
        if (previousLoaded != null) emit(previousLoaded);
      },
    );
  }

  void _onLines(List<CartLineEntity> lines) {
    if (lines.isEmpty) {
      _lastLoaded = null;
      emit(const CartEmpty());
      return;
    }
    final totals = _calculationService.calculate(lines);
    final itemCount = lines.fold(0, (sum, line) => sum + line.quantity);
    final loadedState = CartLoaded(
      lines: List<CartLineEntity>.unmodifiable(lines),
      totals: totals,
      itemCount: itemCount,
    );
    _setLoaded(loadedState);
    emit(loadedState);
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
    final user = currentUser;
    if (user == null) {
      emit(const CartNeedSignIn());
      return;
    }
    await runGuardedMutation(
      'CartCubit.addProductLine',
      () async {
        await _addLine(
          user.id,
          CartLineInput(
            productId: productId,
            name: name,
            imageUrl: imageUrl,
            unitPrice: unitPrice,
            size: size,
            colorLabel: colorLabel,
            quantityDelta: quantity,
          ),
        );
      },
      onError: (Object error) {
        emit(CartError(UnknownFailure(error.toString())));
        final previousLoaded = _lastLoaded;
        if (previousLoaded != null) emit(previousLoaded);
      },
    );
  }

  Future<void> setLineQuantity(String lineId, int quantity) async {
    final user = currentUser;
    if (user == null) {
      emit(const CartNeedSignIn());
      return;
    }
    if (isClosed) return;
    await runGuardedMutation(
      'CartCubit.setLineQuantity',
      () async {
        await _updateQty(user.id, lineId, quantity);
      },
      onError: (Object error) {
        emit(CartError(UnknownFailure(error.toString())));
        final previousLoaded = _lastLoaded;
        if (previousLoaded != null) emit(previousLoaded);
      },
    );
  }

  Future<void> removeLine(String lineId) async {
    final user = currentUser;
    if (user == null) {
      emit(const CartNeedSignIn());
      return;
    }
    if (isClosed) return;
    await runGuardedMutation(
      'CartCubit.removeLine',
      () async {
        await _removeLine(user.id, lineId);
      },
      onError: (Object error) {
        emit(CartError(UnknownFailure(error.toString())));
        final previousLoaded = _lastLoaded;
        if (previousLoaded != null) emit(previousLoaded);
      },
    );
  }

  Future<void> clearAll() async {
    final user = currentUser;
    if (user == null) {
      emit(const CartNeedSignIn());
      return;
    }
    if (isClosed) return;
    await runGuardedMutation(
      'CartCubit.clearAll',
      () async {
        await _clearCart(user.id);
      },
      onError: (Object error) {
        emit(CartError(UnknownFailure(error.toString())));
        final previousLoaded = _lastLoaded;
        if (previousLoaded != null) emit(previousLoaded);
      },
    );
  }

  Future<void> refresh() async {
    final user = currentUser;
    if (user == null) return;
    _cartSub?.cancel();
    _cartSub = _watchCart(user.id).listen(
      _onLines,
      onError: (Object error, StackTrace stackTrace) {
        debugPrint(
          'CartCubit.refresh subscription failed: $error\n$stackTrace',
        );
        emit(CartError(UnknownFailure(error.toString())));
        final previousLoaded = _lastLoaded;
        if (previousLoaded != null) emit(previousLoaded);
      },
    );
  }

  @override
  Future<void> close() {
    _cartSub?.cancel();
    _orderPlacedSub.cancel();
    return super.close();
  }
}
