import 'package:vantage/core/events/domain_event.dart';

final class OrderPlacedEvent extends DomainEvent {
  OrderPlacedEvent({required this.orderId, required this.userId});

  final String orderId;
  final String userId;
}
