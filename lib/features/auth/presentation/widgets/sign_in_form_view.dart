import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:vantage/core/theme/vantage_colors.dart';
import 'package:vantage/core/translations/locale_keys.g.dart';
import 'package:vantage/core/widgets/exit_confirmation_dialog.dart';
import 'package:vantage/core/widgets/vantage_loading_indicator.dart';
import 'package:vantage/core/widgets/vantage_success_burst_overlay.dart';
import 'package:vantage/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:vantage/features/auth/presentation/cubit/auth_state.dart';
import 'package:vantage/features/auth/presentation/cubit/sign_in_password_visibility_cubit.dart';
import 'package:vantage/generated/assets.dart';
import 'package:vantage/router/app_router.dart';

import 'package:vantage/features/auth/presentation/sign_in_page_dimens.dart';

import 'sign_in_google_button.dart';

class SignInFormView extends StatefulWidget {
  const SignInFormView({
    super.key,
    required this.authCubit,
    required this.passwordVisibilityCubit,
  });

  final AuthCubit authCubit;
  final SignInPasswordVisibilityCubit passwordVisibilityCubit;

  @override
  State<SignInFormView> createState() => _SignInFormViewState();
}

class _SignInFormViewState extends State<SignInFormView> {
  final _formKey = GlobalKey<FormState>();
  final _authSubmitKey = GlobalKey();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onContinue() {
    if (!_formKey.currentState!.validate()) return;
    widget.authCubit.signInWithEmailAndPassword(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );
  }

  InputDecoration _fieldDecoration(
    BuildContext context, {
    required String hintText,
    Widget? suffixIcon,
  }) {
    const radius =
        BorderRadius.all(Radius.circular(SignInPageDimens.fieldRadius));
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(
        color: Colors.white.withValues(alpha: 0.5),
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: -0.41,
      ),
      filled: true,
      fillColor: VantageColors.authBgDark2,
      suffixIcon: suffixIcon,
      border: const OutlineInputBorder(
        borderRadius: radius,
        borderSide: BorderSide.none,
      ),
      enabledBorder: const OutlineInputBorder(
        borderRadius: radius,
        borderSide: BorderSide.none,
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: radius,
        borderSide: BorderSide.none,
      ),
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
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.25,
      ),
      errorMaxLines: 3,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
    );
  }

  // Overlay-local when the submit button’s RenderBox isn’t available yet.
  Offset _fallbackAuthSubmitAnchor(BuildContext context) {
    final s = MediaQuery.sizeOf(context);
    return Offset(s.width / 2, s.height - 120);
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: PopScope<void>(
        canPop: false,
        onPopInvokedWithResult: (didPop, _) async {
          if (didPop) return;
          final shouldExit = await showExitConfirmationDialog(context);
          if (!context.mounted || !shouldExit) return;
          await SystemNavigator.pop();
        },
        child: Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: SignInPageDimens.authHorizontalPadding,
              ),
              child: BlocConsumer<AuthCubit, AuthState>(
                bloc: widget.authCubit,
                listenWhen: (prev, current) {
                  if (current is AuthError) return true;
                  if (current is AuthAuthenticated) {
                    return prev is! AuthAuthenticated;
                  }
                  return false;
                },
                listener: (context, state) {
                  if (state is AuthError) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(state.message)));
                  }
                  if (state is AuthAuthenticated) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (!context.mounted) return;
                      final origin = VantageSuccessBurstOverlay
                          .originInOverlayForButton(
                        context,
                        buttonKey: _authSubmitKey,
                        fallback: _fallbackAuthSubmitAnchor(context),
                      );
                      if (!context.mounted) return;
                      VantageSuccessBurstOverlay.show(
                        context,
                        origin: origin,
                        onComplete: () {
                          if (context.mounted) {
                            context.router.replaceAll(
                              [const NavigationRoute()],
                            );
                          }
                        },
                      );
                    });
                  }
                },
                builder: (context, state) {
                  final isLoading = state is AuthLoading;

                  return Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Image.asset(Assets.imageAuthSignIn),
                        const SizedBox(height: SignInPageDimens.titleToFormGap),
                        Text(
                          LocaleKeys.auth_signIn.tr(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                            height: 1.08,
                            letterSpacing: -0.41,
                          ),
                        ),
                        const SizedBox(height: SignInPageDimens.fieldGap),
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          keyboardAppearance: Brightness.dark,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            letterSpacing: -0.41,
                          ),
                          cursorColor: VantageColors.authPrimaryPurple,
                          decoration: _fieldDecoration(
                            context,
                            hintText: LocaleKeys.auth_emailAddress.tr(),
                          ),
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) {
                              return LocaleKeys.auth_validationEmailRequired
                                  .tr();
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: SignInPageDimens.fieldGap),
                        BlocBuilder<SignInPasswordVisibilityCubit, bool>(
                          bloc: widget.passwordVisibilityCubit,
                          builder: (context, obscurePassword) {
                            return TextFormField(
                              controller: _passwordController,
                              obscureText: obscurePassword,
                              keyboardAppearance: Brightness.dark,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                letterSpacing: -0.41,
                              ),
                              cursorColor: VantageColors.authPrimaryPurple,
                              decoration: _fieldDecoration(
                                context,
                                hintText: LocaleKeys.auth_password.tr(),
                                suffixIcon: IconButton(
                                  onPressed:
                                      widget.passwordVisibilityCubit.toggle,
                                  icon: Icon(
                                    obscurePassword
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                    color: Colors.white.withValues(alpha: 0.7),
                                    size: 22,
                                  ),
                                ),
                              ),
                              validator: (v) {
                                if (v == null || v.isEmpty) {
                                  return LocaleKeys
                                      .auth_validationPasswordRequired
                                      .tr();
                                }
                                return null;
                              },
                            );
                          },
                        ),
                        const SizedBox(height: SignInPageDimens.fieldGap),
                        SizedBox(
                          height: SignInPageDimens.fieldHeight,
                          child: FilledButton(
                            key: _authSubmitKey,
                            onPressed: isLoading ? null : _onContinue,
                            style: FilledButton.styleFrom(
                              backgroundColor: VantageColors.authPrimaryPurple,
                              foregroundColor: Colors.white,
                              disabledBackgroundColor: VantageColors
                                  .authPrimaryPurple
                                  .withValues(alpha: 0.5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 48.6,
                                vertical: 11,
                              ),
                              textStyle: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                height: 1.67,
                                letterSpacing: -0.5,
                              ),
                            ),
                            child: isLoading
                                ? const VantageLoadingIndicator.onPrimary()
                                : Text(LocaleKeys.auth_continue.tr()),
                          ),
                        ),
                        const SizedBox(height: SignInPageDimens.fieldGap),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              LocaleKeys.auth_forgotPasswordQuestion.tr(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                letterSpacing: -0.41,
                              ),
                            ),
                            const SizedBox(width: 4),
                            GestureDetector(
                              onTap: () {
                                context.router.push(
                                  const ForgotPasswordRoute(),
                                );
                              },
                              child: Text(
                                LocaleKeys.auth_reset.tr(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: -0.41,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: SignInPageDimens.formToGoogleGap),
                        SignInGoogleButton(
                          onPressed: isLoading
                              ? null
                              : () => widget.authCubit.signInWithGoogle(),
                        ),
                        const SizedBox(height: SignInPageDimens.fieldGap),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              LocaleKeys.auth_noAccount.tr(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                letterSpacing: -0.41,
                              ),
                            ),
                            const SizedBox(width: 4),
                            GestureDetector(
                              onTap: () {
                                context.router.push(const CreateAccountRoute());
                              },
                              child: Text(
                                LocaleKeys.auth_createOne.tr(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: -0.41,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
