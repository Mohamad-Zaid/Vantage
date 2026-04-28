import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:vantage/core/theme/app_spacing.dart';
import 'package:vantage/core/theme/vantage_colors.dart';
import 'package:vantage/core/translations/locale_keys.g.dart';
import 'package:vantage/features/cart/domain/entities/cart_totals.dart';
import 'package:vantage/features/cart/presentation/widgets/cart_money.dart';

class CartSummaryBlock extends StatelessWidget {
  const CartSummaryBlock({super.key, required this.totals});

  final CartTotals totals;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final titleC =
        isDark ? Colors.white : VantageColors.homeCategoryLabelLight;
    final subC = isDark
        ? Colors.white.withValues(alpha: 0.55)
        : VantageColors.profileTextSecondaryLight;
    final purple = VantageColors.authPrimaryPurple;

    return Column(
      children: [
        _Row(
          label: LocaleKeys.cart_subtotal.tr(),
          value: CartMoney.usd(totals.subtotal),
          labelColor: subC,
          valueColor: titleC,
        ),
        const SizedBox(height: AppSpacing.xs),
        _Row(
          label: LocaleKeys.cart_shipping.tr(),
          value: CartMoney.usd(totals.shipping),
          labelColor: subC,
          valueColor: titleC,
        ),
        const SizedBox(height: AppSpacing.xs),
        _Row(
          label: LocaleKeys.cart_tax.tr(),
          value: CartMoney.usd(totals.tax),
          labelColor: subC,
          valueColor: titleC,
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Divider(height: 1),
        ),
        _Row(
          label: LocaleKeys.cart_total.tr(),
          value: CartMoney.usd(totals.total),
          labelColor: titleC,
          valueColor: purple,
          valueBold: true,
        ),
      ],
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({
    required this.label,
    required this.value,
    required this.labelColor,
    required this.valueColor,
    this.valueBold = false,
  });

  final String label;
  final String value;
  final Color labelColor;
  final Color valueColor;
  final bool valueBold;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.nunitoSans(
            color: labelColor,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.gabarito(
            color: valueColor,
            fontSize: valueBold ? 16 : 14,
            fontWeight: valueBold ? FontWeight.w800 : FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
