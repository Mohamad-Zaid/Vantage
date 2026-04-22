import '../../domain/entities/notification_entity.dart';
import '../../domain/repositories/notifications_repository.dart';
import '../datasources/notifications_local_datasource.dart';

final class NotificationsRepositoryImpl implements NotificationsRepository {
  NotificationsRepositoryImpl(this._local);

  final NotificationsLocalDataSource _local;

  @override
  Future<List<NotificationEntity>> getNotifications() => _local.readAll();

  @override
  Future<void> deleteNotification(String id) => _local.deleteById(id);
}
