import 'package:easy_localization/easy_localization.dart';
import 'package:vantage/core/translations/locale_keys.g.dart';
import 'package:vantage/features/auth/domain/entities/auth_error_code.dart';

extension AuthErrorCodeX on AuthErrorCode {
  String toLocalizedMessage() {
    return switch (this) {
      AuthErrorCode.invalidCredentials =>
        LocaleKeys.auth_errorInvalidCredentials.tr(),
      AuthErrorCode.emailInUse => LocaleKeys.auth_errorEmailInUse.tr(),
      AuthErrorCode.weakPassword => LocaleKeys.auth_errorWeakPassword.tr(),
      AuthErrorCode.invalidEmail => LocaleKeys.auth_errorInvalidEmail.tr(),
      AuthErrorCode.network => LocaleKeys.auth_errorNetwork.tr(),
      AuthErrorCode.unknown => '',
    };
  }
}
