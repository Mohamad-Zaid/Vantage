import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:vantage/core/theme/app_spacing.dart';
import 'package:vantage/core/theme/vantage_colors.dart';
import 'package:vantage/core/translations/locale_keys.g.dart';
import 'package:vantage/features/auth/presentation/cubit/sign_in_password_visibility_cubit.dart';
import 'package:vantage/features/auth/presentation/sign_in_page_dimens.dart';

class SignInPasswordField extends StatelessWidget {
  const SignInPasswordField({
    super.key,
    required this.controller,
    required this.visibilityCubit,
  });

  final TextEditingController controller;
  final SignInPasswordVisibilityCubit visibilityCubit;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignInPasswordVisibilityCubit, bool>(
      bloc: visibilityCubit,
      builder: (context, obscureText) => TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardAppearance: Brightness.dark,
        style: const TextStyle(
          color: Colors.white,
          fontSize: SignInPageDimens.subtitleFontSize,
          letterSpacing: SignInPageDimens.titleLetterSpacing,
        ),
        cursorColor: VantageColors.authPrimaryPurple,
        decoration: _decoration(obscureText, visibilityCubit),
        validator: _validate,
      ),
    );
  }

  static InputDecoration _decoration(
    bool obscureText,
    SignInPasswordVisibilityCubit cubit,
  ) {
    const radius =
        BorderRadius.all(Radius.circular(SignInPageDimens.fieldRadius));
    return InputDecoration(
      hintText: LocaleKeys.auth_password.tr(),
      hintStyle: TextStyle(
        color: Colors.white.withValues(alpha: 0.5),
        fontSize: SignInPageDimens.subtitleFontSize,
        fontWeight: FontWeight.w400,
        letterSpacing: SignInPageDimens.titleLetterSpacing,
      ),
      filled: true,
      fillColor: VantageColors.authBgDark2,
      suffixIcon: IconButton(
        onPressed: cubit.toggle,
        icon: Icon(
          obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined,
          color: Colors.white.withValues(alpha: 0.7),
          size: 22,
        ),
      ),
      border: const OutlineInputBorder(
          borderRadius: radius, borderSide: BorderSide.none),
      enabledBorder: const OutlineInputBorder(
          borderRadius: radius, borderSide: BorderSide.none),
      focusedBorder: const OutlineInputBorder(
          borderRadius: radius, borderSide: BorderSide.none),
      errorBorder: const OutlineInputBorder(
        borderRadius: radius,
        borderSide: BorderSide(color: VantageColors.authFieldError, width: 1),
      ),
      focusedErrorBorder: const OutlineInputBorder(
        borderRadius: radius,
        borderSide: BorderSide(color: VantageColors.authFieldError, width: 1),
      ),
      errorStyle: const TextStyle(
        color: VantageColors.authFieldError,
        fontSize: SignInPageDimens.captionFontSize,
        fontWeight: FontWeight.w400,
        height: 1.25,
      ),
      errorMaxLines: 3,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.inset18,
      ),
    );
  }

  static String? _validate(String? value) {
    if (value == null || value.isEmpty) {
      return LocaleKeys.auth_validationPasswordRequired.tr();
    }
    return null;
  }
}
