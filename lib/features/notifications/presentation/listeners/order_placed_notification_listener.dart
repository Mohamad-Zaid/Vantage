import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:vantage/core/events/domain_event_bus.dart';
import 'package:vantage/core/translations/locale_keys.g.dart';
import 'package:vantage/features/notifications/domain/entities/notification_entity.dart';
import 'package:vantage/features/notifications/domain/repositories/notifications_repository.dart';
import 'package:vantage/features/orders/domain/events/order_placed_event.dart';

final class OrderPlacedNotificationListener {
  OrderPlacedNotificationListener(this._domainEvents, this._repository) {
    _domainEvents.events
        .where((event) => event is OrderPlacedEvent)
        .cast<OrderPlacedEvent>()
        .listen(_onOrderPlaced);
  }

  final DomainEventBus _domainEvents;
  final NotificationsRepository _repository;

  Future<void> _onOrderPlaced(OrderPlacedEvent event) async {
    try {
      final message = LocaleKeys.notifications_orderPlacedMessage.tr(
        namedArgs: {'orderId': event.orderId},
      );
      await _repository.appendNotification(
        NotificationEntity(
          id: 'order-${event.orderId}-${event.occurredAt.microsecondsSinceEpoch}',
          message: message,
        ),
      );
    } catch (e, st) {
      debugPrint('OrderPlacedNotificationListener._onOrderPlaced failed: $e\n$st');
    }
  }
}
