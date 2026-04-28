import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:vantage/core/translations/locale_keys.g.dart';
import 'package:vantage/core/widgets/app_settings_scope.dart';
import 'package:vantage/router/app_router.dart';

import '../../../auth/domain/entities/user_entity.dart';
import 'profile_avatar.dart';
import 'profile_delete_account_button.dart';
import 'profile_info_card.dart';
import 'profile_labeled_action_row.dart';
import 'profile_menu_row.dart';
import 'profile_settings_bottom_sheets.dart';
import 'profile_sign_out_button.dart';
import 'package:vantage/core/theme/app_spacing.dart';

class ProfileAuthenticatedBody extends StatelessWidget {
  const ProfileAuthenticatedBody({
    super.key,
    required this.user,
    required this.onSignOutTap,
    required this.onDeleteAccountTap,
  });

  final UserEntity user;
  final VoidCallback onSignOutTap;
  final VoidCallback onDeleteAccountTap;

  @override
  Widget build(BuildContext context) {
    final router = context.router;
    final appSettings = AppSettingsScope.of(context);
    final email = user.email;
    final displayName = (user.displayName?.isNotEmpty ?? false)
        ? user.displayName!
        : (email.isNotEmpty ? email.split('@').first : 'User');

    void showSnack(String message) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }

    final menuRows = <Widget>[
      ProfileMenuRow(
        label: LocaleKeys.profile_menuWishlist.tr(),
        onTap: () => router.push(const WishlistListDetailRoute()),
      ),
      ProfileMenuRow(
        label: LocaleKeys.profile_menuAddress.tr(),
        onTap: () => router.push(const AddressListRoute()),
      ),
      ProfileMenuRow(
        label: LocaleKeys.profile_menuPayment.tr(),
        onTap: () => showSnack(LocaleKeys.profile_paymentCardsComingSoon.tr()),
      ),
      ProfileMenuRow(
        label: LocaleKeys.profile_helpAndSupport.tr(),
        onTap: () => router.push(const HelpSupportRoute()),
      ),
    ];

    final preferenceRows = <Widget>[
      ProfileLabeledActionRow(
        title: LocaleKeys.settings_theme.tr(),
        actionLabel: LocaleKeys.profile_change.tr(),
        onAction: () => showProfileThemeSheet(context, appSettings),
      ),
      ProfileLabeledActionRow(
        title: LocaleKeys.settings_translation.tr(),
        actionLabel: LocaleKeys.profile_change.tr(),
        onAction: () => showProfileLanguageSheet(context),
      ),
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const SizedBox(height: AppSpacing.xl),
          ProfileAvatar(photoUrl: user.photoUrl),
          const SizedBox(height: AppSpacing.xxl),
          ProfileInfoCard(
            name: displayName,
            email: email,
            phone: user.phone,
            onEdit: () => router.push(const EditProfileRoute()),
          ),
          const SizedBox(height: AppSpacing.xl),
          for (var i = 0; i < preferenceRows.length; i++) ...[
            if (i > 0) const SizedBox(height: AppSpacing.sm),
            preferenceRows[i],
          ],
          const SizedBox(height: AppSpacing.sm),
          for (var i = 0; i < menuRows.length; i++) ...[
            if (i > 0) const SizedBox(height: AppSpacing.sm),
            menuRows[i],
          ],
          const SizedBox(height: AppSpacing.xxl),
          ProfileSignOutButton(onTap: onSignOutTap),
          ProfileDeleteAccountButton(onTap: onDeleteAccountTap),
          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }
}
