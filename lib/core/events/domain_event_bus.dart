import 'dart:async';

import 'domain_event.dart';

abstract interface class DomainEventBus {
  Stream<DomainEvent> get events;

  void dispatch(DomainEvent event);
}

final class BroadcastDomainEventBus implements DomainEventBus {
  final _controller = StreamController<DomainEvent>.broadcast();

  @override
  Stream<DomainEvent> get events => _controller.stream;

  @override
  void dispatch(DomainEvent event) => _controller.add(event);
}
