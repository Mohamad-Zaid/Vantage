import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:vantage/core/theme/app_spacing.dart';
import 'package:vantage/core/theme/vantage_colors.dart';
import 'package:vantage/core/translations/locale_keys.g.dart';
import 'package:vantage/core/widgets/vantage_primary_button.dart';
import 'package:vantage/generated/assets.dart';
import 'package:vantage/router/app_router.dart';

@RoutePage()
class OrderPlacedPage extends StatelessWidget {
  const OrderPlacedPage({super.key, required this.orderId});

  final String orderId;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final titleC =
        isDark ? Colors.white : VantageColors.homeCategoryLabelLight;
    final subC = isDark
        ? Colors.white70
        : VantageColors.profileTextSecondaryLight;
    final topBg = VantageColors.authPrimaryPurple.withValues(alpha: 0.35);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: ColoredBox(
                color: topBg,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.screenHorizontal),
                    child: Image.asset(
                      Assets.imageCartOrderPlaced,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.xxl,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      LocaleKeys.cart_orderPlaced.tr(),
                      textAlign: TextAlign.center,
                      style: GoogleFonts.gabarito(
                        color: titleC,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      LocaleKeys.cart_orderPlacedSub.tr(),
                      textAlign: TextAlign.center,
                      style: GoogleFonts.nunitoSans(
                        color: subC,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxl),
                    VantagePrimaryButton(
                      label: LocaleKeys.cart_seeOrderDetails.tr(),
                      onPressed: () {
                        // Shell under detail so back pops to home tab, not checkout/cart.
                        context.router.replaceAll([
                          const NavigationRoute(),
                          OrderDetailRoute(orderId: orderId),
                        ]);
                      },
                    ),
                    const SizedBox(height: AppSpacing.md),
                    TextButton(
                      onPressed: () =>
                          context.router.replaceAll([const NavigationRoute()]),
                      child: Text(
                        LocaleKeys.common_exit.tr(),
                        style: GoogleFonts.nunitoSans(
                          color: VantageColors.authPrimaryPurple,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
