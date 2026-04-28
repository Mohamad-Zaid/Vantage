import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:vantage/core/theme/app_spacing.dart';
import 'package:vantage/core/theme/vantage_colors.dart';
import 'package:vantage/core/translations/locale_keys.g.dart';
import 'package:vantage/core/widgets/vantage_circle_back_button.dart';
import 'package:vantage/features/addresses/presentation/widgets/address_list_content.dart';
import 'package:vantage/router/app_router.dart';

@RoutePage()
class AddressListPage extends StatelessWidget {
  const AddressListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const _AddressPageHeader(),
            const SizedBox(height: AppSpacing.xl),
            const Expanded(child: AddressListContent()),
            const _AddressPageFooter(),
          ],
        ),
      ),
    );
  }
}

class _AddressPageHeader extends StatelessWidget {
  const _AddressPageHeader();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final titleColor =
        isDark ? Colors.white : VantageColors.homeCategoryLabelLight;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenHorizontal,
        AppSpacing.sm,
        AppSpacing.screenHorizontal,
        0,
      ),
      child: Row(
        children: [
          VantageCircleBackButton(onPressed: () => context.router.maybePop()),
          Expanded(
            child: Text(
              LocaleKeys.address_title.tr(),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.gabarito(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: titleColor,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.toolbarIconSlot),
        ],
      ),
    );
  }
}

class _AddressPageFooter extends StatelessWidget {
  const _AddressPageFooter();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenHorizontal,
        AppSpacing.sm,
        AppSpacing.screenHorizontal,
        AppSpacing.lg,
      ),
      child: SizedBox(
        width: double.infinity,
        child: FilledButton(
          onPressed: () => context.router.push(AddressFormRoute()),
          style: FilledButton.styleFrom(
            backgroundColor: VantageColors.authPrimaryPurple,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
            shape: const StadiumBorder(),
            elevation: 0,
          ),
          child: Text(
            LocaleKeys.address_addNew.tr(),
            style: GoogleFonts.nunitoSans(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
