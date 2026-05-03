import 'package:firebase_core/firebase_core.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/cubits/app_settings_cubit.dart';
import 'core/translations/locale_keys.g.dart';
import 'di/injection.dart';
import 'router/app_router.dart';
import 'core/theme/vantage_theme.dart';
import 'core/widgets/app_settings_scope.dart';
import 'features/addresses/presentation/cubit/addresses_cubit.dart';
import 'features/addresses/presentation/cubit/addresses_state.dart';
import 'features/cart/presentation/cubit/cart_cubit.dart';
import 'features/cart/presentation/cubit/cart_state.dart';
import 'features/wishlist/presentation/cubit/favorites_cubit.dart';
import 'features/wishlist/presentation/cubit/favorites_state.dart';
import 'firebase_options.dart';

// Web client ID (type 3 in google-services.json): required on Android so Google Sign-In tokens work with Firebase Auth.
const String _kGoogleServerClientId =
    '42242203473-h1d497vv6i0f4tn9td7gk4p3u25kuk48.apps.googleusercontent.com';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GoogleSignIn.instance.initialize(
    serverClientId: _kGoogleServerClientId,
  );
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await EasyLocalization.ensureInitialized();
  await initInjector();

  final prefs = await SharedPreferences.getInstance();
  final appSettings = AppSettingsCubit(prefs: prefs);
  await appSettings.init();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      startLocale: const Locale('en'),
      child: AppSettingsScope(cubit: appSettings, child: const VantageApp()),
    ),
  );
}

final class VantageApp extends StatelessWidget {
  const VantageApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appSettings = AppSettingsScope.of(context);

    return MultiBlocProvider(
      providers: [
        BlocProvider<FavoritesCubit>.value(value: sl<FavoritesCubit>()),
        BlocProvider<CartCubit>.value(value: sl<CartCubit>()),
        BlocProvider<AddressesCubit>.value(value: sl<AddressesCubit>()),
      ],
      child: ValueListenableBuilder<ThemeMode>(
        valueListenable: appSettings.themeModeNotifier,
        builder: (context, themeMode, _) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'Vantage',
            theme: VantageTheme.light(context),
            darkTheme: VantageTheme.dark(context),
            themeMode: themeMode,
            routerConfig: AppRouter().config(),
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            builder: (context, child) {
              // Cart, wishlist, and addresses can require sign-in from deep in the stack; surface prompts here so any route has a Scaffold.
              return MultiBlocListener(
                listeners: [
                  BlocListener<CartCubit, CartState>(
                    listenWhen: (prev, curr) => curr is CartNeedSignIn,
                    listener: (context, state) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(LocaleKeys.cart_signInToCart.tr()),
                        ),
                      );
                    },
                  ),
                  BlocListener<FavoritesCubit, FavoritesState>(
                    listenWhen: (prev, curr) => curr is FavoritesNeedSignIn,
                    listener: (context, state) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            LocaleKeys.wishlist_signInToFavorite.tr(),
                          ),
                        ),
                      );
                    },
                  ),
                  BlocListener<AddressesCubit, AddressesState>(
                    listenWhen: (prev, curr) => curr is AddressesNeedSignIn,
                    listener: (context, state) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(LocaleKeys.address_signInToSave.tr()),
                        ),
                      );
                    },
                  ),
                ],
                child: child ?? const SizedBox.shrink(),
              );
            },
          );
        },
      ),
    );
  }
}
