import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vantage/core/theme/app_spacing.dart';
import 'package:vantage/core/theme/vantage_colors.dart';
import 'package:vantage/core/widgets/vantage_loading_indicator.dart';
import 'package:vantage/core/widgets/vantage_success_burst_overlay.dart';
import 'package:vantage/core/translations/locale_keys.g.dart';
import 'package:vantage/di/injection.dart';
import 'package:vantage/generated/assets.dart';
import 'package:vantage/router/app_router.dart';

import '../auth_error_ext.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';

const double _kAuthHorizontalPadding = 24;
const double _kFieldHeight = 56;
const double _kFieldRadius = 4;
const double _kFieldGap = 16;
const double _kBackToImageGap = 16;
const double _kImageToTitleGap = 32;
const double _kTitleToFormGap = 32;
const double _kFieldsToButtonGap = 40;

const double _kBackButtonSize = 40;

@RoutePage()
class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({super.key});

  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  late final AuthCubit _authCubit;
  late final _PasswordVisibilityCubit _passwordVisibilityCubit;

  final _formKey = GlobalKey<FormState>();
  final _authSubmitKey = GlobalKey();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _authCubit = sl<AuthCubit>();
    _passwordVisibilityCubit = _PasswordVisibilityCubit();
  }

  @override
  void dispose() {
    _authCubit.close();
    _passwordVisibilityCubit.close();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onContinue() {
    if (!_formKey.currentState!.validate()) return;
    _authCubit.signUpWithEmailAndPassword(
      email: _emailController.text.trim(),
      password: _passwordController.text,
      firstName: _firstNameController.text.trim().isEmpty
          ? null
          : _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim().isEmpty
          ? null
          : _lastNameController.text.trim(),
    );
  }

  InputDecoration _fieldDecoration(
    BuildContext context, {
    required String hintText,
    Widget? suffixIcon,
  }) {
    const radius = BorderRadius.all(Radius.circular(_kFieldRadius));
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
      errorMaxLines: 3,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.inset18,
      ),
    );
  }

  // Overlay-local when the submit button's RenderBox isn't available yet.
  Offset _fallbackAuthSubmitAnchor(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);
    return Offset(
      screenSize.width / 2,
      screenSize.height - AppSpacing.overlayAnchorBottomOffset,
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
            child: BlocConsumer<AuthCubit, AuthState>(
              bloc: _authCubit,
              listenWhen: (prev, current) {
                if (current is AuthError) return true;
                if (current is AuthAuthenticated) {
                  return prev is! AuthAuthenticated;
                }
                return false;
              },
              listener: (context, state) {
                if (state is AuthError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.code.toLocalizedMessage())),
                  );
                }
                if (state is AuthAuthenticated) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (!context.mounted) return;
                    final origin =
                        VantageSuccessBurstOverlay.originInOverlayForButton(
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
                          context.router.replaceAll([const NavigationRoute()]);
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
                      const SizedBox(height: _kBackToImageGap),
                      Image.asset(Assets.imageAuthSignUp),
                      const SizedBox(height: _kImageToTitleGap),
                      Text(
                        LocaleKeys.auth_createAccount.tr(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                          height: 1.08,
                          letterSpacing: -0.41,
                        ),
                      ),
                      const SizedBox(height: _kTitleToFormGap),
                      TextFormField(
                        controller: _firstNameController,
                        textCapitalization: TextCapitalization.words,
                        keyboardAppearance: Brightness.dark,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          letterSpacing: -0.41,
                        ),
                        cursorColor: VantageColors.authPrimaryPurple,
                        decoration: _fieldDecoration(
                          context,
                          hintText: LocaleKeys.auth_firstname.tr(),
                        ),
                      ),
                      const SizedBox(height: _kFieldGap),
                      TextFormField(
                        controller: _lastNameController,
                        textCapitalization: TextCapitalization.words,
                        keyboardAppearance: Brightness.dark,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          letterSpacing: -0.41,
                        ),
                        cursorColor: VantageColors.authPrimaryPurple,
                        decoration: _fieldDecoration(
                          context,
                          hintText: LocaleKeys.auth_lastname.tr(),
                        ),
                      ),
                      const SizedBox(height: _kFieldGap),
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
                            return LocaleKeys.auth_validationEmailRequired.tr();
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: _kFieldGap),
                      BlocBuilder<_PasswordVisibilityCubit, bool>(
                        bloc: _passwordVisibilityCubit,
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
                                onPressed: _passwordVisibilityCubit.toggle,
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
                              if (v.length < 6) {
                                return LocaleKeys
                                    .auth_validationPasswordMinLength
                                    .tr();
                              }
                              return null;
                            },
                          );
                        },
                      ),
                      const SizedBox(height: _kFieldsToButtonGap),
                      SizedBox(
                        height: _kFieldHeight,
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
                      const SizedBox(height: AppSpacing.xl),
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

final class _PasswordVisibilityCubit extends Cubit<bool> {
  _PasswordVisibilityCubit() : super(true);

  void toggle() => emit(!state);
}
