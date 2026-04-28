abstract class DomainEvent {
  DomainEvent() : occurredAt = DateTime.now();

  final DateTime occurredAt;
}
