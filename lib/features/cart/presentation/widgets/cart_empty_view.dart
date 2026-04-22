import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:vantage/core/theme/vantage_colors.dart';
import 'package:vantage/core/translations/locale_keys.g.dart';
import 'package:vantage/core/widgets/vantage_primary_button.dart';
import 'package:vantage/generated/assets.dart';
import 'package:vantage/router/app_router.dart';

class CartEmptyView extends StatelessWidget {
  const CartEmptyView({super.key, this.needsSignIn = false});

  final bool needsSignIn;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textC =
        isDark ? Colors.white : VantageColors.homeCategoryLabelLight;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            Assets.imageCartEmpty,
            height: 180,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 24),
          Text(
            needsSignIn
                ? LocaleKeys.cart_signInToCart.tr()
                : LocaleKeys.cart_emptyTitle.tr(),
            textAlign: TextAlign.center,
            style: GoogleFonts.gabarito(
              color: textC,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 24),
          if (!needsSignIn)
            VantagePrimaryButton(
              label: LocaleKeys.cart_exploreCategories.tr(),
              onPressed: () =>
                  context.router.push(const ShopByCategoriesRoute()),
            ),
        ],
      ),
    );
  }
}
