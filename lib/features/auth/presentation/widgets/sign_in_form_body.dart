import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:vantage/core/theme/app_spacing.dart';
import 'package:vantage/core/translations/locale_keys.g.dart';
import 'package:vantage/core/widgets/exit_confirmation_dialog.dart';
import 'package:vantage/features/auth/presentation/cubit/sign_in_password_visibility_cubit.dart';
import 'package:vantage/features/auth/presentation/sign_in_page_dimens.dart';
import 'package:vantage/features/auth/presentation/widgets/sign_in_email_field.dart';
import 'package:vantage/features/auth/presentation/widgets/sign_in_footer_text.dart';
import 'package:vantage/features/auth/presentation/widgets/sign_in_google_button.dart';
import 'package:vantage/features/auth/presentation/widgets/sign_in_password_field.dart';
import 'package:vantage/features/auth/presentation/widgets/sign_in_submit_button.dart';
import 'package:vantage/generated/assets.dart';
import 'package:vantage/router/app_router.dart';

class SignInFormBody extends StatelessWidget {
  const SignInFormBody({
    super.key,
    required this.formKey,
    required this.authSubmitKey,
    required this.emailController,
    required this.passwordController,
    required this.passwordVisibilityCubit,
    required this.isLoading,
    required this.onContinue,
    required this.onGoogleSignIn,
  });

  final GlobalKey<FormState> formKey;
  final GlobalKey authSubmitKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final SignInPasswordVisibilityCubit passwordVisibilityCubit;
  final bool isLoading;
  final VoidCallback onContinue;
  final VoidCallback? onGoogleSignIn;

  Future<void> _handlePop(BuildContext context, bool didPop) async {
    if (didPop) return;
    final shouldExit = await showExitConfirmationDialog(context);
    if (!context.mounted || !shouldExit) return;
    await SystemNavigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light
          .copyWith(statusBarColor: Colors.transparent),
      child: PopScope<void>(
        canPop: false,
        onPopInvokedWithResult: (didPop, _) => _handlePop(context, didPop),
        child: Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: SignInPageDimens.authHorizontalPadding,
              ),
              child: Form(
                key: formKey,
                child: _SignInFormFields(
                  authSubmitKey: authSubmitKey,
                  emailController: emailController,
                  passwordController: passwordController,
                  passwordVisibilityCubit: passwordVisibilityCubit,
                  isLoading: isLoading,
                  onContinue: onContinue,
                  onGoogleSignIn: onGoogleSignIn,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Renders the ordered column of form widgets.
class _SignInFormFields extends StatelessWidget {
  const _SignInFormFields({
    required this.authSubmitKey,
    required this.emailController,
    required this.passwordController,
    required this.passwordVisibilityCubit,
    required this.isLoading,
    required this.onContinue,
    required this.onGoogleSignIn,
  });

  final GlobalKey authSubmitKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final SignInPasswordVisibilityCubit passwordVisibilityCubit;
  final bool isLoading;
  final VoidCallback onContinue;
  final VoidCallback? onGoogleSignIn;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Image.asset(Assets.imageAuthSignIn),
        const SizedBox(height: SignInPageDimens.titleToFormGap),
        const _SignInTitleText(),
        const SizedBox(height: SignInPageDimens.fieldGap),
        SignInEmailField(controller: emailController),
        const SizedBox(height: SignInPageDimens.fieldGap),
        SignInPasswordField(
          controller: passwordController,
          visibilityCubit: passwordVisibilityCubit,
        ),
        const SizedBox(height: SignInPageDimens.fieldGap),
        SignInSubmitButton(
          buttonKey: authSubmitKey,
          isLoading: isLoading,
          onContinue: onContinue,
        ),
        const SizedBox(height: SignInPageDimens.fieldGap),
        const _SignInForgotPasswordRow(),
        const SizedBox(height: SignInPageDimens.formToGoogleGap),
        SignInGoogleButton(onPressed: isLoading ? null : onGoogleSignIn),
        const SizedBox(height: SignInPageDimens.fieldGap),
        const SignInFooterText(),
        const SizedBox(height: AppSpacing.xl),
      ],
    );
  }
}

class _SignInTitleText extends StatelessWidget {
  const _SignInTitleText();

  @override
  Widget build(BuildContext context) {
    return Text(
      LocaleKeys.auth_signIn.tr(),
      style: const TextStyle(
        color: Colors.white,
        fontSize: SignInPageDimens.titleFontSize,
        fontWeight: FontWeight.w700,
        height: 1.08,
        letterSpacing: SignInPageDimens.titleLetterSpacing,
      ),
    );
  }
}

class _SignInForgotPasswordRow extends StatelessWidget {
  const _SignInForgotPasswordRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          LocaleKeys.auth_forgotPasswordQuestion.tr(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: SignInPageDimens.captionFontSize,
            fontWeight: FontWeight.w400,
            letterSpacing: SignInPageDimens.titleLetterSpacing,
          ),
        ),
        const SizedBox(width: AppSpacing.xxs),
        GestureDetector(
          onTap: () => context.router.push(const ForgotPasswordRoute()),
          child: Text(
            LocaleKeys.auth_reset.tr(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: SignInPageDimens.captionFontSize,
              fontWeight: FontWeight.w700,
              letterSpacing: SignInPageDimens.titleLetterSpacing,
            ),
          ),
        ),
      ],
    );
  }
}
