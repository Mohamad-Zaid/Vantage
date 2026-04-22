import 'dart:async' show unawaited;

import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:vantage/core/theme/vantage_colors.dart';
import 'package:vantage/core/translations/locale_keys.g.dart';
import 'package:vantage/core/widgets/vantage_circle_back_button.dart';
import 'package:vantage/core/widgets/vantage_loading_indicator.dart';
import 'package:vantage/core/widgets/vantage_primary_button.dart';
import 'package:vantage/core/widgets/vantage_success_burst_overlay.dart';
import 'package:vantage/di/injection.dart';
import 'package:vantage/features/addresses/domain/usecases/watch_user_addresses_usecase.dart';
import 'package:vantage/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:vantage/features/cart/domain/usecases/place_order_usecase.dart';
import 'package:vantage/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:vantage/features/cart/presentation/cubit/cart_state.dart' show CartLoaded;
import 'package:vantage/features/cart/presentation/cubit/checkout_cubit.dart';
import 'package:vantage/features/cart/presentation/cubit/checkout_page_host_cubit.dart';
import 'package:vantage/features/cart/presentation/cubit/checkout_state.dart';
import 'package:vantage/features/cart/presentation/widgets/cart_address_picker_sheet.dart';
import 'package:vantage/features/cart/presentation/widgets/cart_summary_block.dart';
import 'package:vantage/features/cart/presentation/widgets/checkout_tappable_field.dart';
import 'package:vantage/features/cart/presentation/widgets/cart_money.dart';
import 'package:vantage/router/app_router.dart';

@RoutePage()
class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  late final CheckoutPageHostCubit _hostCubit;
  final _getUser = sl<GetCurrentUserUseCase>();
  final _placeOrderKey = GlobalKey();
  Offset? _orderButtonOriginInOverlay;
  CheckoutReady? _lastCheckoutSnapshot;

  @override
  void initState() {
    super.initState();
    _hostCubit = CheckoutPageHostCubit();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        unawaited(_bootstrap());
      }
    });
  }

  Future<void> _bootstrap() async {
    final u = await _getUser();
    if (!mounted) return;
    if (u == null) {
      if (context.mounted) context.router.maybePop();
      return;
    }
    if (!mounted) return;
    if (!context.mounted) return;
    final c = context.read<CartCubit>().state;
    if (c is! CartLoaded) {
      if (mounted) context.router.maybePop();
      return;
    }
    if (!mounted) return;
    _hostCubit.setCheckout(
      CheckoutCubit(
        initialLines: c.lines,
        userId: u.id,
        watchAddresses: sl<WatchUserAddressesUseCase>(),
        placeOrder: sl<PlaceOrderUseCase>(),
      ),
    );
  }

  @override
  void dispose() {
    _hostCubit.close();
    super.dispose();
  }

  // Overlay-local anchor when the button’s RenderBox isn’t available after a fast transition.
  Offset _fallbackPlaceOrderAnchor(BuildContext context) {
    final s = MediaQuery.sizeOf(context);
    return Offset(s.width / 2, s.height - 40);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final titleC =
        isDark ? Colors.white : VantageColors.homeCategoryLabelLight;
    return BlocProvider<CheckoutPageHostCubit>.value(
      value: _hostCubit,
      child: BlocBuilder<CheckoutPageHostCubit, CheckoutPageHostState>(
        buildWhen: (p, c) => p.checkoutCubit != c.checkoutCubit,
        builder: (context, host) {
          final checkoutCubit = host.checkoutCubit;
          if (checkoutCubit == null) {
            return Scaffold(
              body: SafeArea(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                      child: Row(
                        children: [
                          VantageCircleBackButton(
                            onPressed: () => context.router.maybePop(),
                          ),
                        ],
                      ),
                    ),
                    const Expanded(
                      child: Center(child: VantageLoadingIndicator()),
                    ),
                  ],
                ),
              ),
            );
          }
          return BlocProvider<CheckoutCubit>.value(
            value: checkoutCubit,
            child: BlocListener<CheckoutCubit, CheckoutState>(
              listenWhen: (p, c) =>
                  c is CheckoutPlaced || c is CheckoutError,
              listener: (context, s) {
                if (s is CheckoutPlaced) {
                  final origin = _orderButtonOriginInOverlay ??
                      _fallbackPlaceOrderAnchor(context);
                  VantageSuccessBurstOverlay.show(
                    context,
                    origin: origin,
                    onComplete: () {
                      if (context.mounted) {
                        context.router.replace(
                          OrderPlacedRoute(orderId: s.orderId),
                        );
                      }
                    },
                  );
                } else if (s is CheckoutError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(s.message)),
                  );
                }
              },
              child: BlocBuilder<CheckoutCubit, CheckoutState>(
                builder: (context, st) {
                  if (st is CheckoutInvalid) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (context.mounted) context.router.maybePop();
                    });
                    return const SizedBox.shrink();
                  }
                  if (st is CheckoutReady) {
                    _lastCheckoutSnapshot = st;
                  }
                  if (st is CheckoutPlaced) {
                    final snap =
                        _lastCheckoutSnapshot?.copyWith(isPlacing: false);
                    if (snap == null) {
                      return const Scaffold(
                        body: Center(child: VantageLoadingIndicator()),
                      );
                    }
                    // Avoids an empty/flash frame while OrderPlacedRoute replaces this page.
                    return IgnorePointer(
                      child: _CheckoutContent(
                        titleColor: titleC,
                        state: snap,
                        cubit: checkoutCubit,
                        placeOrderButtonKey: _placeOrderKey,
                        onBeforePlaceOrder: () {},
                      ),
                    );
                  }
                  if (st is! CheckoutReady) {
                    if (st is CheckoutLoading) {
                      return const Scaffold(
                        body: Center(child: VantageLoadingIndicator()),
                      );
                    }
                    return const SizedBox.shrink();
                  }
                  return _CheckoutContent(
                    titleColor: titleC,
                    state: st,
                    cubit: checkoutCubit,
                    placeOrderButtonKey: _placeOrderKey,
                    onBeforePlaceOrder: () {
                      _orderButtonOriginInOverlay =
                          VantageSuccessBurstOverlay
                              .originInOverlayForButton(
                        context,
                        buttonKey: _placeOrderKey,
                        fallback: _fallbackPlaceOrderAnchor(context),
                      );
                    },
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

class _CheckoutContent extends StatelessWidget {
  const _CheckoutContent({
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
    final hasAddr = state.hasAddress;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 16, 8),
              child: Row(
                children: [
                  VantageCircleBackButton(
                    onPressed: () => context.router.maybePop(),
                  ),
                  Expanded(
                    child: Text(
                      LocaleKeys.cart_checkoutTitle.tr(),
                      textAlign: TextAlign.center,
                      style: GoogleFonts.gabarito(
                        color: titleColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 40),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 12),
                children: [
                  CheckoutTappableField(
                    label: LocaleKeys.cart_shippingAddress.tr(),
                    valueText: hasAddr
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
                  const SizedBox(height: 12),
                  CheckoutTappableField(
                    label: LocaleKeys.cart_paymentMethod.tr(),
                    valueText: state.paymentLabel,
                    onTap: () {
                      // TODO(shop): payment method picker.
                      cubit.onPaymentSectionTap();
                    },
                    trailing: const Icon(Icons.payment, size: 22),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    LocaleKeys.cart_total.tr(),
                    style: GoogleFonts.gabarito(
                      color: titleColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  CartSummaryBlock(totals: state.totals),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
              child: VantagePrimaryButton(
                key: placeOrderButtonKey,
                label: LocaleKeys.cart_placeOrder.tr(),
                isLoading: state.isPlacing,
                horizontalPadding: 20,
                onPressed: state.isPlacing
                    ? null
                    : () {
                        if (!hasAddr) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                LocaleKeys.cart_needAddress.tr(),
                              ),
                            ),
                          );
                          return;
                        }
                        onBeforePlaceOrder();
                        cubit.submitOrder();
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
            ),
          ],
        ),
      ),
    );
  }
}
