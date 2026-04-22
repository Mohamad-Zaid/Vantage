import '../../domain/entities/notification_entity.dart';

abstract class NotificationsLocalDataSource {
  Future<List<NotificationEntity>> readAll();

  Future<void> deleteById(String id);
}

// Demo in-memory list until a real store backs notifications.
final class NotificationsLocalDataSourceImpl
    implements NotificationsLocalDataSource {
  NotificationsLocalDataSourceImpl()
    : _items = List<NotificationEntity>.of(_seed);

  final List<NotificationEntity> _items;

  static const List<NotificationEntity> _seed = [
    NotificationEntity(
      id: '1',
      message:
          'Gilbert, you placed and order check your order history for full details',
    ),
    NotificationEntity(
      id: '2',
      message:
          'Gilbert, Thank you for shopping with us we have canceled order #24568.',
    ),
    NotificationEntity(
      id: '3',
      message:
          'Gilbert, your Order #24568 has been confirmed check your order history for full details',
    ),
  ];

  @override
  Future<List<NotificationEntity>> readAll() async =>
      List<NotificationEntity>.unmodifiable(_items);

  @override
  Future<void> deleteById(String id) async {
    _items.removeWhere((e) => e.id == id);
  }
}
