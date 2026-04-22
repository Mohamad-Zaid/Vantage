import 'package:equatable/equatable.dart';

class NotificationEntity extends Equatable {
  const NotificationEntity({required this.id, required this.message});

  final String id;
  final String message;

  @override
  List<Object?> get props => [id, message];
}
