import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import 'package:vantage/di/injection.dart';
import 'package:vantage/features/search/presentation/cubit/search_cubit.dart';
import 'package:vantage/router/app_router.dart';

import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../navigation/presentation/cubit/navigation_cubit.dart';
import '../cubit/home_audience_cubit.dart';
import '../cubit/product_cubit.dart';
import 'home_categories_section.dart';
import 'package:vantage/core/widgets/vantage_search_field.dart';
import 'home_shelves_section.dart';
import 'home_top_bar.dart';

// Stateful for search [TextEditingController] lifecycle.
class HomeBody extends StatefulWidget {
  const HomeBody({
    super.key,
    required this.navigationCubit,
    required this.productCubit,
    required this.audienceCubit,
    required this.authCubit,
  });

  final NavigationCubit navigationCubit;
  final ProductCubit productCubit;
  final HomeAudienceCubit audienceCubit;
  final AuthCubit authCubit;

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openSearch() {
    context.router.push(SearchRoute(cubit: sl<SearchCubit>()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: SafeArea(
              bottom: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        HomeTopBar(
                          authCubit: widget.authCubit,
                          audienceCubit: widget.audienceCubit,
                          onProfileTap: () {
                            widget.navigationCubit.selectTab(3);
                          },
                          onCartTap: () {
                            context.router.push(const CartRoute());
                          },
                        ),
                        const SizedBox(height: 12),
                        GestureDetector(
                          onTap: _openSearch,
                          behavior: HitTestBehavior.opaque,
                          child: IgnorePointer(
                            child: VantageSearchField(
                                controller: _searchController),
                          ),
                        ),
                        const SizedBox(height: 12),
                        const HomeCategoriesSection(),
                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
                  HomeShelvesSection(productCubit: widget.productCubit),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
