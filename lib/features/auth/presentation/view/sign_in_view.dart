import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vantage/di/injection.dart';
import 'package:vantage/router/app_router.dart';

import 'package:vantage/core/widgets/exit_confirmation_dialog.dart';
import 'package:vantage/core/widgets/home_cold_start_skeleton.dart';
import 'package:vantage/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:vantage/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:vantage/features/auth/presentation/cubit/sign_in_cold_start_cubit.dart';
import 'package:vantage/features/auth/presentation/cubit/sign_in_password_visibility_cubit.dart';
import 'package:vantage/features/auth/presentation/widgets/sign_in_cold_start_skeleton.dart';
import 'package:vantage/features/auth/presentation/widgets/sign_in_form_view.dart';

@RoutePage()
class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  late final AuthCubit _authCubit;
  late final SignInPasswordVisibilityCubit _passwordVisibilityCubit;
  late final SignInColdStartCubit _coldStartCubit;
  late final bool _coldStartUseHomeShimmer;

  @override
  void initState() {
    super.initState();
    _authCubit = sl<AuthCubit>();
    _passwordVisibilityCubit = SignInPasswordVisibilityCubit();
    _coldStartCubit = SignInColdStartCubit();
    _coldStartUseHomeShimmer = sl<GetCurrentUserUseCase>().hasSessionHint;
    unawaited(_resolveExistingSession());
  }

  Future<void> _resolveExistingSession() async {
    try {
      final user = await sl<GetCurrentUserUseCase>()();
      if (!mounted) return;
      if (user != null) {
        context.router.replaceAll([const NavigationRoute()]);
        return;
      }
    } catch (_) {
      // getCurrentUser can throw; still show the sign-in form.
    }
    if (mounted) {
      _coldStartCubit.markReady();
    }
  }

  @override
  void dispose() {
    _authCubit.close();
    _passwordVisibilityCubit.close();
    _coldStartCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SignInColdStartCubit>.value(
      value: _coldStartCubit,
      child: BlocBuilder<SignInColdStartCubit, SignInColdStartPhase>(
        builder: (context, phase) {
          if (phase == SignInColdStartPhase.checking) {
            final isDark = Theme.of(context).brightness == Brightness.dark;
            return AnnotatedRegion<SystemUiOverlayStyle>(
              value: (isDark
                      ? SystemUiOverlayStyle.light
                      : SystemUiOverlayStyle.dark)
                  .copyWith(statusBarColor: Colors.transparent),
              child: PopScope<void>(
                canPop: false,
                onPopInvokedWithResult: (didPop, _) async {
                  if (didPop) return;
                  final shouldExit = await showExitConfirmationDialog(context);
                  if (!context.mounted || !shouldExit) return;
                  await SystemNavigator.pop();
                },
                child: _coldStartUseHomeShimmer
                    ? const HomeColdStartSkeleton()
                    : const SignInColdStartSkeleton(),
              ),
            );
          }
          return SignInFormView(
            authCubit: _authCubit,
            passwordVisibilityCubit: _passwordVisibilityCubit,
          );
        },
      ),
    );
  }
}
