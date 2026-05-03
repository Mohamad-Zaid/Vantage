import 'package:equatable/equatable.dart';

import '../../domain/entities/auth_error_code.dart';

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
  const PasswordResetFailure(this.code);

  final AuthErrorCode code;

  @override
  List<Object?> get props => [code];
}

final class PasswordResetSuccess extends PasswordResetState {
  const PasswordResetSuccess();
}
