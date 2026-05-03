import 'package:equatable/equatable.dart';

sealed class Failure extends Equatable {
  const Failure();

  @override
  List<Object?> get props => [];
}

final class NetworkFailure extends Failure {
  const NetworkFailure();
}

final class NotFoundFailure extends Failure {
  const NotFoundFailure();
}

final class UnknownFailure extends Failure {
  const UnknownFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
