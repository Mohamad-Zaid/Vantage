import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/delete_notification_usecase.dart';
import '../../domain/usecases/get_notifications_usecase.dart';
import 'notifications_state.dart';

final class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit(this._getNotifications, this._deleteNotification)
    : super(const NotificationsInitial()) {
    unawaited(load());
  }

  final GetNotificationsUseCase _getNotifications;
  final DeleteNotificationUseCase _deleteNotification;

  Future<void> load() async {
    emit(const NotificationsLoading());
    try {
      final list = await _getNotifications();
      if (isClosed) return;
      if (list.isEmpty) {
        emit(const NotificationsEmpty());
      } else {
        emit(NotificationsLoaded(list));
      }
    } catch (e) {
      if (isClosed) return;
      emit(NotificationsError(e.toString()));
    }
  }

  Future<void> removeNotification(String id) async {
    try {
      await _deleteNotification(id);
      if (isClosed) return;
      final list = await _getNotifications();
      if (isClosed) return;
      if (list.isEmpty) {
        emit(const NotificationsEmpty());
      } else {
        emit(NotificationsLoaded(list));
      }
    } catch (e, st) {
      debugPrint('NotificationsCubit.removeNotification: $e\n$st');
      if (isClosed) return;
      emit(NotificationsError(e.toString()));
    }
  }
}
