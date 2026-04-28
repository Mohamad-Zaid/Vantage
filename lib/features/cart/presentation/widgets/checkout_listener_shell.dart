import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:vantage/core/theme/app_spacing.dart';
import 'package:vantage/core/theme/vantage_colors.dart';
import 'package:vantage/core/widgets/vantage_loading_indicator.dart';
import 'package:vantage/core/widgets/vantage_success_burst_overlay.dart';
import 'package:vantage/features/cart/presentation/cubit/checkout_cubit.dart';
import 'package:vantage/features/cart/presentation/cubit/checkout_state.dart';
import 'package:vantage/features/cart/presentation/widgets/checkout_page_body.dart';
import 'package:vantage/router/app_router.dart';

class CheckoutListenerShell extends StatefulWidget {
  const CheckoutListenerShell({super.key, required this.checkoutCubit});

  final CheckoutCubit checkoutCubit;

  @override
  State<CheckoutListenerShell> createState() => _CheckoutListenerShellState();
}

class _CheckoutListenerShellState extends State<CheckoutListenerShell> {
  final _placeOrderButtonKey = GlobalKey();
  Offset? _orderButtonOriginInOverlay;
  CheckoutReady? _lastSnapshot;

  Offset _fallbackAnchor(BuildContext context) {
    final s = MediaQuery.sizeOf(context);
    return Offset(s.width / 2, s.height - AppSpacing.toolbarIconSlot);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final titleColor =
        isDark ? Colors.white : VantageColors.homeCategoryLabelLight;
    return BlocProvider<CheckoutCubit>.value(
      value: widget.checkoutCubit,
      child: BlocListener<CheckoutCubit, CheckoutState>(
        listenWhen: (_, current) =>
            current is CheckoutPlaced || current is CheckoutError,
        listener: (context, checkoutState) {
          if (checkoutState is CheckoutPlaced) {
            final origin =
                _orderButtonOriginInOverlay ?? _fallbackAnchor(context);
            VantageSuccessBurstOverlay.show(
              context,
              origin: origin,
              onComplete: () {
                if (context.mounted) {
                  context.router.replace(
                    OrderPlacedRoute(orderId: checkoutState.orderId),
                  );
                }
              },
            );
          } else if (checkoutState is CheckoutError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(checkoutState.message)),
            );
          }
        },
        child: BlocBuilder<CheckoutCubit, CheckoutState>(
          builder: (context, checkoutState) {
            if (checkoutState is CheckoutInvalid) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (context.mounted) context.router.maybePop();
              });
              return const SizedBox.shrink();
            }
            if (checkoutState is CheckoutReady) {
              _lastSnapshot = checkoutState;
            }
            if (checkoutState is CheckoutPlaced) {
              final snapshot = _lastSnapshot?.copyWith(isPlacing: false);
              if (snapshot == null) {
                return const Scaffold(
                  body: Center(child: VantageLoadingIndicator()),
                );
              }
              return IgnorePointer(
                child: CheckoutPageBody(
                  titleColor: titleColor,
                  state: snapshot,
                  cubit: widget.checkoutCubit,
                  placeOrderButtonKey: _placeOrderButtonKey,
                  onBeforePlaceOrder: () {},
                ),
              );
            }
            if (checkoutState is! CheckoutReady) {
              if (checkoutState is CheckoutLoading) {
                return const Scaffold(
                  body: Center(child: VantageLoadingIndicator()),
                );
              }
              return const SizedBox.shrink();
            }
            return CheckoutPageBody(
              titleColor: titleColor,
              state: checkoutState,
              cubit: widget.checkoutCubit,
              placeOrderButtonKey: _placeOrderButtonKey,
              onBeforePlaceOrder: () {
                _orderButtonOriginInOverlay =
                    VantageSuccessBurstOverlay.originInOverlayForButton(
                  context,
                  buttonKey: _placeOrderButtonKey,
                  fallback: _fallbackAnchor(context),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
