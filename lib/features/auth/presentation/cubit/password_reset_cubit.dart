import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/auth_error_code.dart';
import '../../domain/usecases/send_password_reset_email_usecase.dart';
import 'password_reset_state.dart';

final class PasswordResetCubit extends Cubit<PasswordResetState> {
  PasswordResetCubit(this._sendPasswordResetEmail)
      : super(const PasswordResetInitial());

  final SendPasswordResetEmailUseCase _sendPasswordResetEmail;

  Future<void> sendResetEmail(String email) async {
    emit(const PasswordResetSubmitting());
    try {
      await _sendPasswordResetEmail(email: email);
      if (!isClosed) emit(const PasswordResetSuccess());
    } catch (e) {
      if (isClosed) return;
      emit(PasswordResetFailure(_mapError(e.toString())));
      emit(const PasswordResetInitial());
    }
  }

  void consumeSuccess() {
    if (state is PasswordResetSuccess) {
      emit(const PasswordResetInitial());
    }
  }

  AuthErrorCode _mapError(String msg) {
    if (msg.contains('invalid-email')) return AuthErrorCode.invalidEmail;
    if (msg.contains('network-request-failed')) return AuthErrorCode.network;
    return AuthErrorCode.unknown;
  }
}
