// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

/// generated route for
/// [AddressFormPage]
class AddressFormRoute extends PageRouteInfo<AddressFormRouteArgs> {
  AddressFormRoute({Key? key, String? addressId, List<PageRouteInfo>? children})
    : super(
        AddressFormRoute.name,
        args: AddressFormRouteArgs(key: key, addressId: addressId),
        initialChildren: children,
      );

  static const String name = 'AddressFormRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<AddressFormRouteArgs>(
        orElse: () => const AddressFormRouteArgs(),
      );
      return AddressFormPage(key: args.key, addressId: args.addressId);
    },
  );
}

class AddressFormRouteArgs {
  const AddressFormRouteArgs({this.key, this.addressId});

  final Key? key;

  final String? addressId;

  @override
  String toString() {
    return 'AddressFormRouteArgs{key: $key, addressId: $addressId}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! AddressFormRouteArgs) return false;
    return key == other.key && addressId == other.addressId;
  }

  @override
  int get hashCode => key.hashCode ^ addressId.hashCode;
}

/// generated route for
/// [AddressListPage]
class AddressListRoute extends PageRouteInfo<void> {
  const AddressListRoute({List<PageRouteInfo>? children})
    : super(AddressListRoute.name, initialChildren: children);

  static const String name = 'AddressListRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const AddressListPage();
    },
  );
}

/// generated route for
/// [CartPage]
class CartRoute extends PageRouteInfo<void> {
  const CartRoute({List<PageRouteInfo>? children})
    : super(CartRoute.name, initialChildren: children);

  static const String name = 'CartRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const CartPage();
    },
  );
}

/// generated route for
/// [CategoryDetailPage]
class CategoryDetailRoute extends PageRouteInfo<CategoryDetailRouteArgs> {
  CategoryDetailRoute({
    Key? key,
    required String categoryId,
    List<PageRouteInfo>? children,
  }) : super(
         CategoryDetailRoute.name,
         args: CategoryDetailRouteArgs(key: key, categoryId: categoryId),
         initialChildren: children,
       );

  static const String name = 'CategoryDetailRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<CategoryDetailRouteArgs>();
      return CategoryDetailPage(key: args.key, categoryId: args.categoryId);
    },
  );
}

class CategoryDetailRouteArgs {
  const CategoryDetailRouteArgs({this.key, required this.categoryId});

  final Key? key;

  final String categoryId;

  @override
  String toString() {
    return 'CategoryDetailRouteArgs{key: $key, categoryId: $categoryId}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! CategoryDetailRouteArgs) return false;
    return key == other.key && categoryId == other.categoryId;
  }

  @override
  int get hashCode => key.hashCode ^ categoryId.hashCode;
}

/// generated route for
/// [CheckoutPage]
class CheckoutRoute extends PageRouteInfo<void> {
  const CheckoutRoute({List<PageRouteInfo>? children})
    : super(CheckoutRoute.name, initialChildren: children);

  static const String name = 'CheckoutRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const CheckoutPage();
    },
  );
}

/// generated route for
/// [CreateAccountPage]
class CreateAccountRoute extends PageRouteInfo<void> {
  const CreateAccountRoute({List<PageRouteInfo>? children})
    : super(CreateAccountRoute.name, initialChildren: children);

  static const String name = 'CreateAccountRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const CreateAccountPage();
    },
  );
}

/// generated route for
/// [EditProfilePage]
class EditProfileRoute extends PageRouteInfo<void> {
  const EditProfileRoute({List<PageRouteInfo>? children})
    : super(EditProfileRoute.name, initialChildren: children);

  static const String name = 'EditProfileRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const EditProfilePage();
    },
  );
}

/// generated route for
/// [ForgotPasswordPage]
class ForgotPasswordRoute extends PageRouteInfo<void> {
  const ForgotPasswordRoute({List<PageRouteInfo>? children})
    : super(ForgotPasswordRoute.name, initialChildren: children);

  static const String name = 'ForgotPasswordRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ForgotPasswordPage();
    },
  );
}

/// generated route for
/// [HelpSupportPage]
class HelpSupportRoute extends PageRouteInfo<void> {
  const HelpSupportRoute({List<PageRouteInfo>? children})
    : super(HelpSupportRoute.name, initialChildren: children);

  static const String name = 'HelpSupportRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const HelpSupportPage();
    },
  );
}

/// generated route for
/// [NavigationPage]
class NavigationRoute extends PageRouteInfo<void> {
  const NavigationRoute({List<PageRouteInfo>? children})
    : super(NavigationRoute.name, initialChildren: children);

  static const String name = 'NavigationRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const NavigationPage();
    },
  );
}

/// generated route for
/// [OrderDetailPage]
class OrderDetailRoute extends PageRouteInfo<OrderDetailRouteArgs> {
  OrderDetailRoute({
    Key? key,
    required String orderId,
    List<PageRouteInfo>? children,
  }) : super(
         OrderDetailRoute.name,
         args: OrderDetailRouteArgs(key: key, orderId: orderId),
         initialChildren: children,
       );

  static const String name = 'OrderDetailRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<OrderDetailRouteArgs>();
      return OrderDetailPage(key: args.key, orderId: args.orderId);
    },
  );
}

class OrderDetailRouteArgs {
  const OrderDetailRouteArgs({this.key, required this.orderId});

  final Key? key;

  final String orderId;

  @override
  String toString() {
    return 'OrderDetailRouteArgs{key: $key, orderId: $orderId}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! OrderDetailRouteArgs) return false;
    return key == other.key && orderId == other.orderId;
  }

  @override
  int get hashCode => key.hashCode ^ orderId.hashCode;
}

/// generated route for
/// [OrderPlacedPage]
class OrderPlacedRoute extends PageRouteInfo<OrderPlacedRouteArgs> {
  OrderPlacedRoute({
    Key? key,
    required String orderId,
    List<PageRouteInfo>? children,
  }) : super(
         OrderPlacedRoute.name,
         args: OrderPlacedRouteArgs(key: key, orderId: orderId),
         initialChildren: children,
       );

  static const String name = 'OrderPlacedRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<OrderPlacedRouteArgs>();
      return OrderPlacedPage(key: args.key, orderId: args.orderId);
    },
  );
}

class OrderPlacedRouteArgs {
  const OrderPlacedRouteArgs({this.key, required this.orderId});

  final Key? key;

  final String orderId;

  @override
  String toString() {
    return 'OrderPlacedRouteArgs{key: $key, orderId: $orderId}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! OrderPlacedRouteArgs) return false;
    return key == other.key && orderId == other.orderId;
  }

  @override
  int get hashCode => key.hashCode ^ orderId.hashCode;
}

/// generated route for
/// [PasswordResetEmailSentPage]
class PasswordResetEmailSentRoute extends PageRouteInfo<void> {
  const PasswordResetEmailSentRoute({List<PageRouteInfo>? children})
    : super(PasswordResetEmailSentRoute.name, initialChildren: children);

  static const String name = 'PasswordResetEmailSentRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const PasswordResetEmailSentPage();
    },
  );
}

/// generated route for
/// [ProductDetailPage]
class ProductDetailRoute extends PageRouteInfo<ProductDetailRouteArgs> {
  ProductDetailRoute({
    Key? key,
    required ProductEntity product,
    List<PageRouteInfo>? children,
  }) : super(
         ProductDetailRoute.name,
         args: ProductDetailRouteArgs(key: key, product: product),
         initialChildren: children,
       );

  static const String name = 'ProductDetailRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ProductDetailRouteArgs>();
      return ProductDetailPage(key: args.key, product: args.product);
    },
  );
}

class ProductDetailRouteArgs {
  const ProductDetailRouteArgs({this.key, required this.product});

  final Key? key;

  final ProductEntity product;

  @override
  String toString() {
    return 'ProductDetailRouteArgs{key: $key, product: $product}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ProductDetailRouteArgs) return false;
    return key == other.key && product == other.product;
  }

  @override
  int get hashCode => key.hashCode ^ product.hashCode;
}

/// generated route for
/// [SearchPage]
class SearchRoute extends PageRouteInfo<SearchRouteArgs> {
  SearchRoute({
    Key? key,
    required SearchCubit cubit,
    List<PageRouteInfo>? children,
  }) : super(
         SearchRoute.name,
         args: SearchRouteArgs(key: key, cubit: cubit),
         initialChildren: children,
       );

  static const String name = 'SearchRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<SearchRouteArgs>();
      return SearchPage(key: args.key, cubit: args.cubit);
    },
  );
}

class SearchRouteArgs {
  const SearchRouteArgs({this.key, required this.cubit});

  final Key? key;

  final SearchCubit cubit;

  @override
  String toString() {
    return 'SearchRouteArgs{key: $key, cubit: $cubit}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! SearchRouteArgs) return false;
    return key == other.key && cubit == other.cubit;
  }

  @override
  int get hashCode => key.hashCode ^ cubit.hashCode;
}

/// generated route for
/// [ShopByCategoriesPage]
class ShopByCategoriesRoute extends PageRouteInfo<void> {
  const ShopByCategoriesRoute({List<PageRouteInfo>? children})
    : super(ShopByCategoriesRoute.name, initialChildren: children);

  static const String name = 'ShopByCategoriesRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ShopByCategoriesPage();
    },
  );
}

/// generated route for
/// [SignInPage]
class SignInRoute extends PageRouteInfo<void> {
  const SignInRoute({List<PageRouteInfo>? children})
    : super(SignInRoute.name, initialChildren: children);

  static const String name = 'SignInRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SignInPage();
    },
  );
}

/// generated route for
/// [WishlistListDetailPage]
class WishlistListDetailRoute extends PageRouteInfo<void> {
  const WishlistListDetailRoute({List<PageRouteInfo>? children})
    : super(WishlistListDetailRoute.name, initialChildren: children);

  static const String name = 'WishlistListDetailRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const WishlistListDetailPage();
    },
  );
}
