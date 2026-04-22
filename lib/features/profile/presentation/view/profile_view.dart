import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:vantage/core/translations/locale_keys.g.dart';
import 'package:vantage/core/widgets/vantage_loading_indicator.dart';
import 'package:vantage/di/injection.dart';
import 'package:vantage/router/app_router.dart';

import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../auth/presentation/cubit/auth_state.dart';
import '../widgets/profile_authenticated_body.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late final AuthCubit _authCubit;

  @override
  void initState() {
    super.initState();
    _authCubit = sl<AuthCubit>();
  }

  @override
  void dispose() {
    _authCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _ProfileView(authCubit: _authCubit);
  }
}

class _ProfileView extends StatelessWidget {
  const _ProfileView({required this.authCubit});

  final AuthCubit authCubit;

  void _showSignOutLoadingDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return const PopScope<void>(
          canPop: false,
          child: Dialog(
            child: SizedBox.square(
              dimension: 140,
              child: Center(
                child: VantageLoadingIndicator(size: 52, strokeWidth: 2.5),
              ),
            ),
          ),
        );
      },
    );
  }

  void _hideSignOutLoadingDialog(BuildContext context) {
    final navigator = Navigator.of(context, rootNavigator: true);
    if (navigator.canPop()) {
      navigator.pop();
    }
  }

  Future<void> _onSignOut(BuildContext context, BuildContext navContext) async {
    _showSignOutLoadingDialog(context);
    try {
      await authCubit.signOut();
      if (context.mounted) {
        _hideSignOutLoadingDialog(context);
      }
      if (navContext.mounted) {
        navContext.router.replaceAll([const SignInRoute()]);
      }
    } catch (_) {
      if (context.mounted) {
        _hideSignOutLoadingDialog(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(LocaleKeys.common_error.tr())),
        );
      }
    }
  }

  Future<void> _onDeleteAccount(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(LocaleKeys.profile_deleteAccountConfirmTitle.tr()),
          content: Text(LocaleKeys.profile_deleteAccountConfirmMessage.tr()),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(LocaleKeys.common_cancel.tr()),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text(LocaleKeys.profile_deleteAccount.tr()),
            ),
          ],
        );
      },
    );
    if (confirmed == true && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(LocaleKeys.profile_deleteAccountComingSoon.tr())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final navContext = context;

    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<AuthCubit, AuthState>(
          bloc: authCubit,
          builder: (context, state) {
            return switch (state) {
              AuthInitial() => const Center(
                  child: VantageLoadingIndicator(),
                ),
              AuthLoading() => const Center(
                  child: VantageLoadingIndicator(),
                ),
              AuthAuthenticated(:final user) => ProfileAuthenticatedBody(
                  user: user,
                  onSignOutTap: () => _onSignOut(context, navContext),
                  onDeleteAccountTap: () => _onDeleteAccount(context),
                ),
              AuthUnauthenticated() => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      LocaleKeys.profile_notSignedIn.tr(),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                ),
              AuthError(:final message) => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      message,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            };
          },
        ),
      ),
    );
  }
}
