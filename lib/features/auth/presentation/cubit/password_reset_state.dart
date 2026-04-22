import 'package:equatable/equatable.dart';

sealed class PasswordResetState extends Equatable {
  const PasswordResetState();

  @override
  List<Object?> get props => [];
}

final class PasswordResetInitial extends PasswordResetState {
  const PasswordResetInitial();
}

final class PasswordResetSubmitting extends PasswordResetState {
  const PasswordResetSubmitting();
}

final class PasswordResetFailure extends PasswordResetState {
  const PasswordResetFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

final class PasswordResetSuccess extends PasswordResetState {
  const PasswordResetSuccess();
}
