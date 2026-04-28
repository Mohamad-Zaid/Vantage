import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vantage/core/theme/app_spacing.dart';
import 'package:vantage/core/widgets/vantage_success_burst_overlay.dart';
import 'package:vantage/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:vantage/features/auth/presentation/cubit/auth_state.dart';
import 'package:vantage/features/auth/presentation/cubit/sign_in_password_visibility_cubit.dart';
import 'package:vantage/features/auth/presentation/widgets/sign_in_form_body.dart';
import 'package:vantage/router/app_router.dart';

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

  bool _listenWhen(AuthState prev, AuthState current) {
    if (current is AuthError) return true;
    if (current is AuthAuthenticated) return prev is! AuthAuthenticated;
    return false;
  }

  Offset _fallbackAnchor(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Offset(
      size.width / 2,
      size.height - AppSpacing.overlayAnchorBottomOffset,
    );
  }

  void _onAuthStateChanged(BuildContext context, AuthState state) {
    if (state is AuthError) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(state.message)));
      return;
    }
    if (state is AuthAuthenticated) {
      _navigateOnAuthenticated(context);
    }
  }

  void _navigateOnAuthenticated(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!context.mounted) return;
      final origin = VantageSuccessBurstOverlay.originInOverlayForButton(
        context,
        buttonKey: _authSubmitKey,
        fallback: _fallbackAnchor(context),
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

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      bloc: widget.authCubit,
      listenWhen: _listenWhen,
      listener: _onAuthStateChanged,
      builder: (context, state) => SignInFormBody(
        formKey: _formKey,
        authSubmitKey: _authSubmitKey,
        emailController: _emailController,
        passwordController: _passwordController,
        passwordVisibilityCubit: widget.passwordVisibilityCubit,
        isLoading: state is AuthLoading,
        onContinue: _onContinue,
        onGoogleSignIn: () => widget.authCubit.signInWithGoogle(),
      ),
    );
  }
}
