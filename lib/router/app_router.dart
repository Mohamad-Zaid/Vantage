import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../core/domain/entities/product_entity.dart';
import '../features/auth/presentation/view/create_account_view.dart';
import '../features/auth/presentation/view/forgot_password_view.dart';
import '../features/auth/presentation/view/password_reset_email_sent_view.dart';
import '../features/auth/presentation/view/sign_in_view.dart';
import '../features/addresses/presentation/view/address_form_page.dart';
import '../features/cart/presentation/view/cart_page.dart';
import '../features/cart/presentation/view/checkout_page.dart';
import '../features/cart/presentation/view/order_placed_page.dart';
import '../features/addresses/presentation/view/address_list_page.dart';
import '../features/categories/presentation/view/category_detail_view.dart';
import '../features/categories/presentation/view/shop_by_categories_view.dart';
import '../features/navigation/presentation/view/navigation_view.dart';
import '../features/orders/presentation/view/order_detail_view.dart';
import '../features/profile/presentation/view/edit_profile_page.dart';
import '../features/support/presentation/view/help_support_view.dart';
import '../features/search/presentation/cubit/search_cubit.dart';
import '../features/search/presentation/view/search_view.dart';
import '../features/product_detail/presentation/view/product_detail_page.dart';
import '../features/wishlist/presentation/view/wishlist_list_detail_page.dart';

part 'app_router.gr.dart';

@AutoRouterConfig()
final class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: SignInRoute.page, initial: true),
        AutoRoute(page: ForgotPasswordRoute.page),
        AutoRoute(page: PasswordResetEmailSentRoute.page),
        AutoRoute(page: CreateAccountRoute.page),
        AutoRoute(page: NavigationRoute.page),
        AutoRoute(page: ShopByCategoriesRoute.page),
        AutoRoute(page: CategoryDetailRoute.page),
        AutoRoute(page: OrderDetailRoute.page),
        AutoRoute(page: HelpSupportRoute.page),
        AutoRoute(page: AddressListRoute.page),
        AutoRoute(page: AddressFormRoute.page),
        AutoRoute(page: WishlistListDetailRoute.page),
        AutoRoute(page: SearchRoute.page),
        AutoRoute(page: ProductDetailRoute.page),
        AutoRoute(page: CartRoute.page),
        AutoRoute(page: CheckoutRoute.page),
        AutoRoute(page: OrderPlacedRoute.page),
        AutoRoute(page: EditProfileRoute.page),
      ];
}
