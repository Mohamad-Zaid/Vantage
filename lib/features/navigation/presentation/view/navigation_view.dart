import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/theme/vantage_colors.dart';
import '../../../../core/widgets/exit_confirmation_dialog.dart';
import '../../../../di/injection.dart';
import '../../../../generated/assets.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../home/presentation/cubit/home_audience_cubit.dart';
import '../../../home/presentation/cubit/product_cubit.dart';
import '../../../profile/presentation/view/profile_view.dart';
import '../../../home/presentation/view/home_view.dart';
import '../../../notifications/presentation/view/notifications_tab.dart';
import '../../../orders/presentation/view/orders_tab.dart';
import '../cubit/navigation_cubit.dart';
import '../cubit/navigation_state.dart';

const List<String> _kNavIconAssets = [
  Assets.vectorNavHomeNormal,
  Assets.vectorNavNotificationNormal,
  Assets.vectorNavWishlistNormal,
  Assets.vectorNavProfileNormal,
];

@RoutePage()
class NavigationPage extends StatefulWidget {
  const NavigationPage({super.key});

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  late final NavigationCubit _navigationCubit;
  late final ProductCubit _productCubit;
  late final HomeAudienceCubit _audienceCubit;
  late final AuthCubit _authCubit;

  @override
  void initState() {
    super.initState();
    _navigationCubit = sl<NavigationCubit>();
    _productCubit = sl<ProductCubit>();
    _audienceCubit = sl<HomeAudienceCubit>();
    _authCubit = sl<AuthCubit>();
  }

  @override
  void dispose() {
    _navigationCubit.close();
    // Home-tab cubits are closed by _HomePageState.dispose() — no double-close here.
    super.dispose();
  }

  List<Widget> _tabs() => [
    HomePage(
      navigationCubit: _navigationCubit,
      productCubit: _productCubit,
      audienceCubit: _audienceCubit,
      authCubit: _authCubit,
    ),
    const NotificationsTab(),
    const OrdersTab(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationCubit, NavigationState>(
      bloc: _navigationCubit,
      builder: (context, state) {
        return PopScope<void>(
          canPop: false,
          onPopInvokedWithResult: (didPop, _) async {
            if (didPop) return;
            final shouldExit = await showExitConfirmationDialog(context);
            if (!context.mounted || !shouldExit) return;
            await SystemNavigator.pop();
          },
          child: Scaffold(
            body: IndexedStack(index: state.currentIndex, children: _tabs()),
            bottomNavigationBar: _SvgIconBottomBar(
              currentIndex: state.currentIndex,
              onTap: _navigationCubit.selectTab,
            ),
          ),
        );
      },
    );
  }
}

class _SvgIconBottomBar extends StatelessWidget {
  const _SvgIconBottomBar({required this.currentIndex, required this.onTap});

  final int currentIndex;
  final ValueChanged<int> onTap;

  static const double _iconSize = 24;
  static const double _hitSize = 40;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final barColor = isDark
        ? VantageColors.bottomNavDarkBg
        : VantageColors.bottomNavLightBg;

    return Material(
      color: barColor,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(25, 18, 25, 18),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(_kNavIconAssets.length, (index) {
              final selected = index == currentIndex;
              final Color iconColor;
              if (isDark) {
                iconColor = selected
                    ? VantageColors.authPrimaryPurple
                    : Colors.white.withValues(alpha: 0.5);
              } else {
                iconColor = selected
                    ? VantageColors.bottomNavLightIconActive
                    : VantageColors.bottomNavLightIconInactive;
              }

              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => onTap(index),
                child: SizedBox(
                  width: _hitSize,
                  height: _hitSize,
                  child: Center(
                    child: SvgPicture.asset(
                      _kNavIconAssets[index],
                      width: _iconSize,
                      height: _iconSize,
                      colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
