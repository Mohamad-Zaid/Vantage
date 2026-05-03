import 'package:get_it/get_it.dart';
import 'package:vantage/core/auth/current_user_provider.dart';
import 'package:vantage/core/events/domain_event_bus.dart';

import '../features/search/domain/usecases/search_products_usecase.dart';
import '../features/search/presentation/cubit/search_cubit.dart';
import '../features/auth/data/datasources/auth_remote_datasource.dart';
import '../features/auth/data/repositories_impl/auth_repository_impl.dart';
import '../features/auth/domain/repositories/auth_repository.dart';
import '../features/auth/domain/usecases/get_current_user_usecase.dart';
import '../features/auth/domain/usecases/send_password_reset_email_usecase.dart';
import '../features/auth/domain/usecases/sign_in_with_email_and_password_usecase.dart';
import '../features/auth/domain/usecases/sign_in_with_google_usecase.dart';
import '../features/auth/domain/usecases/sign_out_usecase.dart';
import '../features/auth/domain/usecases/sign_up_with_email_and_password_usecase.dart';
import '../features/auth/domain/usecases/update_user_profile_usecase.dart';
import '../features/auth/domain/usecases/watch_auth_state_usecase.dart';
import '../features/auth/presentation/cubit/auth_cubit.dart';
import '../features/auth/presentation/cubit/password_reset_cubit.dart';
import '../features/profile/presentation/cubit/edit_profile_cubit.dart';
import '../features/addresses/data/datasources/addresses_remote_datasource.dart';
import '../features/addresses/data/repositories_impl/addresses_repository_impl.dart';
import '../features/addresses/domain/repositories/addresses_repository.dart';
import '../features/addresses/domain/usecases/delete_address_usecase.dart';
import '../features/addresses/domain/usecases/fetch_user_addresses_usecase.dart';
import '../features/addresses/domain/usecases/upsert_address_usecase.dart';
import '../features/addresses/domain/usecases/watch_user_addresses_usecase.dart';
import '../features/addresses/presentation/cubit/addresses_cubit.dart';
import '../features/cart/data/datasources/cart_remote_datasource.dart';
import '../features/cart/data/repositories_impl/cart_repository_impl.dart';
import '../features/cart/domain/repositories/cart_repository.dart';
import '../features/cart/domain/usecases/add_cart_line_usecase.dart';
import '../features/cart/domain/usecases/clear_cart_usecase.dart';
import '../features/orders/domain/usecases/place_order_usecase.dart';
import '../features/cart/domain/usecases/remove_cart_line_usecase.dart';
import '../features/cart/domain/usecases/update_cart_line_quantity_usecase.dart';
import '../features/cart/domain/usecases/watch_cart_usecase.dart';
import '../features/cart/presentation/cubit/cart_cubit.dart';
import '../features/home/data/datasources/shop_local_datasource.dart';
import '../features/home/data/repositories_impl/category_repository_impl.dart';
import '../features/home/data/repositories_impl/product_repository_impl.dart';
import '../features/home/domain/repositories/category_repository.dart';
import '../features/home/domain/repositories/product_repository.dart';
import '../features/home/domain/usecases/get_categories_usecase.dart';
import '../features/home/domain/usecases/get_home_shelves_usecase.dart';
import '../features/home/domain/usecases/get_products_by_category_usecase.dart';
import '../features/home/presentation/cubit/category_cubit.dart';
import '../features/home/presentation/cubit/home_audience_cubit.dart';
import '../features/categories/presentation/cubit/category_products_cubit.dart';
import '../features/home/presentation/cubit/product_cubit.dart';
import '../features/navigation/presentation/cubit/navigation_cubit.dart';
import '../features/notifications/data/datasources/notifications_local_datasource.dart';
import '../features/notifications/data/repositories_impl/notifications_repository_impl.dart';
import '../features/notifications/domain/repositories/notifications_repository.dart';
import '../features/notifications/domain/usecases/delete_notification_usecase.dart';
import '../features/notifications/domain/usecases/get_notifications_usecase.dart';
import '../features/notifications/presentation/cubit/notifications_cubit.dart';
import '../features/notifications/presentation/listeners/order_placed_notification_listener.dart';
import '../features/orders/data/datasources/orders_remote_datasource.dart';
import '../features/orders/data/repositories_impl/orders_repository_impl.dart';
import '../features/orders/domain/repositories/orders_repository.dart';
import '../features/orders/domain/usecases/delete_order_usecase.dart';
import '../features/orders/domain/usecases/get_order_detail_usecase.dart';
import '../features/orders/domain/usecases/get_order_summaries_usecase.dart';
import '../features/orders/presentation/cubit/orders_cubit.dart';
import '../features/support/data/datasources/support_local_datasource.dart';
import '../features/support/data/repositories_impl/support_repository_impl.dart';
import '../features/support/domain/repositories/support_repository.dart';
import '../features/support/domain/usecases/get_support_faqs_usecase.dart';
import '../features/support/presentation/cubit/support_cubit.dart';
import '../features/wishlist/data/datasources/favorites_remote_datasource.dart';
import '../features/wishlist/data/repositories_impl/favorites_repository_impl.dart';
import '../features/wishlist/domain/repositories/favorites_repository.dart';
import '../features/wishlist/domain/usecases/add_favorite_usecase.dart';
import '../features/wishlist/domain/usecases/fetch_favorites_page_usecase.dart';
import '../features/wishlist/domain/usecases/remove_favorite_usecase.dart';
import '../features/wishlist/domain/usecases/watch_user_favorites_usecase.dart';
import '../features/wishlist/presentation/cubit/favorites_cubit.dart';

// App-wide service locator. Register bottom-up: data sources, repositories, use cases, then per-route cubits via registerFactory.
final sl = GetIt.instance;

Future<void> initInjector() async {
  sl.registerLazySingleton<AuthRemoteDataSource>(AuthRemoteDataSourceImpl.new);
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl<AuthRemoteDataSource>()),
  );
  // AuthRepository implements CurrentUserProvider — reuse the same singleton.
  sl.registerLazySingleton<CurrentUserProvider>(() => sl<AuthRepository>());

  sl.registerLazySingleton<DomainEventBus>(BroadcastDomainEventBus.new);

  sl.registerLazySingleton<WatchAuthStateUseCase>(
    () => WatchAuthStateUseCase(sl<AuthRepository>()),
  );
  sl.registerLazySingleton<SignInWithEmailAndPasswordUseCase>(
    () => SignInWithEmailAndPasswordUseCase(sl<AuthRepository>()),
  );
  sl.registerLazySingleton<SignUpWithEmailAndPasswordUseCase>(
    () => SignUpWithEmailAndPasswordUseCase(sl<AuthRepository>()),
  );
  sl.registerLazySingleton<SignInWithGoogleUseCase>(
    () => SignInWithGoogleUseCase(sl<AuthRepository>()),
  );
  sl.registerLazySingleton<SignOutUseCase>(
    () => SignOutUseCase(sl<AuthRepository>()),
  );
  sl.registerLazySingleton<GetCurrentUserUseCase>(
    () => GetCurrentUserUseCase(sl<AuthRepository>()),
  );
  sl.registerLazySingleton<SendPasswordResetEmailUseCase>(
    () => SendPasswordResetEmailUseCase(sl<AuthRepository>()),
  );
  sl.registerLazySingleton<UpdateUserProfileUseCase>(
    () => UpdateUserProfileUseCase(sl<AuthRepository>()),
  );

  sl.registerFactory<AuthCubit>(
    () => AuthCubit(
      watchAuthState: sl<WatchAuthStateUseCase>(),
      signInWithEmailAndPassword: sl<SignInWithEmailAndPasswordUseCase>(),
      signUpWithEmailAndPassword: sl<SignUpWithEmailAndPasswordUseCase>(),
      signInWithGoogle: sl<SignInWithGoogleUseCase>(),
      signOut: sl<SignOutUseCase>(),
    ),
  );
  sl.registerFactory<PasswordResetCubit>(
    () => PasswordResetCubit(sl<SendPasswordResetEmailUseCase>()),
  );
  sl.registerFactory<EditProfileCubit>(
    () => EditProfileCubit(
      sl<GetCurrentUserUseCase>(),
      sl<UpdateUserProfileUseCase>(),
    ),
  );

  sl.registerLazySingleton<ShopLocalDataSource>(ShopLocalDataSourceImpl.new);

  sl.registerLazySingleton<CategoryRepository>(
    () => CategoryRepositoryImpl(sl<ShopLocalDataSource>()),
  );
  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(sl<ShopLocalDataSource>()),
  );

  sl.registerLazySingleton<GetCategoriesUseCase>(
    () => GetCategoriesUseCase(sl<CategoryRepository>()),
  );
  sl.registerLazySingleton<GetHomeShelvesUseCase>(
    () => GetHomeShelvesUseCase(sl<ProductRepository>()),
  );
  sl.registerLazySingleton<GetProductsByCategoryUseCase>(
    () => GetProductsByCategoryUseCase(sl<ProductRepository>()),
  );
  sl.registerLazySingleton<SearchProductsUseCase>(
    () => SearchProductsUseCase(sl<ProductRepository>()),
  );

  sl.registerFactory<NavigationCubit>(NavigationCubit.new);

  sl.registerFactory<CategoryCubit>(
    () => CategoryCubit(sl<GetCategoriesUseCase>()),
  );
  sl.registerFactory<HomeAudienceCubit>(HomeAudienceCubit.new);
  sl.registerFactory<ProductCubit>(
    () => ProductCubit(
      sl<GetHomeShelvesUseCase>(),
      sl<GetProductsByCategoryUseCase>(),
    ),
  );
  sl.registerFactory<CategoryProductsCubit>(
    () => CategoryProductsCubit(sl<GetProductsByCategoryUseCase>()),
  );
  sl.registerFactory<SearchCubit>(
    () => SearchCubit(sl<SearchProductsUseCase>()),
  );

  sl.registerLazySingleton<SupportLocalDataSource>(
    SupportLocalDataSourceImpl.new,
  );
  sl.registerLazySingleton<SupportRepository>(
    () => SupportRepositoryImpl(sl<SupportLocalDataSource>()),
  );
  sl.registerLazySingleton<GetSupportFaqsUseCase>(
    () => GetSupportFaqsUseCase(sl<SupportRepository>()),
  );
  sl.registerFactory<SupportCubit>(
    () => SupportCubit(sl<GetSupportFaqsUseCase>()),
  );

  sl.registerLazySingleton<NotificationsLocalDataSource>(
    NotificationsLocalDataSourceImpl.new,
  );
  sl.registerLazySingleton<NotificationsRepository>(
    () => NotificationsRepositoryImpl(sl<NotificationsLocalDataSource>()),
  );
  sl.registerLazySingleton<GetNotificationsUseCase>(
    () => GetNotificationsUseCase(sl<NotificationsRepository>()),
  );
  sl.registerLazySingleton<DeleteNotificationUseCase>(
    () => DeleteNotificationUseCase(sl<NotificationsRepository>()),
  );
  sl.registerFactory<NotificationsCubit>(
    () => NotificationsCubit(
      sl<GetNotificationsUseCase>(),
      sl<DeleteNotificationUseCase>(),
    ),
  );

  sl.registerLazySingleton<OrdersRemoteDataSource>(
    OrdersRemoteDataSourceImpl.new,
  );
  sl.registerLazySingleton<OrdersRepository>(
    () => OrdersRepositoryImpl(
      sl<OrdersRemoteDataSource>(),
      sl<GetCurrentUserUseCase>(),
    ),
  );
  sl.registerLazySingleton<GetOrderSummariesUseCase>(
    () => GetOrderSummariesUseCase(sl<OrdersRepository>()),
  );
  sl.registerLazySingleton<GetOrderDetailUseCase>(
    () => GetOrderDetailUseCase(sl<OrdersRepository>()),
  );
  sl.registerLazySingleton<DeleteOrderUseCase>(
    () => DeleteOrderUseCase(sl<OrdersRepository>()),
  );
  sl.registerFactory<OrdersCubit>(
    () => OrdersCubit(sl<GetOrderSummariesUseCase>(), sl<DeleteOrderUseCase>()),
  );

  sl.registerLazySingleton<FavoritesRemoteDataSource>(
    FavoritesRemoteDataSourceImpl.new,
  );
  sl.registerLazySingleton<FavoritesRepository>(
    () => FavoritesRepositoryImpl(sl<FavoritesRemoteDataSource>()),
  );
  sl.registerLazySingleton<WatchUserFavoritesUseCase>(
    () => WatchUserFavoritesUseCase(sl<FavoritesRepository>()),
  );
  sl.registerLazySingleton<AddFavoriteUseCase>(
    () => AddFavoriteUseCase(sl<FavoritesRepository>()),
  );
  sl.registerLazySingleton<RemoveFavoriteUseCase>(
    () => RemoveFavoriteUseCase(sl<FavoritesRepository>()),
  );
  sl.registerLazySingleton<FetchFavoritesPageUseCase>(
    () => FetchFavoritesPageUseCase(sl<FavoritesRepository>()),
  );
  sl.registerLazySingleton<FavoritesCubit>(
    () => FavoritesCubit(
      authProvider: sl<CurrentUserProvider>(),
      fetchPage: sl<FetchFavoritesPageUseCase>(),
      addFavorite: sl<AddFavoriteUseCase>(),
      removeFavorite: sl<RemoveFavoriteUseCase>(),
    ),
  );

  sl.registerLazySingleton<AddressesRemoteDataSource>(
    AddressesRemoteDataSourceImpl.new,
  );
  sl.registerLazySingleton<AddressesRepository>(
    () => AddressesRepositoryImpl(sl<AddressesRemoteDataSource>()),
  );
  sl.registerLazySingleton<WatchUserAddressesUseCase>(
    () => WatchUserAddressesUseCase(sl<AddressesRepository>()),
  );
  sl.registerLazySingleton<UpsertAddressUseCase>(
    () => UpsertAddressUseCase(sl<AddressesRepository>()),
  );
  sl.registerLazySingleton<DeleteAddressUseCase>(
    () => DeleteAddressUseCase(sl<AddressesRepository>()),
  );
  sl.registerLazySingleton<FetchUserAddressesUseCase>(
    () => FetchUserAddressesUseCase(sl<AddressesRepository>()),
  );
  sl.registerLazySingleton<AddressesCubit>(
    () => AddressesCubit(
      authProvider: sl<CurrentUserProvider>(),
      watchAddresses: sl<WatchUserAddressesUseCase>(),
      fetchAddresses: sl<FetchUserAddressesUseCase>(),
      upsertAddress: sl<UpsertAddressUseCase>(),
      deleteAddress: sl<DeleteAddressUseCase>(),
    ),
  );

  sl.registerLazySingleton<CartRemoteDataSource>(CartRemoteDataSourceImpl.new);
  sl.registerLazySingleton<CartRepository>(
    () => CartRepositoryImpl(sl<CartRemoteDataSource>()),
  );
  sl.registerLazySingleton<WatchCartUseCase>(
    () => WatchCartUseCase(sl<CartRepository>()),
  );
  sl.registerLazySingleton<AddCartLineUseCase>(
    () => AddCartLineUseCase(sl<CartRepository>()),
  );
  sl.registerLazySingleton<UpdateCartLineQuantityUseCase>(
    () => UpdateCartLineQuantityUseCase(sl<CartRepository>()),
  );
  sl.registerLazySingleton<RemoveCartLineUseCase>(
    () => RemoveCartLineUseCase(sl<CartRepository>()),
  );
  sl.registerLazySingleton<ClearCartUseCase>(
    () => ClearCartUseCase(sl<CartRepository>()),
  );
  sl.registerLazySingleton<PlaceOrderUseCase>(
    () => PlaceOrderUseCase(
      sl<CartRepository>(),
      sl<OrdersRepository>(),
      sl<DomainEventBus>(),
    ),
  );
  sl.registerLazySingleton<CartCubit>(
    () => CartCubit(
      authProvider: sl<CurrentUserProvider>(),
      domainEvents: sl<DomainEventBus>(),
      watchCart: sl<WatchCartUseCase>(),
      addLine: sl<AddCartLineUseCase>(),
      updateQty: sl<UpdateCartLineQuantityUseCase>(),
      removeLine: sl<RemoveCartLineUseCase>(),
      clearCart: sl<ClearCartUseCase>(),
    ),
  );

  sl.registerLazySingleton<OrderPlacedNotificationListener>(
    () => OrderPlacedNotificationListener(
      sl<DomainEventBus>(),
      sl<NotificationsRepository>(),
    ),
  );

  sl<OrderPlacedNotificationListener>();
}
