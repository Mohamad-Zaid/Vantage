import 'package:vantage/core/errors/domain_exceptions.dart';
import 'package:vantage/core/events/domain_event_bus.dart';
import 'package:vantage/features/addresses/domain/entities/address_entity.dart';
import 'package:vantage/features/cart/domain/entities/cart_line_entity.dart';
import 'package:vantage/features/cart/domain/repositories/cart_repository.dart';
import 'package:vantage/features/cart/domain/services/cart_calculation_service.dart';
import 'package:vantage/features/orders/domain/entities/order_line_entity.dart';
import 'package:vantage/features/orders/domain/events/order_placed_event.dart';
import 'package:vantage/features/orders/domain/repositories/orders_repository.dart';

final class PlaceOrderUseCase {
  const PlaceOrderUseCase(this._cart, this._orders, this._domainEvents);

  final CartRepository _cart;
  final OrdersRepository _orders;
  final DomainEventBus _domainEvents;
  static const _calculationService = CartCalculationService();

  Future<String> call({
    required String userId,
    required List<CartLineEntity> lines,
    required AddressEntity address,
    required String paymentLabel,
  }) async {
    if (lines.isEmpty) {
      throw const DomainValidationException('Cart is empty');
    }
    final totals = _calculationService.calculate(lines);

    final orderLines = lines
        .map(
          (line) => OrderLineEntity(
            productId: line.productId,
            name: line.name,
            imageUrl: line.imageUrl,
            unitPrice: line.unitPrice,
            quantity: line.quantity,
            size: line.size,
            colorLabel: line.colorLabel,
          ),
        )
        .toList();

    final orderId = await _orders.createOrder(
      userId,
      lines: orderLines,
      subtotal: totals.subtotal,
      shipping: totals.shipping,
      tax: totals.tax,
      total: totals.total,
      addressStreet: address.street,
      addressCity: address.city,
      addressState: address.state,
      addressZip: address.zipCode,
      addressId: address.id.isEmpty ? null : address.id,
      paymentLabel: paymentLabel,
    );

    await _cart.clearCart(userId);

    _domainEvents.dispatch(
      OrderPlacedEvent(orderId: orderId, userId: userId),
    );
    return orderId;
  }
}
