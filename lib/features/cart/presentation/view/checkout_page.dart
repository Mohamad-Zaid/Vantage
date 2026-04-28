import 'dart:async' show unawaited;

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:vantage/di/injection.dart';
import 'package:vantage/features/addresses/domain/usecases/watch_user_addresses_usecase.dart';
import 'package:vantage/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:vantage/features/orders/domain/usecases/place_order_usecase.dart';
import 'package:vantage/features/cart/presentation/checkout_session_bootstrap.dart';
import 'package:vantage/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:vantage/features/cart/presentation/cubit/checkout_page_host_cubit.dart';
import 'package:vantage/features/cart/presentation/widgets/checkout_listener_shell.dart';
import 'package:vantage/features/cart/presentation/widgets/checkout_page_loading_shell.dart';

@RoutePage()
class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  late final CheckoutPageHostCubit _hostCubit;
  final _getUser = sl<GetCurrentUserUseCase>();

  @override
  void initState() {
    super.initState();
    _hostCubit = CheckoutPageHostCubit();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) unawaited(_startCheckoutSession());
    });
  }

  Future<void> _startCheckoutSession() async {
    if (!mounted) return;
    await openCheckoutSessionIfReady(
      getUser: _getUser,
      cartState: context.read<CartCubit>().state,
      host: _hostCubit,
      watchAddresses: sl<WatchUserAddressesUseCase>(),
      placeOrder: sl<PlaceOrderUseCase>(),
      onUnauthenticated: () {
        if (context.mounted) context.router.maybePop();
      },
      onCartNotReady: () {
        if (mounted) context.router.maybePop();
      },
    );
  }

  @override
  void dispose() {
    _hostCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CheckoutPageHostCubit>.value(
      value: _hostCubit,
      child: BlocBuilder<CheckoutPageHostCubit, CheckoutPageHostState>(
        buildWhen: (p, c) => p.checkoutCubit != c.checkoutCubit,
        builder: (context, host) {
          final checkoutCubit = host.checkoutCubit;
          if (checkoutCubit == null) return const CheckoutPageLoadingShell();
          return CheckoutListenerShell(checkoutCubit: checkoutCubit);
        },
      ),
    );
  }
}
