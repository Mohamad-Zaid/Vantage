import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vantage/core/translations/locale_keys.g.dart';

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

  String _mapError(String msg) {
    if (msg.contains('invalid-email')) {
      return LocaleKeys.auth_errorInvalidEmail.tr();
    }
    if (msg.contains('network-request-failed')) {
      return LocaleKeys.auth_errorNetwork.tr();
    }
    return msg;
  }
}
