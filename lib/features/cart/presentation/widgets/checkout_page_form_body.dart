import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:vantage/core/theme/app_spacing.dart';
import 'package:vantage/core/translations/locale_keys.g.dart';
import 'package:vantage/features/cart/presentation/cubit/checkout_cubit.dart';
import 'package:vantage/features/cart/presentation/cubit/checkout_state.dart';
import 'package:vantage/features/cart/presentation/widgets/cart_address_picker_sheet.dart';
import 'package:vantage/features/cart/presentation/widgets/cart_summary_block.dart';
import 'package:vantage/features/cart/presentation/widgets/checkout_tappable_field.dart';
import 'package:vantage/router/app_router.dart';

class CheckoutPageFormBody extends StatelessWidget {
  const CheckoutPageFormBody({
    super.key,
    required this.titleColor,
    required this.state,
    required this.cubit,
    required this.hasAddress,
  });

  final Color titleColor;
  final CheckoutReady state;
  final CheckoutCubit cubit;
  final bool hasAddress;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenHorizontal,
        0,
        AppSpacing.screenHorizontal,
        AppSpacing.md,
      ),
      children: [
        CheckoutTappableField(
          label: LocaleKeys.cart_shippingAddress.tr(),
          valueText: hasAddress
              ? (state.selectedAddress?.singleLinePreview ?? '')
              : LocaleKeys.cart_addShippingAddress.tr(),
          onTap: () {
            if (state.addresses.isEmpty) {
              context.router.push(AddressFormRoute());
              return;
            }
            showCartAddressPickerSheet(
              context,
              addresses: state.addresses,
              currentlySelectedId: state.selectedAddressId,
              onPick: cubit.selectAddress,
            );
          },
        ),
        const SizedBox(height: AppSpacing.md),
        CheckoutTappableField(
          label: LocaleKeys.cart_paymentMethod.tr(),
          valueText: state.paymentLabel,
          onTap: cubit.onPaymentSectionTap,
          trailing: const Icon(Icons.payment, size: 22),
        ),
        const SizedBox(height: AppSpacing.xl),
        Text(
          LocaleKeys.cart_total.tr(),
          style: GoogleFonts.gabarito(
            color: titleColor,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        CartSummaryBlock(totals: state.totals),
      ],
    );
  }
}
