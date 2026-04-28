import 'package:vantage/features/addresses/domain/usecases/watch_user_addresses_usecase.dart';
import 'package:vantage/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:vantage/features/orders/domain/usecases/place_order_usecase.dart';
import 'package:vantage/features/cart/presentation/cubit/cart_state.dart';
import 'package:vantage/features/cart/presentation/cubit/checkout_cubit.dart';
import 'package:vantage/features/cart/presentation/cubit/checkout_page_host_cubit.dart';

Future<void> openCheckoutSessionIfReady({
  required GetCurrentUserUseCase getUser,
  required CartState cartState,
  required CheckoutPageHostCubit host,
  required WatchUserAddressesUseCase watchAddresses,
  required PlaceOrderUseCase placeOrder,
  required void Function() onUnauthenticated,
  required void Function() onCartNotReady,
}) async {
  final currentUser = await getUser();
  if (currentUser == null) {
    onUnauthenticated();
    return;
  }
  if (cartState is! CartLoaded) {
    onCartNotReady();
    return;
  }
  host.setCheckout(
    CheckoutCubit(
      initialLines: cartState.lines,
      userId: currentUser.id,
      watchAddresses: watchAddresses,
      placeOrder: placeOrder,
    ),
  );
}
