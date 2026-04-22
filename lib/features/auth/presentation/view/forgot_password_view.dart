import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vantage/core/theme/vantage_colors.dart';
import 'package:vantage/core/widgets/vantage_loading_indicator.dart';
import 'package:vantage/core/translations/locale_keys.g.dart';
import 'package:vantage/di/injection.dart';
import 'package:vantage/router/app_router.dart';

import '../cubit/password_reset_cubit.dart';
import '../cubit/password_reset_state.dart';

const double _kAuthHorizontalPadding = 24;
const double _kFieldHeight = 56;
const double _kFieldRadius = 4;
const double _kBackToTitleGap = 20;
const double _kTitleToFieldGap = 38;
const double _kFieldToButtonGap = 24;
const double _kBackButtonSize = 40;

@RoutePage()
class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  late final PasswordResetCubit _passwordResetCubit;

  @override
  void initState() {
    super.initState();
    _passwordResetCubit = sl<PasswordResetCubit>();
  }

  @override
  void dispose() {
    _passwordResetCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _ForgotPasswordView(cubit: _passwordResetCubit);
  }
}

class _ForgotPasswordView extends StatefulWidget {
  const _ForgotPasswordView({required this.cubit});

  final PasswordResetCubit cubit;

  @override
  State<_ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<_ForgotPasswordView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  PasswordResetCubit get _cubit => widget.cubit;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  InputDecoration _fieldDecoration(BuildContext context) {
    const radius = BorderRadius.all(Radius.circular(_kFieldRadius));
    return InputDecoration(
      hintText: LocaleKeys.auth_enterEmailAddress.tr(),
      hintStyle: TextStyle(
        color: Colors.white.withValues(alpha: 0.5),
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: -0.41,
      ),
      filled: true,
      fillColor: VantageColors.authBgDark2,
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
        borderSide: BorderSide(
          color: VantageColors.authFieldError,
          width: 1,
        ),
      ),
      focusedErrorBorder: const OutlineInputBorder(
        borderRadius: radius,
        borderSide: BorderSide(
          color: VantageColors.authFieldError,
          width: 1,
        ),
      ),
      errorStyle: const TextStyle(
        color: VantageColors.authFieldError,
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.25,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
    );
  }

  void _onContinue() {
    if (!_formKey.currentState!.validate()) return;
    _cubit.sendResetEmail(
      _emailController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: _kAuthHorizontalPadding,
            ),
            child: BlocConsumer<PasswordResetCubit, PasswordResetState>(
              bloc: _cubit,
              listener: (context, state) {
                if (state is PasswordResetFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message)),
                  );
                }
                if (state is PasswordResetSuccess) {
                  _cubit.consumeSuccess();
                  context.router.push(const PasswordResetEmailSentRoute());
                }
              },
              listenWhen: (previous, current) =>
                  current is PasswordResetFailure ||
                  current is PasswordResetSuccess,
              builder: (context, state) {
                final isSubmitting = state is PasswordResetSubmitting;

                return Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: Material(
                          color: VantageColors.authBgDark2,
                          shape: const CircleBorder(),
                          clipBehavior: Clip.antiAlias,
                          child: InkWell(
                            onTap: () => context.router.maybePop(),
                            customBorder: const CircleBorder(),
                            child: const SizedBox(
                              width: _kBackButtonSize,
                              height: _kBackButtonSize,
                              child: Icon(
                                Icons.arrow_back_ios_new_rounded,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: _kBackToTitleGap),
                      Text(
                        LocaleKeys.auth_forgotPassword.tr(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                          height: 1.08,
                          letterSpacing: -0.41,
                        ),
                      ),
                      const SizedBox(height: _kTitleToFieldGap),
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        keyboardAppearance: Brightness.dark,
                        enabled: !isSubmitting,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          letterSpacing: -0.41,
                        ),
                        cursorColor: VantageColors.authPrimaryPurple,
                        decoration: _fieldDecoration(context),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) {
                            return LocaleKeys.auth_validationEmailRequired.tr();
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: _kFieldToButtonGap),
                      SizedBox(
                        height: _kFieldHeight,
                        child: FilledButton(
                          onPressed: isSubmitting ? null : _onContinue,
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
                          child: isSubmitting
                              ? const VantageLoadingIndicator.onPrimary()
                              : Text(LocaleKeys.auth_continue.tr()),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
