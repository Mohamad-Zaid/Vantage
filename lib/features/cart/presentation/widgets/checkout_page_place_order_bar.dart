import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:vantage/core/theme/app_spacing.dart';
import 'package:vantage/core/translations/locale_keys.g.dart';
import 'package:vantage/core/widgets/vantage_primary_button.dart';
import 'package:vantage/features/cart/presentation/cubit/checkout_state.dart';
import 'package:vantage/features/cart/presentation/widgets/cart_money.dart';

class CheckoutPagePlaceOrderBar extends StatelessWidget {
  const CheckoutPagePlaceOrderBar({
    super.key,
    required this.placeOrderButtonKey,
    required this.state,
    required this.hasAddress,
    required this.onBeforePlaceOrder,
    required this.onPlaceOrder,
  });

  final GlobalKey placeOrderButtonKey;
  final CheckoutReady state;
  final bool hasAddress;
  final VoidCallback onBeforePlaceOrder;
  final VoidCallback onPlaceOrder;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenHorizontal,
        0,
        AppSpacing.screenHorizontal,
        AppSpacing.lg,
      ),
      child: VantagePrimaryButton(
        key: placeOrderButtonKey,
        label: LocaleKeys.cart_placeOrder.tr(),
        isLoading: state.isPlacing,
        horizontalPadding: AppSpacing.buttonHorizontalPadding,
        onPressed: state.isPlacing
            ? null
            : () {
                if (!hasAddress) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(LocaleKeys.cart_needAddress.tr()),
                    ),
                  );
                  return;
                }
                onBeforePlaceOrder();
                onPlaceOrder();
              },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              LocaleKeys.cart_placeOrder.tr(),
              style: GoogleFonts.nunitoSans(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              CartMoney.usd(state.totals.total),
              style: GoogleFonts.gabarito(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
