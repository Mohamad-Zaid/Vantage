import 'package:equatable/equatable.dart';

import 'package:vantage/core/domain/failures/failure.dart';
import '../../domain/entities/notification_entity.dart';

sealed class NotificationsState extends Equatable {
  const NotificationsState();

  @override
  List<Object?> get props => [];
}

final class NotificationsInitial extends NotificationsState {
  const NotificationsInitial();
}

final class NotificationsLoading extends NotificationsState {
  const NotificationsLoading();
}

final class NotificationsLoaded extends NotificationsState {
  const NotificationsLoaded(this.items);

  final List<NotificationEntity> items;

  @override
  List<Object?> get props => [items];
}

final class NotificationsEmpty extends NotificationsState {
  const NotificationsEmpty();
}

final class NotificationsError extends NotificationsState {
  const NotificationsError(this.failure);

  final Failure failure;

  @override
  List<Object?> get props => [failure];
}
