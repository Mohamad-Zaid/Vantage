import '../repositories/notifications_repository.dart';

class DeleteNotificationUseCase {
  const DeleteNotificationUseCase(this._repository);

  final NotificationsRepository _repository;

  Future<void> call(String id) => _repository.deleteNotification(id);
}
