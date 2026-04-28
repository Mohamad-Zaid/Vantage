import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:vantage/core/theme/app_spacing.dart';
import 'package:vantage/core/theme/vantage_colors.dart';
import 'package:vantage/core/translations/locale_keys.g.dart';
import 'package:vantage/generated/assets.dart';
import 'package:vantage/router/app_router.dart';

class OrdersEmptyContent extends StatelessWidget {
  const OrdersEmptyContent({super.key, required this.titleColor});

  final Color titleColor;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      Assets.imageOrdersEmpty,
                      width: 100,
                      height: 100,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => Icon(
                        Icons.shopping_cart_outlined,
                        size: 80,
                        color: titleColor.withValues(alpha: 0.45),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    Text(
                      LocaleKeys.orders_emptyTitle.tr(),
                      textAlign: TextAlign.center,
                      style: GoogleFonts.nunitoSans(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                        color: titleColor,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: VantageColors.authPrimaryPurple,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 16,
                        ),
                        shape: const StadiumBorder(),
                        elevation: 0,
                      ),
                      onPressed: () =>
                          context.router.push(const ShopByCategoriesRoute()),
                      child: Text(
                        LocaleKeys.orders_exploreCategories.tr(),
                        style: GoogleFonts.nunitoSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
