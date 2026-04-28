import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import 'package:vantage/features/cart/presentation/cubit/checkout_cubit.dart';
import 'package:vantage/features/cart/presentation/cubit/checkout_state.dart';
import 'package:vantage/features/cart/presentation/widgets/checkout_page_form_body.dart';
import 'package:vantage/features/cart/presentation/widgets/checkout_page_place_order_bar.dart';
import 'package:vantage/features/cart/presentation/widgets/checkout_page_title_bar.dart';

class CheckoutPageBody extends StatelessWidget {
  const CheckoutPageBody({
    super.key,
    required this.titleColor,
    required this.state,
    required this.cubit,
    required this.placeOrderButtonKey,
    required this.onBeforePlaceOrder,
  });

  final Color titleColor;
  final CheckoutReady state;
  final CheckoutCubit cubit;
  final GlobalKey placeOrderButtonKey;
  final VoidCallback onBeforePlaceOrder;

  @override
  Widget build(BuildContext context) {
    final hasAddress = state.hasAddress;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            CheckoutPageTitleBar(
              titleColor: titleColor,
              onBack: () => context.router.maybePop(),
            ),
            Expanded(
              child: CheckoutPageFormBody(
                titleColor: titleColor,
                state: state,
                cubit: cubit,
                hasAddress: hasAddress,
              ),
            ),
            CheckoutPagePlaceOrderBar(
              placeOrderButtonKey: placeOrderButtonKey,
              state: state,
              hasAddress: hasAddress,
              onBeforePlaceOrder: onBeforePlaceOrder,
              onPlaceOrder: cubit.submitOrder,
            ),
          ],
        ),
      ),
    );
  }
}
